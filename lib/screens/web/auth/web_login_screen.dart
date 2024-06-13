import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/localization/locales.dart';
import 'package:flutter_qualification_work/screens/mobile/auth/mobile_restore_screen.dart';
import 'package:flutter_qualification_work/screens/web/auth/web_restore_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';
import 'package:flutter_qualification_work/services/authentication/google_sigh_in_service.dart';
import 'package:flutter_qualification_work/services/authentication/login_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
                LocaleData.login.getString(context)[0].toUpperCase() +
                    LocaleData.login
                        .getString(context)
                        .substring(1)
                        .toLowerCase(),
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
                  label: LocaleData.password.getString(context),
                  disableSpace: true,
                  disableUppercase: false,
                ),
              ),
              PhotoButton(
                widthButton: 370,
                buttonMargin: EdgeInsets.only(top: 18),
                buttonText: LocaleData.login.getString(context),
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
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: RichText(
                  text: TextSpan(
                    text: LocaleData.forgotPassword.getString(context),
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
                                  builder: (context) => ResponsiveLayout(
                                    mobileScaffold: MobileRestoreScreen(),
                                    webScaffold: WebRestoreScreen(),
                                  ),
                                ),
                              ),
                        text: LocaleData.restore.getString(context),
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
                  LocaleData.continueWith.getString(context),
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
        ),
      ),
    );
  }
}
