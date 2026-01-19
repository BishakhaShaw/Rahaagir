import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:signinsignup/CityPage.dart';
import 'package:signinsignup/city_selection.dart';
import 'package:signinsignup/Login.dart';
// ignore: unused_import
import 'package:signinsignup/homepage.dart';
import 'package:signinsignup/verifyemail.dart';

class Wrapper extends StatefulWidget {
  final String Email;

  final dynamic Password;

  const Wrapper({Key? key, required this.Email, required this.Password})
      : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              if (snapshot.data!.emailVerified) {
                return CitySelectionPage();
                // return homepage(Email: TextEditingController(), Password: TextEditingController(),);
              } else {
                return Verifyemail();
              }
            } else {
              return LoginPage();
            }
          }),
    );
  }
}
