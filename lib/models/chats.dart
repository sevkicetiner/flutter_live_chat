

import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String who;
  final String withWho;
  final bool isShowed;
  final String content;
  final Timestamp sendTime;
  final Timestamp seeTime;
  String withWhoUserName = "";
  String withWhoProfileURL = "";

  Chat({this.who, this.withWho, this.isShowed, this.content, this.sendTime, this.seeTime});

  Map<String, dynamic> toMap(){
    return {
      'who' : who,
      'withWho' : withWho,
      'isShowed' : isShowed,
      'content' : content,
      'sendTime' : sendTime ?? FieldValue.serverTimestamp(),
      'seeTime' : seeTime
    };
  }


  Chat.fromMap(Map<String, dynamic> map):
        who = map['who'],
        withWho = map['withWho'],
        isShowed = map['isShowed'],
        content = map['content'],
        sendTime = map['sendTime'],
        seeTime = map['seeTime'];

}