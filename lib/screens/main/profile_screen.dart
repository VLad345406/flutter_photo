import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/screens/main/edit_profile_screen.dart';
import 'package:flutter_qualification_work/screens/main/photo_open.dart';

import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String userName = '';
  String userAvatarLink = '';
  String uid = '';
  int imageCount = 0;
  List<Map<String, dynamic>> userPictures = [];

  Future<void> getUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
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
    }

    setState(() {
      userName = data['user_name'];
      userAvatarLink = data['avatar_link'];
      if (data['name'] != '') {
        name = data['name'];
      } else {
        name = data['user_name'];
      }
      imageCount = data['count_image'];
      uid = data['uid'];
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          name,
          style: GoogleFonts.comfortaa(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditScreen(),
                ),
              ).then((value) => getUserData());
            },
            icon: Icon(Icons.settings),
          ),
        ],
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
          imageCount == 0
              ? Container(
                  margin: const EdgeInsets.all(16),
                  child: Text(
                    "You haven't uploaded any images yet!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: Colors.black,
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
                        onTap: (){
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
                          margin:
                              const EdgeInsets.only(top: 32, left: 16, right: 16),
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
