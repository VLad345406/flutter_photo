import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/screens/mobile/main/profile/open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/mobile/main/photo_open.dart';
import 'package:flutter_qualification_work/screens/web/main/web_open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class PhotoCard extends StatefulWidget {
  final String pathImage;
  final String uid;
  final double cardWidth;

  const PhotoCard({
    super.key,
    required this.pathImage,
    required this.cardWidth,
    required this.uid,
  });

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
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

  bool _isLoading = true;

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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoOpen(
                      path: widget.pathImage,
                      uid: widget.uid,
                    ),
                  ),
                );
              },
              child: Container(
                height: widget.cardWidth - 46,
                width: widget.cardWidth,
                child: Image.network(
                  widget.pathImage,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Center(
                      child: Icon(Icons.error),
                    );
                  },
                ),
              ),
            ),
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
