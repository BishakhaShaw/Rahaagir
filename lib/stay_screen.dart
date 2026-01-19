// import 'package:flutter/material.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:geocoding/geocoding.dart' as geo;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'MapPage.dart';
// import 'food_screen.dart' as food;
// import 'hotel_detail_screen.dart';
// import 'summary_screen.dart';

// class StayScreen extends StatefulWidget {
//   final String city;
//   final List<String> selectedAttractions;

//   const StayScreen({
//     required this.city,
//     super.key,
//     required this.selectedAttractions,
//   });

//   @override
//   _StayScreenState createState() => _StayScreenState();
// }

// class _StayScreenState extends State<StayScreen> {
//   bool showHotels = true;
//   bool showHostels = true;
//   bool showDharamshalas = true;
//   double budget = 0;
//   List<Map<String, dynamic>> selectedHotels = [];
//   List<PlacesSearchResult> googlePlacesHotels = [];
//   List<AmadeusHotelOffer> amadeusHotelOffers = [];
//   bool isLoading = true;
//   final String googlePlacesApiKey = "AIzaSyBKPLjj-Upqy4tTkO4VnBY9XxN8dKLuSyY";
//   final String amadeusApiKey = "ALAPToQUPYvW4FeULwCDe1bVxqsHixs7";
//   final String amadeusApiSecret = "NABPf8FCdA7tSde6";
//   String? amadeusAccessToken;
//   DateTime? amadeusTokenExpiry;
//   late GoogleMapsPlaces _places;
//   LatLng? cityCoordinates;
//   String searchQuery = '';
//   String sortOption = 'None';
//   final TextEditingController searchController = TextEditingController();

//   get totalBudget => budget;

//   @override
//   void initState() {
//     super.initState();
//     _places = GoogleMapsPlaces(apiKey: googlePlacesApiKey);
//     _fetchInitialData();
//   }

//   Future<void> _fetchInitialData() async {
//     await _getAmadeusAccessToken();
//     await fetchHotelsFromGoogle();
//     cityCoordinates = await _getCityCoordinates(widget.city);
//     if (amadeusAccessToken != null && cityCoordinates != null) {
//       await fetchHotelOffersFromAmadeus(
//         cityCoordinates!.latitude,
//         cityCoordinates!.longitude,
//       );
//     }
//     setState(() => isLoading = false);
//   }

//   Future<void> _getAmadeusAccessToken() async {
//     if (amadeusAccessToken != null &&
//         amadeusTokenExpiry != null &&
//         amadeusTokenExpiry!.isAfter(
//           DateTime.now().add(const Duration(minutes: 5)),
//         )) {
//       return;
//     }
//     final String url = 'https://test.api.amadeus.com/v1/security/oauth2/token';
//     final String credentials = base64Encode(
//       utf8.encode('$amadeusApiKey:$amadeusApiSecret'),
//     );
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/x-www-form-urlencoded',
//           'Authorization': 'Basic $credentials',
//         },
//         body: 'grant_type=client_credentials',
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         amadeusAccessToken = data['access_token'];
//         final expiresIn = data['expires_in'] as int?;
//         if (expiresIn != null) {
//           amadeusTokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
//         }
//       }
//     } catch (e) {
//       print('Error getting Amadeus access token: $e');
//     }
//   }

