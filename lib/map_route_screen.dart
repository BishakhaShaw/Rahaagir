import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class MapRouteScreen extends StatefulWidget {
  final List<Map<String, dynamic>> itineraryItems;
  final List<String> transportModes;

  const MapRouteScreen({
    Key? key,
    required this.itineraryItems,
    required this.transportModes,
  }) : super(key: key);

  @override
  State<MapRouteScreen> createState() => _MapRouteScreenState();
}

class _MapRouteScreenState extends State<MapRouteScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LocationData? _currentLocation;
  final Location _location = Location();

  double totalSegmentCost = 0.0;
  Map<int, double> segmentCosts = {};

  final Map<String, double> costPerKm = {
    'Auto': 10,
    'Taxi': 15,
    'Bus': 5,
    'Metro': 7,
    'Bike': 8,
  };

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final permission = await _location.requestPermission();
    if (permission == PermissionStatus.granted) {
      final location = await _location.getLocation();
      setState(() {
        _currentLocation = location;
      });
      _buildMapData();
    }
  }

  void _buildMapData() {
    final List<LatLng> routePoints = [];
    final newMarkers = <Marker>{};
    final newPolylines = <Polyline>{};
    double newTotalCost = 0.0;
    Map<int, double> newSegmentCosts = {};

    for (int i = 0; i < widget.itineraryItems.length; i++) {
      final item = widget.itineraryItems[i];
      final location = item['location'];

      LatLng? latLng = _extractLatLng(location);
      if (latLng == null) continue;

      newMarkers.add(
        Marker(
          markerId: MarkerId('marker_$i'),
          position: latLng,
          infoWindow: InfoWindow(title: item['name']),
          onTap: () => _showDetailsBottomSheet(item),
        ),
      );

      routePoints.add(latLng);

      // Create polyline to next item
      if (i < widget.itineraryItems.length - 1) {
        final nextLocation = widget.itineraryItems[i + 1]['location'];
        LatLng? nextLatLng = _extractLatLng(nextLocation);
        if (nextLatLng == null) continue;

        final distance = Geolocator.distanceBetween(
              latLng.latitude,
              latLng.longitude,
              nextLatLng.latitude,
              nextLatLng.longitude,
            ) /
            1000;

        double minCost = double.infinity;
        for (var mode in widget.transportModes) {
          final cost = (costPerKm[mode] ?? double.infinity) * distance;
          if (cost < minCost) minCost = cost;
        }

        newSegmentCosts[i] = minCost;
        newTotalCost += minCost;

        newPolylines.add(
          Polyline(
            polylineId: PolylineId('poly_$i'),
            points: [latLng, nextLatLng],
            color: Colors.blue,
            width: 4,
          ),
        );
      }
    }

    setState(() {
      _markers
        ..clear()
        ..addAll(newMarkers);
      _polylines
        ..clear()
        ..addAll(newPolylines);
      totalSegmentCost = newTotalCost;
      segmentCosts = newSegmentCosts;
    });

    // Move camera to first point
    if (_mapController != null && routePoints.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(routePoints.first, 12),
        );
      });
    }
  }

  LatLng? _extractLatLng(dynamic location) {
    if (location is LatLng) return location;
    if (location is Map) {
      final lat = location['latitude'];
      final lng = location['longitude'];
      if (lat is double && lng is double) {
        return LatLng(lat, lng);
      }
    }
    return null;
  }

  void _showDetailsBottomSheet(Map<String, dynamic> item) {
    final String type = item['type'] ?? 'Item';
    final String name = item['name'] ?? 'Unknown';
    final Map<String, dynamic> details = item['details'] ?? {};
    final dynamic price = details['price'] ?? details['budget'];
    final checkIn = details['checkInDate'];
    final checkOut = details['checkOutDate'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$type: $name",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (price != null)
                Text("Price: ₹${price.toStringAsFixed(0)}",
                    style: const TextStyle(fontSize: 16)),
              if (checkIn != null && checkOut != null) ...[
                const SizedBox(height: 8),
                Text("Check-in: $checkIn",
                    style: const TextStyle(fontSize: 14)),
                Text("Check-out: $checkOut",
                    style: const TextStyle(fontSize: 14)),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Map'),
        backgroundColor: Colors.teal,
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_currentLocation!.latitude!,
                          _currentLocation!.longitude!),
                      zoom: 12,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    markers: _markers,
                    polylines: _polylines,
                    onMapCreated: (controller) {
                      _mapController = controller;
                      setState(() {}); // refresh map
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Travel Segment Costs:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...segmentCosts.entries.map((entry) {
                        final from = widget.itineraryItems[entry.key]['name'];
                        final to = widget.itineraryItems[entry.key + 1]['name'];
                        return Text(
                            "$from ➝ $to: ₹${entry.value.toStringAsFixed(1)}");
                      }),
                      const SizedBox(height: 10),
                      Text(
                        "Total Travel Cost: ₹${totalSegmentCost.toStringAsFixed(1)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
