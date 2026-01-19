import 'package:flutter/material.dart';

class RoadmapScreen extends StatelessWidget {
  final List<Map<String, dynamic>> itineraryItems;
  final List<String> selectedTransportModes;
  final double distancePerLeg;

  const RoadmapScreen({
    Key? key,
    required this.itineraryItems,
    required this.selectedTransportModes,
    this.distancePerLeg = 3.0,
    required String googleApiKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transportCostsPerKm = {
      'Auto': 10.0,
      'Taxi': 15.0,
      'Bus': 5.0,
      'Metro': 7.0,
      'Bike': 8.0,
    };

    List<Widget> routeWidgets = [];
    double totalTravelCost = 0.0;
    double totalHotelCost = 0.0;
    double totalFoodCost = 0.0;

    for (int i = 0; i < itineraryItems.length; i++) {
      final item = itineraryItems[i];
      final type = item['type'];
      final name = item['name'];

      if (type == 'Hotel') {
        final price = item['details']['price'] ?? 0.0;
        totalHotelCost += price;
        routeWidgets.add(ListTile(
          leading: const Icon(Icons.hotel, color: Colors.purple),
          title: Text(name),
          subtitle: Text("Stay: ₹${price.toStringAsFixed(0)}"),
        ));
      } else if (type == 'Restaurant') {
        final price = item['details']['price'] ?? 0.0;
        totalFoodCost += price;
        routeWidgets.add(ListTile(
          leading: const Icon(Icons.restaurant, color: Colors.orange),
          title: Text(name),
          subtitle: Text("Food Expense: ₹${price.toStringAsFixed(0)}"),
        ));
      } else if (type == 'Attraction') {
        routeWidgets.add(ListTile(
          leading: const Icon(Icons.place, color: Colors.red),
          title: Text(name),
          subtitle: const Text("Attraction"),
        ));
      }

      // Add transport cost if next item exists
      if (i < itineraryItems.length - 1) {
        double minCost = double.infinity;
        String selectedMode = 'Unknown';

        if (selectedTransportModes.isNotEmpty) {
          for (String mode in selectedTransportModes) {
            final rate = transportCostsPerKm[mode] ?? double.infinity;
            final tripCost = rate * distancePerLeg;
            if (tripCost < minCost) {
              minCost = tripCost;
              selectedMode = mode;
            }
          }
        } else {
          // fallback to default
          selectedMode = 'Auto';
          minCost = transportCostsPerKm['Auto']! * distancePerLeg;
        }

        totalTravelCost += minCost;

        routeWidgets.add(
          ListTile(
            leading: const Icon(Icons.directions, color: Colors.blue),
            title: Text("Travel to next"),
            subtitle:
                Text("Via $selectedMode | ₹${minCost.toStringAsFixed(0)}"),
          ),
        );
      }
    }

    final totalTripCost = totalTravelCost + totalHotelCost + totalFoodCost;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Roadmap"),
        backgroundColor: Colors.teal.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Your Complete Journey",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: routeWidgets,
              ),
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            _buildSummaryRow(
                "🛏️ Total Stay Cost:", totalHotelCost, Colors.purple),
            _buildSummaryRow(
                "🍽️ Total Food Cost:", totalFoodCost, Colors.orange),
            _buildSummaryRow(
                "🚕 Total Travel Cost:", totalTravelCost, Colors.blue),
            const Divider(thickness: 1),
            _buildSummaryRow("💰 Grand Total Trip Cost:", totalTripCost,
                Colors.teal.shade800),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text("₹${amount.toStringAsFixed(0)}",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
