import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/auth/start_screen.dart';
import 'package:flutter_qualification_work/screens/main/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class WaitAcceptEmailPage extends StatefulWidget {
  const WaitAcceptEmailPage({super.key});

  @override
  State<WaitAcceptEmailPage> createState() => _WaitAcceptEmailPageState();
}

class _WaitAcceptEmailPageState extends State<WaitAcceptEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      snackBar(e.toString());
    }
  }

  void snackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? MainScreen()
      : Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Center(
                  child: Text(
                    'We have sent you a confirmation email\n'
                    'to the email address you provided.\n'
                    'Please confirm your e-mail address!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              //resent email button
              Container(
                height: 60,
                //width: screenWidth - 32,
                margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  color: Colors.black,
                ),
                child: TextButton(
                  onPressed: sendVerificationEmail,
                  child: Text(
                    'Resent Email',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              //cansel button
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextButton(
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.signOut();
                    } catch (e) {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return StartScreen();
                      }), (route) => false);
                    }
                  },
                  child: const Text(
                    'Cansel',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        );
}
