
 import 'package:firebase_auth/firebase_auth.dart';

//  Future<bool> SignIn(String Email,String Password)

void SignIn(String Email, String Password)
 async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.signInWithEmailAndPassword(
          email: Email, password: Password); //user create
        //  return true;//
    } on FirebaseAuthException catch (Error) //catch user create  error through firebase
    {
      print("Errrrrrrrr : " + Error.toString());
    
    }
  }