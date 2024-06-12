import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/elements/button.dart';

import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/localization/locales.dart';
import 'package:flutter_qualification_work/screens/mobile/main/chats/chat_screen.dart';
import 'package:flutter_qualification_work/screens/mobile/main/list_accounts.dart';
import 'package:flutter_qualification_work/screens/mobile/main/photo_open.dart';

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
              ? !checkFollow
                  ? PhotoButton(
                      widthButton: MediaQuery.of(context).size.width - 32,
                      buttonMargin: EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                      ),
                      buttonText:
                          LocaleData.follow.getString(context).toUpperCase(),
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
                    )
                  : PhotoButton(
                      widthButton: MediaQuery.of(context).size.width - 32,
                      buttonMargin: EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                      ),
                      buttonText:
                          LocaleData.unfollow.getString(context).toUpperCase(),
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
                    )
              : Container(),
          FirebaseAuth.instance.currentUser?.uid != uid
              ? PhotoButton(
                  widthButton: MediaQuery.of(context).size.width - 32,
                  buttonMargin: EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                  ),
                  buttonText:
                      LocaleData.message.getString(context).toUpperCase(),
                  textColor: Theme.of(context).colorScheme.secondary,
                  buttonColor: Theme.of(context).colorScheme.primary,
                  function: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          receiverUserID: widget.userId,
                        ),
                      ),
                    );
                  },
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PhotoButton(
                widthButton: MediaQuery.of(context).size.width / 2 - 24,
                buttonMargin: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 8,
                ),
                buttonText:
                    '${LocaleData.followers.getString(context)} ($countFollowers)',
                textColor: Theme.of(context).colorScheme.secondary,
                buttonColor: Theme.of(context).colorScheme.primary,
                function: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListAccounts(
                        title: LocaleData.followers.getString(context),
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
              ),
              PhotoButton(
                widthButton: MediaQuery.of(context).size.width / 2 - 24,
                buttonMargin: EdgeInsets.only(
                  top: 16,
                  left: 8,
                  right: 16,
                ),
                buttonText:
                    '${LocaleData.subscriptions.getString(context)} ($countSubs)',
                textColor: Theme.of(context).colorScheme.secondary,
                buttonColor: Theme.of(context).colorScheme.primary,
                function: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListAccounts(
                        title: LocaleData.subscriptions.getString(context),
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
              ),
            ],
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
                    physics: NeverScrollableScrollPhysics(),
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
                          child: Image.network(
                            imageLink,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              }
                            },
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return Center(
                                child: Icon(Icons.error),
                              );
                            },
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
