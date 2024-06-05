import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/mobile/main/main_screen.dart';
import 'package:flutter_qualification_work/screens/web/main/web_main_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';

Future signIn(BuildContext context, String email, String password) async {
  if (email == '' || password == '') {
    snackBar(context, 'Input email and password!');
  } else {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      kIsWeb
          ? Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
              return ResponsiveLayout(
                mobileScaffold: MainScreen(),
                webScaffold: WebMainScreen(),
              );
            }), (route) => false)
          : Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
              return MainScreen();
            }), (route) => false);
    } on FirebaseAuthException catch (e) {
      snackBar(context, e.message.toString());
    }
  }
}
