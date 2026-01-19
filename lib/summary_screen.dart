// import 'package:flutter/material.dart';

// class SummaryScreen extends StatefulWidget {
//   final Map<String, double> selectedRestaurants;
//   final double totalBudget;
//   final List<Map<String, dynamic>> selectedAttractions;
//   final List<Map<String, dynamic>> selectedHotels;
//   final List<String> selectedTransportModes;

//   const SummaryScreen({
//     Key? key,
//     required this.selectedRestaurants,
//     required this.totalBudget,
//     required this.selectedAttractions,
//     required this.selectedHotels,
//     required this.selectedTransportModes,
//   }) : super(key: key);

//   @override
//   _SummaryScreenState createState() => _SummaryScreenState();
// }

// class _SummaryScreenState extends State<SummaryScreen> {
//   late List<Map<String, dynamic>> itineraryItems;
//   double totalTravelCost = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _buildItineraryList();
//     _calculateTravelCost();
//   }

//   void _buildItineraryList() {
//     itineraryItems = [];

//     for (var hotel in widget.selectedHotels) {
//       itineraryItems.add({
//         'type': 'Hotel',
//         'name': hotel['name'],
//         'location': hotel['location'],
//         'details': hotel,
//       });
//     }

//     for (var attraction in widget.selectedAttractions) {
//       itineraryItems.add({
//         'type': 'Attraction',
//         'name': attraction['name'],
//         'location': attraction['location'],
//         'details': attraction,
//       });
//     }

//     widget.selectedRestaurants.forEach((name, price) {
//       itineraryItems.add({
//         'type': 'Restaurant',
//         'name': name,
//         'location': null,
//         'details': {'price': price},
//       });
//     });
//   }

//   void _calculateTravelCost() {
//     const distances = 3.0; // Dummy constant distance
//     final costsPerKm = {
//       'Auto': 10.0,
//       'Taxi': 15.0,
//       'Bus': 5.0,
//       'Metro': 7.0,
//       'Bike': 8.0,
//     };

//     double cost = 0.0;

//     for (int i = 0; i < itineraryItems.length - 1; i++) {
//       double minCost = double.infinity;

//       for (String mode in widget.selectedTransportModes) {
//         final costPerKm = costsPerKm[mode] ?? double.infinity;
//         final total = costPerKm * distances;
//         if (total < minCost) minCost = total;
//       }

//       cost += minCost;
//     }

//     setState(() {
//       totalTravelCost = cost;
//     });
//   }

//   void _onReorder(int oldIndex, int newIndex) {
//     setState(() {
//       if (newIndex > oldIndex) newIndex -= 1;
//       final item = itineraryItems.removeAt(oldIndex);
//       itineraryItems.insert(newIndex, item);
//       _calculateTravelCost();
//     });
//   }

//   Widget _buildItineraryItem(Map<String, dynamic> item, int index) {
//     IconData icon;
//     Color iconColor;

//     switch (item['type']) {
//       case 'Hotel':
//         icon = Icons.hotel;
//         iconColor = Colors.purple;
//         break;
//       case 'Attraction':
//         icon = Icons.place;
//         iconColor = Colors.red;
//         break;
//       case 'Restaurant':
//         icon = Icons.restaurant;
//         iconColor = Colors.orange;
//         break;
//       default:
//         icon = Icons.location_on;
//         iconColor = Colors.grey;
//     }