//   Future<void> fetchHotelOffersFromAmadeus(
//     double latitude,
//     double longitude,
//   ) async {
//     if (amadeusAccessToken == null) return;
//     final String apiUrl =
//         'https://test.api.amadeus.com/v2/shopping/hotel-offers/by-geocode?latitude=$latitude&longitude=$longitude&radius=10&radiusUnit=KM';
//     try {
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {'Authorization': 'Bearer $amadeusAccessToken'},
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['data'] != null) {
//           final List<dynamic> offersJson = data['data'];
//           amadeusHotelOffers =
//               offersJson
//                   .map((offer) => AmadeusHotelOffer.fromJson(offer))
//                   .toList();
//           setState(() {});
//         }
//       }
//     } catch (e) {
//       print('Error fetching Amadeus hotel offers: $e');
//     }
//   }

//   Future<void> fetchHotelsFromGoogle() async {
//     setState(() => isLoading = true);
//     try {
//       final cityLatLng = await _getCityCoordinates(widget.city);
//       if (cityLatLng != null) {
//         final response = await _places.searchNearbyWithRadius(
//           Location(lat: cityLatLng.latitude, lng: cityLatLng.longitude),
//           1000,
//           type: 'lodging',
//         );
//         if (response.status == "OK") {
//           setState(() => googlePlacesHotels = response.results);
//         }
//       }
//     } catch (e) {
//       print("Places API Error: $e");
//     }
//   }

//   Future<LatLng?> _getCityCoordinates(String city) async {
//     try {
//       final List<geo.Location> locations = await geo.locationFromAddress(city);
//       if (locations.isNotEmpty) {
//         final loc = locations.first;
//         return LatLng(loc.latitude, loc.longitude);
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }

//   AmadeusHotelOffer? _findAmadeusOffer(String hotelName) {
//     for (final offer in amadeusHotelOffers) {
//       if (offer.hotel?.name?.toLowerCase() == hotelName.toLowerCase()) {
//         return offer;
//       }
//     }
//     return null;
//   }

//   void navigateToHotelDetail(
//     PlacesSearchResult googleHotel,
//     AmadeusHotelOffer? amadeusOffer,
//   ) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder:
//             (context) => HotelDetailScreen(
//               placeId: googleHotel.placeId,
//               hotel: googleHotel,
//               offer: amadeusOffer,
//               hotelName: googleHotel.name ?? '',
//               onBook: (Map<String, dynamic> hotelData) {
//                 setState(() {
//                   selectedHotels.add(hotelData);
//                   budget += hotelData['price'] ?? 0;
//                 });
//               },
//             ),
//       ),
//     );
//   }

//   List<PlacesSearchResult> getFilteredAndSortedHotels() {
//     List<PlacesSearchResult> filtered =
//         googlePlacesHotels.where((hotel) {
//           final nameMatch =
//               hotel.name.toLowerCase().contains(searchQuery.toLowerCase()) ??
//               false;
//           final types = hotel.types ?? [];
//           final isHotel = types.contains('hotel') || types.contains('lodging');
//           final isHostel = types.contains('hostel');
//           final isDharamshala = false;
//           return nameMatch &&
//               ((showHotels && isHotel) ||
//                   (showHostels && isHostel) ||
//                   (showDharamshalas && isDharamshala));
//         }).toList();

//     if (sortOption == 'Price (Low to High)') {
//       filtered.sort((a, b) {
//         final priceA =
//             double.tryParse(
//               _findAmadeusOffer(a.name ?? '')?.cheapestPrice?.amount ?? '',
//             ) ??
//             double.infinity;
//         final priceB =
//             double.tryParse(
//               _findAmadeusOffer(b.name ?? '')?.cheapestPrice?.amount ?? '',
//             ) ??
//             double.infinity;
//         return priceA.compareTo(priceB);
//       });
//     } else if (sortOption == 'Price (High to Low)') {
//       filtered.sort((a, b) {
//         final priceA =
//             double.tryParse(
//               _findAmadeusOffer(a.name ?? '')?.cheapestPrice?.amount ?? '',
//             ) ??
//             0;
//         final priceB =
//             double.tryParse(
//               _findAmadeusOffer(b.name ?? '')?.cheapestPrice?.amount ?? '',
//             ) ??
//             0;
//         return priceB.compareTo(priceA);
//       });
//     } else if (sortOption == 'Rating (High to Low)') {
//       filtered.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
//     }

//     return filtered;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final displayedHotels = getFilteredAndSortedHotels();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Find Your Stay',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 const Text(
//                   'Accommodation Options',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const Spacer(),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder:
//                             (_) => SummaryScreen(
//                               selectedAttractions:
//                                   widget.selectedAttractions
//                                       .map(
//                                         (name) => {
//                                           'name': name,
//                                           'address':
//                                               '', // Add real address if available
//                                         },
//                                       )
//                                       .toList(),
//                               selectedHotels: selectedHotels,
//                               selectedRestaurants: const {},
//                               totalBudget: totalBudget,
//                               selectedTransportModes: [],
//                             ),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
//                   child: Text('Budget: ₹${budget.toStringAsFixed(0)}'),
//                 ),
//               ],
//             ),
//           ),

