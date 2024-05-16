import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/services/authentication/registration_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final emailController = TextEditingController();
  final nickNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
            buttonMargin: EdgeInsets.only(left: 16, top: 16),
            buttonText: 'NEXT',
            textColor: Colors.white,
            buttonColor: Colors.black,
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
