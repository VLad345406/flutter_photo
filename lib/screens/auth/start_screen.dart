import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/screens/auth/login.dart';
import 'package:flutter_qualification_work/screens/auth/registration.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    //get screen ppi
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final widthButton = (screenWidth - 32 - 9) / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: screenHeight - 100,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/start_background.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Image.asset('assets/images/logo.png'),
          ),
          Row(
            children: [
              PhotoButton(
                widthButton: widthButton,
                buttonMargin: const EdgeInsets.only(top: 20, left: 16, right: 9),
                buttonText: 'LOG IN',
                textColor: Colors.black,
                buttonColor: Colors.white,
                function: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
              PhotoButton(
                widthButton: widthButton,
                buttonMargin: const EdgeInsets.only(top: 20),
                buttonText: 'REGISTER',
                textColor: Colors.white,
                buttonColor: Colors.black,
                function: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RegistrationScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
