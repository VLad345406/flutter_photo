import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/screens/mobile/main/profile/open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/main/web_open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayListUsers extends StatelessWidget {
  final QuerySnapshot<Map<String, dynamic>> usersCollection;
  final Future<void> getUserData;

  const DisplayListUsers(
      {super.key, required this.usersCollection, required this.getUserData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "You're not subscribed to anyone!\n"
              "Maybe you know that users:",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 20,
              ),
            ),
          ),
          Container(
            height: 300,
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount:
                  usersCollection.size - 1 > 5 ? 5 : usersCollection.size,
              itemBuilder: (context, index) {
                final currentUser = usersCollection.docs[index];
                if (currentUser['uid'] ==
                    FirebaseAuth.instance.currentUser?.uid) {
                  return Container();
                } else {
                  return ListTile(
                    title: Row(
                      children: [
                        PhotoUserAvatar(
                            userAvatarLink: currentUser['avatar_link'],
                            radius: 20),
                        const SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            currentUser['name'] != ''
                                ? Text(
                                    currentUser['name'],
                                    style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                : Container(),
                            Text(
                              '@${currentUser['user_name']}',
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                //fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => kIsWeb
                              ? ResponsiveLayout(
                                  mobileScaffold: OpenProfileScreen(
                                    userId: currentUser['uid'],
                                  ),
                                  webScaffold: WebOpenProfileScreen(
                                      userId: currentUser['uid']),
                                )
                              : OpenProfileScreen(
                                  userId: currentUser['uid'],
                                ),
                        ),
                      ).then((value) => getUserData);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
