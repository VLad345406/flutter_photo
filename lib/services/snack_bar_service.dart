import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void snackBar(BuildContext context, String text) {
  final screenWidth = MediaQuery.of(context).size.width;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width: kIsWeb && screenWidth >= 1000
          ? screenWidth - 700
          : screenWidth - 32,
      content: Text(text),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
