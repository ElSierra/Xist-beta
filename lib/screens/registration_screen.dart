import 'package:Xistence/constants.dart';
import 'package:Xistence/reusable_outlined_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  bool check = false;
  @override
  void initState() {
    // TODO: implement initState
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: check,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/bg.png'), fit: BoxFit.cover),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child: Lottie.asset(
                      'images/runner.json',
                      fit: BoxFit.fill,
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                      //Do something with the user input.
                    },
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                    ),
                    decoration: kTextField.copyWith(
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
                      labelText: 'Password',
                      labelStyle: GoogleFonts.roboto(
                        color: Color(0xFF9CA7B2),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Hero(
                    tag: 'register',
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: ReUsableButton(
                        text: 'Register',
                        onPressed: () async {
                          setState(() {
                            check = true;
                          });
                          try {
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                            Navigator.pushNamed(context, '/chat_screen');
                            check = false;
                            setState(() {});
                          } catch (e) {
                            check = false;
                            setState(() {});
                            print(e);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
