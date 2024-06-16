import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/elements/content_card.dart';
import 'package:flutter_qualification_work/localization/locales.dart';
import 'package:flutter_qualification_work/screens/mobile/main/discover/display_list_users.dart';
import 'package:flutter_qualification_work/services/discover_service.dart';
import 'package:google_fonts/google_fonts.dart';

class WebDiscoverScreen extends StatefulWidget {
  const WebDiscoverScreen({super.key});

  @override
  State<WebDiscoverScreen> createState() => _WebDiscoverScreenState();
}

class _WebDiscoverScreenState extends State<WebDiscoverScreen> {
  late QuerySnapshot<Map<String, dynamic>> subscriptions;
  late QuerySnapshot<Map<String, dynamic>> usersCollection;
  int countSubs = -1;

  List<Map<String, String>> subsPictures = [];

  Future<void> getUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    subscriptions = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('subscriptions')
        .get();

    usersCollection =
        await FirebaseFirestore.instance.collection('users').get();

    countSubs = subscriptions.size;

    if (countSubs != 0) {
      subsPictures = await getSubscribedFiles();
    }

    setState(() {});
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
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
        title: Text(
          LocaleData.discover.getString(context),
          style: GoogleFonts.comfortaa(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 50,
            fontWeight: FontWeight.w200,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          countSubs == -1
              ? Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : countSubs == 0
                  ? DisplayListUsers(
                      usersCollection: usersCollection,
                      getUserData: getUserData(),
                    )
                  : SizedBox(
                      height: 450.0 * subsPictures.length,
                      child: ListView.builder(
                        itemCount: subsPictures.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ContentCard(
                            fileLink:
                                subsPictures[index]["file_link"].toString(),
                            cardWidth: 400,
                            uid: subsPictures[index]['user_id'].toString(),
                            fileType:
                                subsPictures[index]['file_type'].toString(),
                            fileName:
                                subsPictures[index]['file_name'].toString(),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
