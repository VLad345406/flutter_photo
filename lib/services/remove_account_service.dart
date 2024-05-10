import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/auth/start_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

void removeAccount(BuildContext context) async {
  try {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect();
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  //remove user info from database
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final data =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  try {
    await FirebaseStorage.instance
        .ref()
        .child('avatars/${data['user_name']}')
        .delete();
  } catch (e) {
    if (kDebugMode) {
      print("User don't have avatar!");
    }
  }
  await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  await FirebaseAuth.instance.authStateChanges().listen((User? user) {
    user?.delete();
  });
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StartScreen(),
    ),
  );
}
