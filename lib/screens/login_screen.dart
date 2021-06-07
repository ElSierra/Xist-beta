import 'package:Xistence/constants.dart';
import 'package:Xistence/reusable_mat_button.dart';
import 'package:Xistence/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _text = TextEditingController();
  final _pw = TextEditingController();
  String error = '';

  bool check = false;
  bool isEmpty = false;
  bool pEmpty = false;

  late String email;
  late String password;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, WelcomeScreen.id);
        return false;
      },
      child: ModalProgressHUD(
        inAsyncCall: check,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Flexible(
                  child: Container(
                    child: Lottie.asset(
                      'images/runner.json',
                      fit: BoxFit.fill,
                      height: 200,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome, ',
                    style: GoogleFonts.mavenPro(
                        color: Colors.black,
                        fontSize: 37,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sign in to continue!',
                    style: GoogleFonts.lato(
                        color: Colors.black38,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextField(
                  controller: _text,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                    //Do something with the user input.
                  },
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                  ),
                  decoration: kTextField.copyWith(
                    errorText: isEmpty == true ? 'Field Can\'t be blank' : null,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: isEmpty == false
                              ? Colors.lightBlueAccent
                              : Colors.red,
                          width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: isEmpty == false
                              ? Colors.lightBlueAccent
                              : Colors.red,
                          width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    labelText: 'Email',
                    labelStyle: GoogleFonts.roboto(
                      color: Color(0xFF9CA7B2),
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                    //Do something with the user input.
                  },
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                  ),
                  decoration: kTextField.copyWith(
                    errorText: pEmpty ? 'Enter a password' : null,
                    labelText: 'Password',
                    labelStyle: GoogleFonts.roboto(
                        color: Color(0xFF9CA7B2), fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Material(
                  borderRadius: BorderRadius.circular(60),
                  child: Container(
                    height: 30,
                    child: Text(
                      error,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Hero(
                      tag: 'button',
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                            color: Color(0xff0d60d8),
                            borderRadius: BorderRadius.circular(10.0),
                            child: ReusableMaterialButton(
                              text: 'Login',
                              onPressed: () async {
                                _text.text.isEmpty
                                    ? isEmpty = true
                                    : isEmpty = false;
                                _pw.text.isEmpty
                                    ? pEmpty = true
                                    : pEmpty = false;
                                setState(() {
                                  check = true;
                                });
                                if (_text.text.isNotEmpty ||
                                    _pw.text.isNotEmpty) {
                                  try {
                                    await _auth.signInWithEmailAndPassword(
                                        email: email, password: password);

                                    Navigator.pushNamed(
                                        context, '/chat_screen');

                                    setState(() {
                                      check = false;
                                    });
                                  } catch (e) {
                                    print(e);
                                    error = ' ⚠️Check Email or Password';
                                    if (e.toString() ==
                                        '[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.') {
                                      error =
                                          '⚠️Connections to Network Temporarily blocked due to multiple failed attempts';
                                    }
                                    setState(() {
                                      check = false;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    check = false;
                                  });
                                }
                              },
                            )),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: [
                      Text(' Don\'t have an account ? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/registration_screen');
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            color: Color(0XFFFF808E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
