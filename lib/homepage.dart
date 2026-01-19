//usssless this page may in feture it deleted
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class homepage extends StatefulWidget {
  homepage({super.key, required this.Email, required this.Password});

  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final user = FirebaseAuth.instance.currentUser;

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("HomePage"),
        ), //back jane ka option
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text('${user!.email}'),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() => signout()),
          child: Icon(Icons.login_rounded),
        ),
      ),
    );
  }
}
