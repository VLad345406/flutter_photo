import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/add_bottom_sheet/add_bottom_sheet_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void showAddBottomSheet(context, double widthButton) {
  showMaterialModalBottomSheet<dynamic>(
    context: context,
    backgroundColor: Colors.white,
    builder: (context) => SizedBox(
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16, top: 16),
            child: Text(
              'Add photo',
              style: GoogleFonts.comfortaa(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.w400,
              ),
            ),
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
                  function: () {},
                  swgLink: 'assets/icons/camera.svg',
                  buttonText: 'Camera',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: AddBottomSheetButton(
                  function: () {},
                  swgLink: 'assets/icons/gallery.svg',
                  buttonText: 'Gallery',
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
