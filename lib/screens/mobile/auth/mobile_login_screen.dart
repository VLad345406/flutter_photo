import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/screens/mobile/auth/mobile_restore_screen.dart';
import 'package:flutter_qualification_work/screens/mobile/main/main_screen.dart';
import 'package:flutter_qualification_work/services/authentication/google_sigh_in_service.dart';
import 'package:flutter_qualification_work/services/authentication/login_service.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'mobile_google_sigh_in_registration_data.dart';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/back_arrow.svg',
            width: 12.21,
            height: 11.35,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: ListView(
        primary: false,
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 32.65, bottom: 32),
            child: Text(
              'Log in',
              style: GoogleFonts.comfortaa(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 36,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          //email text-field
          PhotoTextField(
            controller: emailController,
            showVisibleButton: false,
            label: 'Email',
            disableSpace: true,
            disableUppercase: false,
          ),
          //password text-field
          PhotoTextField(
            controller: passwordController,
            showVisibleButton: true,
            label: 'Password',
            disableSpace: true,
            disableUppercase: false,
          ),
          //login button
          PhotoButton(
            widthButton: screenWidth - 32,
            buttonMargin: const EdgeInsets.only(left: 16, top: 16, right: 16),
            buttonText: 'LOG IN',
            textColor: Theme.of(context).colorScheme.secondary,
            buttonColor: Theme.of(context).colorScheme.primary,
            function: () {
              signIn(
                context,
                emailController.text,
                passwordController.text,
              );
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: RichText(
                text: TextSpan(
                  text: 'Forgot password? ',
                  style: GoogleFonts.roboto(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MobileRestoreScreen(),
                              ),
                            ),
                      text: 'Restore',
                      style: GoogleFonts.roboto(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //continue with text
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              child: Text(
                'Continue with:',
                style: GoogleFonts.roboto(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Google auth button
              SizedBox(
                height: 65,
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: IconButton(
                    icon: Image.asset('assets/login_screen/Google.png'),
                    onPressed: () {
                      googleSighInService(context);
                    },
                  ),
                ),
              ),
              //Apple auth button
              SizedBox(
                height: 65,
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: IconButton(
                    icon: Image.asset(
                      'assets/login_screen/Apple.png',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
