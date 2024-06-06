import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/classes/picture.dart';
import 'package:flutter_qualification_work/classes/user.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';

dynamic searchService(BuildContext context, String value) async {
  try {
    if (value[0] == '@') {
      snackBar(context, 'User search');

      QuerySnapshot<Map<String, dynamic>> usersCollection =
          await FirebaseFirestore.instance.collection('users').get();
      //print(usersCollection.size);

      List<Map<String, dynamic>> resultSearchUsers =
          searchUsers(value, usersCollection);

      print(resultSearchUsers.length);

      for (var user in resultSearchUsers) {
        print('UserName: ${user['user_name']}, Email: ${user['email']}');
      }

      /*for (int i = 0; i < resultSearchUsers.length; i++) {
        String tempStr = resultSearchUsers[i]['user_name'];
        if (tempStr.contains(other))
        print(resultSearchUsers[i]['user_name']);
      }*/

      /*for (int i = 0; i < usersCollection.size; i++) {
        print(usersCollection.docs[i]['user_name']);
      }*/
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

List<Map<String, dynamic>> searchUsers(String query, QuerySnapshot<Map<String, dynamic>>? usersCollection) {
  print(query);
  String searchQuery = query.replaceAll('@', '').toLowerCase().trim();
  if (usersCollection == null) {
    return [];
  }
  if (query == '@' && query.length == 1) {
    return usersCollection.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } else {
    return usersCollection.docs
        .where((doc) {
      var userName = doc.data()['name'].toString().toLowerCase().trim();
      return userName.contains(searchQuery);
    })
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}

/*List<Map<String, dynamic>> searchUsers(String query, QuerySnapshot<Map<String, dynamic>>? usersCollection) {
  //print(query);
  String searchQuery = query.replaceAll('@', '').toLowerCase();
  if (usersCollection == null) {
    return [];
  }
  if (query == '@' && query.length == 1) {
    return usersCollection.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } else {
    return usersCollection.docs
        .where((doc) =>
        doc.data()['name'].toString().toLowerCase().contains(searchQuery))
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}*/


/*Future<QuerySnapshot<Map<String, dynamic>>> fetchUsers() async {
  QuerySnapshot<Map<String, dynamic>> usersCollection;
  try {
    usersCollection =
        await FirebaseFirestore.instance.collection('users').get();
  } catch (e) {
    print("Error fetching users: $e");
  }

  return usersCollection;
}*/
