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
      fileLink: '',
      fileType: '',
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chat_id_users')
        .doc(receiverId)
        .set({'user_id': receiverId});
    await _firestore
        .collection('users')
        .doc(receiverId)
        .collection('chat_id_users')
        .doc(currentUserId)
        .set({'user_id': currentUserId});

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

  Future<void> removeChat(String userId, String otherUserId) async {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('chat_id_users')
        .doc(otherUserId)
        .delete();
    await _firestore
        .collection('users')
        .doc(otherUserId)
        .collection('chat_id_users')
        .doc(userId)
        .delete();

    DocumentReference chatRoomDoc =
        _firestore.collection('chat_rooms').doc(chatRoomId);
    CollectionReference messagesCollection = chatRoomDoc.collection('messages');
    QuerySnapshot messagesSnapshot = await messagesCollection.get();
    for (QueryDocumentSnapshot doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }
    await chatRoomDoc.delete();
  }
}
