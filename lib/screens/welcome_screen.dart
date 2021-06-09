import 'package:Xistence/constants.dart';
import 'package:Xistence/reusable_mat_button.dart';
import 'package:Xistence/reusable_outlined_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:vibration/vibration.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController zController;
  late Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    zController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animation =
        ColorTween(begin: Colors.blue, end: Colors.white).animate(zController);
    zController.forward();
    zController.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    zController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Fluttertoast.showToast(
          msg: 'E go be',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
        SystemNavigator.pop();

        return false;
      },
      child: AnnotatedRegion(
        // Reset SystemUiOverlayStyle for PageOne.

        // If this is not set, the status bar will use the style applied from another route.

        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: animation.value,
          body: Container(
            decoration: kBoxDecoration,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      child: Lottie.asset(
                        'images/shut.json',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 60,
                            child: Center(
                                // child: AnimatedTextKit(
                                //   animatedTexts: [
                                //     TypewriterAnimatedText(
                                //       'DevInk',
                                //       textAlign: TextAlign.center,
                                //       textStyle: GoogleFonts.rubik(
                                //           color: Color(0xff676D77),
                                //           fontSize: 60,
                                //           fontWeight: FontWeight.bold),
                                //       speed: const Duration(milliseconds: 200),
                                //     ),
                                //   ],
                                //   totalRepeatCount: 1,
                                //   pause: const Duration(milliseconds: 1000),
                                //   displayFullTextOnTap: true,
                                //   stopPauseOnTap: true,
                                // ),
                                ),
                          ),
                          Container(),
                        ],
                      ),
                      //   child: Center(
                      //       child: Text(
                      //     'Xistence',
                      //     style: GoogleFonts.rubik(
                      //         color: Color(0xff676D77),
                      //         fontSize: 60,
                      //         fontWeight: FontWeight.bold),
                      //   )),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        'by Исак™ ',
                        style: GoogleFonts.openSansCondensed(
                            //prostoOne
                            color: Color(0xff0d60d8),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),

                      SizedBox(
                        height: 10.0,
                      ),
                      Align(
                        child: Center(
                          child: Text(
                            '90% is Garbage, 10% is polished garbage, \n And if you didn\'t know what I was talking about. \n Yeah, The code.',
                            style: GoogleFonts.openSans(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 100.0,
                      ),
                      Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                              tag: 'button',
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Material(
                                  elevation: 0.0,
                                  color: Color(0xff0d60d8),
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: ReusableMaterialButton(
                                    text: 'Login',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/login_screen');
                                      Vibration.vibrate(duration: 10);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Hero(
                              tag: 'register',
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: ReUsableButton(
                                  text: 'Register',
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/registration_screen');
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
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
