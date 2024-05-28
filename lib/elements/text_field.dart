import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PhotoTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool showVisibleButton;
  final String label;
  final bool disableSpace;
  final bool disableUppercase;

  const PhotoTextField({
    super.key,
    required this.controller,
    required this.showVisibleButton,
    required this.label,
    required this.disableSpace,
    required this.disableUppercase,
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
        inputFormatters: [
          if (widget.disableSpace)
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          if (widget.disableUppercase)
            FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9_\W]')),
        ],
        style: GoogleFonts.roboto(
          fontSize: 15,
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        decoration: InputDecoration(
          suffixIcon: widget.showVisibleButton
              ? IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: showPassword,
                )
              : null,
          labelText: widget.label,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
