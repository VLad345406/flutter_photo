import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/classes/picture.dart';
import 'package:flutter_qualification_work/classes/user.dart';
import 'package:flutter_qualification_work/services/snack_bar_service.dart';

Future<List<dynamic>> searchService(BuildContext context, String value) async {
  try {
    if (value[0] == '@') {
      snackBar(context, 'User search');
      //var mapUsers = await FirebaseFirestore.instance.collection('user').get();
      print('before get users');
      List<MyUser> listUsers = await fetchUsers();
      print('after get users');
      for (int i = 0; i < listUsers.length; i++) {
        print(listUsers[i].userName);
      }

    }
    if (value[0] == '#') {
      snackBar(context, 'Tag search');
    }
  }catch (e) {
    if (kDebugMode) {
      print('Out of range');
    }
  }
  return [];
}

Future<List<MyUser>> fetchUsers() async {
  List<MyUser> users = [];

  try {
    // Get the collection reference
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

    // Fetch the collection snapshot
    QuerySnapshot snapshot = await usersCollection.get();
    print(snapshot);

    // Iterate over the documents and convert them to User objects
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Convert the pictures field to a List<Picture>
      List<Picture> pictures = (data['pictures'] as List<dynamic>)
          .map((item) => Picture.fromMap(item as Map<String, dynamic>))
          .toList();

      // Add the pictures field to the data map
      data['pictures'] = pictures;

      // Create a User object from the map and add it to the list
      MyUser user = MyUser.fromMap(data);
      users.add(user);
    }
  } catch (e) {
    print("Error fetching users: $e");
  }

  return users;
}

