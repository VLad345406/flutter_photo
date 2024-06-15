import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<double> calculateProfileListviewHeight(
    BuildContext context, String uid) async {
  double result = 0;

  final collection = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('contents')
      .get();

  print('Collection length: ${collection.size}');

  for (var file in collection.docs) {
    if (file['file_type' == 'music']) {
      result += 150;
    }
    else {
      result += MediaQuery.of(context).size.width - 32;
    }
  }
  print('Result: $result');

  return result;
}
