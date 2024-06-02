import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/mobile/main/main_screen.dart';
import 'package:flutter_qualification_work/services/check_internet_service.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';

Future signIn(BuildContext context, String email, String password) async {
  if (email == '' || password == '') {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Input email and password!"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } else {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
            //return CheckInternet(widget: MainScreen());
            return MainScreen();
          }), (route) => false);
    } on FirebaseAuthException catch (e) {
      snackBar(context, e.message.toString());
    }
  }
}