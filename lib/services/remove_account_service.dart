import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qualification_work/screens/mobile/auth/mobile_start_screen.dart';
import 'package:flutter_qualification_work/screens/web/auth/web_start_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

void removeAccount(BuildContext context) async {
  try {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect();
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  //remove user info from database
  final userId = FirebaseAuth.instance.currentUser!.uid;

  try {
    final data =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final Reference directoryRef = await FirebaseStorage.instance
        .ref()
        .child('pictures/${data['user_name']}');

    final ListResult result = await directoryRef.listAll();

    for (final Reference fileRef in result.items) {
      await fileRef.delete();
    }
  } catch (e) {
    if (kDebugMode) {
      print("User don't have info in database and avatar!");
    }
  }
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('pictures')
        .get();

    for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  } catch (e) {
    if (kDebugMode) {
      print("User don`t have info in database!");
    }
  }
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('followers')
        .get();

    for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(doc['uid'])
          .collection('subscriptions')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .delete();
    }
    for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  } catch (e) {
    if (kDebugMode) {
      print("User don`t have followers in database!");
    }
  }

  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('subscriptions')
        .get();

    for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(doc['uid'])
          .collection('followers')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .delete();
    }
    for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  } catch (e) {
    if (kDebugMode) {
      print("User don`t have subscriptions in database!");
    }
  }

  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chat_id_users')
        .get();

    for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
      List<String> ids = [userId, doc['user_id']];
      ids.sort();
      String chatRoomId = ids.join("_");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('chat_id_users')
          .doc(doc['user_id'])
          .delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(doc['user_id'])
          .collection('chat_id_users')
          .doc(userId)
          .delete();

      DocumentReference chatRoomDoc =
          FirebaseFirestore.instance.collection('chat_rooms').doc(chatRoomId);
      CollectionReference messagesCollection =
          chatRoomDoc.collection('messages');
      QuerySnapshot messagesSnapshot = await messagesCollection.get();
      for (QueryDocumentSnapshot doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }
      await chatRoomDoc.delete();
    }
  } catch (e) {}

  await FirebaseFirestore.instance.collection('users').doc(userId).delete();

  await FirebaseAuth.instance.authStateChanges().listen((User? user) {
    user?.delete();
  });

  FirebaseAuth.instance.signOut();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => kIsWeb ? WebStartScreen() : MobileStartScreen(),
    ),
  );
}
