// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// class HotelDetailScreen extends StatefulWidget {
//   final String placeId;
//   final Function(double) updateBudget;

//   const HotelDetailScreen({super.key, required this.placeId, required this.updateBudget});

//   @override
//   _HotelDetailScreenState createState() => _HotelDetailScreenState();
// }

// class _HotelDetailScreenState extends State<HotelDetailScreen> {
//   DateTime? checkInDate;
//   DateTime? checkOutDate;
//   int adults = 1;
//   int children = 0;
//   int rooms = 1;
//   double pricePerNight = 2000; // Assume fetched from API

//   void calculateTotalPrice() {
//     if (checkInDate != null && checkOutDate != null) {
//       int days = checkOutDate!.difference(checkInDate!).inDays;
//       if (days > 0) {
//         double totalPrice = days * rooms * pricePerNight;
//         widget.updateBudget(totalPrice);
//       }
//     }
//   }

//   Future<void> selectDate(BuildContext context, bool isCheckIn) async {
//     DateTime initialDate = isCheckIn ? DateTime.now() : checkInDate ?? DateTime.now();
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(Duration(days: 365)),
//     );
//     if (picked != null && picked != checkInDate && picked != checkOutDate) {
//       setState(() {
//         if (isCheckIn) {
//           checkInDate = picked;
//           checkOutDate = null;
//         } else {
//           checkOutDate = picked;
//         }
//       });
//       calculateTotalPrice();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Hotel Details", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Hotel Name", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
//             SizedBox(height: 8),
//             Text("Hotel Description fetched from API", style: GoogleFonts.poppins(fontSize: 16)),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.calendar_today),
//               title: Text("Check-in Date: ${checkInDate != null ? DateFormat('yyyy-MM-dd').format(checkInDate!) : 'Select'}"),
//               onTap: () => selectDate(context, true),
//             ),
//             ListTile(
//               leading: Icon(Icons.calendar_today),
//               title: Text("Check-out Date: ${checkOutDate != null ? DateFormat('yyyy-MM-dd').format(checkOutDate!) : 'Select'}"),
//               onTap: checkInDate == null ? null : () => selectDate(context, false),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Adults"),
//                 DropdownButton<int>(
//                   value: adults,
//                   items: List.generate(5, (index) => index + 1)
//                       .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
//                       .toList(),
//                   onChanged: (val) => setState(() => adults = val!),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Children"),
//                 DropdownButton<int>(
//                   value: children,
//                   items: List.generate(5, (index) => index)
//                       .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
//                       .toList(),
//                   onChanged: (val) => setState(() => children = val!),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Rooms"),
//                 DropdownButton<int>(
//                   value: rooms,
//                   items: List.generate(5, (index) => index + 1)
//                       .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
//                       .toList(),
//                   onChanged: (val) => setState(() => rooms = val!),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 calculateTotalPrice();
//                 Navigator.pop(context);
//               },
//               child: Text("Confirm & Add to Budget"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// super main code

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class HotelDetailScreen extends StatefulWidget {
//   final Map<String, dynamic> hotel;
//   const HotelDetailScreen({super.key, required this.hotel});

//   @override
//   _HotelDetailScreenState createState() => _HotelDetailScreenState();
// }

// class _HotelDetailScreenState extends State<HotelDetailScreen> {
//   DateTime? checkInDate;
//   DateTime? checkOutDate;
//   int adults = 1;
//   int children = 0;
//   int rooms = 1;

//   num calculateTotalCost() {
//     if (checkInDate == null || checkOutDate == null) return 0;
//     int days = checkOutDate!.difference(checkInDate!).inDays;
//     if (days <= 0) return 0;
//     return days * (widget.hotel['price'] ?? 0) * rooms;
//   }

//   Future<void> selectDate(bool isCheckIn) async {
//     DateTime initialDate = isCheckIn ? DateTime.now() : checkInDate ?? DateTime.now();
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(Duration(days: 365)),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         if (isCheckIn) {
//           checkInDate = pickedDate;
//           checkOutDate = null;
//         } else {
//           checkOutDate = pickedDate;
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.hotel['name'] ?? 'Hotel Details')),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             widget.hotel['image'] != null && widget.hotel['image'].isNotEmpty
//                 ? Image.network(widget.hotel['image'], fit: BoxFit.cover, width: double.infinity, height: 200)
//                 : Container(height: 200, color: Colors.grey, child: Center(child: Text("No Image Available"))),
//             Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(widget.hotel['name'] ?? 'Unknown Hotel', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                   Text(widget.hotel['location'] ?? 'Location not available', style: TextStyle(color: Colors.grey)),
//                   SizedBox(height: 10),
//                   Text("Hotel Facilities"),
//                   Row(
//                     children: [
//                       Icon(Icons.wifi, color: Colors.blue),
//                       SizedBox(width: 5),
//                       Icon(Icons.fitness_center, color: Colors.blue),
//                       SizedBox(width: 5),
//                       Icon(Icons.free_breakfast, color: Colors.blue),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   Text("Check Availability"),
//                   ListTile(
//                     leading: Icon(Icons.calendar_today),
//                     title: Text(checkInDate == null ? "Select Check-in Date" : DateFormat('yyyy-MM-dd').format(checkInDate!)),
//                     onTap: () => selectDate(true),
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.calendar_today),
//                     title: Text(checkOutDate == null ? "Select Check-out Date" : DateFormat('yyyy-MM-dd').format(checkOutDate!)),
//                     onTap: () => selectDate(false),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [Text("Adults"), Row(children: [
//                           IconButton(icon: Icon(Icons.remove), onPressed: () => setState(() { if (adults > 1) adults--; })),
//                           Text("$adults"),
//                           IconButton(icon: Icon(Icons.add), onPressed: () => setState(() { adults++; })),
//                         ])],
//                       ),
//                       Column(
//                         children: [Text("Children"), Row(children: [
//                           IconButton(icon: Icon(Icons.remove), onPressed: () => setState(() { if (children > 0) children--; })),
//                           Text("$children"),
//                           IconButton(icon: Icon(Icons.add), onPressed: () => setState(() { children++; })),
//                         ])],
//                       ),
//                       Column(
//                         children: [Text("Rooms"), Row(children: [
//                           IconButton(icon: Icon(Icons.remove), onPressed: () => setState(() { if (rooms > 1) rooms--; })),
//                           Text("$rooms"),
//                           IconButton(icon: Icon(Icons.add), onPressed: () => setState(() { rooms++; })),
//                         ])],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   Text("Total Cost: ₹${calculateTotalCost()}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context, calculateTotalCost());
//                     },
//                     child: Text("Done"),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:rahaagir1/stay_screen.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:intl/intl.dart';

