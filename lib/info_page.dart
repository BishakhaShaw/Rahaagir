import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  final String city;

  const InfoPage({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    // Sample data for Mathura (Replace with actual data if needed)
    Map<String, List<String>> cityInfo = {
      "Mathura": [
        "🌟 Krishna Janmabhoomi Temple",
        "🌟 Dwarkadhish Temple",
        "🌟 Vishram Ghat",
        "🏛️ Mathura Museum",
        "🚑 Govt. Hospital, Mathura",
        "🛂 Tourist Help Center",
      ],
    };

    List<String> infoList = cityInfo[city] ?? ["No data available"];

    return Scaffold(
      appBar: AppBar(title: Text("$city - Info")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: infoList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(Icons.place, color: Colors.blue),
              title: Text(infoList[index]),
            ),
          );
        },
      ),
    );
  }
}
