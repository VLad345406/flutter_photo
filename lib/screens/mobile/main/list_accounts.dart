import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/localization/locales.dart';
import 'package:flutter_qualification_work/screens/mobile/main/profile/open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/main/profile/web_open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ListAccounts extends StatefulWidget {
  final String title;
  final String userId;

  const ListAccounts({
    super.key,
    required this.title,
    required this.userId,
  });

  @override
  State<ListAccounts> createState() => _ListAccountsState();
}

class _ListAccountsState extends State<ListAccounts> {
  Future<Map<String, dynamic>> getData() async {
    QuerySnapshot<Map<String, dynamic>> usersCollection =
        await FirebaseFirestore.instance.collection('users').get();
    QuerySnapshot<Map<String, dynamic>> usersCollectionFollowing =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection(widget.title.toLowerCase())
            .get();

    return {
      'usersCollection': usersCollection,
      'usersCollectionFollowing': usersCollectionFollowing
    };
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
          widget.title == 'Followers'
              ? LocaleData.followers.getString(context)
              : LocaleData.subscriptions.getString(context),
          style: GoogleFonts.comfortaa(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: FutureBuilder<Map<String, dynamic>>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            } else {
              var usersCollection = snapshot.data!['usersCollection']
                  as QuerySnapshot<Map<String, dynamic>>;
              var usersCollectionFollowing =
                  snapshot.data!['usersCollectionFollowing']
                      as QuerySnapshot<Map<String, dynamic>>;

              if (usersCollectionFollowing.size == 0) {
                return Center(
                  child: Text('No users!'),
                );
              } else {
                return ListView.builder(
                  itemCount: usersCollectionFollowing.size,
                  itemBuilder: (context, index) {
                    final userDoc = usersCollectionFollowing.docs[index];
                    final user = usersCollection.docs
                        .firstWhere((doc) => doc.id == userDoc['uid']);

                    return ListTile(
                      title: Row(
                        children: [
                          PhotoUserAvatar(
                              userAvatarLink: user['avatar_link'], radius: 20),
                          const SizedBox(width: 20),
                          Text(
                            user['user_name'],
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
                                      userId: userDoc['uid'],
                                    ),
                                    webScaffold: WebOpenProfileScreen(
                                        userId: userDoc['uid']),
                                  )
                                : OpenProfileScreen(
                                    userId: userDoc['uid'],
                                  ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