// class HotelDetailScreen extends StatefulWidget {
//   final String placeId;
//   final PlacesSearchResult hotel;
//   final AmadeusHotelOffer? offer;
//   final void Function(Map<String, dynamic> hotelData) onBook;
//   final String hotelName;

//   const HotelDetailScreen({
//     super.key,
//     required this.placeId,
//     required this.hotel,
//     required this.offer,
//     required this.onBook,
//     required this.hotelName,
//   });

//   @override
//   _HotelDetailScreenState createState() => _HotelDetailScreenState();
// }

// class _HotelDetailScreenState extends State<HotelDetailScreen> {
//   PlaceDetails? hotelDetails;
//   bool isLoading = true;
//   final String googlePlacesApiKey = "AIzaSyBKPLjj-Upqy4tTkO4VnBY9XxN8dKLuSyY";
//   late GoogleMapsPlaces _places;

//   DateTime? checkInDate;
//   DateTime? checkOutDate;
//   int adults = 1;
//   int children = 0;
//   int rooms = 1;

//   @override
//   void initState() {
//     super.initState();
//     _places = GoogleMapsPlaces(apiKey: googlePlacesApiKey);
//     _fetchHotelDetails();
//   }

//   Future<void> _fetchHotelDetails() async {
//     setState(() => isLoading = true);
//     try {
//       final response = await _places.getDetailsByPlaceId(
//         widget.placeId,
//         fields: ['reviews', 'price_level', 'formatted_address', 'formatted_phone_number', 'website', 'name', 'rating'],
//       );

