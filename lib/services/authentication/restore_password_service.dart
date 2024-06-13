import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/localization/locales.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';

Future restorePassword(BuildContext context, String email) async {
  try {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email);
    snackBar(context, LocaleData.restoreMessage.getString(context));
    Navigator.pop(context);
  }on FirebaseAuthException catch (e) {
    snackBar(context, e.message.toString());
  }catch (e) {
    snackBar(context, e.toString());
  }
}