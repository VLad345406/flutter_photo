import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';

dynamic searchService(BuildContext context, String value) async {
  try {
    if (value[0] == '@') {

      QuerySnapshot<Map<String, dynamic>> usersCollection =
          await FirebaseFirestore.instance.collection('users').get();

      List<Map<String, dynamic>> resultSearchUsers =
          searchUsers(value, usersCollection);

      print(resultSearchUsers.length);

      for (var user in resultSearchUsers) {
        print('UserName: ${user['user_name']}, Email: ${user['email']}');
      }
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
    return usersCollection.docs
        .map((doc) => doc.data())
        .toList();
  } else {
    return usersCollection.docs
        .where((doc) {
          var userName = doc.data()['user_name'].toString().toLowerCase().trim();
          return userName.contains(searchQuery);
        })
        .map((doc) => doc.data())
        .toList();
  }
}
