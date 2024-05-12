import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/screens/auth/start_screen.dart';
import 'package:flutter_qualification_work/services/remove_account_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        title: Text(
          'Edit profile',
          style: GoogleFonts.comfortaa(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'CHANGE AVATAR',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 16),
                  child: GestureDetector(
                    onTap: () {
                      print("Change avatar");
                    },
                    child: CircleAvatar(
                      radius: 64,
                      backgroundImage: AssetImage("assets/images/avatar1.jpg"),
                    ),
                  ),
                ),
              ),
              PhotoTextField(
                controller: nameController,
                showVisibleButton: false,
                label: 'Name',
              ),
              PhotoTextField(
                controller: nicknameController,
                showVisibleButton: false,
                label: 'Nick name',
              ),
              PhotoTextField(
                controller: emailController,
                showVisibleButton: false,
                label: 'Email',
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, left: 16),
                child: Text(
                  'Password',
                  style: GoogleFonts.comfortaa(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              PhotoTextField(
                controller: passwordController,
                showVisibleButton: true,
                label: 'Password',
              ),
              //password text-field
              PhotoTextField(
                controller: confirmPasswordController,
                showVisibleButton: true,
                label: 'Confirm password',
              ),
              PhotoButton(
                widthButton: screenWidth - 32,
                buttonMargin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                buttonText: 'SAVE',
                textColor: Colors.white,
                buttonColor: Colors.black,
                function: () {
                  Navigator.pop(context);
                },
              ),
              PhotoButton(
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
              ),
            ],
          );
        }
      ),
    );
  }
}
