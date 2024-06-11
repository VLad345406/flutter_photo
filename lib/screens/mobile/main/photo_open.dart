import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/screens/mobile/main/profile/open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/main/web_open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:photo_view/photo_view.dart';

class PhotoOpen extends StatefulWidget {
  final String path;
  final String uid;

  const PhotoOpen({
    Key? key,
    required this.path,
    required this.uid,
  }) : super(key: key);

  @override
  State<PhotoOpen> createState() => _PhotoOpenState();
}

class _PhotoOpenState extends State<PhotoOpen> {
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
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        fit: StackFit.loose,
        children: [
          PhotoView(
            minScale: 0.18,
            maxScale: 1.0,
            imageProvider: NetworkImage(widget.path),
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
                margin: const EdgeInsets.only(top: 50, left: 16),
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
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.only(top: 40, right: 16),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
