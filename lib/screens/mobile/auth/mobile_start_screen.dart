import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/localization/locales.dart';
import 'package:flutter_qualification_work/screens/mobile/auth/mobile_login_screen.dart';
import 'package:flutter_qualification_work/screens/mobile/auth/mobile_registration_screen.dart';
import 'package:flutter_qualification_work/screens/web/auth/web_login_screen.dart';
import 'package:flutter_qualification_work/screens/web/auth/web_registration_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';

class MobileStartScreen extends StatefulWidget {
  const MobileStartScreen({super.key});

  @override
  State<MobileStartScreen> createState() => _MobileStartScreenState();
}

class _MobileStartScreenState extends State<MobileStartScreen> {
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
                  'assets/images/start_background_mobile.jpg',
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
                buttonMargin:
                    const EdgeInsets.only(top: 20, left: 16, right: 9),
                buttonText: LocaleData.login.getString(context),
                textColor: Colors.black,
                buttonColor: Colors.white,
                function: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return kIsWeb
                            ? ResponsiveLayout(
                                mobileScaffold: MobileLoginScreen(),
                                webScaffold: WebLoginScreen(),
                              )
                            : MobileLoginScreen();
                      },
                    ),
                  );
                },
              ),
              PhotoButton(
                widthButton: widthButton,
                buttonMargin: const EdgeInsets.only(top: 20),
                buttonText: LocaleData.register.getString(context),
                textColor: Colors.white,
                buttonColor: Colors.black,
                function: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return kIsWeb
                            ? ResponsiveLayout(
                                mobileScaffold: MobileRegistrationScreen(),
                                webScaffold: WebRegistrationScreen())
                            : MobileRegistrationScreen();
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
