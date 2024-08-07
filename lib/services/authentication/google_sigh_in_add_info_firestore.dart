import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/mobile/main/main_screen.dart';
import 'package:flutter_qualification_work/screens/web/main/web_main_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';
import 'package:flutter_qualification_work/services/check_internet_service.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:flutter_qualification_work/services/validate_username_service.dart';

Future googleSighInAddInfoFirestore(
    BuildContext context, String nickName) async {
  if (nickName.isEmpty) {
    snackBar(context, 'Input nick name!');
  } else {
    if (!await validateUsername(nickName)) {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      String? userID = FirebaseAuth.instance.currentUser?.uid;
      try {
        final FirebaseFirestore fireStore = FirebaseFirestore.instance;
        fireStore.collection('users').doc(userID).set({
          'uid': userID,
          'email': userEmail,
          'user_name': nickName,
          'avatar_link': '',
          'count_image': 0,
          'name': '',
        }, SetOptions(merge: true));
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          //return CheckInternet(widget: MainScreen());
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
    } else {
      snackBar(context, 'That nick name is already exist!');
    }
  }
}
