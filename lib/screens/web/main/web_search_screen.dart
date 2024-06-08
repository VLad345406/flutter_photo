import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/screens/mobile/main/open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/main/web_open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';
import 'package:flutter_qualification_work/services/search_service.dart';
import 'package:google_fonts/google_fonts.dart';

class WebSearchScreen extends StatefulWidget {
  const WebSearchScreen({super.key});

  @override
  State<WebSearchScreen> createState() => _WebSearchScreenState();
}

class _WebSearchScreenState extends State<WebSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResult = [];

  void updateSearchResult() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              'Search',
              style: GoogleFonts.comfortaa(
                fontSize: 90,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 100,
            height: 52,
            margin: const EdgeInsets.only(left: 50, top: 32, right: 50),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 14,
                left: 17,
                right: 17,
              ),
              child: TextField(
                controller: searchController,
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (value) async {
                  if (value.isEmpty) {
                    searchResult = [];
                  } else {
                    QuerySnapshot<Map<String, dynamic>> usersCollection =
                    await FirebaseFirestore.instance
                        .collection('users')
                        .get();
                    searchResult = await searchUsers(value, usersCollection);
                  }
                  updateSearchResult();
                },
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
                decoration: const InputDecoration.collapsed(
                  hintText: 'Search all photos, profiles',
                ),
              ),
            ),
          ),
          Expanded(
            child: searchController.text.isNotEmpty && searchResult.isEmpty
                ? Center(child: Text('No users found!'))
                : Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 16),
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
                                userId: searchResult[index]['uid'],
                              ),
                              webScaffold: WebOpenProfileScreen(
                                  userId: searchResult[index]['uid']),
                            )
                                : OpenProfileScreen(
                              userId: searchResult[index]['uid'],
                            ),
                          ),
                        );
                      },
                    );
                  }
                                },
                              ),
                ),
          ),
        ],
      ),
    );
  }
}
