import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ReUsableButton extends StatelessWidget {
  ReUsableButton({required this.text,required this.onPressed});
  final String text;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(

      child: Text(text,style: GoogleFonts.roboto(fontSize: 20 , color: Color(0xff0d60d8))),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: Size(150, 60),
        side: BorderSide(width: 2, color: Color(0xff0d60d8)),
      ),
      onPressed:onPressed,

    );
  }
}