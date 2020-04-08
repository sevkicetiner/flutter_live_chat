import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livechat/models/chats.dart';
import 'package:livechat/models/message.dart';
import 'package:livechat/models/user.dart';
import 'package:livechat/services/db_base.dart';

class FirestoreDBService implements DBBase {
  Firestore _firestore = Firestore.instance;

  @override
  Future<bool> saveUser(User user) async {
    Map _userMap = user.toMap();
    _userMap['createAt'] = FieldValue.serverTimestamp();
    _userMap['updateAt'] = FieldValue.serverTimestamp();
    await _firestore
        .collection("users")
        .document(user.userID)
        .setData(_userMap);

//    DocumentSnapshot _okunanDosya = await Firestore.instance.document("users/${user.userID}").get();
//
//    User _okunanUser = User.fromMap(_okunanDosya.data);
//
//    print(_okunanUser.toString());

    return true;
  }

  @override
  Future<User> readUser(String userID) async {
    DocumentSnapshot _okunanUser =
        await _firestore.collection("users").document(userID).get();

    User user = User.fromMap(_okunanUser.data);
    return user;
  }

  @override
  Future<bool> updateUserName(String userID, String newUserName) async {
    var users = await _firestore
        .collection("users")
        .where('userName', isEqualTo: newUserName)
        .getDocuments();

    if (users.documents.length >= 1) {
      return false;
    } else {
      await _firestore
          .collection("users")
          .document(userID)
          .updateData({'userName': newUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfileFoto(String userID, String profilFotoUrl) async {
    await _firestore
        .collection('users')
        .document(userID)
        .updateData({'profilURL': profilFotoUrl});
    return true;
  }

//  @override
//  Future<List<User>> getAllUser() async {
//    QuerySnapshot _querysnapshot =
//        await _firestore.collection("users").getDocuments();
//    List<User> userList = [];
//    _querysnapshot.documents.forEach((item) {
//      userList.add(User.fromMap(item.data));
//    });
//    return userList;
//  }

  @override
  Stream<List<Message>> getMessage(
      String currentUserID, String talkingUserID) {
    var snapshot = _firestore
        .collection("chats")
        .document(currentUserID + "--" + talkingUserID)
        .collection("messages")
        .orderBy("dateTime", descending: true)
        .limit(1)
        .snapshots();
    return snapshot.map((messageList)=> messageList.documents.map((message)=>Message.fromMap(message.data)).toList());
  }

  @override
  Stream<List<Message>> getMessages(
      String currentUserID, String talkingUserID) {
    var snapshot = _firestore
        .collection("chats")
        .document(currentUserID + "--" + talkingUserID)
        .collection("messages")
        .orderBy("dateTime", descending: true)
        .snapshots();
    Stream<List<Message>> list = Stream.empty();
    list = snapshot.map((mesajlistesi)=>mesajlistesi.documents.map((mesaj)=>Message.fromMap(mesaj.data)).toList());

    return list;
  }



  @override
  Future<bool> saveMessage(Message message) async {
    var messageMap = message.toMap();

    var _messageID = _firestore.collection("chats").document().documentID;
    var _myDocumentID = message.fromWho + "--" + message.toWho;
    var _receiverDocumentID = message.toWho + "--" + message.fromWho;
    await _firestore
        .collection("chats")
        .document(_myDocumentID)
        .collection('messages')
        .document(_messageID)
        .setData(message.toMap());

    await _firestore.collection('chats').document(_myDocumentID).setData({
        'who': message.fromWho,
        'withWho': message.toWho,
        'isShowed': false,
        'sendTime': FieldValue.serverTimestamp(),
        'content': message.content,
        'seeTime': FieldValue.serverTimestamp()
  });


    messageMap.update("isMy", (_) => false);

    await _firestore
        .collection("chats")
        .document(_receiverDocumentID)
        .collection('messages')
        .document(_messageID)
        .setData(messageMap);

    await _firestore.collection('chats').document(_receiverDocumentID).setData({
      'who': message.toWho,
      'withWho': message.fromWho,
      'isShowed': false,
      'sendTime': FieldValue.serverTimestamp(),
      'content': message.content,
      'seeTime': FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<List<Chat>> getAllChats(String userID) async {
   QuerySnapshot querySnapshot = await _firestore.collection('chats').where('who', isEqualTo: userID).orderBy('sendTime').getDocuments();

   List<Chat> allChats = [];
   for (DocumentSnapshot chatMap in querySnapshot.documents){
     print(chatMap.data.toString());
     Chat _chat = Chat.fromMap(chatMap.data);
     allChats.add(_chat);
   }
   return allChats;
  }

  @override
  Future<List<User>> getAllUserPagination(User lastUser, int itemCount) async{
    List<User> _userList = [];
      QuerySnapshot _querysnapshot;

    if (lastUser == null) {
      _querysnapshot = await Firestore.instance
          .collection('users')
          .orderBy('userName')
          .limit(itemCount)
          .getDocuments();
    } else {
      _querysnapshot = await Firestore.instance
          .collection('users')
          .orderBy('userName')
          .startAfter([lastUser.userName])
          .limit(itemCount)
          .getDocuments();
      await Future.delayed(Duration(seconds: 1));
    }

    for(DocumentSnapshot snap in _querysnapshot.documents){
      _userList.add(User.fromMap(snap.data));
    }

      return _userList;
  }

  Future<List<Message>> getMessagesWithPagination(String currentUser, String talkingUser, Message lastMessage, int itemCount) async{
    List<Message> _messageList = [];
    QuerySnapshot _querysnapshot;

    if (lastMessage == null) {
      _querysnapshot = await Firestore.instance
          .collection('chats')
          .document(currentUser+"--"+talkingUser)
          .collection('messages')
          .orderBy('dateTime', descending: true)
          .limit(itemCount)
          .getDocuments();
    } else {
      _querysnapshot = await Firestore.instance
          .collection('chats')
          .document(currentUser+"--"+talkingUser)
          .collection('messages')
          .orderBy('dateTime', descending: true)
          .startAfter([lastMessage.dateTime])
          .limit(itemCount)
          .getDocuments();
      print("yeni gelen mesajlar =>  "+_querysnapshot.documents.toList().toString());
      await Future.delayed(Duration(seconds: 1));
    }
    for(DocumentSnapshot snap in _querysnapshot.documents){
      Message _oneMessage = Message.fromMap(snap.data);
      print("gelen mesaj  : ${_oneMessage.content}");
      _messageList.add(_oneMessage);
    }

    return _messageList;
  }
}
