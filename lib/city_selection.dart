// import 'package:flutter/material.dart';
// import 'MapPage.dart';

// class CityPage extends StatefulWidget {
//   @override
//   _CityPageState createState() => _CityPageState();
// }

// class _CityPageState extends State<CityPage> {
//   String selectedState = "Uttar Pradesh";
//   String selectedCity = "Vrindavan";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   DropdownButtonFormField<String>(
//                     value: selectedState,
//                     items: ["Uttar Pradesh", "Maharashtra", "Delhi"]
//                         .map((state) =>
//                             DropdownMenuItem(value: state, child: Text(state)))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedState = value!;
//                       });
//                     },
//                     decoration: InputDecoration(labelText: "Select State"),
//                   ),
//                   SizedBox(height: 10),
//                   DropdownButtonFormField<String>(
//                     value: selectedCity,
//                     items: ["Vrindavan", "Agra", "Lucknow"]
//                         .map((city) =>
//                             DropdownMenuItem(value: city, child: Text(city)))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedCity = value!;
//                       });
//                     },
//                     decoration: InputDecoration(labelText: "Select City"),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     "Life is short and the world is wide",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => MapPage(
//                                 state: selectedState, city: selectedCity)),
//                       );
//                     },
//                     child: Text("Get Started"),
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
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'MapPage.dart';

// class CityPage extends StatefulWidget {
//   @override
//   _CityPageState createState() => _CityPageState();
// }

// class _CityPageState extends State<CityPage> {
//   String selectedState = "Uttar Pradesh";
//   String selectedCity = "Vrindavan";

//   final Map<String, LatLng> cityCoordinates = {
//     "Vrindavan": LatLng(27.5651, 77.6593),
//     "Agra": LatLng(27.1767, 78.0081),
//     "Lucknow": LatLng(26.8467, 80.9462),
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/bg_image.jpg"), // ✅ Background Image
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   children: [
//                     DropdownButtonFormField<String>(
//                       value: selectedState,
//                       items: ["Uttar Pradesh", "Maharashtra", "Delhi"]
//                           .map((state) => DropdownMenuItem(
//                               value: state, child: Text(state)))
//                           .toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedState = value!;
//                         });
//                       },
//                       decoration: InputDecoration(labelText: "Select State"),
//                     ),
//                     SizedBox(height: 10),
//                     DropdownButtonFormField<String>(
//                       value: selectedCity,
//                       items: cityCoordinates.keys
//                           .map((city) =>
//                               DropdownMenuItem(value: city, child: Text(city)))
//                           .toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedCity = value!;
//                         });
//                       },
//                       decoration: InputDecoration(labelText: "Select City"),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       "Life is short and the world is wide",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () {
//                         if (cityCoordinates.containsKey(selectedCity)) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => MapPage(
//                                 cityName: selectedCity,
//                                 cityCoordinates: cityCoordinates[selectedCity]!,
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                       child: Text("Get Started"),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// //2

import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'MapPage.dart'; // Import the updated MapPage

class CitySelectionPage extends StatefulWidget {
  const CitySelectionPage({super.key});

  @override
  _CitySelectionPageState createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  String selectedCountry = "India"; // Default country
  String selectedState = "Uttar Pradesh"; // Default state
  String selectedCity = "Mathura"; // Default city

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/your_image.png', // Ensure this image is in your assets
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                ),
                Column(
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        "Where you wanna go!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black45,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // CSC Picker
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CSCPicker(
                        layout: Layout.vertical,
                        flagState: CountryFlag.ENABLE,
                        showStates: true,
                        showCities: true,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        disabledDropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        defaultCountry: CscCountry.India,
                        currentCountry: selectedCountry,
                        currentState: selectedState,
                        currentCity: selectedCity,
                        onCountryChanged: (country) {
                          setState(() {
                            selectedCountry = country ?? "India";
                          });
                        },
                        onStateChanged: (state) {
                          setState(() {
                            selectedState = state ?? "Uttar Pradesh";
                            selectedCity = "Mathura"; // Reset to default city
                          });
                        },
                        onCityChanged: (city) {
                          setState(() {
                            selectedCity = city ?? "Mathura";
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Description Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Life is short and the world is ",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 24, color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'wide',
                          style: TextStyle(color: Colors.orange),
                        ),
                        TextSpan(
                          text: ' So lets start with Mathura',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Mathura, the city where Krishna's divine light first shone, a beacon of faith and devotion for generations.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  // Go to Map Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                             builder: (context) => MapScreen(city: selectedCity),
                                // builder: (context) => Mappage(city: selectedCity),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: const Text('Go to Map'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
