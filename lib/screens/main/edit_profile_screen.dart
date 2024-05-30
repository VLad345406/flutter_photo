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
import 'package:flutter_qualification_work/services/remove_picture_service.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:flutter_qualification_work/services/validate_username_service.dart';
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
      userAvatarLink = data['avatar_link'];
      nicknameController.text = userName;
      emailController.text = data['email'];
      nameController.text = data['name'];
    });
  }

  void selectAvatar() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    uploadImageToStorage(userName, 'avatar', image);
    await saveAvatar(FirebaseAuth.instance.currentUser!.email.toString(),
        FirebaseAuth.instance.currentUser!.uid.toString(), userName, image);
    getUserData();
    snackBar(context, 'Success avatar change!');
  }

  void saveData() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    try {
      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid);
      final data = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (nicknameController.text == data['user_name']) {
        await userRef
            .set({'name': nameController.text}, SetOptions(merge: true));
        snackBar(context, 'Success add name!');
      } else {
        if (!await validateUsername(nicknameController.text)) {
          await userRef.set(
              {'user_name': nicknameController.text}, SetOptions(merge: true));
          snackBar(context, 'Success add nick name!');
        } else {
          snackBar(context, 'That nick name is already exist!');
        }
      }
    } catch (e) {
      snackBar(context, 'Error add name!');
    }
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
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
        title: Text(
          'Edit profile',
          style: GoogleFonts.comfortaa(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
        ),
        //actions: [IconButton(onPressed: () {}, icon: Icon(Icons.light_mode))],
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'CHANGE AVATAR',
                    style: GoogleFonts.roboto(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Stack(
                alignment: AlignmentDirectional.topCenter,
                fit: StackFit.loose,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: GestureDetector(
                        onTap: selectAvatar,
                        child: PhotoUserAvatar(
                          userAvatarLink: userAvatarLink,
                          radius: 64,
                        ),
                      ),
                    ),
                  ),
                  userAvatarLink.isNotEmpty ? Padding(
                    padding:
                    const EdgeInsets.only(left: 100),
                    child: IconButton(
                      onPressed: () async {
                        String result = await removePictureService(
                          'pictures/$userName/avatar',
                          'avatar',
                        );
                        if (result == 'Success') {
                          getUserData();
                          snackBar(context, 'Success remove file!');
                        }
                        else {
                          snackBar(context, 'Fail remove file!');
                        }
                      },
                      icon: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                    ),
                  ) : Container(),
                ],
              ),
              PhotoTextField(
                controller: nameController,
                showVisibleButton: false,
                label: 'Name',
                disableSpace: false,
                disableUppercase: false,
              ),
              PhotoTextField(
                controller: nicknameController,
                showVisibleButton: false,
                label: 'Nick name',
                disableSpace: true,
                disableUppercase: true,
              ),
              PhotoButton(
                widthButton: screenWidth - 32,
                buttonMargin:
                    const EdgeInsets.only(top: 16, left: 16, right: 16),
                buttonText: 'SAVE',
                textColor: Theme.of(context).colorScheme.secondary,
                buttonColor: Theme.of(context).colorScheme.primary,
                function: () {
                  saveData();
                  //snackBar(context, 'Success save!');
                  //Navigator.pop(context);
                },
              ),
              PhotoTextField(
                controller: emailController,
                showVisibleButton: false,
                label: 'Email',
                disableSpace: true,
                disableUppercase: false,
              ),
              PhotoButton(
                widthButton: screenWidth - 32,
                buttonMargin:
                    const EdgeInsets.only(top: 16, left: 16, right: 16),
                buttonText: 'SAVE EMAIL',
                textColor: Theme.of(context).colorScheme.secondary,
                buttonColor: Theme.of(context).colorScheme.primary,
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
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              PhotoTextField(
                controller: oldPasswordController,
                showVisibleButton: true,
                label: 'Old password',
                disableSpace: true,
                disableUppercase: false,
              ),
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
              PhotoButton(
                widthButton: screenWidth - 32,
                buttonMargin:
                    const EdgeInsets.only(top: 16, left: 16, right: 16),
                buttonText: 'SAVE PASSWORD',
                textColor: Theme.of(context).colorScheme.secondary,
                buttonColor: Theme.of(context).colorScheme.primary,
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
                buttonColor: Theme.of(context).colorScheme.secondary,
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
                  buttonColor: Theme.of(context).colorScheme.secondary,
                  function: () {
                    removeAccount(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
