import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/localization/locales.dart';
import 'package:flutter_qualification_work/screens/mobile/main/main_screen.dart';
import 'package:flutter_qualification_work/screens/web/main/web_main_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:flutter_qualification_work/services/validate_password_service.dart';
import 'package:flutter_qualification_work/services/validate_username_service.dart';

Future registration(
  BuildContext context,
  String email,
  String nickName,
  String password,
  String confirmPassword,
) async {
  if (email == '' ||
      nickName == '' ||
      password == '' ||
      confirmPassword == '') {
    snackBar(context, LocaleData.registerError.getString(context));
  } else if (password != confirmPassword) {
    snackBar(context, LocaleData.confirmPasswordError.getString(context));
  } else if (password.length < 8 || !validatePassword(password)) {
    snackBar(
        context, LocaleData.passwordValidateError.getString(context));
  } else {
    if (await validateUsername(nickName)) {
      snackBar(context, LocaleData.registerUserNameError.getString(context));
    } else {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        final FirebaseFirestore fireStore = FirebaseFirestore.instance;
        fireStore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'user_name': nickName,
          'avatar_link': '',
          'name': '',
          'count_image': 0,
        }, SetOptions(merge: true));
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return kIsWeb
              ? ResponsiveLayout(
                  mobileScaffold: MainScreen(),
                  webScaffold: WebMainScreen(),
                )
              : MainScreen();
        }), (route) => false);
      } on FirebaseAuthException catch (e) {
        snackBar(context, e.message.toString());
      } catch (e) {
        snackBar(context, e.toString());
      }
    }
  }
}
