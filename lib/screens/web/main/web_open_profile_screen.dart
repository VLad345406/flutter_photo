import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/screens/mobile/main/list_accounts.dart';
import 'package:flutter_qualification_work/screens/mobile/main/photo_open.dart';
import 'package:flutter_qualification_work/screens/web/main/web_edit_screen.dart';
import 'package:flutter_qualification_work/services/remove_picture_service.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WebOpenProfileScreen extends StatefulWidget {
  final String userId;

  const WebOpenProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<WebOpenProfileScreen> createState() => _WebOpenProfileScreenState();
}

class _WebOpenProfileScreenState extends State<WebOpenProfileScreen> {
  String name = '';
  String userName = '';
  String userAvatarLink = '';
  String uid = '';
  int imageCount = 0;
  int countFollowers = 0;
  int countSubs = 0;
  List<Map<String, dynamic>> userPictures = [];

  bool checkFollow = false;

  void updateFollow() {
    setState(() {
      checkFollow = !checkFollow;
    });
  }

  Future<void> getReceiverUserData() async {
    final userId = widget.userId;
    final data =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final followers = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('followers')
        .get();
    final subscriptions = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('subscriptions')
        .get();

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
    }

    final getFollowStatus = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('subscriptions')
        .doc(widget.userId)
        .get();

    checkFollow = getFollowStatus.exists;

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
      countFollowers = followers.size;
      countSubs = subscriptions.size;
    });
  }

  @override
  void initState() {
    super.initState();
    getReceiverUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              ? !checkFollow
                  ? Center(
                      child: PhotoButton(
                        widthButton: MediaQuery.of(context).size.width / 2,
                        buttonMargin: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        buttonText: 'FOLLOW',
                        textColor: Theme.of(context).colorScheme.secondary,
                        buttonColor: Theme.of(context).colorScheme.primary,
                        function: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .collection('subscriptions')
                              .doc(widget.userId)
                              .set({
                            'uid': widget.userId,
                          });
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userId)
                              .collection('followers')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .set({
                            'uid': FirebaseAuth.instance.currentUser?.uid,
                          });
                          updateFollow();
                        },
                      ),
                    )
                  : Center(
                      child: PhotoButton(
                        widthButton: MediaQuery.of(context).size.width / 2,
                        buttonMargin: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        buttonText: 'UNFOLLOW',
                        textColor: Colors.red,
                        buttonColor: Theme.of(context).colorScheme.primary,
                        function: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .collection('subscriptions')
                              .doc(widget.userId)
                              .delete();
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userId)
                              .collection('followers')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .delete();
                          updateFollow();
                        },
                      ),
                    )
              : Container(),
          FirebaseAuth.instance.currentUser?.uid != uid
              ? Center(
                  child: PhotoButton(
                    widthButton: MediaQuery.of(context).size.width / 2,
                    buttonMargin: EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    buttonText: 'MESSAGE',
                    textColor: Theme.of(context).colorScheme.secondary,
                    buttonColor: Theme.of(context).colorScheme.primary,
                  ),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PhotoButton(
                widthButton: MediaQuery.of(context).size.width / 4 - 8,
                buttonMargin: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 8,
                ),
                buttonText: 'Followers ($countFollowers)',
                textColor: Theme.of(context).colorScheme.secondary,
                buttonColor: Theme.of(context).colorScheme.primary,
                function: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListAccounts(
                          title: 'Followers',
                          userId: widget.userId,),
                    ),
                  );
                },
              ),
              PhotoButton(
                widthButton: MediaQuery.of(context).size.width / 4 - 8,
                buttonMargin: EdgeInsets.only(
                  top: 16,
                  left: 8,
                  right: 16,
                ),
                buttonText: 'Subscriptions ($countSubs)',
                textColor: Theme.of(context).colorScheme.secondary,
                buttonColor: Theme.of(context).colorScheme.primary,
                function: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListAccounts(
                          title: 'Subscriptions',
                          userId: widget.userId,),
                    ),
                  );
                },
              ),
            ],
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userId)
                .collection('pictures')
                .snapshots(),
            builder: (context, snapshot) {
              try {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error ${snapshot.error.toString()}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('Loading...'));
                }
                if (snapshot.data!.docs.length == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      "You haven't uploaded any images yet!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    height: (MediaQuery.of(context).size.width / 2) *
                        snapshot.data!.docs.length,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final userPicture = snapshot.data!.docs[index];
                        final imageLink = userPicture['image_link'];
                        return Center(
                          child: GestureDetector(
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
                              height: MediaQuery.of(context).size.width / 2,
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(imageLink),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              } catch (e) {
                return Text(
                  "You haven't uploaded any images yet!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                );
              }
            },
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
