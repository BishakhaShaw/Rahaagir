import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class SourceSelectionScreen extends StatefulWidget {
  final LatLng destination;
  final String destinationName;

  const SourceSelectionScreen({
    super.key,
    required this.destination,
    required this.destinationName,
  });

  @override
  _SourceSelectionScreenState createState() => _SourceSelectionScreenState();
}

class _SourceSelectionScreenState extends State<SourceSelectionScreen> {
  LatLng? _selectedSource;
  Marker? _sourceMarker;
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final List<dynamic> _predictions = [];
  Timer? _debounce;
  String _sessionToken = '';

  static const String _googleMapsApiKey = 'AIzaSyBKPLjj-Upqy4tTkO4VnBY9XxN8dKLuSyY';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (_searchController.text.isNotEmpty) {
        _getAutocomplete(_searchController.text);
      } else {
        setState(() => _predictions.clear());
      }
    });
  }

  Future<void> _getAutocomplete(String input) async {
    _sessionToken = const Uuid().v4();
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_googleMapsApiKey&sessiontoken=$_sessionToken';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() => _predictions.addAll(json['predictions']));
    }
  }

  Future<void> _selectPrediction(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_googleMapsApiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final location = data['result']['geometry']['location'];
      LatLng latLng = LatLng(location['lat'], location['lng']);

      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));

      setState(() {
        _selectedSource = latLng;
        _sourceMarker = Marker(
          markerId: const MarkerId('source'),
          position: latLng,
          infoWindow: InfoWindow(title: data['result']['name']),
        );
        _predictions.clear();
        _searchController.clear();
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        return;
      }
    }

    final position =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final latLng = LatLng(position.latitude, position.longitude);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));

    setState(() {
      _selectedSource = latLng;
      _sourceMarker = Marker(
        markerId: const MarkerId('source'),
        position: latLng,
        infoWindow: const InfoWindow(title: 'Current Location'),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Source Location")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.destination,
              zoom: 12,
            ),
            markers: {
              if (_sourceMarker != null) _sourceMarker!,
              Marker(
                markerId: const MarkerId('destination'),
                position: widget.destination,
                infoWindow: InfoWindow(title: widget.destinationName),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            },
            onMapCreated: (controller) => _mapController = controller,
            onTap: (latLng) {
              setState(() {
                _selectedSource = latLng;
                _sourceMarker = Marker(
                  markerId: const MarkerId('source'),
                  position: latLng,
                  infoWindow: const InfoWindow(title: "Selected Source"),
                );
              });
            },
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Column(
              children: [
                Card(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search source...',
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                if (_predictions.isNotEmpty)
                  Container(
                    color: Colors.white,
                    height: 200,
                    child: ListView.builder(
                      itemCount: _predictions.length,
                      itemBuilder: (context, index) {
                        final p = _predictions[index];
                        return ListTile(
                          title: Text(p['description']),
                          onTap: () => _selectPrediction(p['place_id']),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _getCurrentLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text("Use Current Location"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedSource != null) {
                      Navigator.pop(context, _selectedSource);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select a source")),
                      );
                    }
                  },
                  child: const Text("Confirm Source"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
