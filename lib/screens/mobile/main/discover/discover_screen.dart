import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/photo_card.dart';
import 'package:flutter_qualification_work/screens/mobile/main/discover/display_list_users.dart';
import 'package:flutter_qualification_work/services/discover_service.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
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
      subsPictures = await getSubscribedPictures();
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          'Discover',
          style: GoogleFonts.comfortaa(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: getUserData,
        child: ListView(
          children: [
            countSubs == -1
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : countSubs == 0
                    ? DisplayListUsers(
                        usersCollection: usersCollection,
                        getUserData: getUserData(),
                      )
                    : SizedBox(
                        height: (MediaQuery.of(context).size.width + 10) *
                            subsPictures.length,
                        child: ListView.builder(
                          itemCount: subsPictures.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return PhotoCard(
                              pathImage: subsPictures[index].values.first,
                              cardWidth: MediaQuery.of(context).size.width - 32,
                              uid: subsPictures[index].keys.first,
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
