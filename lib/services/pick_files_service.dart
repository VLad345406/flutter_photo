import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'image_picker_service.dart';

Future<Uint8List> selectGalleryImage() async {
  Uint8List image = Uint8List(0);
  try {
    image = await pickImage(ImageSource.gallery);
    return image;
  } catch (e) {
    return image;
  }
}

Future<Uint8List> addCameraImage() async {
  Uint8List image = Uint8List(0);
  try {
    image = await pickImage(ImageSource.camera);
    return image;
  } catch (e) {
    return image;
  }
}

Future<void> pickAudioFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['mp3', 'wav', 'm4a'],
  );

  if (result != null) {
    PlatformFile file = result.files.first;

    final userId = FirebaseAuth.instance.currentUser!.uid;
    final data =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final userName = data['user_name'];

    String fileUrl = await uploadFileToStorage(userName, file.name, file);

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      List<String> listTags = [];

      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('contents')
          .doc(file.name)
          .set({
        'file_link': fileUrl,
        'file_name': file.name,
        'file_type' : 'music',
        'tags': listTags,
      });
    } catch (e) {}
  } else {
    print('No audio file selected');
  }
}

Future<void> pickVideoFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['mp4', 'avi', 'mov'],
  );

  if (result != null) {
    PlatformFile file = result.files.first;

    final userId = FirebaseAuth.instance.currentUser!.uid;
    final data =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final userName = data['user_name'];

    String fileUrl = await uploadFileToStorage(userName, file.name, file);

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      List<String> listTags = [];

      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('contents')
          .doc(file.name)
          .set({
        'file_link': fileUrl,
        'file_name': file.name,
        'file_type' : 'video',
        'tags': listTags,
      });
    } catch (e) {}
  } else {
    print('No video file selected');
  }
}
