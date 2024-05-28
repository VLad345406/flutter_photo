import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AddBottomSheetButton extends StatelessWidget {
  final Function()? function;
  final String swgLink;
  final String buttonText;

  const AddBottomSheetButton({
    super.key,
    required this.function,
    required this.swgLink,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 41) / 2,
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: function,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              swgLink,
              width: 20,
              height: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              buttonText,
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
