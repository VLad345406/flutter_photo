import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/screens/auth/restore_screen.dart';
import 'package:flutter_qualification_work/screens/main/main_screen.dart';
import 'package:flutter_qualification_work/services/authentication/login_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/back_arrow.svg',
            width: 12.21,
            height: 11.35,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 32.65, bottom: 32),
            child: Text(
              'Log in',
              style: GoogleFonts.comfortaa(
                color: Colors.black,
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
          ),
          //password text-field
          PhotoTextField(
            controller: passwordController,
            showVisibleButton: true,
            label: 'Password',
          ),
          //login button
          PhotoButton(
            widthButton: screenWidth - 32,
            buttonMargin: const EdgeInsets.only(left: 16, top: 16),
            buttonText: 'LOG IN',
            textColor: Colors.white,
            buttonColor: Colors.black,
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
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RestoreScreen(),
                              ),
                            ),
                      //..onTap = () => navigatorPush(context, const RestorePage()),
                      text: 'Restore',
                      style: GoogleFonts.roboto(
                        color: Colors.black,
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
                  color: Colors.black,
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => MainScreen(),
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        print(e.message);
                      }
                    },
                  ),
                ),
              ),
              //Facebook auth button
              SizedBox(
                height: 70,
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: IconButton(
                    icon: Image.asset('assets/login_screen/Facebook.png'),
                    onPressed: () {},
                  ),
                ),
              ),
              //Apple auth button
              SizedBox(
                height: 65,
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: IconButton(
                    icon: Image.asset('assets/login_screen/Apple.png'),
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
