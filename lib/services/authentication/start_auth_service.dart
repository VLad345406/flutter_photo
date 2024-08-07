import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/mobile/auth/mobile_start_screen.dart';
import 'package:flutter_qualification_work/screens/web/auth/web_start_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';
import 'package:flutter_qualification_work/services/authentication/snapshot_has_data_page.dart';

class StartAuthService {
  handleAuthState() {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          } else if (snapshot.hasData) {
            return SnapshotHasDataPage();
          } else {
            return kIsWeb
                ? ResponsiveLayout(
                    mobileScaffold: MobileStartScreen(),
                    webScaffold: WebStartScreen(),
                  )
                : MobileStartScreen();
          }
        },
      ),
    );
  }
}
