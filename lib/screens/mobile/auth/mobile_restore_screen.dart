import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/services/authentication/restore_password_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileRestoreScreen extends StatelessWidget {
  const MobileRestoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 32.65, bottom: 32),
            child: Text(
              'Restore password',
              style: GoogleFonts.comfortaa(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 36,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          //email text-field
          PhotoTextField(
            controller: emailController,
            showVisibleButton: false,
            label: 'Email', disableSpace: true, disableUppercase: false,
          ),
          PhotoButton(
            widthButton: MediaQuery.of(context).size.width - 32,
            buttonMargin: const EdgeInsets.only(left: 16, top: 16),
            buttonText: 'RESTORE',
            textColor: Theme.of(context).colorScheme.secondary,
            buttonColor: Theme.of(context).colorScheme.primary,
            function: () => restorePassword(context, emailController.text),
          ),
        ],
      ),
    );
  }
}