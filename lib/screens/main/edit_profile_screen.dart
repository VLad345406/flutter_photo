import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/screens/auth/start_screen.dart';
import 'package:flutter_qualification_work/services/change_password_service.dart';
import 'package:flutter_qualification_work/services/image_picker_service.dart';
import 'package:flutter_qualification_work/services/remove_account_service.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io' show Platform;

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String userName = '';
  String userAvatarLink = '';

  Future<void> getUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final data =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    setState(() {
      userName = data['user_name'];
      userAvatarLink = data['image_link'];
      nicknameController.text = userName;
      emailController.text = data['email'];
    });
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    uploadImageToStorage(userName, image);
    await saveData(FirebaseAuth.instance.currentUser!.email.toString(),
        FirebaseAuth.instance.currentUser!.uid.toString(), userName, image);
    getUserData();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

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
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: GestureDetector(
                    onTap: selectImage,
                    child: PhotoUserAvatar(
                      userAvatarLink: userAvatarLink,
                      radius: 64,
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
              PhotoButton(
                widthButton: screenWidth - 32,
                buttonMargin:
                    const EdgeInsets.only(top: 16, left: 16, right: 16),
                buttonText: 'SAVE',
                textColor: Colors.white,
                buttonColor: Colors.black,
                function: () {
                  snackBar(context, 'Success save!');
                  //Navigator.pop(context);
                },
              ),
              PhotoTextField(
                controller: emailController,
                showVisibleButton: false,
                label: 'Email',
              ),
              PhotoButton(
                widthButton: screenWidth - 32,
                buttonMargin:
                    const EdgeInsets.only(top: 16, left: 16, right: 16),
                buttonText: 'SAVE EMAIL',
                textColor: Colors.white,
                buttonColor: Colors.black,
                function: () {
                  snackBar(context, 'Success save!');
                  //Navigator.pop(context);
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Text(
                  'Password (if use alternative sigh in method write name this method. For example "Google")',
                  style: GoogleFonts.comfortaa(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              PhotoTextField(
                controller: oldPasswordController,
                showVisibleButton: true,
                label: 'Old password',
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
                buttonMargin:
                    const EdgeInsets.only(top: 16, left: 16, right: 16),
                buttonText: 'SAVE PASSWORD',
                textColor: Colors.white,
                buttonColor: Colors.black,
                function: () {
                  changePassword(context, oldPasswordController.text,
                      passwordController.text, confirmPasswordController.text);
                  //snackBar(context, 'Success save!');
                  //Navigator.pop(context);
                },
              ),
              PhotoButton(
                widthButton: screenWidth - 32,
                buttonMargin:
                    const EdgeInsets.only(top: 16, left: 16, right: 16),
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
              Padding(
                padding: EdgeInsets.only(
                  bottom: Platform.isIOS ? 0 : 16,
                ),
                child: PhotoButton(
                  widthButton: screenWidth - 32,
                  buttonMargin:
                      const EdgeInsets.only(top: 16, left: 16, right: 16),
                  buttonText: 'REMOVE ACCOUNT',
                  textColor: Colors.red,
                  buttonColor: Colors.white,
                  function: () {
                    removeAccount(context);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
