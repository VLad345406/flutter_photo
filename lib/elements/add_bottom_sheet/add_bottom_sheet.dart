import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qualification_work/elements/add_bottom_sheet/add_bottom_sheet_button.dart';
import 'package:flutter_qualification_work/services/image_picker_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:io' show Platform;

class ShowAddBottomSheet {
  String _userName = '';
  int _countImage = 0;

  void selectGalleryImage(BuildContext context) async {
    try {
      Uint8List image = await pickImage(ImageSource.gallery);
      await getUserData();
      uploadImageToStorage(_userName, (_countImage + 1).toString(), image);
      await savePictureInFirestore(FirebaseAuth.instance.currentUser!.uid.toString(),
          _userName, image, _countImage + 1);
      //snackBar(context, 'Success add picture!');
    } catch (e) {
      //snackBar(context, 'Something wen`t wrong!');
    }
  }

  void addCameraImage(BuildContext context) async {
    try {
      Uint8List image = await pickImage(ImageSource.camera);
      await getUserData();
      uploadImageToStorage(_userName, (_countImage + 1).toString(), image);
      await savePictureInFirestore(FirebaseAuth.instance.currentUser!.uid.toString(),
          _userName, image, _countImage + 1);
      //snackBar(context, 'Success add picture!');
    } catch (e) {
      //snackBar(context, 'Something wen`t wrong!');
    }
  }

  Future<void> getUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final data =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    _userName = data['user_name'];
    _countImage = data['count_image'];
  }

  void showAddBottomSheet(BuildContext context, double widthButton) {
    showMaterialModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => SizedBox(
        height: kIsWeb ? 250 : Platform.isIOS ? 250 : 230,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16, top: 16),
              child: Text(
                'Add content',
                style: GoogleFonts.comfortaa(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 16,
                        right: 9,
                      ),
                      child: AddBottomSheetButton(
                        function: () {
                          addCameraImage(context);
                          Navigator.pop(context);
                        },
                        swgLink: 'assets/icons/camera.svg',
                        buttonText: 'Picture (Camera)',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: AddBottomSheetButton(
                        function: () {
                          selectGalleryImage(context);
                          Navigator.pop(context);
                        },
                        swgLink: 'assets/icons/gallery.svg',
                        buttonText: 'Picture (Gallery)',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 16,
                        right: 9,
                      ),
                      child: AddBottomSheetButton(
                        function: () {
                          //addCameraImage(context);
                          Navigator.pop(context);
                        },
                        swgLink: 'assets/icons/music.svg',
                        buttonText: 'Music',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: AddBottomSheetButton(
                        function: () {
                          //selectGalleryImage(context);
                          Navigator.pop(context);
                        },
                        swgLink: 'assets/icons/video.svg',
                        buttonText: 'Video',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
