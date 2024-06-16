import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/audio_player.dart';
import 'package:flutter_qualification_work/elements/display_image.dart';
import 'package:flutter_qualification_work/elements/display_video.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/screens/mobile/main/profile/open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/main/profile/web_open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class ContentCard extends StatefulWidget {
  final String fileLink;
  final String uid;
  final double cardWidth;
  final String fileType;
  final String fileName;

  const ContentCard({
    super.key,
    required this.fileLink,
    required this.cardWidth,
    required this.uid,
    required this.fileType,
    required this.fileName,
  });

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  String userName = '';
  String name = '';
  String userAvatarLink = '';

  Future<void> getUserData() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();

    setState(() {
      userName = data['user_name'];
      userAvatarLink = data['avatar_link'];
      name = data['name'];
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.cardWidth,
        height: widget.cardWidth + 20,
        margin: const EdgeInsets.only(
          left: 16,
          top: 12,
          right: 16,
          bottom: 12,
        ),
        child: Column(
          children: [
            widget.fileType == 'image'
                ? DisplayImage(
                    imageLink: widget.fileLink,
                    uid: widget.uid,
                    widthImage: widget.cardWidth,
                    heightImage: widget.cardWidth - 70,
                  )
                : Container(),
            widget.fileType == 'music'
                ? AudioPlayerWidget(
                    fileName: widget.fileName,
                    fileLink: widget.fileLink,
                    playerWidth: widget.cardWidth,
                    playerHeight: widget.cardWidth - 70,
                  )
                : Container(),
            widget.fileType == 'video'
                ? DisplayVideo(
                    fileName: widget.fileName,
                    fileLink: widget.fileLink,
                    videoWidth: widget.cardWidth,
                    videoHeight: widget.cardWidth - 70,
                  )
                : Container(),
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => kIsWeb
                          ? ResponsiveLayout(
                              mobileScaffold: OpenProfileScreen(
                                userId: widget.uid,
                              ),
                              webScaffold:
                                  WebOpenProfileScreen(userId: widget.uid),
                            )
                          : OpenProfileScreen(
                              userId: widget.uid,
                            ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  //width: 200,
                  width: userName.length < name.length
                      ? name.length * 14
                      : userName.length * 18,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PhotoUserAvatar(
                        userAvatarLink: userAvatarLink,
                        radius: 15,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.roboto(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                          Text(
                            '@$userName',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
