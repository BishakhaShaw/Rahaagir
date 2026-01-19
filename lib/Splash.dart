import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:signinsignup/Login.dart';
import 'package:signinsignup/wrapper.dart';

class Splash extends StatefulWidget{
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   Timer(Duration( seconds:2),(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Wrapper(Email: '', Password: ' ',),
    )
    );

   }
   );

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
    body: Container(color: Colors.blue,
   child: Center(child: Text('RAHAAGIR :) ',style: TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    color: Colors.white
   ),)),
    ),
   );
  }
}