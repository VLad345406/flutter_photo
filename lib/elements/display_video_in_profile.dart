import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/video_player.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayVideoInProfile extends StatelessWidget {
  final String fileName;
  final String fileLink;

  const DisplayVideoInProfile({
    super.key,
    required this.fileName,
    required this.fileLink,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                fileName: fileName,
                fileLink: fileLink,
              ),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          height: kIsWeb
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width - 32,
          width: kIsWeb
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width - 32,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    fileName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.play_arrow,
                color: Theme.of(context).colorScheme.secondary,
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
