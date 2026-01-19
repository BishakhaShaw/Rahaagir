import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class FoodMapScreen extends StatefulWidget {
  final List<PlacesSearchResult> restaurants;

  const FoodMapScreen({required this.restaurants, super.key});

  @override
  State<FoodMapScreen> createState() => _FoodMapScreenState();
}

class _FoodMapScreenState extends State<FoodMapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  LatLng _initialPosition = const LatLng(20.5937, 78.9629); // Default to India

  @override
  void initState() {
    super.initState();
    if (widget.restaurants.isNotEmpty) {
      final first = widget.restaurants.first.geometry?.location;
      if (first != null) {
        _initialPosition = LatLng(first.lat, first.lng);
      }

      for (var place in widget.restaurants) {
        final loc = place.geometry?.location;
        if (loc != null) {
          _markers.add(Marker(
            markerId: MarkerId(place.placeId ?? place.name ?? ''),
            position: LatLng(loc.lat, loc.lng),
            infoWindow: InfoWindow(
              title: place.name,
              snippet: "Rating: ${place.rating ?? 'N/A'}",
            ),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurants Map View"),
        backgroundColor: Colors.green.shade700,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 13,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
