// import 'package:flutter/material.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:geocoding/geocoding.dart' as geo;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'FoodMapScreen.dart';
// import 'ModeOfTransportPage.dart';
// import 'menu_screen.dart';
// import 'summary_screen.dart';

// class FoodScreen extends StatefulWidget {
//   final String city;
//   final double budget;
//   final Map<String, double> selectedRestaurants;
//   final List<Map<String, dynamic>> selectedAttractions;
//   final List<Map<String, dynamic>> selectedHotels;

//   const FoodScreen({
//     required this.city,
//     required this.budget,
//     required this.selectedRestaurants,
//     required this.selectedAttractions,
//     required this.selectedHotels,
//     super.key,
//   });

//   @override
//   _FoodScreenState createState() => _FoodScreenState();
// }

// class _FoodScreenState extends State<FoodScreen> {
//   List<PlacesSearchResult> restaurants = [];
//   bool isLoading = true;
//   late double totalBudget;
//   late Map<String, double> selectedRestaurants;
//   bool showRestaurants = true;
//   bool showDhabas = true;

//   final String googlePlacesApiKey = "AIzaSyBKPLjj-Upqy4tTkO4VnBY9XxN8dKLuSyY";
//   late GoogleMapsPlaces _places;

//   final TextEditingController searchController = TextEditingController();
//   String searchQuery = '';

//   List<Map<String, String>> dhabas = [
//     {"name": "Desi Dhaba", "rating": "4.5"},
//     {"name": "Highway Dhaba", "rating": "4.2"},
//     {"name": "Tandoori Nights", "rating": "4.0"},
//   ];

//   get calculatedBudget => null;

//   @override
//   void initState() {
//     super.initState();
//     totalBudget = widget.budget;
//     selectedRestaurants = Map.from(widget.selectedRestaurants);
//     _places = GoogleMapsPlaces(apiKey: googlePlacesApiKey);
//     fetchRestaurantsFromGoogle();
//   }

//   Future<void> fetchRestaurantsFromGoogle() async {
//     setState(() => isLoading = true);
//     try {
//       final cityLatLng = await _getCityCoordinates(widget.city);
//       if (cityLatLng != null) {
//         final response = await _places.searchNearbyWithRadius(
//           Location(lat: cityLatLng.latitude, lng: cityLatLng.longitude),
//           5000,
//           type: 'restaurant',
//         );
//         if (response.status == "OK") {
//           setState(() {
//             restaurants = response.results;
//           });
//         } else {
//           debugPrint("Google Places Error: ${response.errorMessage}");
//         }
//       } else {
//         debugPrint("Could not determine coordinates for city: ${widget.city}");
//       }
//     } catch (e) {
//       debugPrint("Exception fetching restaurants: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<LatLng?> _getCityCoordinates(String city) async {
//     try {
//       final List<geo.Location> locations = await geo.locationFromAddress(city);
//       if (locations.isNotEmpty) {
//         final loc = locations.first;
//         return LatLng(loc.latitude, loc.longitude);
//       }
//     } catch (e) {
//       debugPrint("Geocoding error: $e");
//     }
//     return null;
//   }

//   void openMenuScreen(String name) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => MenuScreen(restaurantName: name)),
//     );
//     if (result != null && result is double) {
//       setState(() {
//         selectedRestaurants[name] = result;
//         totalBudget = widget.budget +
//             selectedRestaurants.values.fold(0, (prev, curr) => prev + curr);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, String>> filteredDhabas = dhabas
//         .where((d) => d["name"]!.toLowerCase().contains(searchQuery))
//         .toList();

//     List<PlacesSearchResult> filteredRestaurants = restaurants
//         .where((r) => r.name.toLowerCase().contains(searchQuery) ?? false)
//         .toList();

