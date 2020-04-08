import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  User({@required this.userID, @required this.email});
  User.idProfileUrl({@required this.userID,@required this.userName,@required this.profilURL});
  final String userID;
  String email;
  String userName;
  String profilURL;
  DateTime createdAt;
  DateTime updateAt;
  int level;

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      "email": email,
      "userName": userName ?? email.substring(0, email.indexOf('@'))+randomCreator() ,
      "profilURL": profilURL ?? 'https://i.pinimg.com/originals/0d/36/e7/0d36e7a476b06333d9fe9960572b66b9.jpg',
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
      "updateAt": updateAt ?? FieldValue.serverTimestamp(),
      "level": level ?? 1,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profilURL = map['profilURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updateAt = (map['updateAt'] as Timestamp).toDate(),
        level = map['level'];

  @override
  String toString() {
    return 'User{userID: $userID, email: $email, userName: $userName, profilURL: $profilURL, createdAt: $createdAt, updateAt: $updateAt, level: $level}';
  }

  String randomCreator() {
    int rasgeleSayi = Random().nextInt(999999);
    return rasgeleSayi.toString();
  }


}
