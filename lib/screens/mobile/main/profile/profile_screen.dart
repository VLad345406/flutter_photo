import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/localization/locales.dart';
import 'package:flutter_qualification_work/screens/mobile/main/profile/profile_stream_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_qualification_work/elements/button.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/screens/mobile/main/profile/settings_screen.dart';
import 'package:flutter_qualification_work/screens/mobile/main/list_accounts.dart';
import 'package:flutter_qualification_work/screens/mobile/main/photo_open.dart';
import 'package:flutter_qualification_work/screens/web/main/web_settings_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';

import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String userName = '';
  String userAvatarLink = '';
  String uid = '';
  int countFollowers = 0;
  int countSubs = 0;
  double sizedBoxHeight = 0;

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
      //imageCount = data['count_image'];
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.surface,
        ),
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
                  builder: (context) => kIsWeb
                      ? ResponsiveLayout(
                          mobileScaffold: EditScreen(),
                          webScaffold: WebEditScreen(),
                        )
                      : EditScreen(),
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
                        title: 'Followers',
                        userId: FirebaseAuth.instance.currentUser!.uid,
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
                  return Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state.hasError) {
                  return Center(child: Text('An error occurred'));
                }

                return ProfileStreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('contents')
                      .snapshots(),
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  userName: userName,
                  mode: 'personal',
                );

                /*return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('contents')
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
                          height: MediaQuery.of(context).size.width *
                              snapshot.data!.docs.length,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              final userFile = snapshot.data!.docs[index];
                              final imageLink = userFile['file_link'];

                              return Stack(
                                alignment: AlignmentDirectional.topEnd,
                                fit: StackFit.loose,
                                children: [
                                  userFile['file_type'] == 'image'
                                      ? DisplayImageInProfile(
                                          imageLink: imageLink,
                                          uid: state.uid,
                                        )
                                      : userFile['file_type'] == 'music'
                                          ? AudioPlayerScreen(
                                              fileName: userFile['file_name'],
                                              fileLink: userFile['file_link'],
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        VideoPlayerScreen(
                                                      fileName:
                                                          userFile['file_name'],
                                                      fileLink:
                                                          userFile['file_link'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Stack(
                                                alignment:
                                                    AlignmentDirectional.center,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      left: 16,
                                                      right: 16,
                                                      top: 16
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        userFile['file_name'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 20,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      size: 50,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 16,
                                      right: 16,
                                    ),
                                    child: IconButton(
                                      onPressed: () async {
                                        String result =
                                            await removePictureService(
                                          'content/${state.userName}/${userFile['file_name']}',
                                          userFile['file_name'],
                                        );
                                        if (result == 'Success') {
                                          context
                                              .read<ProfileBloc>()
                                              .add(LoadUserData());
                                          snackBar(
                                              context, 'Success remove file!');
                                        } else {
                                          snackBar(
                                              context, 'Fail remove file!');
                                        }
                                      },
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
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
                );*/
              },
            ),
          ),
        ],
      ),
    );
  }
}
