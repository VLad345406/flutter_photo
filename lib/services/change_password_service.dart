import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:flutter_qualification_work/services/validate_password_service.dart';

void changePassword(
  BuildContext context,
  String oldPassword,
  String newPassword,
  String repeatNewPassword,
) async {
  if (oldPassword.isEmpty ||
      newPassword.isEmpty ||
      repeatNewPassword.isEmpty) {
    snackBar(context, 'Not enough information!');
  } else {
    bool checkOldPassword = false;

    final user = FirebaseAuth.instance.currentUser;

    if (oldPassword == 'Google') {
      checkOldPassword = true;
    }
    else {
      final AuthCredential credential;
      try {
        credential = EmailAuthProvider.credential(
          email: user!.email.toString(),
          password: oldPassword,
        );
        await user.reauthenticateWithCredential(credential);
        checkOldPassword = true;
      } on Exception {
        snackBar(context, 'Wrong old password!');
      }
    }
    if (checkOldPassword) {
      if (newPassword != repeatNewPassword) {
        snackBar(context, 'New password and repeat not equal!');
      } else {
        if (oldPassword == newPassword) {
          snackBar(context, "New password can`t be equal old password!");
        } else {
          bool checkRules = validatePassword(newPassword);
          if (checkRules) {
            await user?.updatePassword(newPassword);
            Navigator.pop(context);
            snackBar(context, 'Success change!');
          } else {
            snackBar(context,
                'Password should have minimum 8 characters with at least one capital letter!');
          }
        }
      }
    }
  }
}