//           // ... other widgets remain unchanged
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: searchController,
//                     decoration: const InputDecoration(
//                       labelText: 'Search accommodations...',
//                     ),
//                     onChanged: (value) => setState(() => searchQuery = value),
//                   ),
//                 ),
//                 const SizedBox(width: 6),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 6,
//                     vertical: 2,
//                   ),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: sortOption,
//                       items:
//                           [
//                                 'None',
//                                 'Price (Low to High)',
//                                 'Price (High to Low)',
//                                 'Rating (High to Low)',
//                               ]
//                               .map(
//                                 (option) => DropdownMenuItem(
//                                   value: option,
//                                   child: Text(
//                                     option,
//                                     style: const TextStyle(fontSize: 12),
//                                   ),
//                                 ),
//                               )
//                               .toList(),
//                       onChanged: (value) => setState(() => sortOption = value!),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             children: [
//               Checkbox(
//                 value: showHotels,
//                 onChanged: (v) => setState(() => showHotels = v!),
//               ),
//               const Text('Hotels'),
//               Checkbox(
//                 value: showHostels,
//                 onChanged: (v) => setState(() => showHostels = v!),
//               ),
//               const Text('Hostels'),
//               Checkbox(
//                 value: showDharamshalas,
//                 onChanged: (v) => setState(() => showDharamshalas = v!),
//               ),
//               const Text('Dharamshala'),
//             ],
//           ),
//           isLoading
//               ? const Expanded(
//                 child: Center(child: CircularProgressIndicator()),
//               )
//               : Expanded(
//                 child: ListView.builder(
//                   itemCount: displayedHotels.length,
//                   itemBuilder: (context, index) {
//                     final googleHotel = displayedHotels[index];
//                     final amadeusOffer = _findAmadeusOffer(
//                       googleHotel.name ?? '',
//                     );
//                     return ListTile(
//                       leading: SizedBox(
//                         width: 80,
//                         height: 80,
//                         child:
//                             googleHotel.photos.isNotEmpty
//                                 ? Image.network(
//                                   "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${googleHotel.photos.first.photoReference}&key=$googlePlacesApiKey",
//                                   fit: BoxFit.cover,
//                                 )
//                                 : const Icon(Icons.hotel, size: 40),
//                       ),
//                       title: Text(googleHotel.name ?? 'Unknown'),
//                       subtitle: Text(
//                         googleHotel.vicinity ?? 'No address available',
//                       ),
//                       trailing: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text('${googleHotel.rating?.toString() ?? "N/A"} ⭐'),
//                           Text(
//                             amadeusOffer != null
//                                 ? '${amadeusOffer.cheapestPrice?.amount} ${amadeusOffer.cheapestPrice?.currency}'
//                                 : 'Price Not Available',
//                           ),
//                         ],
//                       ),
//                       onTap:
//                           () =>
//                               navigateToHotelDetail(googleHotel, amadeusOffer),
//                     );
//                   },
//                 ),
//               ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed:
//                       () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => MapScreen(city: widget.city),
//                         ),
//                       ),
//                   icon: const Icon(Icons.map),
//                   label: const Text('In MAP VIEW'),
//                 ),
//                 ElevatedButton(onPressed: () {}, child: const Text('Done')),
//                 ElevatedButton(
//                   onPressed:
//                       () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (context) => food.FoodScreen(
//                                 city: widget.city,
//                                 budget: budget,
//                                 selectedRestaurants: {},
//                                 selectedAttractions:
//                                     widget.selectedAttractions
//                                         .map(
//                                           (name) => {
//                                             'name': name,
//                                             'address': '',
//                                           },
//                                         )
//                                         .toList(),
//                                 selectedHotels: selectedHotels,
//                               ),
//                         ),
//                       ),
//                   child: const Text('Next'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // AmadeusHotelOffer, Hotel, and CheapestPrice classes remain unchanged
// class AmadeusHotelOffer {
//   final Hotel? hotel;
//   final CheapestPrice? cheapestPrice;

