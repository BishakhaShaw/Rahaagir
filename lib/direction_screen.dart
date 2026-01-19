import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';

const String googleMapsApiKey = 'AIzaSyBKPLjj-Upqy4tTkO4VnBY9XxN8dKLuSyY';

class DirectionScreen extends StatefulWidget {
  final LatLng initialOrigin;
  final LatLng destination;
  final String destinationName;
  final String sourceName;

  const DirectionScreen({
    super.key,
    required this.initialOrigin,
    required this.destination,
    required this.destinationName,
    required this.sourceName,
  });

  @override
  _DirectionScreenState createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  GoogleMapController? _mapController;
  List<LatLng> _polylinePoints = [];
  LatLng? _liveLocation;
  StreamSubscription<Position>? _positionStream;
  List<dynamic> _steps = [];
  String _selectedMode = 'driving';
  String _distance = '';
  String _duration = '';
  double _distanceValue = 0.0;
  double _estimatedFare = 0.0;
  LatLngBounds? _routeBounds;
  bool _isPreviewing = false;
  Timer? _previewTimer;

  @override
  void initState() {
    super.initState();
    _startLiveTracking();
    _getDirections();
  }

  void _startLiveTracking() {
    _positionStream = Geolocator.getPositionStream().listen((pos) {
      setState(() {
        _liveLocation = LatLng(pos.latitude, pos.longitude);
      });
    });
  }

  double _calculateFare(double distanceKm, String mode) {
    switch (mode) {
      case 'driving':
        return 30 + (distanceKm * 10);
      case 'transit':
        return 10 + (distanceKm * 2);
      case 'walking':
        return 0.0;
      default:
        return 0.0;
    }
  }

  Future<void> _getDirections() async {
    final origin = _liveLocation ?? widget.initialOrigin;

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${widget.destination.latitude},${widget.destination.longitude}&mode=$_selectedMode&key=$googleMapsApiKey';
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      final route = data['routes'][0];
      final leg = route['legs'][0];
      final points = route['overview_polyline']['points'];
      final polylinePoints = PolylinePoints().decodePolyline(points);
      final distanceText = leg['distance']['text'];
      final distanceValue = leg['distance']['value'] / 1000.0;

      setState(() {
        _polylinePoints = polylinePoints
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();
        _steps = leg['steps'];
        _distance = distanceText;
        _duration = leg['duration']['text'];
        _distanceValue = distanceValue;
        _estimatedFare = _calculateFare(distanceValue, _selectedMode);

        _routeBounds = LatLngBounds(
          southwest: LatLng(
            route['bounds']['southwest']['lat'],
            route['bounds']['southwest']['lng'],
          ),
          northeast: LatLng(
            route['bounds']['northeast']['lat'],
            route['bounds']['northeast']['lng'],
          ),
        );
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
            CameraUpdate.newLatLngBounds(_routeBounds!, 50));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get directions.')),
      );
    }
  }

  void _changeMode(String mode) {
    setState(() {
      _selectedMode = mode;
    });
    _getDirections();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _previewTimer?.cancel();
    super.dispose();
  }

  Future<void> _startPreview() async {
    if (_polylinePoints.isEmpty || _mapController == null) return;

    setState(() {
      _isPreviewing = true;
    });

    int i = 0;
    _previewTimer = Timer.periodic(Duration(milliseconds: 800), (timer) {
      if (i >= _polylinePoints.length) {
        timer.cancel();
        setState(() {
          _isPreviewing = false;
        });
        return;
      }
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(_polylinePoints[i]),
      );
      i++;
    });
  }

  void _stopPreview() {
    _previewTimer?.cancel();
    setState(() {
      _isPreviewing = false;
    });
  }

  Widget _buildModeSelector() {
    final modes = [
      {'label': 'Auto', 'icon': Icons.electric_rickshaw, 'mode': 'driving'},
      {'label': 'Cab', 'icon': Icons.local_taxi, 'mode': 'driving'},
      {'label': 'Bus', 'icon': Icons.directions_bus, 'mode': 'transit'},
      {'label': 'Walk', 'icon': Icons.directions_walk, 'mode': 'walking'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: modes.map((m) {
        return Column(
          children: [
            IconButton(
              icon: Icon(m['icon'] as IconData),
              onPressed: () => _changeMode(m['mode'] as String),
              color: _selectedMode == m['mode'] ? Colors.blue : Colors.grey,
            ),
            Text(m['label'] as String),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStepList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _steps.length,
      itemBuilder: (context, index) {
        final step = _steps[index];
        final instruction =
            step['html_instructions'].replaceAll(RegExp(r'<[^>]*>'), '');
        final distance = step['distance']['text'];
        return ListTile(
          leading: Icon(Icons.directions),
          title: Text(instruction),
          subtitle: Text(distance),
        );
      },
    );
  }

  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.2,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.sourceName} → ${widget.destinationName}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _buildModeSelector(),
                Divider(),
                Text(
                    '$_duration ($_distance) • ₹${_estimatedFare.toStringAsFixed(0)} approx'),
                SizedBox(height: 8),
                _buildStepList(),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isPreviewing ? _stopPreview : _startPreview,
                      icon: Icon(
                          _isPreviewing ? Icons.stop : Icons.preview_rounded),
                      label: Text(_isPreviewing ? 'Stop Preview' : 'Preview'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Share.share(
                          'Route from ${widget.sourceName} to ${widget.destinationName}: $_distance ($_duration). Fare: ₹${_estimatedFare.toStringAsFixed(0)}',
                        );
                      },
                      icon: Icon(Icons.share),
                      label: Text('Share'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Route saved for later.')),
                        );
                      },
                      icon: Icon(Icons.save),
                      label: Text('Save'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialOrigin,
              zoom: 14,
            ),
            onMapCreated: (controller) => _mapController = controller,
            polylines: {
              Polyline(
                polylineId: PolylineId("route"),
                points: _polylinePoints,
                color: Colors.blue,
                width: 5,
              ),
            },
            markers: {
              Marker(
                  markerId: MarkerId('origin'),
                  position: widget.initialOrigin,
                  infoWindow: InfoWindow(title: widget.sourceName)),
              Marker(
                  markerId: MarkerId('destination'),
                  position: widget.destination,
                  infoWindow: InfoWindow(title: widget.destinationName)),
              if (_liveLocation != null)
                Marker(
                  markerId: MarkerId('live'),
                  position: _liveLocation!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                  infoWindow: InfoWindow(title: "You"),
                ),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          _buildBottomSheet(),
        ],
      ),
    );
  }
}
