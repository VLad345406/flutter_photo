import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhotoTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool showVisibleButton;
  final String label;

  const PhotoTextField({
    super.key,
    required this.controller,
    required this.showVisibleButton,
    required this.label,
  });

  @override
  State<PhotoTextField> createState() => _PhotoTextFieldState();
}

class _PhotoTextFieldState extends State<PhotoTextField> {
  bool _isObscure = true;

  void showPassword() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.showVisibleButton ? _isObscure : false,
        enableSuggestions: false,
        autocorrect: false,
        style: GoogleFonts.roboto(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        decoration: InputDecoration(
          suffixIcon: widget.showVisibleButton ? IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
            onPressed: showPassword,
          ) : null,
          labelText: widget.label,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          focusedBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.all(Radius.zero),
            borderSide: BorderSide(
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.all(Radius.zero),
            borderSide: BorderSide(
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
