import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/elements/add_bottom_sheet/add_bottom_sheet_button.dart';
import 'package:flutter_qualification_work/screens/mobile/main/add_photo_info.dart';
import 'package:flutter_qualification_work/services/image_picker_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:io' show Platform;

import '../../localization/locales.dart';

class ShowAddBottomSheet {
  Future<Uint8List> selectGalleryImage() async {
    Uint8List image = Uint8List(0);
    try {
      image = await pickImage(ImageSource.gallery);
      return image;
    } catch (e) {
      return image;
    }
  }

  Future<Uint8List> addCameraImage() async {
    Uint8List image = Uint8List(0);
    try {
      image = await pickImage(ImageSource.camera);
      return image;
    } catch (e) {
      return image;
    }
  }

  void showAddBottomSheet(BuildContext context, double widthButton) {
    showMaterialModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => SizedBox(
        height: kIsWeb
            ? 250
            : Platform.isIOS
                ? 250
                : 230,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16, top: 16),
              child: Text(
                LocaleData.addContent.getString(context),
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
                  mainAxisAlignment: kIsWeb
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    kIsWeb
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: 16,
                              right: 9,
                            ),
                            child: AddBottomSheetButton(
                              function: () async {
                                Uint8List image = await addCameraImage();
                                if (image.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddPhotoInfo(
                                        image: image,
                                      ),
                                    ),
                                  ).then((value) => Navigator.pop(context));
                                }
                              },
                              swgLink: 'assets/icons/camera.svg',
                              buttonText: LocaleData.camera.getString(context),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: AddBottomSheetButton(
                        function: () async {
                          Uint8List image = await selectGalleryImage();
                          if (image.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddPhotoInfo(
                                  image: image,
                                ),
                              ),
                            ).then((value) => Navigator.pop(context));
                          }
                        },
                        swgLink: 'assets/icons/gallery.svg',
                        buttonText: LocaleData.gallery.getString(context),
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
                        buttonText: LocaleData.music.getString(context),
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
                        buttonText: LocaleData.video.getString(context),
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