//   AmadeusHotelOffer({this.hotel, this.cheapestPrice});

//   factory AmadeusHotelOffer.fromJson(Map<String, dynamic> json) {
//     return AmadeusHotelOffer(
//       hotel: json['hotel'] != null ? Hotel.fromJson(json['hotel']) : null,
//       cheapestPrice:
//           json['cheapestPrice'] != null
//               ? CheapestPrice.fromJson(json['cheapestPrice'])
//               : null,
//     );
//   }
// }

// class Hotel {
//   final String? name;

//   Hotel({this.name});

//   factory Hotel.fromJson(Map<String, dynamic> json) {
//     return Hotel(name: json['name']);
//   }
// }

// class CheapestPrice {
//   final String? amount;
//   final String? currency;

//   CheapestPrice({this.amount, this.currency});

//   factory CheapestPrice.fromJson(Map<String, dynamic> json) {
//     return CheapestPrice(amount: json['amount'], currency: json['currency']);
//   }
// }

//2

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../MapPage.dart';
import 'food_screen.dart' as food;
import 'hotel_detail_screen.dart';
import 'summary_screen.dart';

class StayScreen extends StatefulWidget {
  final String city;
  final List<String> selectedAttractions;

  const StayScreen({
    required this.city,
    super.key,
    required this.selectedAttractions,
  });

  @override
  _StayScreenState createState() => _StayScreenState();
}

class _StayScreenState extends State<StayScreen> {
  bool showHotels = true;
  bool showHostels = true;
  bool showDharamshalas = true;
  double budget = 0;
  List<Map<String, dynamic>> selectedHotels = [];
  List<PlacesSearchResult> googlePlacesHotels = [];
  List<AmadeusHotelOffer> amadeusHotelOffers = [];
  bool isLoading = true;
  final String googlePlacesApiKey = "AIzaSyBKPLjj-Upqy4tTkO4VnBY9XxN8dKLuSyY";
  final String amadeusApiKey = "ALAPToQUPYvW4FeULwCDe1bVxqsHixs7";
  final String amadeusApiSecret = "NABPf8FCdA7tSde6";
  String? amadeusAccessToken;
  DateTime? amadeusTokenExpiry;
  late GoogleMapsPlaces _places;
  LatLng? cityCoordinates;
  String searchQuery = '';
  String sortOption = 'None';
  final TextEditingController searchController = TextEditingController();

  get totalBudget => budget;

  @override
  void initState() {
    super.initState();
    _places = GoogleMapsPlaces(apiKey: googlePlacesApiKey);
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await _getAmadeusAccessToken();
    await fetchHotelsFromGoogle();
    cityCoordinates = await _getCityCoordinates(widget.city);
    if (amadeusAccessToken != null && cityCoordinates != null) {
      await fetchHotelOffersFromAmadeus(
          cityCoordinates!.latitude, cityCoordinates!.longitude);
    }
    setState(() => isLoading = false);
  }

