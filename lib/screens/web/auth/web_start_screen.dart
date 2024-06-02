import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/screens/web/auth/web_login_screen.dart';
import 'package:flutter_qualification_work/screens/web/auth/web_registration_screen.dart';

class WebStartScreen extends StatefulWidget {
  const WebStartScreen({super.key});

  @override
  State<WebStartScreen> createState() => _WebStartScreenState();
}

class _WebStartScreenState extends State<WebStartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/start_background_web.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            //child: Image.asset('assets/images/logo.png'),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png'),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 52),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PhotoButton(
                      widthButton: 257,
                      buttonMargin: const EdgeInsets.only(),
                      buttonText: 'LOG IN',
                      textColor: Colors.black,
                      buttonColor: Colors.white,
                      function: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebLoginScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 74,
                    ),
                    PhotoButton(
                      widthButton: 257,
                      buttonMargin: const EdgeInsets.only(),
                      buttonText: 'REGISTER',
                      textColor: Colors.white,
                      buttonColor: Colors.black,
                      function: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebRegistrationScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}