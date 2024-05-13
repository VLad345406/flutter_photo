import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/screens/main/edit_profile_screen.dart';
//import 'package:flutter_qualification_work/screens/main/photo_open.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  final String mode;

  const ProfileScreen({Key? key, required this.mode}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String userName = '';
  String userAvatarLink = '';

  Future<void> getUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final data =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();

    setState(() {
      userName = data['user_name'];
      userAvatarLink = data['image_link'];
      try {
        name = data['name'];
      } catch (e) {
        name = data['user_name'];
      }
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

    /*final List<String> photoArray = [
      "picture1.jpg",
      "picture2.jpg",
      "picture3.jpg",
      "picture4.jpg",
      "picture5.jpg",
      "picture5.jpg"
    ];
    int _countPictures = 5;*/

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          name,
          style: GoogleFonts.comfortaa(
            color: Colors.black,
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
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: PhotoUserAvatar(
                userAvatarLink: userAvatarLink,
                radius: 64,
              ),
            ),
          ),
          /*Center(
            child: Container(
              padding: EdgeInsets.only(top: 16),
              child: GestureDetector(
                onTap: () {
                  print("Change avatar");
                },
                child: CircleAvatar(
                  radius: 64,
                  backgroundImage: AssetImage("assets/images/avatar1.jpg"),
                ),
              ),
            ),
          ),*/
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
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      /*body: ListView.builder(
        //itemCount: photoArray.length + 2,
        itemCount: photoArray.length > 5
            ? (_countPictures + 2)
            : (photoArray.length + 2),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return ProfileHeaderBuilder(mode: widget.mode);
          } else if (index < photoArray.length + 1 &&
              index < _countPictures + 1) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PhotoOpen(
                            path:
                                'assets/images/Profile1/${photoArray[index - 1]}')));
              },
              *//*onTap: (){
                //Navigator.pushNamed(context, '/photo_open');
                // PhotoOpen(path: 'assets/images/Profile1/${photoArray[index - 1]}');
                Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoOpen(path: 'assets/images/Profile1/${photoArray[index - 1]}')));
              },*//*
              child: Container(
                margin: const EdgeInsets.only(top: 32, left: 16, right: 16),
                height: screenWidth - 32,
                width: screenWidth - 32,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/Profile1/${photoArray[index - 1]}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          } else if (photoArray.length > 5) {
            return PhotoButton(
              widthButton: screenWidth - 32,
              buttonMargin: const EdgeInsets.only(top: 32, left: 16, right: 16),
              buttonText: 'SEE MORE',
              textColor: Colors.black,
              buttonColor: Colors.white,
            );
          }
          return null;
        },
      ),*/
    );
  }
}