  Future<void> _getAmadeusAccessToken() async {
    if (amadeusAccessToken != null &&
        amadeusTokenExpiry != null &&
        amadeusTokenExpiry!
            .isAfter(DateTime.now().add(const Duration(minutes: 5)))) {
      return;
    }
    final String url = 'https://test.api.amadeus.com/v1/security/oauth2/token';
    final String credentials =
        base64Encode(utf8.encode('$amadeusApiKey:$amadeusApiSecret'));
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Basic $credentials',
        },
        body: 'grant_type=client_credentials',
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        amadeusAccessToken = data['access_token'];
        final expiresIn = data['expires_in'] as int?;
        if (expiresIn != null) {
          amadeusTokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
        }
      }
    } catch (e) {
      print('Error getting Amadeus access token: $e');
    }
  }

  Future<void> fetchHotelOffersFromAmadeus(
      double latitude, double longitude) async {
    if (amadeusAccessToken == null) return;
    final String apiUrl =
        'https://test.api.amadeus.com/v2/shopping/hotel-offers/by-geocode?latitude=$latitude&longitude=$longitude&radius=10&radiusUnit=KM';
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $amadeusAccessToken',
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          final List<dynamic> offersJson = data['data'];
          amadeusHotelOffers = offersJson
              .map((offer) => AmadeusHotelOffer.fromJson(offer))
              .toList();
          setState(() {});
        }
      }
    } catch (e) {
      print('Error fetching Amadeus hotel offers: $e');
    }
  }

  Future<void> fetchHotelsFromGoogle() async {
    setState(() => isLoading = true);
    try {
      final cityLatLng = await _getCityCoordinates(widget.city);
      if (cityLatLng != null) {
        final response = await _places.searchNearbyWithRadius(
          Location(lat: cityLatLng.latitude, lng: cityLatLng.longitude),
          1000,
          type: 'lodging',
        );
        if (response.status == "OK") {
          setState(() => googlePlacesHotels = response.results);
        }
      }
    } catch (e) {
      print("Places API Error: $e");
    }
  }

  Future<LatLng?> _getCityCoordinates(String city) async {
    try {
      final List<geo.Location> locations = await geo.locationFromAddress(city);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        return LatLng(loc.latitude, loc.longitude);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  AmadeusHotelOffer? _findAmadeusOffer(String hotelName) {
    for (final offer in amadeusHotelOffers) {
      if (offer.hotel?.name?.toLowerCase() == hotelName.toLowerCase()) {
        return offer;
      }
    }
    return null;
  }

  void navigateToHotelDetail(
      PlacesSearchResult googleHotel, AmadeusHotelOffer? amadeusOffer) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelDetailScreen(
          placeId: googleHotel.placeId,
          hotel: googleHotel,
          offer: amadeusOffer,
          hotelName: googleHotel.name ?? '',
          onBook: (Map<String, dynamic> hotelData) {
            setState(() {
              selectedHotels.add(hotelData);
              budget += hotelData['price'] ?? 0;
            });
          },
        ),
      ),
    );
  }

  List<PlacesSearchResult> getFilteredAndSortedHotels() {
    List<PlacesSearchResult> filtered = googlePlacesHotels.where((hotel) {
      final nameMatch =
          hotel.name.toLowerCase().contains(searchQuery.toLowerCase()) ?? false;
      final types = hotel.types ?? [];
      final isHotel = types.contains('hotel') || types.contains('lodging');
      final isHostel = types.contains('hostel');
      final isDharamshala = false;
      return nameMatch &&
          ((showHotels && isHotel) ||
              (showHostels && isHostel) ||
              (showDharamshalas && isDharamshala));
    }).toList();

    if (sortOption == 'Price (Low to High)') {
      filtered.sort((a, b) {
        final priceA = double.tryParse(
                _findAmadeusOffer(a.name ?? '')?.cheapestPrice?.amount ?? '') ??
            double.infinity;
        final priceB = double.tryParse(
                _findAmadeusOffer(b.name ?? '')?.cheapestPrice?.amount ?? '') ??
            double.infinity;
        return priceA.compareTo(priceB);
      });
    } else if (sortOption == 'Price (High to Low)') {
      filtered.sort((a, b) {
        final priceA = double.tryParse(
                _findAmadeusOffer(a.name ?? '')?.cheapestPrice?.amount ?? '') ??
            0;
        final priceB = double.tryParse(
                _findAmadeusOffer(b.name ?? '')?.cheapestPrice?.amount ?? '') ??
            0;
        return priceB.compareTo(priceA);
      });
    } else if (sortOption == 'Rating (High to Low)') {
      filtered.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final displayedHotels = getFilteredAndSortedHotels();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Stay',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Accommodation Options',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SummaryScreen(
                          selectedAttractions: widget.selectedAttractions
                              .map((name) => {
                                    'name': name,
                                    'address':
                                        '' // Add real address if available
                                  })
                              .toList(),
                          selectedHotels: selectedHotels,
                          selectedRestaurants: const {},
                          totalBudget: totalBudget,
                          selectedTransportModes: [],
                          autoSelectBestMode: false,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  child: Text('Budget: ₹${budget.toStringAsFixed(0)}'),
                ),
              ],
            ),
          ),
          // ... other widgets remain unchanged

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                        labelText: 'Search accommodations...'),
                    onChanged: (value) => setState(() => searchQuery = value),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: sortOption,
                      items: [
                        'None',
                        'Price (Low to High)',
                        'Price (High to Low)',
                        'Rating (High to Low)'
                      ]
                          .map((option) => DropdownMenuItem(
                              value: option,
                              child: Text(option,
                                  style: const TextStyle(fontSize: 12))))
                          .toList(),
                      onChanged: (value) => setState(() => sortOption = value!),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Checkbox(
                  value: showHotels,
                  onChanged: (v) => setState(() => showHotels = v!)),
              const Text('Hotels'),
              Checkbox(
                  value: showHostels,
                  onChanged: (v) => setState(() => showHostels = v!)),
              const Text('Hostels'),
              Checkbox(
                  value: showDharamshalas,
                  onChanged: (v) => setState(() => showDharamshalas = v!)),
              const Text('Dharamshala'),
            ],
          ),
          isLoading
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: ListView.builder(
                    itemCount: displayedHotels.length,
                    itemBuilder: (context, index) {
                      final googleHotel = displayedHotels[index];
                      final amadeusOffer =
                          _findAmadeusOffer(googleHotel.name ?? '');
                      return ListTile(
                        leading: SizedBox(
                          width: 80,
                          height: 80,
                          child: googleHotel.photos.isNotEmpty
                              ? Image.network(
                                  "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${googleHotel.photos.first.photoReference}&key=$googlePlacesApiKey",
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.hotel, size: 40),
                        ),
                        title: Text(googleHotel.name ?? 'Unknown'),
                        subtitle: Text(
                            googleHotel.vicinity ?? 'No address available'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                '${googleHotel.rating?.toString() ?? "N/A"} ⭐'),
                            Text(amadeusOffer != null
                                ? '${amadeusOffer.cheapestPrice?.amount} ${amadeusOffer.cheapestPrice?.currency}'
                                : 'Price Not Available'),
                          ],
                        ),
                        onTap: () =>
                            navigateToHotelDetail(googleHotel, amadeusOffer),
                      );
                    },
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapScreen(city: widget.city)),
                  ),
                  icon: const Icon(Icons.map),
                  label: const Text('In MAP VIEW'),
                ),
                ElevatedButton(onPressed: () {}, child: const Text('Done')),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => food.FoodScreen(
                        city: widget.city,
                        budget: budget,
                        selectedRestaurants: {},
                        selectedAttractions: widget.selectedAttractions
                            .map((name) => {'name': name, 'address': ''})
                            .toList(),
                        selectedHotels: selectedHotels,
                        autoSelectBestMode: false,
                      ),
                    ),
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// AmadeusHotelOffer, Hotel, and CheapestPrice classes remain unchanged
class AmadeusHotelOffer {
  final Hotel? hotel;
  final CheapestPrice? cheapestPrice;

  AmadeusHotelOffer({this.hotel, this.cheapestPrice});

  factory AmadeusHotelOffer.fromJson(Map<String, dynamic> json) {
    return AmadeusHotelOffer(
      hotel: json['hotel'] != null ? Hotel.fromJson(json['hotel']) : null,
      cheapestPrice: json['cheapestPrice'] != null
          ? CheapestPrice.fromJson(json['cheapestPrice'])
          : null,
    );
  }
}

class Hotel {
  final String? name;

  Hotel({this.name});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(name: json['name']);
  }
}

class CheapestPrice {
  final String? amount;
  final String? currency;

  CheapestPrice({this.amount, this.currency});

  factory CheapestPrice.fromJson(Map<String, dynamic> json) {
    return CheapestPrice(
      amount: json['amount'],
      currency: json['currency'],
    );
  }
}
