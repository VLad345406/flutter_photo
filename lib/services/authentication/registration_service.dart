import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/main/main_screen.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:flutter_qualification_work/services/validate_password_service.dart';

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
    snackBar(context, 'Please, input data!');
  } else if (password != confirmPassword) {
    snackBar(context, 'Wrong confirm password!');
  } else if (password.length < 8 || !validatePassword(password)) {
    snackBar(
        context,
        'Password must be 8 characters or more! Minimum 1 Upper case symbol, '
        'Minimum 1 lowercase symbol, Minimum 1 Numeric Number symbol, '
        'Minimum 1 Special Character!');
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
        'image_link': '',
      }, SetOptions(merge: true));
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return MainScreen();
      }), (route) => false);
    } on FirebaseAuthException catch (e) {
      snackBar(context, e.message.toString());
    } catch (e) {
      snackBar(context, e.toString());
    }
  }
}
