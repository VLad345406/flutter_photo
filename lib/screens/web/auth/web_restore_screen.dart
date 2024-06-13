import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/localization/locales.dart';
import 'package:flutter_qualification_work/services/authentication/restore_password_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WebRestoreScreen extends StatefulWidget {
  const WebRestoreScreen({super.key});

  @override
  State<WebRestoreScreen> createState() => _WebRestoreScreenState();
}

class _WebRestoreScreenState extends State<WebRestoreScreen> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Center(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                LocaleData.restore.getString(context) +
                    ' ' +
                    LocaleData.password.getString(context).toLowerCase(),
                style: GoogleFonts.comfortaa(
                  fontSize: 90,
                ),
              ),
              SizedBox(
                width: 400,
                child: PhotoTextField(
                  controller: emailController,
                  showVisibleButton: false,
                  label: 'Email',
                  disableSpace: true,
                  disableUppercase: true,
                ),
              ),
              PhotoButton(
                widthButton: 370,
                buttonMargin: EdgeInsets.only(top: 18),
                buttonText: LocaleData.restore.getString(context).toUpperCase(),
                textColor: Theme.of(context).colorScheme.secondary,
                buttonColor: Theme.of(context).colorScheme.primary,
                function: () => restorePassword(context, emailController.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
