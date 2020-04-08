

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String fromWho;
  final String toWho;
  final bool isMy;
  final String content;
  final Timestamp dateTime;

  Message({this.fromWho, this.toWho, this.isMy, this.content, this.dateTime});

  Map<String, dynamic> toMap(){
    return {
      'fromWho' : fromWho,
      'toWho' : toWho,
      'isMy' : isMy,
      'content' : content,
      'dateTime' : dateTime ?? FieldValue.serverTimestamp()
    };
  }


  Message.fromMap(Map<String, dynamic> map):
      fromWho = map['fromWho'],
      toWho = map['toWho'],
      isMy = map['isMy'],
      content = map['content'],
      dateTime = map['dateTime'];
}