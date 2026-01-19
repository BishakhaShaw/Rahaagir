// import 'package:flutter/material.dart';
// import 'summary_screen.dart'; // Import your SummaryScreen here

// class ModeOfTransportPage extends StatefulWidget {
//   final List<Map<String, dynamic>> selectedAttractions;
//   final List<Map<String, dynamic>> selectedHotels;
//   final Map<String, double> selectedRestaurants;
//   final double totalBudget;

//   const ModeOfTransportPage({
//     super.key,
//     required this.selectedAttractions,
//     required this.selectedHotels,
//     required this.selectedRestaurants,
//     required this.totalBudget,
//   });

//   @override
//   _ModeOfTransportPageState createState() => _ModeOfTransportPageState();
// }

// class _ModeOfTransportPageState extends State<ModeOfTransportPage> {
//   List<String> selectedModes = [];

//   get selectedAttractions => null;

//   get selectedHotels => null;

//   get selectedRestaurants => null;

//   get selectedTransportModes => null;

//   get totalBudget => null;

//   void toggleSelection(String mode) {
//     setState(() {
//       if (selectedModes.contains(mode)) {
//         selectedModes.remove(mode);
//       } else {
//         selectedModes.add(mode);
//       }
//     });
//   }

//   Widget buildTransportOption(String title, String assetPath) {
//     final isSelected = selectedModes.contains(title);
//     return Card(
//       elevation: 3,
//       color: isSelected ? Colors.lightBlue.shade50 : Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: Image.asset(assetPath, width: 40),
//         title: Text(title, style: const TextStyle(fontSize: 18)),
//         trailing: Icon(
//           isSelected ? Icons.check_box : Icons.check_box_outline_blank,
//           color: isSelected ? Colors.blue : Colors.grey,
//         ),
//         onTap: () => toggleSelection(title),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black87,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: const Text("Mode of Transport",
//             style: TextStyle(color: Colors.white)),
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//               ),
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Choose your modes of transport:",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),
//                   buildTransportOption("Auto", "assets/auto.png"),
//                   buildTransportOption("Taxi", "assets/taxi.png"),
//                   buildTransportOption("Bus", "assets/bus.png"),
//                   const Spacer(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TextButton.icon(
//                         onPressed: () {
//                           // Future: open map view screen
//                         },
//                         icon: const Icon(Icons.map, color: Colors.blue),
//                         label: const Text("IN MAP VIEW",
//                             style: TextStyle(color: Colors.blue)),
//                       ),
//                       Row(
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context); // Go back
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.grey.shade300,
//                               foregroundColor: Colors.black,
//                             ),
//                             child: const Text("Back"),
//                           ),
//                           const SizedBox(width: 10),
//                           ElevatedButton(
//                             onPressed: () {
//                               if (selectedModes.isEmpty) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                         "Please select at least one mode of transport."),
//                                   ),
//                                 );
//                                 return;
//                               }

//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => SummaryScreen(
//                                     selectedAttractions: selectedAttractions,
//                                     selectedHotels: selectedHotels,
//                                     selectedRestaurants: selectedRestaurants,
//                                     selectedTransportModes:
//                                         selectedTransportModes,
//                                     totalBudget: totalBudget,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: const Text("Next"),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//               boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Current Budget:",
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                 Text("₹${widget.totalBudget.toStringAsFixed(0)}",
//                     style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//2 new

import 'package:flutter/material.dart';
import 'package:signinsignup/MapPage.dart';
import 'summary_screen.dart';

class ModeOfTransportPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedAttractions;
  final List<Map<String, dynamic>> selectedHotels;
  final Map<String, double> selectedRestaurants;
  final double totalBudget;
  final String city;

  const ModeOfTransportPage({
    Key? key,
    required this.selectedAttractions,
    required this.selectedHotels,
    required this.selectedRestaurants,
    required this.totalBudget,
    required this.city,
    required bool autoSelectBestMode,
  }) : super(key: key);

  @override
  _ModeOfTransportPageState createState() => _ModeOfTransportPageState();
}

class _ModeOfTransportPageState extends State<ModeOfTransportPage> {
  List<String> selectedModes = [];
  bool autoSelectBestMode = true;

  void toggleSelection(String mode) {
    setState(() {
      if (selectedModes.contains(mode)) {
        selectedModes.remove(mode);
      } else {
        selectedModes.add(mode);
      }
    });
  }

  Widget buildTransportOption(String title, String assetPath) {
    final isSelected = selectedModes.contains(title);
    return Card(
      elevation: 3,
      color: isSelected ? Colors.lightBlue.shade50 : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Image.asset(assetPath, width: 40),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: Icon(
          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
          color: isSelected ? Colors.blue : Colors.grey,
        ),
        onTap: autoSelectBestMode ? null : () => toggleSelection(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Mode of Transport",
            style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Choose your modes of transport:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Auto-select best mode",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Switch(
                        value: autoSelectBestMode,
                        onChanged: (value) {
                          setState(() {
                            autoSelectBestMode = value;
                            if (value) selectedModes.clear();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildTransportOption("Auto", "assets/auto.png"),
                  buildTransportOption("Taxi", "assets/taxi.png"),
                  buildTransportOption("Bus", "assets/bus.png"),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          //new add just!!!
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MapScreen(
                                      city: 'Mathura',
                                    )),
                          );
                          // Future: open map view screen
                        },
                        icon: const Icon(Icons.map, color: Colors.blue),
                        label: const Text("IN MAP VIEW",
                            style: TextStyle(color: Colors.blue)),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              foregroundColor: Colors.black,
                            ),
                            child: const Text("Back"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (!autoSelectBestMode &&
                                  selectedModes.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Please select at least one mode of transport."),
                                  ),
                                );
                                return;
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SummaryScreen(
                                    selectedAttractions:
                                        widget.selectedAttractions,
                                    selectedHotels: widget.selectedHotels,
                                    selectedRestaurants:
                                        widget.selectedRestaurants,
                                    selectedTransportModes: selectedModes,
                                    autoSelectBestMode: autoSelectBestMode,
                                    totalBudget: widget.totalBudget,
                                  ),
                                ),
                              );
                            },
                            child: const Text("Next"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Current Budget:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text("₹${widget.totalBudget.toStringAsFixed(0)}",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
