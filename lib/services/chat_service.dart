import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/classes/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(
    String receiverId,
    String message,
  ) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Future<void> editMessage(
    String receiverUserID,
    String messageID,
    String newMessage,
  ) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;

    List<String> ids = [currentUserId, receiverUserID];
    ids.sort();
    String chatRoomId = ids.join("_");

    try {
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc(messageID)
          .update({'message': newMessage});
    } catch (e) {
      print('Error editing message: $e');
      throw e;
    }
  }

  Future<void> deleteMessage(
    String receiverUserID,
    String messageID,
  ) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;

    List<String> ids = [currentUserId, receiverUserID];
    ids.sort();
    String chatRoomId = ids.join("_");

    try {
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc(messageID)
          .delete();
    } catch (e) {
      print('Error deleting message: $e');
      throw e;
    }
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
