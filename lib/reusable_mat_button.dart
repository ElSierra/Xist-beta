import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableMaterialButton extends StatelessWidget {
  ReusableMaterialButton({required this.text, required this.onPressed});
  final String text;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: 150.0,
      height: 60.0,
      child: Text(
        text,
        style: GoogleFonts.roboto(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
