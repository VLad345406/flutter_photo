import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhotoButton extends StatelessWidget {
  final double widthButton;
  final EdgeInsets buttonMargin;
  final Function()? function;
  final String buttonText;
  final Color textColor;
  final Color buttonColor;

  const PhotoButton({
    super.key,
    required this.widthButton,
    required this.buttonMargin,
    this.function,
    required this.buttonText,
    required this.textColor,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthButton,
      height: 52,
      margin: buttonMargin,
      decoration: BoxDecoration(
        color: buttonColor,
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextButton(
        onPressed: function,
        child: Text(
          buttonText,
          style: GoogleFonts.roboto(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
