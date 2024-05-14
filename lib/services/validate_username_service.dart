import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> validateUsername(String username) async {
  bool exists = false;

  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('user_name', isEqualTo: username)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      exists = true;
    }
  } catch (e) {}

  return exists;
}