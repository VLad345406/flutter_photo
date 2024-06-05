import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/mobile/auth/mobile_google_sigh_in_registration_data.dart';
import 'package:flutter_qualification_work/screens/mobile/main/main_screen.dart';
import 'package:flutter_qualification_work/screens/web/main/web_main_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    _checkDataInDatabase(context);
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
