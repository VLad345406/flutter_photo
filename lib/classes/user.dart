import 'package:flutter_qualification_work/classes/picture.dart';

class MyUser {
  String avatarLink;
  int countImage;
  String email;
  String name;
  String uid;
  String userName;
  List<Picture> pictures;
  List<String> subscriptions;

  MyUser({
    required this.avatarLink,
    required this.countImage,
    required this.email,
    required this.name,
    required this.uid,
    required this.userName,
    required this.pictures,
    required this.subscriptions,
  });

  Map<String, dynamic> toMap() {
    return {
      'avatar_link': avatarLink,
      'count_image': countImage,
      'email': email,
      'name': name,
      'uid': uid,
      'user_name': userName,
      'subscriptions': subscriptions,
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
      pictures: map['pictures'],
      subscriptions: map['subscriptions'],
    );
  }
}
