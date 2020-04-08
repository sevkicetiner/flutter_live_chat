import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:livechat/locator.dart';
import 'package:livechat/models/chats.dart';
import 'package:livechat/models/message.dart';
import 'package:livechat/models/user.dart';
import 'package:livechat/services/auth_base.dart';
import 'package:livechat/services/fake_auth_service.dart';
import 'package:livechat/services/firebase_auth_service.dart';
import 'package:livechat/services/firebase_storage_service.dart';
import 'package:livechat/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthSevice _firebaseAuthSevice = getIt<FirebaseAuthSevice>();
  FakeAuthenticationService _fakeAuthenticationService =
      getIt<FakeAuthenticationService>();
  FirestoreDBService _firestoreDBService = getIt<FirestoreDBService>();
  FirebaseStorageService _firebaseStorage = getIt<FirebaseStorageService>();
  AppMode appMode = AppMode.RELEASE;
  List<User> userList = [];

  @override
  Future<User> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.currentUser();
    } else {
      User _user = await _firebaseAuthSevice.currentUser();
      if (_user != null) {
        User userFromStore = await _firestoreDBService.readUser(_user.userID);
        _user = userFromStore;
        print("current userdaki firestore dan gelen : " +
            userFromStore.toString());
        return _user;
      } else
        return null;
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signOut();
    } else
      return await _firebaseAuthSevice.signOut();
  }

  @override
  Future<User> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInAnonymously();
    } else {
      return await _firebaseAuthSevice.signInAnonymously();
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithGoogle();
    } else {
      User user = await _firebaseAuthSevice.signInWithGoogle();
      bool result = await _firestoreDBService.saveUser(user);
      return result ? user : null;
    }
  }

  @override
  Future<User> signInWithFacebook() async {
//    if(appMode == AppMode.DEBUG){
//      return await _fakeAuthenticationService.signInWithFacebook();
//    } else {
//      return await _firebaseAuthSevice.signInWithFacebook();
//    bool result = await _firestoreDBService.signin(user);
//    return result? user:null;
//    }
    return null;
  }

  @override
  Future<User> signInWithEmailPassword(email, password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithEmailPassword(
          email, password);
    } else {
      return await _firebaseAuthSevice.signInWithEmailPassword(email, password);
    }
  }

  @override
  Future<User> createWithEmailPassword(String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.createWithEmailPassword(
          email, password);
    } else {
      User _user = await _firebaseAuthSevice.createWithEmailPassword(email, password);
      if (_user != null) {
        bool result = await _firestoreDBService.saveUser(_user);
        return _user;
      } else
        return null;
    }
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateUserName(userID, newUserName);
    }
  }

  Future<String> uploadFile(String userID, String fileName, File file) async {
    if (appMode == AppMode.DEBUG) {
      return "download_link";
    } else {

      var profilFotoUrl =  await _firebaseStorage.uploadFile(userID, fileName, file);
      await _firestoreDBService.updateProfileFoto(userID, profilFotoUrl);
      return profilFotoUrl;
    }
  }

  Future<List<User>> getAllUsersPagination(User lastUser, int itemCount) async {
    if(appMode == AppMode.DEBUG){
      return null;
    } else {
      List<User> _userList = await _firestoreDBService.getAllUserPagination(lastUser, itemCount);
      userList.addAll(_userList);
      return _userList;
    }
  }
  Stream<List<Message>> getMessages(String currentUser, String talkingUser) {
    if(appMode == AppMode.DEBUG){
      return Stream.empty();
    } else {
     return _firestoreDBService.getMessages(currentUser, talkingUser);
    }
  }

  Stream<List<Message>> getLastMessage(String currentUser, String talkingUser) {
    if(appMode == AppMode.DEBUG){
      return Stream.empty();
    } else {
      return _firestoreDBService.getMessage(currentUser, talkingUser);
    }
  }

  Future<List<Message>> getMessagesWithPagination(String currentUser, String talkingUser, Message lastMessage, int itemCount) async {
    if(appMode == AppMode.DEBUG){
      return null;
    } else {
      return _firestoreDBService.getMessagesWithPagination(currentUser, talkingUser, lastMessage, itemCount);
    }
  }

  Future<bool> saveMessage(message) {
    if(appMode == AppMode.DEBUG){
      return Future.value(true);
    }else {
      return _firestoreDBService.saveMessage(message);
    }
  }

  Future<List<Chat>> getAllChats(userID) async {
    if(appMode == AppMode.DEBUG){
      return Future.value(null);
    }else {
      List<Chat> chatlist = await _firestoreDBService.getAllChats(userID);
      for(int i=0;i<chatlist.length;i++){
        var bulunanUser = findUserInUserList(chatlist[i].withWho);
        if(bulunanUser != null){
          chatlist[i].withWhoUserName = bulunanUser.userName;
          chatlist[i].withWhoProfileURL = bulunanUser.profilURL;
        } else {
          var _userFromFirestore = await _firestoreDBService.readUser(chatlist[i].withWho);
          chatlist[i].withWhoUserName = _userFromFirestore.userName;
          chatlist[i].withWhoProfileURL = _userFromFirestore.profilURL;
        }
      }
      return chatlist;
    }
  }

  User findUserInUserList(String userID){
    for(int i =0; i< userList.length; i++){
      if(userList[i].userID == userID){
        return userList[i];
      }
    }
  }


  Chat searchUserList(Chat chat){

    for(User user in userList){
      if(chat.withWho == user.userID){
        print('bulunuyor kullancilar');
        chat.withWhoProfileURL = user.profilURL;
        chat.withWhoUserName = user.userName;
        print (chat.withWhoUserName +  "  "+ chat.withWhoProfileURL);
        return chat;
      }else return chat;
    }
  }

}
