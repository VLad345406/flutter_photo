import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/localization/locales.dart';
import 'package:flutter_qualification_work/services/search_service.dart';
import 'package:google_fonts/google_fonts.dart';

import 'web_display_pictures.dart';
import 'web_display_users.dart';

class WebSearchScreen extends StatefulWidget {
  const WebSearchScreen({super.key});

  @override
  State<WebSearchScreen> createState() => _WebSearchScreenState();
}

class _WebSearchScreenState extends State<WebSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResult = [];
  String searchType = '';

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
              LocaleData.search.getString(context),
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
                    searchType = '';
                    updateSearchResult();
                  } else if (value[0] == '@') {
                    searchType = 'users';
                    QuerySnapshot<Map<String, dynamic>> usersCollection =
                        await FirebaseFirestore.instance
                            .collection('users')
                            .get();
                    searchResult = await searchUsers(value, usersCollection);
                    updateSearchResult();
                  } else {
                    searchType = 'tags';
                    searchResult =
                        await getPicturesByTag(searchController.text);
                    updateSearchResult();
                  }
                },
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
                decoration: InputDecoration.collapsed(
                  hintText: LocaleData.searchPhotos.getString(context),
                ),
              ),
            ),
          ),
          Expanded(
            child: searchType != ''
                ? searchResult.isEmpty
                    ? Center(child: Text('No result!'))
                    : searchType == 'users'
                        ? WebDisplayUsers(searchResult: searchResult)
                        : WebDisplayPictures(searchResult: searchResult)
                : Container(),
          ),
        ],
      ),
    );
  }
}
