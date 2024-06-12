import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/localization/locales.dart';
import 'package:flutter_qualification_work/services/authentication/google_sigh_in_add_info_firestore.dart';
import 'package:flutter_qualification_work/services/remove_account_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleSighInRegistrationData extends StatefulWidget {
  const GoogleSighInRegistrationData({super.key});

  @override
  State<GoogleSighInRegistrationData> createState() =>
      _GoogleSighInRegistrationDataState();
}

class _GoogleSighInRegistrationDataState
    extends State<GoogleSighInRegistrationData> {
  final nickNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            removeAccount(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/back_arrow.svg',
            width: 12.21,
            height: 11.35,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //header text
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 32.65,
              bottom: 16,
            ),
            child: Text(
              //'Register',
              LocaleData.register.getString(context)[0].toUpperCase() +
                  LocaleData.register
                      .getString(context)
                      .substring(1)
                      .toLowerCase(),
              style: GoogleFonts.comfortaa(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 36,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          //nickname text-field
          PhotoTextField(
            controller: nickNameController,
            showVisibleButton: false,
            label: LocaleData.nickName.getString(context),
            disableSpace: true,
            disableUppercase: true,
          ),
          //registration button
          PhotoButton(
            widthButton: MediaQuery.of(context).size.width - 32,
            buttonMargin: EdgeInsets.only(left: 16, top: 16),
            buttonText: LocaleData.register.getString(context),
            textColor: Theme.of(context).colorScheme.secondary,
            buttonColor: Theme.of(context).colorScheme.primary,
            function: () {
              googleSighInAddInfoFirestore(context, nickNameController.text);
            },
          ),
        ],
      ),
    );
  }
}
