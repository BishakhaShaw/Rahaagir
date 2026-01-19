// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:signinsignup/SignUpPage.dart';
// import 'package:signinsignup/forgetscreen.dart';
// import 'package:signinsignup/homepage.dart';
// // import 'package:signinsignup/tempCodeRunnerFile.dart';

// class LoginPage extends StatefulWidget {
//   LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   Color backgroundColor = Color(0xFF007AFF);

//   final GlobalKey<FormState> _key = GlobalKey<FormState>();

//   bool isloading=false;
//  //for validation
//  void SignIn(String Email, String Password) async {
//   setState(() {
//     isloading=true;
//   });
//     final FirebaseAuth _auth = FirebaseAuth.instance;
//     try {
//       await _auth.signInWithEmailAndPassword(
//           email: Email, password: Password); //user create
//     } on FirebaseAuthException catch (Error) //catch user create  error through firebase
//     {

//      Get.snackbar("error message",Error.code);
//     }
//     catch(Error)
//     {
//       Get.snackbar("error message",Error.toString());
//     }
//      setState(() {
//     isloading=false;
//   });
//   }

//   void movetohome(BuildContext context) {
//     if (_key.currentState!.validate()) {
//       SignIn(_Email.text, _Password.text);
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   homepage(Email: _Email, Password: _Password)));
//     }
//   }

//   TextEditingController _Email = TextEditingController();

//   TextEditingController _Password = TextEditingController();

//   String? validate(value) {
//     if (value!.isEmpty) //if empty email ho toh
//     {
//       return "Please enter an Emali";
//     } else if (!value.contains("@gmail.com")) {
//       return "Please enter valid Email";
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isloading?Center(child: CircularProgressIndicator(),): SafeArea(
//         child: Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: backgroundColor,
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 60),
//             child: Row(
//               children: [
//                 Text(
//                   "RAHAAGIR",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 40,
//                     color: Colors.white,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Container(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 25, right: 25),
//               child: Column(
//                 // mainAxisAlignment:MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   //one by
//                   SizedBox(
//                     height: 20,
//                   ),

//                   Text(
//                     "Sign in",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 25,
//                         color: Colors.black),
//                   ),

//                   SizedBox(
//                     height: 20,
//                   ),

//                   Text(
//                     "Email",

//                     style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 20,
//                         color: Colors.black),
//                   ),

//                   Form(
//                     key: _key,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextFormField(
//                           controller: _Email,
//                           validator: validate,
//                           obscureText: false,
//                           decoration: InputDecoration(
//                               hintText: "Enter Email",
//                               enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.grey.withOpacity(0.6)))),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Text(
//                           "Password",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 20,
//                               color: Colors.black),
//                         ),
//                         TextFormField(
//                             controller: _Password,
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return "Please Enter Password";
//                               } else if (value.length < 6) {
//                                 return "Length should be greater than 6";
//                               }
//                               return null;
//                             },
//                             obscureText: true,
//                             decoration: InputDecoration(
//                                 hintText: "Enter Password",
//                                 enabledBorder: UnderlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.grey.withOpacity(0.6))))),
//                       ],
//                     ),
//                   ),

//                   SizedBox(
//                     height: 20,
//                   ),

//                  Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [

//                       // Text(
//                       //   "Don't hava an account?",
//                       //   style: TextStyle(
//                       //       fontWeight: FontWeight.w500,
//                       //       fontSize: 15,
//                       //       color: Colors.black),
//                       // ),

//                       Align(
//                         alignment:Alignment.bottomRight,

//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>ForgetScreen()));
//                           },
//                           child: Text(
//                             "Forgot Password",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 15,
//                                 color: backgroundColor),
//                           ),
//                         ),
//                       ),
//                    ],
//                  ),

//                   SizedBox(
//                     height: 30,
//                   ),

//                   GestureDetector(
//                     onTap: () {
//                       movetohome(context);
//                     },
//                     child: Container(
//                       child: Center(
//                         child: Text(
//                           "Sign in",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16,
//                               color: Colors.white),
//                         ),
//                       ),
//                       height: 70,
//                       width: 370,
//                       decoration: BoxDecoration(
//                           color: backgroundColor,
//                           borderRadius: BorderRadius.circular(30)),
//                     ),
//                   ),

//                   SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Don't hava an account?",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 15,
//                             color: Colors.black),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => SignUpPage()));
//                         },
//                         child: Text(
//                           "Sign up",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 15,
//                               color: backgroundColor),
//                         ),
//                       ),
//                     ],
//                   ),

//                   SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "OR",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 20,
//                           color: backgroundColor,
//                           // color:Colors.grey.withOpacity(0.6),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             height: 553,
//             width: double.maxFinite,
//             decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                       offset: Offset(0, -10),
//                       blurRadius: 10, //kitni upr
//                       color: Colors.black.withOpacity(0.4)),
//                 ],
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(50),
//                   topRight: Radius.circular(50),
//                 )),
//           )

//         ],
//       ),
//     ));
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'city_selection.dart';
import 'SignUpPage.dart';
import 'forgetscreen.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  // अगर यूजर पहले से लॉग इन है, तो सीधा City Page पर भेजो
  void checkUserLoggedIn() async {
    User? user = _auth.currentUser;
    if (user != null && user.emailVerified) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => CitySelectionPage()));
    }
  }

  void signIn(String email, String password) async {
    setState(() => isLoading = true);

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;
      if (user != null) {
        if (user.emailVerified) {
          // लॉगिन सक्सेसफुल, City Page पर भेजें
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => CitySelectionPage()));
        } else {
          Get.snackbar(
              "Verification Required", "Please verify your email first.");
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "An error occurred");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Color(0xFF007AFF),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 75, vertical: 60),
                    child: Text("RAHAAGIR",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: Colors.white)),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Form(
                        key: _key,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Sign in",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w500)),
                            SizedBox(height: 20),
                            Text("Email",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                            TextFormField(
                              controller: _emailController,
                              validator: (value) => value!.isEmpty
                                  ? "Please enter an Email"
                                  : null,
                              decoration:
                                  InputDecoration(hintText: "Enter Email"),
                            ),
                            SizedBox(height: 20),
                            Text("Password",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              validator: (value) => value!.isEmpty
                                  ? "Please Enter Password"
                                  : null,
                              decoration:
                                  InputDecoration(hintText: "Enter Password"),
                            ),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetScreen()));
                                },
                                child: Text("Forgot Password?",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF007AFF))),
                              ),
                            ),
                            SizedBox(height: 30),
                            GestureDetector(
                              onTap: () {
                                if (_key.currentState!.validate()) {
                                  signIn(_emailController.text,
                                      _passwordController.text);
                                }
                              },
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Color(0xFF007AFF),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                  child: Text("Sign in",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account?",
                                    style: TextStyle(fontSize: 15)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpPage()));
                                  },
                                  child: Text(" Sign up",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF007AFF))),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Text("OR",
                                  style: TextStyle(
                                      fontSize: 20, color: Color(0xFF007AFF))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
