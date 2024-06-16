import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/localization/locales.dart';
import 'package:flutter_qualification_work/screens/mobile/main/profile/settings_screen.dart';
import 'package:flutter_qualification_work/screens/mobile/main/photo_open.dart';
import 'package:flutter_qualification_work/screens/web/main/profile/web_profile_stream_builder.dart';
import 'package:flutter_qualification_work/screens/web/main/web_settings_screen.dart';
import 'package:flutter_qualification_work/screens/mobile/main/list_accounts.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';

class WebProfileScreen extends StatefulWidget {
  const WebProfileScreen({super.key});

  @override
  State<WebProfileScreen> createState() => _WebProfileScreenState();
}

class _WebProfileScreenState extends State<WebProfileScreen> {
  String name = '';
  String userName = '';
  String userAvatarLink = '';
  String uid = '';
  int countFollowers = 0;
  int countSubs = 0;

  Future<void> getUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
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

    setState(() {
      userName = data['user_name'];
      userAvatarLink = data['avatar_link'];
      if (data['name'] != '') {
        name = data['name'];
      } else {
        name = data['user_name'];
      }
      uid = data['uid'];
      countFollowers = followers.size;
      countSubs = subscriptions.size;
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
      appBar: AppBar(
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
                  builder: (context) => ResponsiveLayout(
                    mobileScaffold: EditScreen(),
                    webScaffold: WebEditScreen(),
                  ),
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
                buttonText:
                    '${LocaleData.followers.getString(context)} ($countFollowers)',
                textColor: Theme.of(context).colorScheme.secondary,
                buttonColor: Theme.of(context).colorScheme.primary,
                function: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListAccounts(
                        title: 'Followers',
                        userId: FirebaseAuth.instance.currentUser!.uid,
                      ),
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
                buttonText:
                    '${LocaleData.subscriptions.getString(context)} ($countSubs)',
                textColor: Theme.of(context).colorScheme.secondary,
                buttonColor: Theme.of(context).colorScheme.primary,
                function: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListAccounts(
                        title: 'Subscriptions',
                        userId: FirebaseAuth.instance.currentUser!.uid,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          BlocProvider(
            create: (context) => ProfileBloc()..add(LoadUserData()),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state.hasError) {
                  return Center(child: Text('An error occurred'));
                }

                return WebProfileStreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('contents')
                      .snapshots(),
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  userName: userName,
                  mode: 'personal',
                );
              },
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
