
// //isme itinerary  ,info and map type  apdation hai  search bar proble in this
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:signinsignup/itinerary_page.dart';
// import 'stay_screen.dart';
// import 'package:signinsignup/stay_screen.dart';
// import 'package:uuid/uuid.dart';
// import 'package:location/location.dart' hide LocationAccuracy;
// import 'place_detail_screen.dart';

// const String googleMapsApiKey = 'AIzaSyBKPLjj-Upqy4tTkO4VnBY9XxN8dKLuSyY';

// class MapScreen extends StatefulWidget {
//   final String city;
//   const MapScreen({super.key, required this.city});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   final Completer<GoogleMapController> _controller = Completer();
//   GoogleMapController? mapController;
//   MapType _currentMapType = MapType.normal;

//   LatLng? _currentPosition;
//   final Set<Marker> _markers = {};
//   final TextEditingController _searchController = TextEditingController();
//   List<dynamic> _placePredictions = [];
//   String _sessionToken = '';
//   Timer? _debounce;

//   Set<String> _selectedCategories = {'restaurant'};
//   Map<String, BitmapDescriptor> _customIcons = {};

//   final List<Map<String, dynamic>> _dharamshalas = [
//     {
//       'name': 'Maa Vaishno Devi Dharamshala',
//       'location': LatLng(27.2040, 77.3837),
//     },
//     {
//       'name': 'Shri Radha Rani Dharmshala',
//       'location': LatLng(27.2025, 77.3798),
//     },
//     {
//       'name': 'Shri Bankey Bihari Ji Dharamshala',
//       'location': LatLng(27.2043, 77.3823),
//     },
//     {'name': 'Radha Govind Dharamshala', 'location': LatLng(27.2055, 77.3810)},
//     {'name': 'Gokul Dharmshala', 'location': LatLng(27.2061, 77.3807)},
//     {'name': 'Prem Mandir Dharamshala', 'location': LatLng(27.2000, 77.3795)},
//     {
//       'name': 'Vrindavan Ashram Dharamshala',
//       'location': LatLng(27.2075, 77.3818),
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadCustomIcons();
//     _getCurrentLocation();
//     _searchController.addListener(_onSearchChanged);
//   }

//   Future<BitmapDescriptor> _getBitmapDescriptorFromAsset(String path) async {
//     return await BitmapDescriptor.fromAssetImage(
//       const ImageConfiguration(size: Size(12, 12)),
//       path,
//     );
//   }

//   Future<void> _loadCustomIcons() async {
//     final icons = {
//       'restaurant': 'assets/icons/restaurant.png',
//       'hotel': 'assets/icons/hotel.png',
//       'atm': 'assets/icons/atm.png',
//       'tourist_attraction': 'assets/icons/temple.png',
//       'dharamshala': 'assets/icons/dharamshala.png',
//     };

//     for (final entry in icons.entries) {
//       final descriptor = await _getBitmapDescriptorFromAsset(entry.value);
//       _customIcons[entry.key] = descriptor;
//     }

//     setState(() {});
//   }

//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (_searchController.text.isNotEmpty && _currentPosition != null) {
//         _getAutocomplete(_searchController.text);
//       } else {
//         setState(() => _placePredictions = []);
//       }
//     });
//   }

//   Future<void> _getCurrentLocation() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return;
//     }

//     if (permission == LocationPermission.deniedForever) return;

//     try {
//       final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//         _markers.add(
//           Marker(
//             markerId: const MarkerId('current'),
//             position: _currentPosition!,
//             infoWindow: const InfoWindow(title: 'You Are Here'),
//             icon: BitmapDescriptor.defaultMarkerWithHue(
//               BitmapDescriptor.hueBlue,
//             ),
//           ),
//         );
//       });

//       _getNearbyPlaces();
//     } catch (e) {
//       print("Location error: $e");
//     }
//   }

//   Future<void> _getAutocomplete(String input) async {
//     _sessionToken = const Uuid().v4();
//     final url =
//         "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=50000&key=$googleMapsApiKey&sessiontoken=$_sessionToken";

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         setState(() => _placePredictions = json['predictions']);
//       }
//     } catch (e) {
//       print("Autocomplete error: $e");
//     }
//   }

//   Future<void> _goToPlace(String placeId) async {
//     final url =
//         "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleMapsApiKey";

