import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/screens/auth/wait_accept_email_page.dart';
import 'package:flutter_qualification_work/screens/main/main_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future signIn() async {
    if (emailController.text == '' || passwordController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Input email and password!"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      try {
        setState(() {
          const Center(child: CircularProgressIndicator());
        });
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return WaitAcceptEmailPage();
        }), (route) => false);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

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
            // function: signIn,
            function: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MainScreen();
                  },
                ),
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
          //Google auth button
          /*Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              child: IconButton(
                icon: Image.asset('assets/login_screen/Google.png'),
                onPressed: () {},
                */ /*onPressed: ()async {
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
                },*/ /*
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
