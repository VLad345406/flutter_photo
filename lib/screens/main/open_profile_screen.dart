import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qualification_work/elements/button.dart';

import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/screens/main/photo_open.dart';

import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class OpenProfileScreen extends StatefulWidget {
  final String userId;

  const OpenProfileScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<OpenProfileScreen> createState() => _OpenProfileScreenState();
}

class _OpenProfileScreenState extends State<OpenProfileScreen> {
  String name = '';
  String userName = '';
  String userAvatarLink = '';
  String uid = '';
  int imageCount = 0;
  List<Map<String, dynamic>> userPictures = [];

  Future<void> getReceiverUserData() async {
    final userId = widget.userId;
    final data =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (data['count_image'] > 0) {
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pictures');

      QuerySnapshot querySnapshot = await collectionRef.get();
      userPictures = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      imageCount = querySnapshot.docs.length;
      print(imageCount);
    }

    setState(() {
      userAvatarLink = data['avatar_link'];
      userName = data['user_name'];
      uid = widget.userId;
      //imageCount = data['count_image'];
      if (data['name'] != '') {
        name = data['name'];
      } else {
        name = data['user_name'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getReceiverUserData();
  }

  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
        title: Text(
          name,
          style: GoogleFonts.comfortaa(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: ListView(
        primary: false,
        shrinkWrap: true,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: GestureDetector(
                onTap: () {
                  if (!userAvatarLink.isEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoOpen(
                          path: userAvatarLink,
                          uid: uid,
                        ),
                      ),
                    );
                  }
                },
                child: PhotoUserAvatar(
                  userAvatarLink: userAvatarLink,
                  radius: 64,
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: "@$userName"));
                snackBar(context, 'Success copied!');
                if (kDebugMode) {
                  print("success copied");
                }
              },
              child: Container(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  '@$userName',
                  style: GoogleFonts.roboto(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          FirebaseAuth.instance.currentUser?.uid != uid
              ? PhotoButton(
                  widthButton: MediaQuery.of(context).size.width - 32,
                  buttonMargin: EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                  ),
                  buttonText: 'FOLLOW',
                  textColor: Theme.of(context).colorScheme.secondary,
                  buttonColor: Theme.of(context).colorScheme.primary,
                )
              : Container(),
          PhotoButton(
            widthButton: MediaQuery.of(context).size.width - 32,
            buttonMargin: EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            buttonText: 'MESSAGE',
            textColor: Theme.of(context).colorScheme.secondary,
            buttonColor: Theme.of(context).colorScheme.primary,
          ),
          imageCount == 0
              ? Container(
                  //alignment: Alignment.center,
                  margin: const EdgeInsets.all(16),
                  child: Text(
                    "This user has not uploaded any images yet!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                    ),
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.width * imageCount,
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: userPictures.length,
                    itemBuilder: (BuildContext context, int index) {
                      final userPicture = userPictures[index];
                      final imageLink = userPicture['image_link'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoOpen(
                                path: imageLink,
                                uid: uid,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 32, left: 16, right: 16),
                          height: MediaQuery.of(context).size.width - 32,
                          width: MediaQuery.of(context).size.width - 32,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageLink),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