//     try {
//       final response = await http.get(Uri.parse(url));
//       final json = jsonDecode(response.body);
//       final result = json['result'];

//       if (result != null) {
//         final location = result['geometry']['location'];
//         final name = result['name'];
//         LatLng latLng = LatLng(location['lat'], location['lng']);

//         _searchController.clear();
//         setState(() => _placePredictions = []);
//         _navigateToPlaceDetail(latLng, name, placeId);
//       }
//     } catch (e) {
//       print("Place detail error: $e");
//     }
//   }

//   Future<void> _navigateToPlaceDetail(
//     LatLng latLng,
//     String name,
//     String placeId,
//   ) async {
//     final url =
//         "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleMapsApiKey";

//     try {
//       final response = await http.get(Uri.parse(url));
//       final json = jsonDecode(response.body);
//       final result = json['result'];

//       if (result != null) {
//         final address = result['formatted_address'] ?? 'No address';
//         final rating = result['rating']?.toString() ?? 'No rating';
//         final openNow = result['opening_hours']?['open_now'] == true
//             ? 'Open Now'
//             : 'Closed';
//         final photoReference = result['photos']?[0]?['photo_reference'];

//         String? photoUrl;
//         if (photoReference != null) {
//           photoUrl =
//               "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$googleMapsApiKey";
//         }

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PlaceDetailScreen(
//               name: name,
//               address: address,
//               rating: rating,
//               openNow: openNow,
//               photoUrl: photoUrl,
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       print("Place detail fetch failed: $e");
//     }
//   }

//   Future<void> _getNearbyPlaces() async {
//     if (_currentPosition == null) return;

//     _markers.removeWhere((m) => m.markerId.value != 'current');

//     for (String type in _selectedCategories) {
//       if (type == 'dharamshala') {
//         for (var dh in _dharamshalas) {
//           final latLng = dh['location'] as LatLng;
//           final name = dh['name'] as String;
//           _markers.add(
//             Marker(
//               markerId: MarkerId('dharamshala-$name'),
//               position: latLng,
//               infoWindow: InfoWindow(title: name),
//               icon:
//                   _customIcons['dharamshala'] ?? BitmapDescriptor.defaultMarker,
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PlaceDetailScreen(
//                     name: name,
//                     address:
//                         'Address not available', // You can hardcode or fetch via API
//                     rating: 'N/A',
//                     openNow: 'N/A',
//                     photoUrl: null,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//       } else {
//         final url =
//             "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=2000&type=$type&key=$googleMapsApiKey";

//         try {
//           final response = await http.get(Uri.parse(url));
//           final json = jsonDecode(response.body);
//           if (json['status'] == 'OK') {
//             final places = json['results'];
//             for (var place in places) {
//               final name = place['name'];
//               final lat = place['geometry']['location']['lat'];
//               final lng = place['geometry']['location']['lng'];
//               LatLng latLng = LatLng(lat, lng);
//               final placeId = place['place_id'];

//               _markers.add(
//                 Marker(
//                   markerId: MarkerId('$type-$name'),
//                   position: latLng,
//                   infoWindow: InfoWindow(title: name),
//                   icon: _customIcons[type] ?? BitmapDescriptor.defaultMarker,
//                   onTap: () => _navigateToPlaceDetail(latLng, name, placeId),
//                 ),
//               );
//             }
//           }
//         } catch (e) {
//           print("Nearby places error for $type: $e");
//         }
//       }
//     }

//     setState(() {});
//   }

//   Widget _buildCategoryFilters() {
//     final categories = {
//       'restaurant': 'Restaurant',
//       'hotel': 'Hotel',
//       'atm': 'ATM',
//       'tourist_attraction': 'Tourist Spot',
//       'dharamshala': 'Dharamshala',
//     };

//     return Wrap(
//       spacing: 10,
//       children: categories.entries.map((entry) {
//         return FilterChip(
//           label: Text(entry.value),
//           selected: _selectedCategories.contains(entry.key),
//           selectedColor: Colors.blueAccent,
//           onSelected: (selected) {
//             setState(() {
//               if (selected) {
//                 _selectedCategories.add(entry.key);
//               } else {
//                 _selectedCategories.remove(entry.key);
//               }
//               _getNearbyPlaces();
//             });
//           },
//         );
//       }).toList(),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Google Maps Clone"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.list),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => StayScreen(
//                     city: widget.city,
//                     selectedAttractions: [],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // _currentPosition == null
//           //     ? const Center(child: CircularProgressIndicator())
//           //     : GoogleMap(
//           //         onMapCreated: (controller) {
//           //           _controller.complete(controller);
//           //           mapController = controller;
//           //         },
//           //         initialCameraPosition: CameraPosition(
//           //           target: _currentPosition!,
//           //           zoom: 14,
//           //         ),
//           //         myLocationEnabled: true,
//           //         myLocationButtonEnabled: true,
//           //         markers: _markers,
//           //       ),
//           /// ✅ Google Map with dynamic mapType
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: LatLng(27.1751, 78.0421), // Example: Taj Mahal
//               zoom: 14,
//             ),
//             onMapCreated: (controller) {
//               mapController = controller;
//             },
//             mapType: _currentMapType, // 👈 This is important!
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             zoomControlsEnabled: false,
//           ),
//           // Map Type Button (Middle Right)
//           Positioned(
//             top: MediaQuery.of(context).size.height / 2 - 30,
//             right: 10,
//             child: FloatingActionButton(
//               heroTag: "mapTypeBtn",
//               mini: true,
//               backgroundColor: Colors.white,
//               onPressed: () {
//                 setState(() {
//                   _currentMapType = _currentMapType == MapType.normal
//                       ? MapType.satellite
//                       : _currentMapType == MapType.satellite
//                           ? MapType.terrain
//                           : MapType.normal;
//                 });
//               },
//               child: Icon(Icons.map, color: Colors.black),
//             ),
//             // bottom: 20,
//             // right: 10,
//             // child: Column(
//             //   children: [
//             //     Container(
//             //       padding: EdgeInsets.symmetric(horizontal: 8),
//             //       decoration: BoxDecoration(
//             //         color: Colors.white,
//             //         borderRadius: BorderRadius.circular(8),
//             //         boxShadow: [
//             //           BoxShadow(color: Colors.black26, blurRadius: 4)
//             //         ],
//             //       ),
//             //       child: DropdownButtonHideUnderline(
//             //         child: DropdownButton<MapType>(
//             //           value: _currentMapType,
//             //           icon: Icon(Icons.map),
//             //           items: [
//             //             DropdownMenuItem(
//             //                 value: MapType.normal, child: Text("Normal")),
//             //             DropdownMenuItem(
//             //                 value: MapType.satellite, child: Text("Satellite")),
//             //             DropdownMenuItem(
//             //                 value: MapType.terrain, child: Text("Terrain")),
//             //             DropdownMenuItem(
//             //                 value: MapType.hybrid, child: Text("Hybrid")),
//             //           ],
//             //           onChanged: (MapType? newType) {
//             //             setState(() {
//             //               _currentMapType = newType!;
//             //             });
//             //           },
//             //         ),
//             //       ),
//             //     ),
//             //   ],
//             // ),
//           ),

//           // Itinerary and Info Buttons (Bottom Right)
// //add
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: Row(
//               children: [
//                 // Info Icon Button (Left of Itinerary)
//                 FloatingActionButton(
//                   heroTag: "infoBtn",
//                   mini: true,
//                   backgroundColor: Colors.white,
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: Text("Info"),
//                         content: Text(
//                             "Tap the map icons to view attractions.\n\nUse the map type button to switch views.\n\nTap 'Itinerary' to build your trip route."),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: Text("OK"),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   child: Icon(Icons.info_outline, color: Colors.black),
//                 ),
//                 SizedBox(width: 10),

//                 // Itinerary Button
//                 // FloatingActionButton.extended(
//                 //   heroTag: "itineraryBtn",
//                 //   backgroundColor: Colors.blue,
//                 //   onPressed: () {
//                 //     // TODO: Implement your itinerary logic or navigation
//                 //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 //       content: Text("Itinerary button tapped."),
//                 //     ));
//                 //   },
//                 //   label: Text("Itinerary"),
//                 //   icon: Icon(Icons.alt_route),
//                 // ),
//                 FloatingActionButton.extended(
//                   heroTag: "itineraryBtn",
//                   backgroundColor: Colors.blue,
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ItineraryPage(
//                                 city: 'Mathura',
//                               )),
//                     );
//                   },
//                   label: Text("Itinerary"),
//                   icon: Icon(Icons.alt_route),
//                 ),
//               ],
//             ),
//           ),

//           Positioned(
//             top: 10,
//             left: 10,
//             right: 10,
//             child: Column(
//               children: [
//                 Card(
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: const InputDecoration(
//                       hintText: 'Search places...',
//                       contentPadding: EdgeInsets.all(10),
//                       suffixIcon: Icon(Icons.search),
//                     ),
//                   ),
//                 ),
//                 if (_placePredictions.isNotEmpty)
//                   Container(
//                     color: Colors.white,
//                     height: 200,
//                     child: ListView.builder(
//                       itemCount: _placePredictions.length,
//                       itemBuilder: (context, index) {
//                         final p = _placePredictions[index];
//                         return ListTile(
//                           title: Text(p['description']),
//                           onTap: () => _goToPlace(p['place_id']),
//                         );
//                       },
//                     ),
//                   ),
//                 const SizedBox(height: 10),
//                 _buildCategoryFilters(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




























































// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:uuid/uuid.dart';

// import 'direction_screen.dart';
// import 'source_selection_screen.dart';
// import 'itinerary_page.dart';
// import 'info_page.dart';

// const String googleMapsApiKey = "AIzaSyBKPLjj-Upqy4tTkO4VnBY9XxN8dKLuSyY";

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key, required String city});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   final Completer<GoogleMapController> _controller = Completer();
//   LatLng? _currentPosition;
//   final Set<Marker> _markers = {};
//   final TextEditingController _searchController = TextEditingController();
//   List<dynamic> _placePredictions = [];
//   String _sessionToken = '';
//   Timer? _debounce;
//   String _selectedCategory = 'restaurant';

//   String? _selectedPlaceName;
//   LatLng? _selectedDestination;
//   double? _selectedPlaceRating;
//   String? _photoReference;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     _searchController.addListener(_onSearchChanged);
//   }

//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (_searchController.text.isNotEmpty && _currentPosition != null) {
//         _getAutocomplete(_searchController.text);
//       } else {
//         setState(() => _placePredictions = []);
//       }
//     });
//   }

//   Future<void> _getCurrentLocation() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return;
//     }
//     if (permission == LocationPermission.deniedForever) return;

//     try {
//       final position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//         _markers.add(Marker(
//           markerId: const MarkerId('current'),
//           position: _currentPosition!,
//           infoWindow: const InfoWindow(title: 'You Are Here'),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         ));
//       });
//       _getNearbyPlaces(_selectedCategory);
//     } catch (e) {
//       print("Location error: $e");
//     }
//   }

//   Future<void> _getAutocomplete(String input) async {
//     _sessionToken = const Uuid().v4();
//     final url =
//         "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=50000&key=$googleMapsApiKey&sessiontoken=$_sessionToken";

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         setState(() => _placePredictions = json['predictions']);
//       }
//     } catch (e) {
//       print("Autocomplete error: $e");
//     }
//   }

//   Future<void> _goToPlace(String placeId) async {
//     final url =
//         "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleMapsApiKey";

//     try {
//       final response = await http.get(Uri.parse(url));
//       final json = jsonDecode(response.body);
//       final result = json['result'];

//       if (result != null) {
//         final location = result['geometry']['location'];
//         final name = result['name'];
//         final rating = result['rating']?.toDouble();
//         final photos = result['photos'] as List?;
//         final photoRef = photos != null && photos.isNotEmpty
//             ? photos[0]['photo_reference']
//             : null;

//         LatLng latLng = LatLng(location['lat'], location['lng']);

//         _searchController.clear();
//         setState(() {
//           _placePredictions = [];
//           _selectedPlaceName = name;
//           _selectedDestination = latLng;
//           _selectedPlaceRating = rating;
//           _photoReference = photoRef;
//         });

//         _promptForSourceAndNavigate(latLng, name);
//       }
//     } catch (e) {
//       print("Place detail error: $e");
//     }
//   }

//   Future<void> _getNearbyPlaces(String type) async {
//     if (_currentPosition == null) return;

//     final url =
//         "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=2000&type=$type&key=$googleMapsApiKey";

//     try {
//       final response = await http.get(Uri.parse(url));
//       final json = jsonDecode(response.body);
//       if (json['status'] == 'OK') {
//         final places = json['results'];
//         _markers.removeWhere((m) => m.markerId.value != 'current');
//         for (var place in places) {
//           final name = place['name'];
//           final lat = place['geometry']['location']['lat'];
//           final lng = place['geometry']['location']['lng'];
//           LatLng latLng = LatLng(lat, lng);

//           _markers.add(Marker(
//             markerId: MarkerId(name),
//             position: latLng,
//             infoWindow: InfoWindow(title: name),
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//             onTap: () {
//               setState(() {
//                 _selectedPlaceName = name;
//                 _selectedDestination = latLng;
//               });
//             },
//           ));
//         }
//         setState(() {});
//       }
//     } catch (e) {
//       print("Nearby places error: $e");
//     }
//   }

//   Future<void> _promptForSourceAndNavigate(LatLng destination, String name) async {
//     final source = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             SourceSelectionScreen(destination: destination, destinationName: name),
//       ),
//     );

//     if (source != null && source is LatLng) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DirectionScreen(
//             initialOrigin: source,
//             destination: destination,
//             destinationName: name,
//             sourceName: "My Location",
//           ),
//         ),
//       );
//     }
//   }

//   Widget _buildCategoryChips() {
//     final categories = ['restaurant', 'hotel', 'atm', 'tourist_attraction'];
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: categories.map((type) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: ChoiceChip(
//               label: Text(type.replaceAll('_', ' ').toUpperCase()),
//               selected: _selectedCategory == type,
//               selectedColor: Colors.blueAccent,
//               onSelected: (selected) {
//                 if (selected) {
//                   setState(() => _selectedCategory = type);
//                   _getNearbyPlaces(type);
//                 }
//               },
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildFeatureButtons() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.95),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _featureButton(Icons.directions, "Itinerary", () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const ItineraryPage(city: 'Mathura',)),
//             );
//           }),
//           _featureButton(Icons.info_outline, "Info", () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const InfoPage(city: 'Mathura',)),
//             );
//           }),
//           _featureButton(Icons.reviews, "Reviews", () {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Review feature coming soon")),
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _featureButton(IconData icon, String label, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 22,
//             backgroundColor: Colors.blueAccent,
//             child: Icon(icon, color: Colors.white),
//           ),
//           const SizedBox(height: 5),
//           Text(label, style: const TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Google Maps Clone")),
//       body: Stack(
//         children: [
//           _currentPosition == null
//               ? const Center(child: CircularProgressIndicator())
//               : GoogleMap(
//                   onMapCreated: (controller) => _controller.complete(controller),
//                   initialCameraPosition:
//                       CameraPosition(target: _currentPosition!, zoom: 14),
//                   myLocationEnabled: true,
//                   myLocationButtonEnabled: true,
//                   markers: _markers,
//                 ),
//           Positioned(
//             top: 10,
//             left: 10,
//             right: 10,
//             child: Column(
//               children: [
//                 Card(
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: const InputDecoration(
//                       hintText: 'Search places...',
//                       contentPadding: EdgeInsets.all(10),
//                       suffixIcon: Icon(Icons.search),
//                     ),
//                   ),
//                 ),
//                 if (_placePredictions.isNotEmpty)
//                   Container(
//                     color: Colors.white,
//                     height: 200,
//                     child: ListView.builder(
//                       itemCount: _placePredictions.length,
//                       itemBuilder: (context, index) {
//                         final p = _placePredictions[index];
//                         return ListTile(
//                           title: Text(p['description']),
//                           onTap: () => _goToPlace(p['place_id']),
//                         );
//                       },
//                     ),
//                   ),
//                 const SizedBox(height: 10),
//                 _buildCategoryChips(),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 20,
//             left: 10,
//             right: 10,
//             child: _buildFeatureButtons(),
//           ),
//         ],
//       ),
//     );
//   }
// }































// Final Code 

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'direction_screen.dart';
import 'source_selection_screen.dart';
import 'itinerary_page.dart';
import 'info_page.dart';

const String googleMapsApiKey = "AIzaSyBKPLjj-Upqy4tTkO4VnBY9XxN8dKLuSyY";

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required String city});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _placePredictions = [];
  String _sessionToken = '';
  Timer? _debounce;
  String _selectedCategory = 'restaurant';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty && _currentPosition != null) {
        _getAutocomplete(_searchController.text);
      } else {
        setState(() => _placePredictions = []);
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _markers.add(Marker(
          markerId: const MarkerId('current'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(title: 'You Are Here'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));
      });
      _getNearbyPlaces(_selectedCategory);
    } catch (e) {
      print("Location error: $e");
    }
  }

  Future<void> _getAutocomplete(String input) async {
    _sessionToken = const Uuid().v4();
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=50000&key=$googleMapsApiKey&sessiontoken=$_sessionToken";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() => _placePredictions = json['predictions']);
      }
    } catch (e) {
      print("Autocomplete error: $e");
    }
  }

  Future<void> _getNearbyPlaces(String type) async {
    if (_currentPosition == null) return;

    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=2000&type=$type&key=$googleMapsApiKey";

    try {
      final response = await http.get(Uri.parse(url));
      final json = jsonDecode(response.body);
      if (json['status'] == 'OK') {
        final places = json['results'];
        _markers.removeWhere((m) => m.markerId.value != 'current');
        for (var place in places) {
          final name = place['name'];
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];
          final placeId = place['place_id'];

          LatLng latLng = LatLng(lat, lng);

          _markers.add(Marker(
            markerId: MarkerId(name),
            position: latLng,
            infoWindow: InfoWindow(title: name),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            onTap: () => _goToPlace(placeId),
          ));
        }
        setState(() {});
      }
    } catch (e) {
      print("Nearby places error: $e");
    }
  }

  Future<void> _goToPlace(String placeId) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleMapsApiKey";

    try {
      final response = await http.get(Uri.parse(url));
      final json = jsonDecode(response.body);
      final result = json['result'];

      if (result != null) {
        final location = result['geometry']['location'];
        final name = result['name'];
        final rating = result['rating']?.toDouble();
        final address = result['formatted_address'];
        final photos = result['photos'] as List?;
        final photoRef = photos != null && photos.isNotEmpty
            ? photos[0]['photo_reference']
            : null;

        LatLng latLng = LatLng(location['lat'], location['lng']);

        _searchController.clear();
        setState(() => _placePredictions = []);

        _showPlaceDetailsBottomSheet(name, address, rating, photoRef, latLng);
      }
    } catch (e) {
      print("Place detail error: $e");
    }
  }

  void _showPlaceDetailsBottomSheet(
      String name, String address, double? rating, String? photoRef, LatLng destination) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (photoRef != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoRef&key=$googleMapsApiKey',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 10),
              Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(address, style: const TextStyle(color: Colors.grey)),
              if (rating != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 20),
                      Text(rating.toString(), style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context); // Close bottom sheet
                  _promptForSourceAndNavigate(destination, name);
                },
                icon: const Icon(Icons.directions),
                label: const Text("Get Directions"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _promptForSourceAndNavigate(LatLng destination, String name) async {
    final source = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SourceSelectionScreen(destination: destination, destinationName: name),
      ),
    );

    if (source != null && source is LatLng) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DirectionScreen(
            initialOrigin: source,
            destination: destination,
            destinationName: name,
            sourceName: "My Location",
          ),
        ),
      );
    }
  }

  Widget _buildCategoryChips() {
    final categories = ['restaurant', 'hotel', 'atm', 'tourist_attraction'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((type) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(type.replaceAll('_', ' ').toUpperCase()),
              selected: _selectedCategory == type,
              selectedColor: Colors.blueAccent,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedCategory = type);
                  _getNearbyPlaces(type);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _featureButton(Icons.directions, "Itinerary", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ItineraryPage(city: 'Mathura')),
            );
          }),
          _featureButton(Icons.info_outline, "Info", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InfoPage(city: 'Mathura')),
            );
          }),
          _featureButton(Icons.reviews, "Reviews", () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Review feature coming soon")),
            );
          }),
        ],
      ),
    );
  }

  Widget _featureButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blueAccent,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
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
      appBar: AppBar(title: const Text("Explore Mathura")),
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: (controller) => _controller.complete(controller),
                  initialCameraPosition: CameraPosition(target: _currentPosition!, zoom: 14),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: _markers,
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
                      hintText: 'Search places...',
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                if (_placePredictions.isNotEmpty)
                  Container(
                    color: Colors.white,
                    height: 200,
                    child: ListView.builder(
                      itemCount: _placePredictions.length,
                      itemBuilder: (context, index) {
                        final p = _placePredictions[index];
                        return ListTile(
                          title: Text(p['description']),
                          onTap: () => _goToPlace(p['place_id']),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                _buildCategoryChips(),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: _buildFeatureButtons(),
          ),
        ],
      ),
    );
  }
}
