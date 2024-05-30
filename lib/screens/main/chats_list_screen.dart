import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/screens/main/chat_screen.dart';
import 'package:flutter_qualification_work/services/chat_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          'Chats',
          style: GoogleFonts.comfortaa(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
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
          //return const Center(child: Text("Loading..."));
          return CircularProgressIndicator();
        }

        return ListView(
          primary: false,
          shrinkWrap: true,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receiverUserName,
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                StreamBuilder(
                  stream: _chatService.getMessages(
                      data['uid'], FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, snapshot) {
                    try {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text('Error ${snapshot.error.toString()}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: Text('Loading...'));
                      }
                      return Text(snapshot.data!.docs.last['message']);
                    } catch (e) {
                      return Text('No message!');
                    }
                  },
                ),
              ],
            )
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiverUserID: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
