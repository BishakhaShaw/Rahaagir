import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

const String googleMapsApiKey = 'YOUR_API_KEY'; // Replace with your actual API key

class DirectionScreen extends StatefulWidget {
  final LatLng? initialOrigin; // Make origin nullable
  final LatLng destination;
  final String destinationName;

  const DirectionScreen({
    super.key,
    this.initialOrigin,
    required this.destination,
    required this.destinationName,
  });

  @override
  _DirectionScreenState createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  String _distanceDriving = '';
  String _durationDriving = '';
  String _distanceBicycling = '';
  String _durationBicycling = '';
  String _distanceTransit = '';
  String _durationTransit = '';
  String _selectedMode = 'driving';
  LatLng? _origin;
  final TextEditingController _sourceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _determineOrigin();
  }

  Future<void> _determineOrigin() async {
    if (widget.initialOrigin != null) {
      setState(() {
        _origin = widget.initialOrigin;
      });
      _getDirections();
    } else {
      // Prompt user to enter source
      _showSourceInputDialog(context);
    }
  }

  Future<LatLng?> _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    locationData = await location.getLocation();
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  Future<void> _showSourceInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _sourceController,
                decoration: const InputDecoration(
                    hintText: 'Enter source latitude,longitude'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final parts = _sourceController.text.split(',');
                  if (parts.length == 2) {
                    setState(() {
                      _origin = LatLng(
                          double.parse(parts[0].trim()), double.parse(parts[1].trim()));
                    });
                    Navigator.of(context).pop();
                    _getDirections();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid source format')),
                    );
                  }
                },
                child: const Text('Use Entered Source'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final currentLocation = await _getCurrentLocation();
                  if (currentLocation != null) {
                    setState(() {
                      _origin = currentLocation;
                    });
                    Navigator.of(context).pop();
                    _getDirections();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Could not get current location')),
                    );
                  }
                },
                child: const Text('Use Current Location'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getDirections() async {
    if (_origin == null) return;

    await _fetchDirections('driving');
    await _fetchDirections('bicycling');
    await _fetchDirections('transit');

    // Initially show driving directions
    _updateMapWithDirections('driving');
  }

  Future<void> _fetchDirections(String mode) async {
    final url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${_origin!.latitude},${_origin!.longitude}&destination=${widget.destination.latitude},${widget.destination.longitude}&mode=$mode&key=$googleMapsApiKey";

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        final route = data['routes'][0];
        final polyline = route['overview_polyline']['points'];
        final points = PolylinePoints().decodePolyline(polyline);
        final List<LatLng> latlngs =
            points.map((p) => LatLng(p.latitude, p.longitude)).toList();
        final distance = route['legs'][0]['distance']['text'];
        final duration = route['legs'][0]['duration']['text'];

        setState(() {
          if (mode == 'driving') {
            _distanceDriving = distance;
            _durationDriving = duration;
          } else if (mode == 'bicycling') {
            _distanceBicycling = distance;
            _durationBicycling = duration;
          } else if (mode == 'transit') {
            _distanceTransit = distance;
            _durationTransit = duration;
          }
        });
      } else {
        print("❌ Directions API Error ($mode): ${data['status']}");
        print(
            "Message ($mode): ${data['error_message'] ?? 'No error message provided'}");
      }
    } catch (e) {
      print("⚠️ Error fetching directions ($mode): $e");
    }
  }

  void _updateMapWithDirections(String mode) async {
    if (_origin == null) return;
    setState(() {
      _selectedMode = mode;
      _polylines.clear();
    });

    final url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${_origin!.latitude},${_origin!.longitude}&destination=${widget.destination.latitude},${widget.destination.longitude}&mode=$mode&key=$googleMapsApiKey";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      final route = data['routes'][0];
      final polyline = route['overview_polyline']['points'];
      final points = PolylinePoints().decodePolyline(polyline);
      final List<LatLng> latlngs =
          points.map((p) => LatLng(p.latitude, p.longitude)).toList();

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId("route"),
            color: Colors.blue,
            width: 5,
            points: latlngs,
          ),
        };
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
              _origin!.latitude < widget.destination.latitude
                  ? _origin!.latitude
                  : widget.destination.latitude,
              _origin!.longitude < widget.destination.longitude
                  ? _origin!.longitude
                  : widget.destination.longitude,
            ),
            northeast: LatLng(
              _origin!.latitude > widget.destination.latitude
                  ? _origin!.latitude
                  : widget.destination.latitude,
              _origin!.longitude > widget.destination.longitude
                  ? _origin!.longitude
                  : widget.destination.longitude,
            ),
          ),
          60,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Directions to ${widget.destinationName}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Go back to the previous screen (MapScreen)
        ),
      ),
      body: _origin == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: _origin!, zoom: 14),
                    onMapCreated: (controller) => _mapController = controller,
                    polylines: _polylines,
                    markers: {
                      Marker(
                          markerId: const MarkerId('origin'),
                          position: _origin!,
                          infoWindow: const InfoWindow(title: 'Start')),
                      Marker(
                          markerId: const MarkerId('destination'),
                          position: widget.destination,
                          infoWindow:
                              InfoWindow(title: widget.destinationName)),
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    left: 15,
                    right: 15,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 5)
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Estimated Travel Time & Distance:',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildModeInfo('Driving', _distanceDriving,
                                  _durationDriving, 'driving'),
                              _buildModeInfo('Bike', _distanceBicycling,
                                  _durationBicycling, 'bicycling'),
                              _buildModeInfo('Transit', _distanceTransit,
                                  _durationTransit, 'transit'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildModeInfo(
      String title, String distance, String duration, String mode) {
    return GestureDetector(
      onTap: () => _updateMapWithDirections(mode),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontWeight: _selectedMode == mode ? FontWeight.bold : FontWeight.normal)),
          Text(distance, style: TextStyle(color: _selectedMode == mode ? Colors.blue : Colors.black)),
          Text(duration, style: TextStyle(color: _selectedMode == mode ? Colors.blue : Colors.grey)),
        ],
      ),
    );
  }
}