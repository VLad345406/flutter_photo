import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/localization/locales.dart';
import 'package:flutter_qualification_work/services/authentication/registration_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WebRegistrationScreen extends StatefulWidget {
  const WebRegistrationScreen({super.key});

  @override
  State<WebRegistrationScreen> createState() => _WebRegistrationScreenState();
}

class _WebRegistrationScreenState extends State<WebRegistrationScreen> {
  final emailController = TextEditingController();
  final nickNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                LocaleData.register.getString(context)[0].toUpperCase() +
                    LocaleData.register
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
                  controller: nickNameController,
                  showVisibleButton: false,
                  label: LocaleData.nickName.getString(context),
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
              SizedBox(
                width: 400,
                child: PhotoTextField(
                  controller: confirmPasswordController,
                  showVisibleButton: true,
                  label: LocaleData.confirmPassword.getString(context),
                  disableSpace: true,
                  disableUppercase: false,
                ),
              ),
              PhotoButton(
                widthButton: 370,
                buttonMargin: EdgeInsets.only(top: 18),
                buttonText: LocaleData.register.getString(context),
                textColor: Theme.of(context).colorScheme.secondary,
                buttonColor: Theme.of(context).colorScheme.primary,
                function: () {
                  registration(
                    context,
                    emailController.text,
                    nickNameController.text,
                    passwordController.text,
                    confirmPasswordController.text,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
