import 'package:flutter/material.dart';

class PlaceDetailScreen extends StatelessWidget {
  final String name;
  final String address;
  final String rating;
  final String openNow;
  final String? photoUrl;

  const PlaceDetailScreen({
    super.key,
    required this.name,
    required this.address,
    required this.rating,
    required this.openNow,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (photoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(photoUrl!, height: 200, fit: BoxFit.cover),
              ),
            const SizedBox(height: 16),
            Text('Address: $address', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Rating: $rating', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Status: $openNow', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
