import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/screens/main/chat_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userName = '';

  Future<void> getUserName() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final data =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();
    setState(() {
      userName = data['user_name'];
    });
  }

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;

    /*final List<String> users = [
      "Tom",
      "Alice",
      "Sam",
      "Bob",
      "Kate",
      "Tom",
      "Alice",
      "Sam",
      "Bob",
      "Kate",
      "Tom",
      "Alice",
      "Sam",
      "Bob",
      "Kate"
    ];*/

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Chats',
          style: GoogleFonts.comfortaa(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      /*body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    print("Tap $index");
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ChatScreen(index: index),),);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundImage:
                              AssetImage("assets/images/avatar1.jpg"),
                        ),
                        Container(
                          height: 64,
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  users[index],
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  'Thank you! That was very helpful!',
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),*/
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error!");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading..."));
        }

        //return Text('Test loading');

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      String receiverUserName = data['user_name'];

      if (data['name'] != '') {
        receiverUserName = data['name'];
      }

      return ListTile(
        title: Row(
          children: [
            PhotoUserAvatar(userAvatarLink: data['avatar_link'], radius: 20),
            const SizedBox(width: 20),
            Text(receiverUserName)
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiverUserEmail: data['email'],
                receiverUserID: data['uid'],
                senderUserName: userName,
                receiverUserName: receiverUserName,
              ),
            ),
          );
          /*navigatorPush(
            context,
            ChatScreen(index: 0,
              */ /*receiverUserEmail: data['email'],
              receiverUserID: data['uid'],
              senderUserName: userName,
              receiverUserName: receiverUserName,*/ /*
            ),
          );*/
        },
      );
    } else {
      return Container();
    }
  }
}
