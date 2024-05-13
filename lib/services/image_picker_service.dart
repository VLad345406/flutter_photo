import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}

Future<String> uploadImageToStorage(String childName, Uint8List file) async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.ref().child('avatars/$childName');
  UploadTask uploadTask = ref.putData(file);
  TaskSnapshot snapshot = await uploadTask;
  String downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}

Future<String> saveData(
    String email,
    String uid,
    String userName,
    Uint8List file,
    ) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String result = 'Some errors occurred!';
  try {
    String imageUrl = await uploadImageToStorage(userName, file);
    await firestore
        .collection('users')
        .doc(uid)
        .update({'image_link': imageUrl});
    result = 'Success avatar change!';
  } catch (e) {
    result = e.toString();
  }
  return result;
}
