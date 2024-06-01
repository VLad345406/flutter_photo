import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/auth/google_sigh_in_registration_data.dart';
import 'package:flutter_qualification_work/screens/main/main_screen.dart';
import 'package:flutter_qualification_work/services/check_internet_service.dart';

class SnapshotHasDataPage extends StatelessWidget {
  const SnapshotHasDataPage({super.key});

  Future _checkDataInDatabase(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final data =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();
    try {
      if (data['uid'] == userId) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            //builder: (context) => CheckInternet(widget: MainScreen()),
            builder: (context) => MainScreen(),
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
  }

  @override
  Widget build(BuildContext context) {
    _checkDataInDatabase(context);
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
