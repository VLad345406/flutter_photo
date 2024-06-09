import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/screens/mobile/main/chats/chat_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/chat_service.dart';

class WebChatsScreen extends StatefulWidget {
  const WebChatsScreen({super.key});

  @override
  State<WebChatsScreen> createState() => _WebChatsScreenState();
}

class _WebChatsScreenState extends State<WebChatsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();
  Widget currentChat = Container();

  void openChat(String receiverUserId) {
    setState(() {
      currentChat = Center(child: CircularProgressIndicator());
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          currentChat = ChatScreen(receiverUserID: receiverUserId);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
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
      body: Row(
        children: [
          Container(
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width / 5,
            child: _buildUserList(),
          ),
          Expanded(
            child: currentChat,
          ),
        ],
      ),
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
          return Center(child: CircularProgressIndicator());
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
                      String textMessage = snapshot.data!.docs.last['message'];
                      if (textMessage.length > 30) {
                        String truncatedTextMessage =
                            textMessage.substring(0, 30) + "...";
                        textMessage = truncatedTextMessage;
                      }
                      return Text(textMessage);
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
          openChat(data['uid']);
          //currentChat = ChatScreen(receiverUserID: data['uid']);
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
