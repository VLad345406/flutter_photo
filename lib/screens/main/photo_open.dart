import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'package:google_fonts/google_fonts.dart';
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
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final data =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();

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
    //get screen ppi

    //final screenHeight = MediaQuery.of(context).size.height;
    //final screenWidth = MediaQuery.of(context).size.width;

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
            child: Container(
              margin: const EdgeInsets.only(top: 50, left: 16),
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              //child: Image.asset('assets/images/user.png'),
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
                        ),
                      ),
                      Text('@$userName'),
                    ],
                  ),
                ],
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