//     final allItems = [
//       if (showRestaurants) ...filteredRestaurants,
//       if (showDhabas) ...filteredDhabas,
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ITINERARY",
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 10),
//             child: CircleAvatar(
//               radius: 22,
//               backgroundImage: AssetImage("assets/your_image.png"),
//             ),
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       const Text("Food",
//                           style: TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.bold)),
//                       const Spacer(),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SummaryScreen(
//                                 selectedAttractions: widget.selectedAttractions,
//                                 selectedHotels: widget.selectedHotels,
//                                 selectedRestaurants: selectedRestaurants,
//                                 totalBudget: totalBudget,
//                                 selectedTransportModes: [],
//                               ),
//                             ),
//                           );
//                         },
//                         child:
//                             Text("Budget : ₹${totalBudget.toStringAsFixed(0)}"),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   child: TextField(
//                     controller: searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Search restaurants or dhabas...',
//                       prefixIcon: const Icon(Icons.search),
//                       suffixIcon: searchQuery.isNotEmpty
//                           ? IconButton(
//                               icon: const Icon(Icons.clear),
//                               onPressed: () {
//                                 setState(() {
//                                   searchQuery = '';
//                                   searchController.clear();
//                                 });
//                               },
//                             )
//                           : null,
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                     ),
//                     onChanged: (value) =>
//                         setState(() => searchQuery = value.toLowerCase()),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Row(
//                     children: [
//                       Checkbox(
//                           value: showRestaurants,
//                           onChanged: (v) =>
//                               setState(() => showRestaurants = v!)),
//                       const Text("Restaurants"),
//                       const SizedBox(width: 20),
//                       Checkbox(
//                           value: showDhabas,
//                           onChanged: (v) => setState(() => showDhabas = v!)),
//                       const Text("Dhabas"),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView(
//                     children: [
//                       ...allItems.map((item) {
//                         if (item is PlacesSearchResult) {
//                           return buildFoodTile(
//                             name: item.name ?? 'Unknown',
//                             rating: item.rating?.toString() ?? "N/A",
//                             photoReference: item.photos.isNotEmpty == true
//                                 ? item.photos.first.photoReference
//                                 : null,
//                           );
//                         } else {
//                           final dhaba = item as Map<String, String>;
//                           return buildFoodTile(
//                             name: dhaba["name"]!,
//                             rating: dhaba["rating"]!,
//                             photoReference: null,
//                           );
//                         }
//                       }),
//                       const Divider(),
//                       const Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Text("Selected Items",
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold)),
//                       ),
//                       ExpansionTile(
//                         title: const Text("Selected Restaurants"),
//                         children: selectedRestaurants.entries
//                             .map((e) => ListTile(
//                                   title: Text(e.key),
//                                   trailing:
//                                       Text("₹${e.value.toStringAsFixed(0)}"),
//                                 ))
//                             .toList(),
//                       ),
//                       ExpansionTile(
//                         title: const Text("Selected Attractions"),
//                         children: widget.selectedAttractions
//                             .map((a) => ListTile(
//                                 title: Text(a['name'] ?? 'Unknown Attraction')))
//                             .toList(),
//                       ),
//                       ExpansionTile(
//                         title: const Text("Selected Hotels"),
//                         children: widget.selectedHotels.map((hotel) {
//                           return ListTile(
//                             title: Text(hotel['name'] ?? 'Unknown Hotel'),
//                             subtitle: Text(
//                                 "${hotel['checkInDate'] ?? ''} to ${hotel['checkOutDate'] ?? ''}"),
//                             trailing: Text(
//                                 "₹${hotel['price']?.toStringAsFixed(0) ?? 'N/A'}"),
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ElevatedButton.icon(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   FoodMapScreen(restaurants: restaurants),
//                             ),
//                           );
//                         },
//                         icon: const Icon(Icons.map, color: Colors.blue),
//                         label: const Text("IN MAP VIEW",
//                             style: TextStyle(color: Colors.blue)),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SummaryScreen(
//                                 selectedRestaurants: selectedRestaurants,
//                                 totalBudget: totalBudget,
//                                 selectedAttractions: widget.selectedAttractions,
//                                 selectedHotels: widget.selectedHotels,
//                                 selectedTransportModes: [],
//                               ),
//                             ),
//                           );
//                         },
//                         child: const Text("Done"),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ModeOfTransportPage(
//                                       selectedAttractions: [],
//                                       selectedHotels: [],
//                                       selectedRestaurants: {},
//                                       totalBudget: totalBudget,
//                                     )),
//                           );
//                         },
//                         child: const Text("Next"),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget buildFoodTile(
//       {required String name, required String rating, String? photoReference}) {
//     Widget leadingWidget;
//     if (photoReference != null) {
//       leadingWidget = SizedBox(
//         width: 80,
//         height: 80,
//         child: Image.network(
//           "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$googlePlacesApiKey",
//           fit: BoxFit.cover,
//         ),
//       );
//     } else {
//       leadingWidget = const Icon(Icons.restaurant, size: 40);
//     }

//     return Card(
//       margin: const EdgeInsets.all(10),
//       child: ListTile(
//         leading: leadingWidget,
//         title: Text(name),
//         subtitle: Text("Rating: $rating ⭐"),
//         trailing: ElevatedButton(
//           onPressed: () => openMenuScreen(name),
//           child: const Text("Menu"),
//         ),
//       ),
//     );
//   }
// }

// //same hi hai
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:geocoding/geocoding.dart' as geo;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'FoodMapScreen.dart';
// import 'ModeOfTransportPage.dart';
// import 'menu_screen.dart';
// import 'summary_screen.dart';

// class FoodScreen extends StatefulWidget {
//   final String city;
//   final double budget;

//   final Map<String, double> selectedRestaurants;
//   final List<Map<String, dynamic>> selectedAttractions;
//   final List<Map<String, dynamic>> selectedHotels;

//   const FoodScreen({
//     required this.city,
//     required this.budget,
//     required this.selectedRestaurants,
//     required this.selectedAttractions,
//     required this.selectedHotels,
//     super.key,
//     required bool autoSelectBestMode,
//   });

//   @override
//   _FoodScreenState createState() => _FoodScreenState();
// }

// class _FoodScreenState extends State<FoodScreen> {
//   //new add
//   User? currentUser;

//   List<PlacesSearchResult> restaurants = [];
//   bool isLoading = true;
//   late double totalBudget;
//   late Map<String, double> selectedRestaurants;
//   bool showRestaurants = true;
//   bool showDhabas = true;

//   final String googlePlacesApiKey = "AIzaSyBKPLjj-Upqy4tTkO4VnBY9XxN8dKLuSyY";
//   late GoogleMapsPlaces _places;

//   final TextEditingController searchController = TextEditingController();
//   String searchQuery = '';

//   List<Map<String, String>> dhabas = [
//     {"name": "Desi Dhaba", "rating": "4.5"},
//     {"name": "Highway Dhaba", "rating": "4.2"},
//     {"name": "Tandoori Nights", "rating": "4.0"},
//   ];

//   get calculatedBudget => null;

//   @override
//   void initState() {
//     super.initState();
//     totalBudget = widget.budget;
//     selectedRestaurants = Map.from(widget.selectedRestaurants);
//     _places = GoogleMapsPlaces(apiKey: googlePlacesApiKey);
//     fetchRestaurantsFromGoogle();
//     currentUser = FirebaseAuth.instance.currentUser;
//   }

//   Future<void> fetchRestaurantsFromGoogle() async {
//     setState(() => isLoading = true);
//     try {
//       final cityLatLng = await _getCityCoordinates(widget.city);
//       if (cityLatLng != null) {
//         final response = await _places.searchNearbyWithRadius(
//           Location(lat: cityLatLng.latitude, lng: cityLatLng.longitude),
//           5000,
//           type: 'restaurant',
//         );
//         if (response.status == "OK") {
//           setState(() {
//             restaurants = response.results;
//           });
//         } else {
//           debugPrint("Google Places Error: ${response.errorMessage}");
//         }
//       } else {
//         debugPrint("Could not determine coordinates for city: ${widget.city}");
//       }
//     } catch (e) {
//       debugPrint("Exception fetching restaurants: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<LatLng?> _getCityCoordinates(String city) async {
//     try {
//       final List<geo.Location> locations = await geo.locationFromAddress(city);
//       if (locations.isNotEmpty) {
//         final loc = locations.first;
//         return LatLng(loc.latitude, loc.longitude);
//       }
//     } catch (e) {
//       debugPrint("Geocoding error: $e");
//     }
//     return null;
//   }

//   void openMenuScreen(String name) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => MenuScreen(restaurantName: name)),
//     );
//     if (result != null && result is double) {
//       setState(() {
//         selectedRestaurants[name] = result;
//         totalBudget = widget.budget +
//             selectedRestaurants.values.fold(0, (prev, curr) => prev + curr);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, String>> filteredDhabas = dhabas
//         .where((d) => d["name"]!.toLowerCase().contains(searchQuery))
//         .toList();

//     List<PlacesSearchResult> filteredRestaurants = restaurants
//         .where((r) => r.name.toLowerCase().contains(searchQuery) ?? false)
//         .toList();

//     final allItems = [
//       if (showRestaurants) ...filteredRestaurants,
//       if (showDhabas) ...filteredDhabas,
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ITINERARY",
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: currentUser?.photoURL != null
//                 ? CircleAvatar(
//                     radius: 22,
//                     backgroundImage: NetworkImage(currentUser!.photoURL!),
//                   )
//                 : CircleAvatar(
//                     radius: 22,
//                     child: Text(
//                       currentUser?.email?.substring(0, 1).toUpperCase() ?? '',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       const Text("Food",
//                           style: TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.bold)),
//                       const Spacer(),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SummaryScreen(
//                                 selectedAttractions: widget.selectedAttractions,
//                                 selectedHotels: widget.selectedHotels,
//                                 selectedRestaurants: selectedRestaurants,
//                                 totalBudget: totalBudget,
//                                 selectedTransportModes: [],
//                                 autoSelectBestMode: true,
//                               ),
//                             ),
//                           );
//                         },
//                         child:
//                             Text("Budget : ₹${totalBudget.toStringAsFixed(0)}"),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   child: TextField(
//                     controller: searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Search restaurants or dhabas...',
//                       prefixIcon: const Icon(Icons.search),
//                       suffixIcon: searchQuery.isNotEmpty
//                           ? IconButton(
//                               icon: const Icon(Icons.clear),
//                               onPressed: () {
//                                 setState(() {
//                                   searchQuery = '';
//                                   searchController.clear();
//                                 });
//                               },
//                             )
//                           : null,
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                     ),
//                     onChanged: (value) =>
//                         setState(() => searchQuery = value.toLowerCase()),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Row(
//                     children: [
//                       Checkbox(
//                           value: showRestaurants,
//                           onChanged: (v) =>
//                               setState(() => showRestaurants = v!)),
//                       const Text("Restaurants"),
//                       const SizedBox(width: 20),
//                       Checkbox(
//                           value: showDhabas,
//                           onChanged: (v) => setState(() => showDhabas = v!)),
//                       const Text("Dhabas"),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView(
//                     children: [
//                       ...allItems.map((item) {
//                         if (item is PlacesSearchResult) {
//                           return buildFoodTile(
//                             name: item.name ?? 'Unknown',
//                             rating: item.rating?.toString() ?? "N/A",
//                             photoReference: item.photos.isNotEmpty == true
//                                 ? item.photos.first.photoReference
//                                 : null,
//                           );
//                         } else {
//                           final dhaba = item as Map<String, String>;
//                           return buildFoodTile(
//                             name: dhaba["name"]!,
//                             rating: dhaba["rating"]!,
//                             photoReference: null,
//                           );
//                         }
//                       }),
//                       const Divider(),
//                       const Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Text("Selected Items",
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold)),
//                       ),
//                       ExpansionTile(
//                         title: const Text("Selected Restaurants"),
//                         children: selectedRestaurants.entries
//                             .map((e) => ListTile(
//                                   title: Text(e.key),
//                                   trailing:
//                                       Text("₹${e.value.toStringAsFixed(0)}"),
//                                 ))
//                             .toList(),
//                       ),
//                       ExpansionTile(
//                         title: const Text("Selected Attractions"),
//                         children: widget.selectedAttractions
//                             .map((a) => ListTile(
//                                 title: Text(a['name'] ?? 'Unknown Attraction')))
//                             .toList(),
//                       ),
//                       ExpansionTile(
//                         title: const Text("Selected Hotels"),
//                         children: widget.selectedHotels.map((hotel) {
//                           return ListTile(
//                             title: Text(hotel['name'] ?? 'Unknown Hotel'),
//                             subtitle: Text(
//                                 "${hotel['checkInDate'] ?? ''} to ${hotel['checkOutDate'] ?? ''}"),
//                             trailing: Text(
//                                 "₹${hotel['price']?.toStringAsFixed(0) ?? 'N/A'}"),
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ElevatedButton.icon(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   FoodMapScreen(restaurants: restaurants),
//                             ),
//                           );
//                         },
//                         icon: const Icon(Icons.map, color: Colors.blue),
//                         label: const Text("IN MAP VIEW",
//                             style: TextStyle(color: Colors.blue)),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SummaryScreen(
//                                 selectedRestaurants: selectedRestaurants,
//                                 totalBudget: totalBudget,
//                                 selectedAttractions: widget.selectedAttractions,
//                                 selectedHotels: widget.selectedHotels,
//                                 selectedTransportModes: [],
//                                 autoSelectBestMode: true,
//                               ),
//                             ),
//                           );
//                         },
//                         child: const Text("Done"),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ModeOfTransportPage(
//                                       selectedAttractions: [],
//                                       selectedHotels: [],
//                                       selectedRestaurants: {},
//                                       totalBudget: totalBudget,
//                                       city: '',
//                                       autoSelectBestMode: true,
//                                     )),
//                           );
//                         },
//                         child: const Text("Next"),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget buildFoodTile(
//       {required String name, required String rating, String? photoReference}) {
//     Widget leadingWidget;
//     if (photoReference != null) {
//       leadingWidget = SizedBox(
//         width: 80,
//         height: 80,
//         child: Image.network(
//           "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$googlePlacesApiKey",
//           fit: BoxFit.cover,
//         ),
//       );
//     } else {
//       leadingWidget = const Icon(Icons.restaurant, size: 40);
//     }

//     return Card(
//       margin: const EdgeInsets.all(10),
//       child: ListTile(
//         leading: leadingWidget,
//         title: Text(name),
//         subtitle: Text("Rating: $rating ⭐"),
//         trailing: ElevatedButton(
//           onPressed: () => openMenuScreen(name),
//           child: const Text("Menu"),
//         ),
//       ),
//     );
//   }
// }

//new

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'FoodMapScreen.dart';
import 'ModeOfTransportPage.dart';
import 'menu_screen.dart';
import 'summary_screen.dart';

class FoodScreen extends StatefulWidget {
  final String city;
  final double budget;

  final Map<String, double> selectedRestaurants;
  final List<Map<String, dynamic>> selectedAttractions;
  final List<Map<String, dynamic>> selectedHotels;
  final bool autoSelectBestMode;

  const FoodScreen({
    required this.city,
    required this.budget,
    required this.selectedRestaurants,
    required this.selectedAttractions,
    required this.selectedHotels,
    required this.autoSelectBestMode,
    super.key,
  });

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  User? currentUser;

  List<PlacesSearchResult> restaurants = [];
  bool isLoading = true;
  late double totalBudget;
  late Map<String, double> selectedRestaurants;
  bool showRestaurants = true;
  bool showDhabas = true;

  final String googlePlacesApiKey = "AIzaSyBKPLjj-Upqy4tTkO4VnBY9XxN8dKLuSyY";
  late GoogleMapsPlaces _places;

  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  List<Map<String, String>> dhabas = [
    {"name": "Desi Dhaba", "rating": "4.5"},
    {"name": "Highway Dhaba", "rating": "4.2"},
    {"name": "Tandoori Nights", "rating": "4.0"},
  ];

  get calculatedBudget => null;

  @override
  void initState() {
    super.initState();
    totalBudget = widget.budget;
    selectedRestaurants = Map.from(widget.selectedRestaurants);
    _places = GoogleMapsPlaces(apiKey: googlePlacesApiKey);
    fetchRestaurantsFromGoogle();

    // Get current user
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> fetchRestaurantsFromGoogle() async {
    setState(() => isLoading = true);
    try {
      final cityLatLng = await _getCityCoordinates(widget.city);
      if (cityLatLng != null) {
        final response = await _places.searchNearbyWithRadius(
          Location(lat: cityLatLng.latitude, lng: cityLatLng.longitude),
          5000,
          type: 'restaurant',
        );
        if (response.status == "OK") {
          setState(() {
            restaurants = response.results;
          });
        } else {
          debugPrint("Google Places Error: ${response.errorMessage}");
        }
      } else {
        debugPrint("Could not determine coordinates for city: ${widget.city}");
      }
    } catch (e) {
      debugPrint("Exception fetching restaurants: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<LatLng?> _getCityCoordinates(String city) async {
    try {
      final List<geo.Location> locations = await geo.locationFromAddress(city);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        return LatLng(loc.latitude, loc.longitude);
      }
    } catch (e) {
      debugPrint("Geocoding error: $e");
    }
    return null;
  }

  void openMenuScreen(String name) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MenuScreen(restaurantName: name)),
    );
    if (result != null && result is double) {
      setState(() {
        selectedRestaurants[name] = result;
        totalBudget = widget.budget +
            selectedRestaurants.values.fold(0, (prev, curr) => prev + curr);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredDhabas = dhabas
        .where((d) => d["name"]!.toLowerCase().contains(searchQuery))
        .toList();

    List<PlacesSearchResult> filteredRestaurants = restaurants
        .where((r) => r.name.toLowerCase().contains(searchQuery) ?? false)
        .toList();

    final allItems = [
      if (showRestaurants) ...filteredRestaurants,
      if (showDhabas) ...filteredDhabas,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("ITINERARY",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.only(right: 10),
        //     child: CircleAvatar(
        //       radius: 22,
        //       backgroundImage: AssetImage("assets/your_image.png"),
        //     ),
        //   ),
        // ],
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: currentUser?.photoURL != null
                ? CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(currentUser!.photoURL!),
                  )
                : CircleAvatar(
                    radius: 22,
                    child: Text(
                      currentUser?.email?.substring(0, 1).toUpperCase() ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("Food",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SummaryScreen(
                                selectedAttractions: widget.selectedAttractions,
                                selectedHotels: widget.selectedHotels,
                                selectedRestaurants: selectedRestaurants,
                                totalBudget: totalBudget,
                                selectedTransportModes: [],
                                autoSelectBestMode: false,
                              ),
                            ),
                          );
                        },
                        child:
                            Text("Budget : ₹${totalBudget.toStringAsFixed(0)}"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search restaurants or dhabas...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  searchQuery = '';
                                  searchController.clear();
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (value) =>
                        setState(() => searchQuery = value.toLowerCase()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Checkbox(
                          value: showRestaurants,
                          onChanged: (v) =>
                              setState(() => showRestaurants = v!)),
                      const Text("Restaurants"),
                      const SizedBox(width: 20),
                      Checkbox(
                          value: showDhabas,
                          onChanged: (v) => setState(() => showDhabas = v!)),
                      const Text("Dhabas"),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ...allItems.map((item) {
                        if (item is PlacesSearchResult) {
                          return buildFoodTile(
                            name: item.name ?? 'Unknown',
                            rating: item.rating?.toString() ?? "N/A",
                            photoReference: item.photos.isNotEmpty == true
                                ? item.photos.first.photoReference
                                : null,
                          );
                        } else {
                          final dhaba = item as Map<String, String>;
                          return buildFoodTile(
                            name: dhaba["name"]!,
                            rating: dhaba["rating"]!,
                            photoReference: null,
                          );
                        }
                      }),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Selected Items",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      ExpansionTile(
                        title: const Text("Selected Restaurants"),
                        children: selectedRestaurants.entries
                            .map((e) => ListTile(
                                  title: Text(e.key),
                                  trailing:
                                      Text("₹${e.value.toStringAsFixed(0)}"),
                                ))
                            .toList(),
                      ),
                      ExpansionTile(
                        title: const Text("Selected Attractions"),
                        children: widget.selectedAttractions
                            .map((a) => ListTile(
                                title: Text(a['name'] ?? 'Unknown Attraction')))
                            .toList(),
                      ),
                      ExpansionTile(
                        title: const Text("Selected Hotels"),
                        children: widget.selectedHotels.map((hotel) {
                          return ListTile(
                            title: Text(hotel['name'] ?? 'Unknown Hotel'),
                            subtitle: Text(
                                "${hotel['checkInDate'] ?? ''} to ${hotel['checkOutDate'] ?? ''}"),
                            trailing: Text(
                                "₹${hotel['price']?.toStringAsFixed(0) ?? 'N/A'}"),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FoodMapScreen(restaurants: restaurants),
                            ),
                          );
                        },
                        icon: const Icon(Icons.map, color: Colors.blue),
                        label: const Text("IN MAP VIEW",
                            style: TextStyle(color: Colors.blue)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SummaryScreen(
                                selectedRestaurants: selectedRestaurants,
                                totalBudget: totalBudget,
                                selectedAttractions: widget.selectedAttractions,
                                selectedHotels: widget.selectedHotels,
                                selectedTransportModes: [],
                                autoSelectBestMode: false,
                              ),
                            ),
                          );
                        },
                        child: const Text("Done"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModeOfTransportPage(
                                selectedAttractions: widget.selectedAttractions,
                                selectedHotels: widget.selectedHotels,
                                selectedRestaurants: selectedRestaurants,
                                totalBudget: totalBudget,
                                city: widget.city,
                                autoSelectBestMode: true,
                              ),
                            ),
                          );
                        },
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildFoodTile(
      {required String name, required String rating, String? photoReference}) {
    Widget leadingWidget;
    if (photoReference != null) {
      leadingWidget = SizedBox(
        width: 80,
        height: 80,
        child: Image.network(
          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$googlePlacesApiKey",
          fit: BoxFit.cover,
        ),
      );
    } else {
      leadingWidget = const Icon(Icons.restaurant, size: 40);
    }

    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: leadingWidget,
        title: Text(name),
        subtitle: Text("Rating: $rating ⭐"),
        trailing: ElevatedButton(
          onPressed: () => openMenuScreen(name),
          child: const Text("Menu"),
        ),
      ),
    );
  }
}
