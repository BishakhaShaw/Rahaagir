import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as loc;

import 'info_page.dart';
import 'stay_screen.dart';
import 'profile_page.dart';

class ItineraryPage extends StatefulWidget {
  final String city;
  final LatLng? initialCoordinates;

  const ItineraryPage({super.key, required this.city, this.initialCoordinates});

  @override
  _ItineraryPageState createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  late GoogleMapController mapController;
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  loc.Location location = loc.Location();
  final TextEditingController _searchController = TextEditingController();

  final String googleMapsApiKey = "AIzaSyBKPLjj-Upqy4tTkO4VnBY9XxN8dKLuSyY";
  late GoogleMapsPlaces places;

  final LatLng _defaultCityLatLng = const LatLng(27.4924, 77.6737); // Mathura
  LatLng? _currentUserLocation;

  List<String> selectedAttractions = [];

  @override
  void initState() {
    super.initState();
    places = GoogleMapsPlaces(apiKey: googleMapsApiKey);
    _currentUserLocation = widget.initialCoordinates ?? _defaultCityLatLng;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAttractions(); // Initial load
    });
  }

  void _fetchAttractions() {
    _fetchPlaces("tourist_attraction", BitmapDescriptor.hueRed);
  }

  Future<void> _fetchPlaces(String placeType, double markerColor) async {
    final locationToUse = _currentUserLocation ?? _defaultCityLatLng;

    try {
      final response = await places.searchNearbyWithRadius(
        Location(lat: locationToUse.latitude, lng: locationToUse.longitude),
        5000,
        type: placeType,
      );

      if (response.status == "OK") {
        
        final random = Random();
        setState(() {
          _markers.clear();

          for (var result in response.results) {
            if (result.geometry?.location == null) continue;

            double offsetLat = (random.nextDouble() - 0.5) / 10000;
            double offsetLng = (random.nextDouble() - 0.5) / 10000;

            final latLng = LatLng(
              result.geometry!.location.lat + offsetLat,
              result.geometry!.location.lng + offsetLng,
            );

            _markers.add(
              Marker(
                markerId: MarkerId(result.placeId),
                position: latLng,
                infoWindow: InfoWindow(title: result.name),
                icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
                onTap: () {
                  _showAttractionSelectionDialog(result.name ?? "Unknown");
                },
              ),
            );
          }
        });
      } else {
        print("Error fetching $placeType: ${response.errorMessage}");
      }
    } catch (e) {
      print("Error during nearby search: $e");
    }
  }

  void _showAttractionSelectionDialog(String attractionName) {
    final isSelected = selectedAttractions.contains(attractionName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(attractionName),
        content: Text(
          isSelected
              ? "Remove this attraction from your itinerary?"
              : "Add this attraction to your itinerary?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (isSelected) {
                  selectedAttractions.remove(attractionName);
                } else {
                  selectedAttractions.add(attractionName);
                }
              });
              Navigator.pop(context);
            },
            child: Text(isSelected ? "Remove" : "Add"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _searchLocation(String query) async {
    try {
      final response = await places.searchByText(query);
      if (response.status == "OK" && response.results.isNotEmpty) {
        final result = response.results.first;
        final searchedLatLng = LatLng(
          result.geometry!.location.lat,
          result.geometry!.location.lng,
        );

        setState(() {
          _currentUserLocation = searchedLatLng;
        });

        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(searchedLatLng, 14),
        );

        _fetchAttractions();
      } else {
        print("Search failed: ${response.errorMessage}");
      }
    } catch (e) {
      print("Error during text search: $e");
    }
  }

  void _navigateToStayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StayScreen(
          city: widget.city,
          selectedAttractions: selectedAttractions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ITINERARY',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
              mapController.animateCamera(
                CameraUpdate.newLatLngZoom(_currentUserLocation!, 14),
              );
            },
            onCameraIdle: _fetchAttractions,
            onCameraMove: (position) {
              _currentUserLocation = position.target;
            },
            initialCameraPosition: CameraPosition(
              target: _currentUserLocation ?? _defaultCityLatLng,
              zoom: 14.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attractions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: "Search a location",
                            border: InputBorder.none,
                          ),
                          onSubmitted: _searchLocation,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () =>
                            _searchLocation(_searchController.text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<MapType>(
                      value: _currentMapType,
                      icon: const Icon(Icons.map),
                      items: const [
                        DropdownMenuItem(
                          value: MapType.normal,
                          child: Text("Normal"),
                        ),
                        DropdownMenuItem(
                          value: MapType.satellite,
                          child: Text("Satellite"),
                        ),
                        DropdownMenuItem(
                          value: MapType.terrain,
                          child: Text("Terrain"),
                        ),
                        DropdownMenuItem(
                          value: MapType.hybrid,
                          child: Text("Hybrid"),
                        ),
                      ],
                      onChanged: (MapType? newType) {
                        setState(() {
                          _currentMapType = newType!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  mini: true,
                  heroTag: "info",
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfoPage(city: widget.city),
                      ),
                    );
                  },
                  child: const Icon(Icons.info_outline, color: Colors.blue),
                ),
              ],
            ),
          ),
          Positioned(
            top: 80,
            left: 10,
            child: FloatingActionButton(
              mini: true,
              heroTag: "stay",
              backgroundColor: Colors.blueAccent,
              onPressed:
                  selectedAttractions.isEmpty ? null : _navigateToStayScreen,
              tooltip: "Go to Stay Screen",
              child: const Icon(Icons.hotel),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed:
                  selectedAttractions.isEmpty ? null : _navigateToStayScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Continue the Journey",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
