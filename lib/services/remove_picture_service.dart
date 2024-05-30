import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> removePictureService(
  String filePath,
  String fileName,
) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  try {
    await FirebaseStorage.instance.ref().child(filePath).delete();

    if (fileName == 'avatar') {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'avatar_link': ''});
    }
    else {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pictures')
          .get();

      for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
        if (doc['file_name'] == fileName) {
          await doc.reference.delete();
          break;
        }
      }

      final QuerySnapshot newQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pictures')
          .get();

      if (newQuerySnapshot.docs.isEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'count_image': 0});
      }
    }
    return 'Success';
  }
  catch (e) {
    return 'Fail';
  }
}
