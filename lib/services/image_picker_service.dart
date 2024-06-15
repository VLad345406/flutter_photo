import 'dart:io';
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

Future<String> uploadImageToStorage(
    String userName, String fileName, Uint8List file) async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.ref().child('content/$userName/$fileName');
  UploadTask uploadTask = ref.putData(file);
  TaskSnapshot snapshot = await uploadTask;
  String downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}

Future<String> uploadFileToStorage(
    String userName, String fileName, dynamic file) async {
  try {
    final FirebaseStorage storage = FirebaseStorage.instance;
    TaskSnapshot uploadTask =
        await storage.ref('content/$userName/$fileName').putFile(File(file.path));
    String downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print(e);
    return "";
  }
}

Future<String> saveAvatar(
  String email,
  String uid,
  String userName,
  Uint8List file,
) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String result = 'Some errors occurred!';
  try {
    String imageUrl = await uploadImageToStorage(userName, 'avatar', file);
    await firestore
        .collection('users')
        .doc(uid)
        .update({'avatar_link': imageUrl});
    result = 'Success avatar change!';
  } catch (e) {
    result = e.toString();
  }
  return result;
}

Future savePictureInFirestore(
  String uid,
  String userName,
  Uint8List file,
  int pictureNumber,
  String tags,
) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    List<String> listTags = tags.split(' ');

    String imageUrl =
        await uploadImageToStorage(userName, pictureNumber.toString(), file);
    await firestore
        .collection('users')
        .doc(uid)
        .collection('contents')
        .doc(pictureNumber.toString())
        .set({
      'file_link': imageUrl,
      'file_name': pictureNumber.toString(),
      'tags': listTags,
      'file_type' : 'image',
    });
    await firestore
        .collection('users')
        .doc(uid)
        .update({'count_image': pictureNumber});
  } catch (e) {}
}
