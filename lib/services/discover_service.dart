import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<Map<String, String>>> getSubscribedFiles() async {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  List<Map<String, String>> result = [];

  var subscriptionsSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('subscriptions')
      .get();

  List<String> subscribedUserIds = subscriptionsSnapshot.docs.map((doc) => doc.id).toList();

  for (String subscribedUserId in subscribedUserIds) {
    var picturesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(subscribedUserId)
        .collection('contents')
        .get();

    for (var pictureDoc in picturesSnapshot.docs) {
      var data = pictureDoc.data();
      result.add({
        'user_id' : subscribedUserId,
        'file_link' : data['file_link'] ?? '',
        'file_type': data['file_type'] ?? '',
        'file_name' : data['file_name'] ?? '',
      });
    }
  }

  return result;
}
