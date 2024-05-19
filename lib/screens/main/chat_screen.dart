import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/elements/text_field.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/services/chat_service.dart';
import 'package:flutter_svg/svg.dart';

/*class ChatScreen extends StatefulWidget {
  final int index;

  const ChatScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final List<String> user1Messages = [
      "Really love your most recent photo. I’ve been trying to capture the same thing for a few months and would love some tips!",
      "Thank you! That was very helpful!",
      "A fast 50mm like f1.8 would help with the bokeh. I’ve been using primes as they tend to get a bit sharper images.",
      "Thanks!"
    ];

    final List<String> users = [
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
    ];

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/back_arrow.svg',
            width: 12.21,
            height: 11.35,
          ),
        ),
        elevation: 0,
        title: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen()));
          },
          child: Text(
            users[widget.index],
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              //color: Colors.black,
              child: ListView.builder(
                itemCount: user1Messages.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0 || index % 2 != 0) {
                    return Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16, right: 16),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundImage:
                                  AssetImage("assets/images/avatar1.jpg"),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              color: Colors.grey[300],
                              child: Text(user1Messages[index]),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              color: Colors.grey[300],
                              child: Text(user1Messages[index]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, left: 16),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundImage:
                                  AssetImage("assets/images/avatar1.jpg"),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  bottom: Platform.isIOS ? 32 : 16,
                  right: 16,
                ),
                height: Platform.isIOS ? 98 : 82,
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(screenWidth - 90, 52)),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Write message',
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide(width: 2)),
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide(width: 2)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 5),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}*/

class ChatScreen extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  final String senderUserName;
  final String receiverUserName;

  const ChatScreen(
      {super.key,
      required this.receiverUserEmail,
      required this.receiverUserID,
      required this.senderUserName,
      required this.receiverUserName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageEditingController =
      TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  void sendMessage() async {
    if (_messageEditingController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverUserID,
          _messageEditingController.text, widget.senderUserName);
      _messageEditingController.clear();
    }
  }

  String receiverAvatarLink = '';

  Future<void> getReceiverUserData() async {
    final userId = widget.receiverUserID;
    final data =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    setState(() {
      receiverAvatarLink = data['avatar_link'];
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserName),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/back_arrow.svg',
            width: 12.21,
            height: 11.35,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(child: _buildMessageItemList()),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              children: [
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
                    size: 40,
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
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
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
                child: PhotoUserAvatar(
                  userAvatarLink: receiverAvatarLink,
                  radius: 20,
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
              color: Colors.black12,
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
                  (data['senderId'] == _firebaseAuth.currentUser!.uid)
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                Text(
                  data['senderUserName'],
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w700),
                ),
                Text(data['message']),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
