import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeaderBuilder extends StatefulWidget {
  final String mode;

  const ProfileHeaderBuilder({Key? key, required this.mode}) : super(key: key);

  @override
  State<ProfileHeaderBuilder> createState() => _ProfileHeaderBuilder();
}

class _ProfileHeaderBuilder extends State<ProfileHeaderBuilder> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (widget.mode == 'individual') {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 32),
            child: CircleAvatar(
              radius: 64,
              backgroundImage: AssetImage("assets/images/avatar1.jpg"),
            ),
          ),
          /*Center(
            child: Container(
              padding: EdgeInsets.only(top: 32),
              child: Text(
                'Tom',
                style: GoogleFonts.comfortaa(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),*/
          Center(
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: "@TomProfile1"));
                snackBar(context, 'Success copied!');
                if (kDebugMode) {
                  print("success copied");
                }
              },
              child: Container(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  '@TomProfile1',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          /*Center(
            child: Container(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                "SAN FRANCISCO, CA",
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),*/
          /*PhotoButton(
            widthButton: screenWidth - 32,
            buttonMargin: const EdgeInsets.only(top: 32, left: 16, right: 16),
            buttonText: 'EDIT PROFILE',
            textColor: Colors.black,
            buttonColor: Colors.white,
            function: () {
              Navigator.pushNamed(context, '/edit_profile');
            },
          ),*/
          /*PhotoButton(
            widthButton: screenWidth - 32,
            buttonMargin: const EdgeInsets.only(top: 16, left: 16, right: 16),
            buttonText: 'EXIT PROFILE',
            textColor: Colors.red,
            buttonColor: Colors.white,
            function: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return StartScreen();
              }), (route) => false);
            },
          ),
          PhotoButton(
            widthButton: screenWidth - 32,
            buttonMargin: const EdgeInsets.only(top: 16, left: 16, right: 16),
            buttonText: 'REMOVE ACCOUNT',
            textColor: Colors.red,
            buttonColor: Colors.white,
            function: () {
              removeAccount(context);
            },
          ),*/
        ],
      );
    } else {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 32),
            child: CircleAvatar(
              radius: 64,
              backgroundImage: AssetImage("assets/images/avatar1.jpg"),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 32),
              child: Text(
                'Tom',
                style: GoogleFonts.comfortaa(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: "@TomProfile1"));
                print("success copied");
              },
              child: Container(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  '@TomProfile1',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                "SAN FRANCISCO, CA",
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
          PhotoButton(
            widthButton: screenWidth - 32,
            buttonMargin: const EdgeInsets.only(top: 32, left: 16, right: 16),
            buttonText: 'FOLLOW',
            textColor: Colors.white,
            buttonColor: Colors.black,
          ),
          PhotoButton(
            widthButton: screenWidth - 32,
            buttonMargin: const EdgeInsets.only(top: 16, left: 16, right: 16),
            buttonText: 'MESSAGE',
            textColor: Colors.black,
            buttonColor: Colors.white,
          ),
        ],
      );
    }
  }
}
