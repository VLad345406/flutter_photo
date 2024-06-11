import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/services/image_picker_service.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPhotoInfo extends StatefulWidget {
  final Uint8List image;

  const AddPhotoInfo({
    super.key,
    required this.image,
  });

  @override
  State<AddPhotoInfo> createState() => _AddPhotoInfoState();
}

class _AddPhotoInfoState extends State<AddPhotoInfo> {
  final TextEditingController tagsController = TextEditingController();
  String _userName = '';
  int _countImage = 0;

  Future<void> getUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final data =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    _userName = data['user_name'];
    _countImage = data['count_image'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add photo tags',
          style: GoogleFonts.roboto(
            fontSize: 25,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        leading: kIsWeb
            ? Container()
            : IconButton(
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Image.memory(
            widget.image,
            fit: BoxFit.contain,
          )),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16,
            ),
            child: TextFormField(
              controller: tagsController,
              maxLines: 5,
              enableSuggestions: false,
              autocorrect: false,
              style: GoogleFonts.roboto(
                fontSize: 15,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
              decoration: InputDecoration(
                hintText: "Write tags without ',' or '#'",
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          PhotoButton(
            widthButton: MediaQuery.of(context).size.width - 32,
            buttonMargin: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: kIsWeb ? 16 : Platform.isIOS ? 32 : 16,
            ),
            buttonText: 'SAVE',
            textColor: Theme.of(context).colorScheme.secondary,
            buttonColor: Theme.of(context).colorScheme.primary,
            function: () async {
              if (tagsController.text.isNotEmpty) {
                await getUserData();
                uploadImageToStorage(
                  _userName,
                  (_countImage + 1).toString(),
                  widget.image,
                );
                await savePictureInFirestore(
                  FirebaseAuth.instance.currentUser!.uid.toString(),
                  _userName,
                  widget.image,
                  _countImage + 1,
                  tagsController.text,
                );
                Navigator.pop(context);
              }
              else {
                snackBar(context, 'Input tags!');
              }
            },
          ),
        ],
      ),
    );
  }
}
