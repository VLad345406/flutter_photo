import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/screens/mobile/main/open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/main/web_open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class WebDisplayUsers extends StatelessWidget {
  final List<Map<String, dynamic>> searchResult;

  const WebDisplayUsers({
    super.key,
    required this.searchResult,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 34, right: 34),
      child: ListView.builder(
        itemCount: searchResult.length,
        itemBuilder: (context, index) {
          String userName = searchResult[index]['user_name'];

          if (searchResult[index]['uid'] ==
              FirebaseAuth.instance.currentUser?.uid) {
            return Container();
          } else {
            return ListTile(
              title: Row(
                children: [
                  PhotoUserAvatar(
                      userAvatarLink: searchResult[index]
                      ['avatar_link'],
                      radius: 20),
                  const SizedBox(width: 20),
                  Text(
                    userName,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => kIsWeb
                        ? ResponsiveLayout(
                      mobileScaffold: OpenProfileScreen(
                        userId: searchResult[index]
                        ['uid'],
                      ),
                      webScaffold: WebOpenProfileScreen(
                          userId: searchResult[index]
                          ['uid']),
                    )
                        : OpenProfileScreen(
                      userId: searchResult[index]
                      ['uid'],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
