import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/services/search_service.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  dynamic searchResult;

  Widget buildSearchResult(dynamic resultSearch){
    return _buildUserList(resultSearch, 'email');
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
                onChanged: (value) {
                  searchService(context, value);
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
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(dynamic list, String type) {
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: list!.docs
          .map<Widget>((doc) => _buildUserListItem(doc))
          .toList(),
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (FirebaseAuth.instance.currentUser!.email != data['email']) {
      String receiverUserName = data['user_name'];

      if (data['name'] != '') {
        receiverUserName = data['name'];
      }

      return ListTile(
        title: Row(
          children: [
            PhotoUserAvatar(userAvatarLink: data['avatar_link'], radius: 20),
            const SizedBox(width: 20),
            Text(
              receiverUserName,
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
        onTap: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiverUserID: data['uid'],
              ),
            ),
          );*/
        },
      );
    } else {
      return Container();
    }
  }

}
