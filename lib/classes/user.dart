import 'package:flutter_qualification_work/classes/file.dart';

class MyUser {
  String avatarLink;
  int countImage;
  String email;
  String name;
  String uid;
  String userName;
  List<File> contents;
  List<String> subscriptions;
  List<String> followers;

  MyUser({
    required this.avatarLink,
    required this.countImage,
    required this.email,
    required this.name,
    required this.uid,
    required this.userName,
    required this.contents,
    required this.subscriptions,
    required this.followers,
  });

  Map<String, dynamic> toMap() {
    return {
      'avatar_link': avatarLink,
      'count_image': countImage,
      'email': email,
      'name': name,
      'uid': uid,
      'user_name': userName,
      'contents' : contents,
      'subscriptions': subscriptions,
      'followers': followers,
    };
  }

  static MyUser fromMap(Map<String, dynamic> map) {
    return MyUser(
      avatarLink: map['avatar_link'],
      countImage: map['count_image'],
      email: map['email'],
      name: map['name'],
      uid: map['uid'],
      userName: map['user_name'],
      contents: map['contents'],
      subscriptions: map['subscriptions'],
      followers: map['followers'],
    );
  }
}
