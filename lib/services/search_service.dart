import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';

dynamic searchService(BuildContext context, String value) async {
  try {
    if (value[0] == '@') {
      QuerySnapshot<Map<String, dynamic>> usersCollection =
          await FirebaseFirestore.instance.collection('users').get();

      searchUsers(value, usersCollection);
      return usersCollection;
    }
    if (value[0] == '#') {
      snackBar(context, 'Tag search');
    }
  } catch (e) {
    print(e);
    if (kDebugMode) {
      print('Out of range');
    }
  }
  return [];
}

List<Map<String, dynamic>> searchUsers(
    String query, QuerySnapshot<Map<String, dynamic>>? usersCollection) {
  String searchQuery = query.replaceAll('@', '').toLowerCase().trim();
  if (usersCollection == null) {
    return [];
  }
  if (query == '@' && query.length == 1) {
    return usersCollection.docs.map((doc) => doc.data()).toList();
  } else {
    return usersCollection.docs
        .where((doc) {
          var userName =
              doc.data()['user_name'].toString().toLowerCase().trim();
          return userName.contains(searchQuery);
        })
        .map((doc) => doc.data())
        .toList();
  }
}

Future<List<Map<String, String>>> getPicturesByTag(String searchTag) async {
  List<Map<String, String>> resultList = [];
  CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  searchTag = searchTag.trim();
  try {
    // Get all users
    QuerySnapshot usersSnapshot = await usersCollection.get();

    for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
      String userId = userDoc.id;

      // Get this user's pictures collection
      CollectionReference picturesCollection = usersCollection.doc(userId).collection('pictures');
      QuerySnapshot picturesSnapshot = await picturesCollection.where('tags', arrayContains: searchTag).get();

      // Traversing all found documents in the pictures collection
      for (QueryDocumentSnapshot pictureDoc in picturesSnapshot.docs) {
        String imageLink = pictureDoc['image_link'];
        resultList.add({userId: imageLink});
      }
    }
  } catch (e) {
    print(e);
  }

  return resultList;
}
