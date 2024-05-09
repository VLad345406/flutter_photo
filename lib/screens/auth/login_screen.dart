import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
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
          Container(
            margin: const EdgeInsets.only(left: 16, top: 32.65, bottom: 32),
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
                    /*onPressed: ()async {
                      final FirebaseAuth auth;

                      GoogleSignIn _googleSignIn = GoogleSignIn();

                      //@override
                      //Future<User?> signUpWithGoogle() async {

                      GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();

                      GoogleSignInAccount googleSignInAccount = _googleSignInAccount!;

                      GoogleSignInAuthentication googleSignInAuthentication =
                          await googleSignInAccount.authentication;

                      AuthCredential authCredential = GoogleAuthProvider.credential(
                          idToken: googleSignInAuthentication.idToken,
                          accessToken: googleSignInAuthentication.accessToken);

                      UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(authCredential);
                      User user = authResult.user!;

                      //return user;
                      //}

                      //Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
                    },*/
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
