import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/services/authentication/registration_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileRegistrationScreen extends StatefulWidget {
  const MobileRegistrationScreen({super.key});

  @override
  State<MobileRegistrationScreen> createState() => _MobileRegistrationScreenState();
}

class _MobileRegistrationScreenState extends State<MobileRegistrationScreen> {
  final emailController = TextEditingController();
  final nickNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
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
      body: ListView(
        primary: false,
        shrinkWrap: true,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //header text
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              top: 32.65,
              bottom: 16,
            ),
            child: Text(
              'Register',
              style: GoogleFonts.comfortaa(
                color: Theme.of(context).colorScheme.primary,
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
            disableSpace: true,
            disableUppercase: false,
          ),
          //email text-field
          PhotoTextField(
            controller: nickNameController,
            showVisibleButton: false,
            label: 'Nick name',
            disableSpace: true,
            disableUppercase: true,
          ),
          //password text-field
          PhotoTextField(
            controller: passwordController,
            showVisibleButton: true,
            label: 'Password',
            disableSpace: true,
            disableUppercase: false,
          ),
          //password text-field
          PhotoTextField(
            controller: confirmPasswordController,
            showVisibleButton: true,
            label: 'Confirm password',
            disableSpace: true,
            disableUppercase: false,
          ),
          //registration button
          PhotoButton(
            widthButton: screenWidth - 32,
            buttonMargin: EdgeInsets.only(left: 16, top: 16, right: 16),
            buttonText: 'NEXT',
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
    );
  }
}
