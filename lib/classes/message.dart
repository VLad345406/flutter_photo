import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String fileLink;
  final String fileType;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.fileLink,
    required this.fileType,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'timestamp': timestamp,
      'file_link': fileLink,
      'file_type': fileType,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['sender_id'],
      receiverId: map['receiver_id'],
      message: map['message'],
      timestamp: map['timestamp'],
      fileLink: map['file_link'],
      fileType: map['file_type'],
    );
  }
}
