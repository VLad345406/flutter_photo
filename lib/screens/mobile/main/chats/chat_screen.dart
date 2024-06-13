import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_qualification_work/elements/user_avatar.dart';
import 'package:flutter_qualification_work/localization/locales.dart';
import 'package:flutter_qualification_work/screens/mobile/main/photo_open.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_qualification_work/services/chat_service.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';
import 'package:flutter_qualification_work/screens/mobile/main/chats/linkify_text.dart';
import 'package:flutter_qualification_work/screens/mobile/main/profile/open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/main/profile/web_open_profile_screen.dart';
import 'package:flutter_qualification_work/screens/web/responsive_layout.dart';

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

  bool editingStatus = false;
  String editingMessageID = '';

  final ImagePicker _picker = ImagePicker();

  final TextEditingController _messageEditingController =
      TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  FocusNode _focusNode = FocusNode();

  late Stream<QuerySnapshot<Object?>> getMessages;

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
      if (editingStatus) {
        await _chatService.editMessage(
          widget.receiverUserID,
          editingMessageID,
          _messageEditingController.text,
        );
        editingStatus = false;
        editingMessageID = '';
        snackBar(context, 'Success edit!');
      } else {
        await _chatService.sendMessage(
          widget.receiverUserID,
          _messageEditingController.text,
          '',
          'text',
          '',
        );
      }
      _messageEditingController.clear();
    }
  }

  void editMessage(String messageID, String message) {
    setState(() {
      editingStatus = true;
      editingMessageID = messageID;
      _messageEditingController.text = message;
    });
  }

  void deleteMessage(String messageID) async {
    await _chatService.deleteMessage(widget.receiverUserID, messageID);
    snackBar(context, 'Success!');
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

  Future<void> sendImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String imageUrl = await uploadImage(image, fileName);
      await _chatService.sendMessage(
        widget.receiverUserID,
        '',
        imageUrl,
        'image',
        fileName,
      );
    } catch (e) {
      print("Error sending image: $e");
    }
  }

  Future<String> uploadImage(File image, String fileName) async {
    try {
      Reference reference =
          FirebaseStorage.instance.ref().child("images").child(fileName);
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw e;
    }
  }

  void pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await sendImage(imageFile);
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    getReceiverUserData();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => kIsWeb
                    ? ResponsiveLayout(
                        mobileScaffold: OpenProfileScreen(
                          userId: widget.receiverUserID,
                        ),
                        webScaffold: WebOpenProfileScreen(
                          userId: widget.receiverUserID,
                        ),
                      )
                    : OpenProfileScreen(
                        userId: widget.receiverUserID,
                      ),
              ),
            );
          },
          child: Text(
            receiverName,
            style: GoogleFonts.roboto(
              fontSize: 25,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        leading: kIsWeb
            ? Container()
            : IconButton(
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
      body: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.enter) {
              sendMessage();
            }
          }
        },
        child: Column(
          children: [
            Expanded(child: buildMessageItemList()),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 32,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: pickImage,
                    icon: const Icon(
                      Icons.add_photo_alternate,
                      size: 32,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      child: TextFormField(
                        controller: _messageEditingController,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            editingStatus = false;
                          }
                        },
                      ),
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
      ),
    );
  }

  Widget buildMessageItemList() {
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

    // get message sent time
    Timestamp messageTimestamp = data['timestamp'];
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(messageTimestamp.seconds * 1000);
    int hour = dateTime.hour;
    int minute = dateTime.minute;

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
                        builder: (context) => kIsWeb
                            ? ResponsiveLayout(
                                mobileScaffold: OpenProfileScreen(
                                  userId: widget.receiverUserID,
                                ),
                                webScaffold: WebOpenProfileScreen(
                                  userId: widget.receiverUserID,
                                ),
                              )
                            : OpenProfileScreen(
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
          constraints: BoxConstraints(
            maxWidth: kIsWeb ? 550 : MediaQuery.of(context).size.width - 60,
          ),
          child: Container(
            margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
            padding:
                const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 100,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
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
                alignment == Alignment.centerLeft
                    ? Text(
                        receiverName,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      )
                    : SizedBox(
                        width: 86,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleData.you.getString(context),
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                            alignment == Alignment.centerRight
                                ? PopupMenuButton(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    icon: const Icon(Icons.more_vert),
                                    iconColor:
                                        Theme.of(context).colorScheme.secondary,
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: TextButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: data['message']));
                                            snackBar(context,
                                                'Success copied text!');
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            LocaleData.copy.getString(context),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: TextButton(
                                          onPressed: () {
                                            if (data['file_type'] != 'image') {
                                              editMessage(
                                                  document.id, data['message']);
                                              Navigator.pop(context);
                                            } else {
                                              snackBar(
                                                  context, 'Photo can`t edit!');
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text(
                                            LocaleData.edit.getString(context),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: TextButton(
                                          onPressed: () {
                                            deleteMessage(document.id);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            LocaleData.delete
                                                .getString(context),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                if (data['file_type'] == 'image' &&
                    data.containsKey('file_link'))
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoOpen(
                            path: data['file_link'],
                            uid: alignment == Alignment.centerLeft
                                ? widget.receiverUserID
                                : FirebaseAuth.instance.currentUser!.uid,
                          ),
                        ),
                      );
                    },
                    child: Image.network(
                      data['file_link'],
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Text('Error loading image: $error');
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  )
                else if (data['file_type'] != 'image')
                  LinkifyText(text: data['message']),
                Text(
                  '${hour < 10 ? '0$hour' : hour}:${minute == 0 ? '00' : minute}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