//     return ListTile(
//       key: ValueKey('$index-${item['name']}'),
//       leading: Icon(icon, color: iconColor),
//       title: Text(item['name'],
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//       subtitle: Text(item['type'], style: const TextStyle(color: Colors.grey)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Trip Summary"),
//         backgroundColor: Colors.teal.shade700,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Your Itinerary",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ReorderableListView(
//                 onReorder: _onReorder,
//                 children: [
//                   for (int i = 0; i < itineraryItems.length; i++)
//                     _buildItineraryItem(itineraryItems[i], i),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Divider(thickness: 1),
//             const SizedBox(height: 10),
//             const Text("Selected Transport Modes",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             Wrap(
//               spacing: 8.0,
//               runSpacing: 6.0,
//               children: widget.selectedTransportModes
//                   .map((mode) => Chip(
//                         label: Text(mode),
//                         backgroundColor: Colors.lightBlue.shade50,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                       ))
//                   .toList(),
//             ),
//             const SizedBox(height: 20),
//             const Divider(thickness: 1),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Total Travel Cost:",
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                 Text("₹${totalTravelCost.toStringAsFixed(0)}",
//                     style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green)),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Overall Trip Budget:",
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                 Text("₹${widget.totalBudget.toStringAsFixed(0)}",
//                     style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.deepPurple)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//2
import 'package:flutter/material.dart';
import 'map_route_screen.dart';
import 'roadmap_screen.dart';

class SummaryScreen extends StatefulWidget {
  final Map<String, double> selectedRestaurants;
  final double totalBudget;
  final List<Map<String, dynamic>> selectedAttractions;
  final List<Map<String, dynamic>> selectedHotels;
  final List<String> selectedTransportModes;

  const SummaryScreen({
    Key? key,
    required this.selectedRestaurants,
    required this.totalBudget,
    required this.selectedAttractions,
    required this.selectedHotels,
    required this.selectedTransportModes,
    required bool autoSelectBestMode,
  }) : super(key: key);

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late List<Map<String, dynamic>> itineraryItems;
  double totalTravelCost = 0.0;

  @override
  void initState() {
    super.initState();
    _buildItineraryList();
    _calculateTravelCost();
  }

  void _buildItineraryList() {
    itineraryItems = [];

    for (var hotel in widget.selectedHotels) {
      itineraryItems.add({
        'type': 'Hotel',
        'name': hotel['name'],
        'location': hotel['location'],
        'details': hotel,
      });
    }

    for (var attraction in widget.selectedAttractions) {
      itineraryItems.add({
        'type': 'Attraction',
        'name': attraction['name'],
        'location': attraction['location'],
        'details': attraction,
      });
    }

    widget.selectedRestaurants.forEach((name, price) {
      itineraryItems.add({
        'type': 'Restaurant',
        'name': name,
        'location': null,
        'details': {'price': price},
      });
    });
  }

  void _calculateTravelCost() {
    const double defaultDistance = 3.0;
    const Map<String, double> costsPerKm = {
      'Auto': 10.0,
      'Taxi': 15.0,
      'Bus': 5.0,
      'Metro': 7.0,
      'Bike': 8.0,
    };

    double cost = 0.0;

    for (int i = 0; i < itineraryItems.length - 1; i++) {
      double minCost = double.infinity;

      for (String mode in widget.selectedTransportModes) {
        final costPerKm = costsPerKm[mode] ?? double.infinity;
        final total = costPerKm * defaultDistance;
        if (total < minCost) minCost = total;
      }

      cost += minCost;
    }

    setState(() {
      totalTravelCost = cost;
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = itineraryItems.removeAt(oldIndex);
      itineraryItems.insert(newIndex, item);
      _calculateTravelCost(); // recalculate after reordering
    });
  }

  Widget _buildItineraryItem(Map<String, dynamic> item, int index) {
    IconData icon;
    Color iconColor;

    switch (item['type']) {
      case 'Hotel':
        icon = Icons.hotel;
        iconColor = Colors.purple;
        break;
      case 'Attraction':
        icon = Icons.place;
        iconColor = Colors.red;
        break;
      case 'Restaurant':
        icon = Icons.restaurant;
        iconColor = Colors.orange;
        break;
      default:
        icon = Icons.location_on;
        iconColor = Colors.grey;
    }

    return ListTile(
      key: ValueKey('$index-${item['name']}'),
      leading: Icon(icon, color: iconColor),
      title: Text(item['name'],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      subtitle: Text(item['type'], style: const TextStyle(color: Colors.grey)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Summary"),
        backgroundColor: Colors.teal.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            tooltip: 'Route Map',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MapRouteScreen(
                    itineraryItems: itineraryItems,
                    transportModes: widget.selectedTransportModes,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.route),
            tooltip: 'Roadmap',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RoadmapScreen(
                    itineraryItems: itineraryItems,
                    selectedTransportModes: widget.selectedTransportModes,
                    googleApiKey: '',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your Itinerary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ReorderableListView(
                onReorder: _onReorder,
                children: [
                  for (int i = 0; i < itineraryItems.length; i++)
                    _buildItineraryItem(itineraryItems[i], i),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1),
            const Text("Selected Transport Modes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 6.0,
              children: widget.selectedTransportModes
                  .map((mode) => Chip(
                        label: Text(mode),
                        backgroundColor: Colors.lightBlue.shade50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Travel Cost:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text("₹${totalTravelCost.toStringAsFixed(0)}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Overall Trip Budget:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text("₹${widget.totalBudget.toStringAsFixed(0)}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
