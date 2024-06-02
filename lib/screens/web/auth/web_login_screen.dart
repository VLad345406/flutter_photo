import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/screens/mobile/auth/mobile_google_sigh_in_registration_data.dart';
import 'package:flutter_qualification_work/screens/mobile/main/main_screen.dart';
import 'package:flutter_qualification_work/screens/web/auth/web_restore_screen.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WebLoginScreen extends StatefulWidget {
  const WebLoginScreen({super.key});

  @override
  State<WebLoginScreen> createState() => _WebLoginScreenState();
}

class _WebLoginScreenState extends State<WebLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Center(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Log in',
                style: GoogleFonts.comfortaa(
                  fontSize: 90,
                ),
              ),
              SizedBox(
                width: 400,
                child: PhotoTextField(
                  controller: emailController,
                  showVisibleButton: false,
                  label: 'Email',
                  disableSpace: true,
                  disableUppercase: true,
                ),
              ),
              SizedBox(
                width: 400,
                child: PhotoTextField(
                  controller: passwordController,
                  showVisibleButton: true,
                  label: 'Password',
                  disableSpace: true,
                  disableUppercase: false,
                ),
              ),
              PhotoButton(
                widthButton: 370,
                buttonMargin: EdgeInsets.only(top: 18),
                buttonText: 'LOGIN',
                textColor: Theme.of(context).colorScheme.secondary,
                buttonColor: Theme.of(context).colorScheme.primary,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: RichText(
                  text: TextSpan(
                    text: 'Forgot password? ',
                    style: GoogleFonts.roboto(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebRestoreScreen(),
                            ),
                          ),
                        text: 'Restore',
                        style: GoogleFonts.roboto(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18),
                child: Text(
                  'Continue with:',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
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
                        /*onPressed: (){},*/
                        onPressed: () async {
                          try {
                            final googleAccount = await GoogleSignIn().signIn();

                            final googleAuth = await googleAccount?.authentication;

                            final credential = GoogleAuthProvider.credential(
                              accessToken: googleAuth?.accessToken,
                              idToken: googleAuth?.idToken,
                            );

                            await FirebaseAuth.instance
                                .signInWithCredential(credential);

                            if (mounted) {
                              final userId = FirebaseAuth.instance.currentUser!.uid;
                              final data = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .get();
                              try {
                                if (data['uid'] == userId) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => MainScreen(),
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          GoogleSighInRegistrationData(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GoogleSighInRegistrationData(),
                                  ),
                                );
                              }
                            }
                          } on FirebaseAuthException catch (e) {
                            snackBar(context, e.message.toString());
                            print(e.message);
                          }
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
        ),
      ),
    );
  }
}
