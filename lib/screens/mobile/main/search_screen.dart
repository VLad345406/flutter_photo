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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResult = [];

  void updateSearchResult() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          'Search',
          style: GoogleFonts.comfortaa(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Container(
            width: screenWidth - 32,
            height: 52,
            margin: const EdgeInsets.only(left: 16, top: 32, right: 16),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 17,
                right: 17,
                top: 14,
              ),
              child: TextField(
                controller: searchController,
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (value) async {
                  if (value.isEmpty) {
                    searchResult = [];
                    updateSearchResult();
                  } else {
                    QuerySnapshot<Map<String, dynamic>> usersCollection =
                        await FirebaseFirestore.instance
                            .collection('users')
                            .get();
                    searchResult = await searchUsers(value, usersCollection);
                    updateSearchResult();
                  }
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
                : ListView.builder(
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
        ],
      ),
    );
  }
}
