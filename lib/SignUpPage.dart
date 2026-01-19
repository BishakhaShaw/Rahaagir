import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:signinsignup/Login.dart';
import 'package:signinsignup/homepage.dart';
import 'package:signinsignup/wrapper.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
   TextEditingController Email = TextEditingController();

  TextEditingController Password = TextEditingController();

  Color backgroundColor = Color(0xFF007AFF);

   final GlobalKey<FormState> _key =  GlobalKey<FormState>();

   void SignUp(String Email,String Password)
  
  async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try{
await _auth.createUserWithEmailAndPassword(email: Email, password: Password);//user create
Get.offAll(Wrapper(Email: '', Password: ' ',));
    }
   on FirebaseAuthException  catch (Error)//catch user create  error through firebase
    {
print("Errrrrrrrr : "+Error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 60),
            child: Row(
              children: [
                Text(
                  "RAHAAGIR",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                // mainAxisAlignment:MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //one by
                  SizedBox(
                    height: 20,
                  ),

                  Text(
                    "Sign Up",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        color: Colors.black),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Text(
                    "Email",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                 Form(
                  key: _key,
                   child: Column(
                    children: [
                       TextFormField(
                       validator: (value) {
                           if(value!.isEmpty)
                            {
                              return "Please enter something";
                            }
                        else  if (!value!.contains("@gmail.com")) {
                            return "Please Enter a valid Email";
                          } else {
                            return null;
                          }
                        },
                      controller: Email,
                      obscureText: false,
                      decoration: InputDecoration(
                          hintText: "Enter Email",
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.6)))),
                    ),
                   
                    SizedBox(
                      height: 20,
                    ),
                   
                    Row(
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    TextFormField(
                      validator: (value) {
                            if(value!.isEmpty)
                            {
                              return "Please enter something";
                            }
                          else  if (value!.length < 6) {
                              return "Please Enter a Strong Password";
                            } 
                            else {
                              return null;
                            }
                          },
                      controller: Password,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Enter Password",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.6))))),
                    ],
                   ),
                 ),

                  SizedBox(
                    height: 20,
                  ),
                  // Text(
                  //   "Confirm Password",
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 20,
                  //       color: Colors.black),
                  // ),
                  // TextFormField(
                  //     obscureText: true,
                  //     decoration: InputDecoration(
                  //         hintText: "Enter Password",
                  //         enabledBorder: UnderlineInputBorder(
                  //             borderSide: BorderSide(
                  //                 color: Colors.grey.withOpacity(0.6))))),

                  SizedBox(
                    height: 30,
                  ),


                  GestureDetector(
 onTap: ()
                    {
                      //function call
                      if(_key.currentState!.validate())
                      {
                        //first call sign funct
                        SignUp(Email.text, Password.text);//call when no error
                        //sign in...
                         Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => homepage(Email: Email, Password: Password,))//Loginpage()
                                    );

                      }
                    },
                    child: Container(
                      child: Center(
                        
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                           color: Colors.white), 
                        ),
                      ),
                    
                    
                    
                      height: 70,
                      width: 370,
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already  hava an account?",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: backgroundColor),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "OR",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: backgroundColor,
                          // color:Colors.grey.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            height: 553,
            width: double.maxFinite,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, -10),
                      blurRadius: 10, //kitni upr
                      color: Colors.black.withOpacity(0.4)),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                )),
          )
        ],
      ),
    ));
  }
}

