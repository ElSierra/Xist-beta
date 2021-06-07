import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

class Easter extends StatefulWidget {
  @override
  _EasterState createState() => _EasterState();
}

class _EasterState extends State<Easter> with SingleTickerProviderStateMixin {
  late AnimationController zController;
  late Animation animation;
  late Timer _timer;
  String _url = 'https://google.com';
  @override
  void initState() {
    Vibration.vibrate(duration: 1000);
    Fluttertoast.showToast(
      msg: 'Werey, na only you fit reach here',
    );
    zController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    animation =
        ColorTween(begin: Colors.white, end: Colors.black).animate(zController);
    zController.forward();
    zController.addListener(() {
      setState(() {});
      print(animation.value);
    });
    super.initState();
  }

  @override
  void dispose() {
    zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bg.png'), fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                child: Image.asset('images/zzzz.png'),
              ),
              Container(
                child: Text(
                  'EDM is all that matters',
                  style: GoogleFonts.baloo(fontSize: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
