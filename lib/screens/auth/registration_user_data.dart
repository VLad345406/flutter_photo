import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/main/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationUserDataScreen extends StatefulWidget {
  const RegistrationUserDataScreen({super.key});

  @override
  State<RegistrationUserDataScreen> createState() =>
      _RegistrationUserDataScreenState();
}

class _RegistrationUserDataScreenState
    extends State<RegistrationUserDataScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        /*leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/back_arrow.svg',
            width: 12.21,
            height: 11.35,
          ),
        ),*/
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16, top: 32.65),
            child: Text(
              'Register',
              style: GoogleFonts.comfortaa(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          //nick TextFormField
          Padding(
            padding: const EdgeInsets.only(
              top: 32,
              left: 16,
              right: 16,
            ),
            child: TextFormField(
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                decoration: TextDecoration.none,
              ),
              decoration: const InputDecoration(
                labelText: 'Nick name',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(
                    width: 2,
                  ),
                ),
              ),
              textInputAction: TextInputAction.next,
            ),
          ),
          //real name TextFormField
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
            ),
            child: TextFormField(
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                decoration: TextDecoration.none,
              ),
              decoration: const InputDecoration(
                labelText: 'Real name (optional)',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(
                    width: 2,
                  ),
                ),
              ),
              textInputAction: TextInputAction.next,
            ),
          ),
          //sing up button
          Container(
            width: screenWidth - 32,
            height: 52,
            margin: const EdgeInsets.only(left: 16, top: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(width: 2),
              color: Colors.black,
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return MainScreen();
                }), (route) => false);
              },
              child: Text(
                'SIGN UP',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
