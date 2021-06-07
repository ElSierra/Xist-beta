import 'dart:async';

import 'package:Xistence/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;
bool cSuccess = false;
int tapCheck = 0;
late HandleUncaughtErrorHandler errorHandler;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  int value = 0;
  bool isaac = false;
  bool isBlack = false;

  late String messageText;
  final messageTextController = TextEditingController();

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    if (loggedInUser.email == 'Hojoisaac@gmail.com' ||
        loggedInUser.email == 'hojoisaac@gmail.com') {
      isaac = true;
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Fluttertoast.showToast(
          msg: 'Chairman calm down, Logout first',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );

        return false;
      },
      child: Scaffold(
        backgroundColor: isBlack ? Colors.black : Color(0xffF4F6FA),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg.png'), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 30,
                width: double.infinity,
                color: isBlack ? Colors.black : Colors.white,
              ),
              Container(
                color: isBlack ? Colors.black45 : Colors.white,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(02, 12, 30, 2),
                  child: Container(
                    color: isBlack ? Colors.black45 : Colors.white,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        CircleAvatar(
                          minRadius: 20,
                          child: isaac ? null : Icon(Icons.person),
                          backgroundImage:
                              isaac ? AssetImage('images/isaac.jpg') : null,
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Text(
                                '${loggedInUser.email}',
                                style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color:
                                        isBlack ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                isaac
                                    ? 'Admin                          '
                                    : 'New user                       ',
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          width: 20,
                        )),
                        Expanded(
                            child: IconButton(
                          icon: Icon(
                            Icons.wb_sunny_rounded,
                            color: isBlack ? Colors.white : Colors.black,
                          ),
                          onPressed: () {
                            if (isBlack == false) {
                              isBlack = true;
                              setState(() {});
                            } else if (isBlack == true) {
                              isBlack = false;
                              setState(() {});
                            }
                          },
                        )),
                        Expanded(
                          child: Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 8),
                              child: PopupMenuButton(
                                elevation: 0,
                                shape: ShapeBorder.lerp(
                                    Border.all(color: Colors.blue),
                                    Border.all(color: Colors.blue),
                                    10),
                                icon: Icon(
                                  Icons.more_horiz,
                                  size: 40.0,
                                  color: Color(0xffA5A3D4),
                                ), //don't specify icon if you want 3 dot menu
                                color: isBlack ? Colors.black : Colors.white,
                                itemBuilder: (context) => [
                                  PopupMenuItem<int>(
                                    value: 0,
                                    child: Text(
                                      "Clear",
                                      style: TextStyle(
                                          color: isBlack
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 1,
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(
                                          color: isBlack
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                ],
                                onSelected: (item) async {
                                  if (item == 1) {
                                    _auth.signOut();
                                    Navigator.pushNamed(
                                        context, '/login_screen');
                                  } else {
                                    _firestore
                                        .collection('messages')
                                        .get()
                                        .then((snapshot) {
                                      for (var ds in snapshot.docs) {
                                        ds.reference.delete();
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              BubbleStream(),
              Container(
                decoration: kMessageContainerDecoration.copyWith(
                  color: isBlack ? Colors.black12 : Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;

                          //Do something with the user input.
                        },
                        style: TextStyle(
                            color: isBlack ? Colors.white : Colors.black),
                        decoration: kMessageTextFieldDecoration.copyWith(
                          hintStyle: TextStyle(
                              color: isBlack ? Colors.white24 : Colors.black45),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        messageTextController.clear();
                        Vibration.vibrate(duration: 10);
                        if (messageText.isNotEmpty) {
                          _firestore.collection('messages').add({
                            'sender': loggedInUser.email,
                            'text': messageText,
                            'timestamp': DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                          }).whenComplete(() {
                            Fluttertoast.showToast(
                                msg: 'Sent',
                                gravity: ToastGravity.TOP,
                                backgroundColor:
                                    isBlack ? Colors.black : Colors.white);
                            messageText = '';
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Chairman, you write nothing');
                        }

                        //Implement send functionality.
                      },
                      child: Icon(
                        Icons.send,
                        color: Color(0xFFA3ADB4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BubbleStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection("messages")
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs;
          List<Bubble> messageWidgets = [];
          for (var message in messages) {
            final messageSender = message['sender'];
            final messageText = message['text'];
            final date = message['timestamp'];

            final currentUser = loggedInUser.email;

            final messageWidget = Bubble(
              sender: messageSender,
              text: messageText,
              date: date,
              isSuccess: cSuccess,
              isMe: currentUser == messageSender,
            );

            messageWidgets.add(messageWidget);
          }
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
              child: ListView(
                reverse: true,
                children: messageWidgets,
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }
      },
    );
  }
}

class Bubble extends StatelessWidget {
  Bubble(
      {required this.text,
      required this.sender,
      required this.isMe,
      required this.date,
      required this.isSuccess});
  final String text;
  final String sender;
  final bool isMe;
  final String date;
  final bool isSuccess;

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe == true ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isMe ? '' : '$sender',
            style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 10),
          ),
          GestureDetector(
            onDoubleTap: () {
              tapCheck = tapCheck + 1;
              if (tapCheck >= 2) {
                print('Registered');

                Navigator.pushNamed(context, '/easter');
                tapCheck = 0;
              }
            },
            child: FractionallySizedBox(
              widthFactor: 0.4,
              child: Material(
                borderRadius:
                    isMe == true ? kBorderRadiusForMe : kBorderRadiusForthem,
                color: isMe == true ? Colors.white : Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: isMe == true
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          '$text',
                          style: GoogleFonts.montserrat(
                              fontSize: 15,
                              color:
                                  isMe == true ? Colors.black : Colors.white),
                        ),
                      ),
                      Align(
                        alignment: isMe == true
                            ? Alignment.bottomRight
                            : Alignment.bottomLeft,
                        child: Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('MMM d ').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(date)),
                              ),
                              style: GoogleFonts.openSans(
                                  fontSize: 7,
                                  color: isMe ? Colors.grey : Colors.white),
                            ),
                            Text(
                              DateFormat('kk:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(date)),
                              ),
                              style: GoogleFonts.openSans(
                                  fontSize: 10,
                                  color: isMe ? Colors.grey : Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
