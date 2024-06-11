import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/mobile/auth/mobile_google_sigh_in_registration_data.dart';
import 'package:flutter_qualification_work/screens/mobile/main/main_screen.dart';
import 'package:flutter_qualification_work/screens/web/main/web_main_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> googleSighInService(BuildContext context) async {
  try {
    await GoogleSignIn().signOut();

    final googleAccount = await GoogleSignIn().signIn();

    if (googleAccount == null) {
      return;
    }

    final googleAuth = await googleAccount.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    final userId = FirebaseAuth.instance.currentUser!.uid;
    final data =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    try {
      if (data['uid'] == userId) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => kIsWeb
                ? ResponsiveLayout(
                    mobileScaffold: MainScreen(),
                    webScaffold: WebMainScreen(),
                  )
                : MainScreen(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GoogleSighInRegistrationData(),
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GoogleSighInRegistrationData(),
        ),
      );
    }

    /*if (mounted) {

    }*/
  } on FirebaseAuthException catch (e) {
    snackBar(context, e.message.toString());
    print(e.message);
  }
}
