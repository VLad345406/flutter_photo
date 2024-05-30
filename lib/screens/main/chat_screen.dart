import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/services/chat_service.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'open_profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUserID;

  const ChatScreen({
    super.key,
    required this.receiverUserID,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String userName = '';
  String name = '';
  String receiverName = '';
  String receiverAvatarLink = '';

  final TextEditingController _messageEditingController =
      TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  Future<void> getUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final data =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    userName = data['user_name'];
    if (data['name'] != '') {
      name = data['name'];
    } else {
      name = data['user_name'];
    }
  }

  void sendMessage() async {
    if (_messageEditingController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserID,
        _messageEditingController.text,
      );
      _messageEditingController.clear();
    }
  }

  Future<void> getReceiverUserData() async {
    final userId = widget.receiverUserID;
    final data =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    setState(() {
      receiverAvatarLink = data['avatar_link'];
      if (data['name'] != '') {
        receiverName = data['name'];
      } else {
        receiverName = data['user_name'];
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getReceiverUserData();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          receiverName,
          style: GoogleFonts.roboto(
            fontSize: 25,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(child: _buildMessageItemList()),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 32,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  //onPressed: sendMessage,
                  icon: const Icon(
                    Icons.attach_file,
                    size: 32,
                  ),
                ),
                Expanded(
                  child: PhotoTextField(
                    controller: _messageEditingController,
                    showVisibleButton: false,
                    label: '',
                    disableSpace: false,
                    disableUppercase: false,
                  ),
                ),
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(
                    Icons.send,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItemList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error ${snapshot.error.toString()}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Loading...'));
          }

          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['sender_id'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    _scrollToBottom();
    return Row(
      mainAxisAlignment: alignment == Alignment.centerRight
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        alignment == Alignment.centerLeft
            ? Padding(
                padding: const EdgeInsets.only(left: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OpenProfileScreen(
                          userId: widget.receiverUserID,
                        ),
                      ),
                    );
                  },
                  child: PhotoUserAvatar(
                    userAvatarLink: receiverAvatarLink,
                    radius: 20,
                  ),
                ),
              )
            : Container(),
        Container(
          alignment: alignment,
          child: Container(
            margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
            padding:
                const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 100,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              //color: Colors.black12,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: (alignment == Alignment.centerRight)
                    ? const Radius.circular(20)
                    : const Radius.circular(0),
                bottomRight: (alignment == Alignment.centerLeft)
                    ? const Radius.circular(20)
                    : const Radius.circular(0),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  (data['sender_id'] == _firebaseAuth.currentUser!.uid)
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      alignment == Alignment.centerLeft ? receiverName : name,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    alignment == Alignment.centerRight
                        ? PopupMenuButton(
                            color: Theme.of(context).colorScheme.primary,
                            icon: Icon(Icons.more_vert),
                            iconColor: Theme.of(context).colorScheme.secondary,
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: TextButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: data['message']));
                                    snackBar(context, 'Success copied text!');
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Copy',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                child: TextButton(
                                  onPressed: (){
                                    snackBar(context, 'Edit');
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                child: TextButton(
                                  onPressed: (){
                                    snackBar(context, 'Delete');
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
                GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: data['message']));
                    snackBar(context, 'Success copied text!');
                  },
                  child: Text(
                    data['message'],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
