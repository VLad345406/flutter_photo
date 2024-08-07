import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/localization/locales.dart';
import 'package:flutter_qualification_work/screens/web/auth/web_start_screen.dart';
import 'package:flutter_qualification_work/services/change_password_service.dart';
import 'package:flutter_qualification_work/services/image_picker_service.dart';
import 'package:flutter_qualification_work/services/remove_account_service.dart';
import 'package:flutter_qualification_work/services/remove_picture_service.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:flutter_qualification_work/services/validate_username_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class WebEditScreen extends StatefulWidget {
  const WebEditScreen({super.key});

  @override
  State<WebEditScreen> createState() => _WebEditScreenState();
}

class _WebEditScreenState extends State<WebEditScreen> {
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

  void _setLocale(String? value) {
    if (value == null) return;
    if (value == 'en') {
      FlutterLocalization.instance.translate('en');
    } else if (value == 'uk') {
      FlutterLocalization.instance.translate('uk');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          LocaleData.settings.getString(context),
          style: GoogleFonts.comfortaa(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Text(
                      LocaleData.language.getString(context),
                      style: GoogleFonts.comfortaa(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: DropdownButton(
                      value: FlutterLocalization
                          .instance.currentLocale!.languageCode,
                      items: [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'uk',
                          child: Text('Українська'),
                        ),
                      ],
                      onChanged: (value) {
                        _setLocale(value);
                      },
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    LocaleData.changeAvatar.getString(context).toUpperCase(),
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
                  userAvatarLink.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(left: 100),
                          child: IconButton(
                            onPressed: () async {
                              String result = await removePictureService(
                                'pictures/$userName/avatar',
                                'avatar',
                              );
                              if (result == 'Success') {
                                getUserData();
                                snackBar(context, 'Success remove file!');
                              } else {
                                snackBar(context, 'Fail remove file!');
                              }
                            },
                            icon: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              PhotoTextField(
                controller: nameController,
                showVisibleButton: false,
                label: LocaleData.name.getString(context),
                disableSpace: false,
                disableUppercase: false,
              ),
              PhotoTextField(
                controller: nicknameController,
                showVisibleButton: false,
                label: LocaleData.nickName.getString(context),
                disableSpace: true,
                disableUppercase: true,
              ),
              PhotoButton(
                widthButton: screenWidth - 32,
                buttonMargin:
                    const EdgeInsets.only(top: 16, left: 16, right: 16),
                buttonText: LocaleData.save.getString(context).toUpperCase(),
                textColor: Theme.of(context).colorScheme.secondary,
                buttonColor: Theme.of(context).colorScheme.primary,
                function: () {
                  saveData();
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
                buttonText:
                    '${LocaleData.save.getString(context).toUpperCase()} EMAIL',
                textColor: Theme.of(context).colorScheme.secondary,
                buttonColor: Theme.of(context).colorScheme.primary,
                function: () {
                  snackBar(context, 'Success save!');
                  //Navigator.pop(context);
                },
              ),
              PhotoTextField(
                controller: oldPasswordController,
                showVisibleButton: true,
                label: LocaleData.oldPassword.getString(context),
                disableSpace: true,
                disableUppercase: false,
              ),
              PhotoTextField(
                controller: passwordController,
                showVisibleButton: true,
                label: LocaleData.password.getString(context),
                disableSpace: true,
                disableUppercase: false,
              ),
              //password text-field
              PhotoTextField(
                controller: confirmPasswordController,
                showVisibleButton: true,
                label: LocaleData.confirmPassword.getString(context),
                disableSpace: true,
                disableUppercase: false,
              ),
              PhotoButton(
                widthButton: screenWidth - 32,
                buttonMargin:
                    const EdgeInsets.only(top: 16, left: 16, right: 16),
                buttonText: LocaleData.save.getString(context).toUpperCase() +
                    ' ' +
                    LocaleData.password.getString(context).toUpperCase(),
                textColor: Theme.of(context).colorScheme.secondary,
                buttonColor: Theme.of(context).colorScheme.primary,
                function: () {
                  changePassword(context, oldPasswordController.text,
                      passwordController.text, confirmPasswordController.text);
                },
              ),
              PhotoButton(
                widthButton: screenWidth - 32,
                buttonMargin:
                    const EdgeInsets.only(top: 16, left: 16, right: 16),
                buttonText: LocaleData.exit.getString(context).toUpperCase(),
                textColor: Colors.red,
                buttonColor: Theme.of(context).colorScheme.secondary,
                function: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return WebStartScreen();
                  }), (route) => false);
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 16,
                ),
                child: PhotoButton(
                  widthButton: screenWidth - 32,
                  buttonMargin:
                      const EdgeInsets.only(top: 16, left: 16, right: 16),
                  buttonText:
                      LocaleData.removeAccount.getString(context).toUpperCase(),
                  textColor: Colors.red,
                  buttonColor: Theme.of(context).colorScheme.secondary,
                  function: () {
                    removeAccount(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
