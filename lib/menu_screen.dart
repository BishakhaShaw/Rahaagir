import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class MenuScreen extends StatefulWidget {
  final String restaurantName;

  const MenuScreen({super.key, required this.restaurantName});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String imageUrl = "";
  TextEditingController budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMenuImage();
  }

  Future<void> fetchMenuImage() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("menus").child(widget.restaurantName);
    DataSnapshot snapshot = await dbRef.get();
    if (snapshot.exists) {
      setState(() {
        imageUrl = snapshot.value.toString();
      });
    }
  }

  void submitBudget() {
    double budget = double.tryParse(budgetController.text) ?? 0;
    Navigator.pop(context, budget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu for ${widget.restaurantName}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            imageUrl.isNotEmpty
                ? Image.network(imageUrl, fit: BoxFit.cover)
                : Text("We don't have the menu, we apologize."),
            SizedBox(height: 10),
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Write Your Approx Food Budget",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: submitBudget,
              child: Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}