//       if (response.status == "OK") {
//         setState(() {
//           hotelDetails = response.result;
//           isLoading = false;
//         });
//       } else {
//         setState(() => isLoading = false);
//         print("Error fetching hotel details: ${response.errorMessage}");
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       print("Error during hotel details API call: $e");
//     }
//   }

//   num calculateTotalCost() {
//     if (checkInDate == null || checkOutDate == null) return 0;
//     int days = checkOutDate!.difference(checkInDate!).inDays;
//     if (days <= 0) return 0;
//     return days * rooms * (widget.offer?.cheapestPrice != null
//         ? double.tryParse(widget.offer!.cheapestPrice!.amount ?? '') ?? 1000
//         : (hotelDetails?.priceLevel?.index ?? 1) * 1000);
//   }

//   Future<void> selectDate(bool isCheckIn) async {
//     DateTime initialDate = isCheckIn ? DateTime.now() : checkInDate ?? DateTime.now();
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         if (isCheckIn) {
//           checkInDate = pickedDate;
//           checkOutDate = null;
//         } else {
//           checkOutDate = pickedDate;
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final offerPrice = widget.offer?.cheapestPrice;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(hotelDetails?.name ?? widget.hotel.name ?? 'Hotel Details'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (widget.hotel.photos.isNotEmpty)
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(
//                         "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${widget.hotel.photos.first.photoReference}&key=$googlePlacesApiKey",
//                         height: 180,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   const SizedBox(height: 10),
//                   Text(
//                     hotelDetails?.name ?? widget.hotel.name ?? 'Unknown Hotel',
//                     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   if (offerPrice != null)
//                     Text(
//                       "From ₹${offerPrice.amount} ${offerPrice.currency}",
//                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                     ),
//                   const SizedBox(height: 10),
//                   Text(
//                     hotelDetails?.formattedAddress ?? 'No address available',
//                     style: const TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: const [
//                       Icon(Icons.wifi, color: Colors.blue),
//                       SizedBox(width: 5),
//                       Icon(Icons.fitness_center, color: Colors.blue),
//                       SizedBox(width: 5),
//                       Icon(Icons.free_breakfast, color: Colors.blue),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   const Text('Check Availability', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   ListTile(
//                     leading: const Icon(Icons.calendar_today),
//                     title: Text(checkInDate == null
//                         ? "Select Check-in Date"
//                         : DateFormat('yyyy-MM-dd').format(checkInDate!)),
//                     onTap: () => selectDate(true),
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.calendar_today),
//                     title: Text(checkOutDate == null
//                         ? "Select Check-out Date"
//                         : DateFormat('yyyy-MM-dd').format(checkOutDate!)),
//                     onTap: () => selectDate(false),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(children: [
//                         const Text("Adults"),
//                         Row(children: [
//                           IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() { if (adults > 1) adults--; })),
//                           Text("$adults"),
//                           IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() { adults++; })),
//                         ])
//                       ]),
//                       Column(children: [
//                         const Text("Children"),
//                         Row(children: [
//                           IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() { if (children > 0) children--; })),
//                           Text("$children"),
//                           IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() { children++; })),
//                         ])
//                       ]),
//                       Column(children: [
//                         const Text("Rooms"),
//                         Row(children: [
//                           IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() { if (rooms > 1) rooms--; })),
//                           Text("$rooms"),
//                           IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() { rooms++; })),
//                         ])
//                       ]),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Text("Total Cost: ₹${calculateTotalCost().toStringAsFixed(0)}",
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 20),
//                   if (hotelDetails?.website != null)
//                     InkWell(
//                       onTap: () => launchUrl(Uri.parse(hotelDetails!.website!)),
//                       child: Text('Website: ${hotelDetails!.website}', style: const TextStyle(color: Colors.blue)),
//                     ),
//                   const SizedBox(height: 20),
//                   const Text('Reviews:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   if (hotelDetails?.reviews != null && hotelDetails!.reviews.isNotEmpty)
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: hotelDetails!.reviews.length,
//                       itemBuilder: (context, index) {
//                         final review = hotelDetails!.reviews[index];
//                         return Card(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(review.authorName ?? 'Anonymous', style: const TextStyle(fontWeight: FontWeight.bold)),
//                                 Text('Rating: ${review.rating} ⭐'),
//                                 Text(review.text ?? 'No review text'),
//                                 Text(review.relativeTimeDescription!),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     )
//                   else
//                     const Text('No reviews available.'),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//   onPressed: () {
//     widget.onBook({
//       'name': hotelDetails?.name ?? widget.hotel.name ?? 'Unnamed Hotel',
//       'vicinity': hotelDetails?.formattedAddress ?? widget.hotel.vicinity ?? '',
//       'rating': hotelDetails?.rating ?? widget.hotel.rating ?? 'N/A',
//       'price': calculateTotalCost(),
//     });
//     Navigator.pop(context);
//   },
//   child: const Text("Book Now (Hypothetical)"),
// ),

//                 ],
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'stay_screen.dart';
import 'package:signinsignup/stay_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class HotelDetailScreen extends StatefulWidget {
  final String placeId;
  final PlacesSearchResult hotel;
  final AmadeusHotelOffer? offer;
  final void Function(Map<String, dynamic> hotelData) onBook;
  final String hotelName;

  const HotelDetailScreen({
    super.key,
    required this.placeId,
    required this.hotel,
    required this.offer,
    required this.onBook,
    required this.hotelName,
  });

  @override
  _HotelDetailScreenState createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  PlaceDetails? hotelDetails;
  bool isLoading = true;
  final String googlePlacesApiKey = "AIzaSyBKPLjj-Upqy4tTkO4VnBY9XxN8dKLuSyY";
  late GoogleMapsPlaces _places;

  DateTime? checkInDate;
  DateTime? checkOutDate;
  int adults = 1;
  int children = 0;
  int rooms = 1;

  @override
  void initState() {
    super.initState();
    _places = GoogleMapsPlaces(apiKey: googlePlacesApiKey);
    _fetchHotelDetails();
  }

  Future<void> _fetchHotelDetails() async {
    try {
      final response = await _places.getDetailsByPlaceId(
        widget.placeId,
        fields: [
          'reviews',
          'price_level',
          'formatted_address',
          'formatted_phone_number',
          'website',
          'name',
          'rating',
          'photo'
        ],
      );

      if (response.status == "OK") {
        setState(() {
          hotelDetails = response.result;
        });
        print("Hotel address: ${hotelDetails?.formattedAddress}");
      } else {
        print("Error fetching hotel details: ${response.errorMessage}");
      }
    } catch (e) {
      print("Error during hotel details API call: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  num calculateTotalCost() {
    if (checkInDate == null || checkOutDate == null) return 0;
    int days = checkOutDate!.difference(checkInDate!).inDays;
    if (days <= 0) return 0;
    return days *
        rooms *
        (widget.offer?.cheapestPrice != null
            ? double.tryParse(widget.offer!.cheapestPrice!.amount ?? '') ?? 1000
            : (hotelDetails?.priceLevel?.index ?? 1) * 1000);
  }

  Future<void> selectDate(bool isCheckIn) async {
    DateTime initialDate =
        isCheckIn ? DateTime.now() : checkInDate ?? DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = pickedDate;
          checkOutDate = null;
        } else {
          checkOutDate = pickedDate;
        }
      });
    }
  }

  Widget buildDateTile(
      {required String label,
      required DateTime? date,
      required VoidCallback onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: const Icon(Icons.calendar_today),
      title: Text(
        date == null
            ? "Select $label Date"
            : DateFormat('EEE, MMM d, yyyy').format(date),
        style: const TextStyle(fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  Widget _buildCounter(
      String label, int value, VoidCallback onAdd, VoidCallback onRemove) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Row(
          children: [
            IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.remove_circle_outline)),
            Text('$value', style: const TextStyle(fontSize: 16)),
            IconButton(
                onPressed: onAdd, icon: const Icon(Icons.add_circle_outline)),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final offerPrice = widget.offer?.cheapestPrice;

    return Scaffold(
      appBar: AppBar(
        title: Text(hotelDetails?.name ?? widget.hotel.name ?? 'Hotel Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.hotel.photos.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        "https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=${widget.hotel.photos.first.photoReference}&key=$googlePlacesApiKey",
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    hotelDetails?.name ?? widget.hotel.name ?? 'Unknown Hotel',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  if (offerPrice != null)
                    Text(
                      "From ₹${offerPrice.amount} ${offerPrice.currency}",
                      style: TextStyle(fontSize: 16, color: Colors.green[700]),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: Colors.redAccent),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hotelDetails?.formattedAddress ??
                              widget.hotel.vicinity ??
                              'No address available',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(Icons.wifi, color: Colors.blue),
                      Icon(Icons.fitness_center, color: Colors.blue),
                      Icon(Icons.local_dining, color: Colors.blue),
                      Icon(Icons.local_parking, color: Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Check Availability",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          buildDateTile(
                              label: "Check-in",
                              date: checkInDate,
                              onTap: () => selectDate(true)),
                          buildDateTile(
                              label: "Check-out",
                              date: checkOutDate,
                              onTap: () => selectDate(false)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildCounter(
                                  "Adults",
                                  adults,
                                  () => setState(() => adults++),
                                  () => setState(
                                      () => adults > 1 ? adults-- : null)),
                              _buildCounter(
                                  "Children",
                                  children,
                                  () => setState(() => children++),
                                  () => setState(
                                      () => children > 0 ? children-- : null)),
                              _buildCounter(
                                  "Rooms",
                                  rooms,
                                  () => setState(() => rooms++),
                                  () => setState(
                                      () => rooms > 1 ? rooms-- : null)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                              "Total Cost: ₹${calculateTotalCost().toStringAsFixed(0)}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (hotelDetails?.website != null)
                    InkWell(
                      onTap: () => launchUrl(Uri.parse(hotelDetails!.website!)),
                      child: Text('Visit Website',
                          style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline)),
                    ),
                  const SizedBox(height: 20),
                  const Text('Reviews:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  if (hotelDetails?.reviews?.isNotEmpty ?? false)
                    ...hotelDetails!.reviews.map(
                      (review) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(review.authorName ?? 'Anonymous'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rating: ${review.rating} ⭐'),
                              const SizedBox(height: 4),
                              Text(review.text ?? 'No review text'),
                              const SizedBox(height: 4),
                              Text(review.relativeTimeDescription ?? ''),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    const Text('No reviews available.'),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.hotel),
                      label: const Text("Book Now (Hypothetical)"),
                      onPressed: () {
                        widget.onBook({
                          'name': hotelDetails?.name ??
                              widget.hotel.name ??
                              'Unnamed Hotel',
                          'vicinity': hotelDetails?.formattedAddress ??
                              widget.hotel.vicinity ??
                              '',
                          'rating': hotelDetails?.rating ??
                              widget.hotel.rating ??
                              'N/A',
                          'price': calculateTotalCost(),
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
