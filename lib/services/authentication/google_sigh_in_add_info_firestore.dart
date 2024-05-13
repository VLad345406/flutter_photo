import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/main/main_screen.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';

Future googleSighInAddInfoFirestore(
    BuildContext context, String nickName) async {
  if (nickName.isEmpty) {
    snackBar(context, 'Input nick name!');
  } else {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    String? userID = FirebaseAuth.instance.currentUser?.uid;
    try {
      final FirebaseFirestore fireStore = FirebaseFirestore.instance;
      fireStore.collection('users').doc(userID).set({
        'uid': userID,
        'email': userEmail,
        'user_name': nickName,
        'avatar_link': '',
        'count_image' : 0,
        'name' : '',
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
