import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<Map<String, String>>> getSubscribedPictures() async {
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
        .collection('pictures')
        .get();

    for (var pictureDoc in picturesSnapshot.docs) {
      var data = pictureDoc.data();
      result.add({
        subscribedUserId: data['image_link'] ?? '',
      });
    }
  }

  return result;
}
