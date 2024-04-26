import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/main/main_screen.dart';

Future registration(BuildContext context, String email, String password) async {
  if (email == '' || password == '') {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please, input data!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } else {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
            return MainScreen();
          }), (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}