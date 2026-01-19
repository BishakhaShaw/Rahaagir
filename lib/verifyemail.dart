import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signinsignup/wrapper.dart';

class Verifyemail extends StatefulWidget {
  const Verifyemail({Key? key}) : super(key: key);

  @override
  State<Verifyemail> createState() => _VerifyState();
}

class _VerifyState extends State<Verifyemail> {
  @override
  void initState() {
    sendverifylink();
    super.initState();
  }

  sendverifylink() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification().then((value) => {
          Get.snackbar('Link sent', 'A link has been send to your email',
              margin: EdgeInsets.all(30), snackPosition: SnackPosition.BOTTOM)
        });
  }

  reload() async {
    await FirebaseAuth.instance.currentUser!.reload().then((Value) => {
          Get.offAll(Wrapper(
            Email: '',
            Password: " ",
          ))
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: Text(
              'Open your mail and click on the link provided verify email & reload this page'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (() => reload()), child: Icon(Icons.restart_alt_rounded)),
    );
  }
}
