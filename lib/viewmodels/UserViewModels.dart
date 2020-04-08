import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livechat/locator.dart';
import 'package:livechat/models/chats.dart';
import 'package:livechat/models/message.dart';
import 'package:livechat/models/user.dart';
import 'package:livechat/repository/user_respository.dart';
import 'package:livechat/services/auth_base.dart';
import 'package:livechat/services/firestore_db_service.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  UserModel() {
    currentUser();
  }

  ViewState _userState = ViewState.Idle;

  UserRepository _userRepository = getIt<UserRepository>();

  User _user;

  User get user => _user;

  set user(User value) {
    _user = value;
  }

  String errorEmailMessage = null, errorPasswordMessage =null;

  ViewState get userState => _userState;

  set userState(ViewState value) {
    _userState = value;
    notifyListeners();
  }

  @override
  Future<bool> signOut() async {
    try {
      userState = ViewState.Busy;
      bool result = await _userRepository.signOut();
      _user = null;
      return result;
    } catch (e) {
      print("Error : UserViewModel.currentUser() =>  " + e.toString());
      return false;
    } finally {
      userState = ViewState.Idle;
    }
  }

  @override
  Future<User> signInAnonymously() async {
    try {
      userState = ViewState.Busy;
      _user = await _userRepository.signInAnonymously();
      return _user;
    } catch (e) {
      print("Error : UserViewModel.signInAnonymous() =>  " + e.toString());
      return null;
    } finally {
      userState = ViewState.Idle;
    }
  }

  @override
  Future<User> currentUser() async {
    try {
      userState = ViewState.Busy;
      _user = await _userRepository.currentUser();
      print("current userdaki repodan gelen  :"+_user.toString());
    } catch (e) {
      print("Error : UserViewModel.currentUser() =>  " + e.toString());
      return null;
    } finally {
      userState = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      userState = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      return _user;
    } catch (e) {
      print("Error : UserViewModel.signInGoogle() =>  " + e.toString());
      return null;
    } finally {
      userState = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithFacebook() async {
//    try {
//      userState = ViewState.Busy;
//      _user = await _userRepository.signInWithFacebook();
//      return _user;
//    } catch (e) {
//      print("Error : UserViewModel.signInGoogle() =>  " + e.toString());
//    } finally {
//      userState = ViewState.Idle;
//    }
    return null;
  }

  @override
  Future<User> signInWithEmailPassword(email, password) async {
    try {
      if(_emailPasswordControl(email, password)) {
        userState = ViewState.Busy;
        _user = await _userRepository.signInWithEmailPassword(email, password);
        return _user;
      } else {
        print("_emailPasswordControl   true dondermiyor");
        return null;
      }
    }  finally {
      userState = ViewState.Idle;
    }
  }

  @override
  Future<User> createWithEmailPassword(String email, String password) async {
    try {
      if (_emailPasswordControl(email, password)) {
        userState = ViewState.Busy;
        _user = await _userRepository.createWithEmailPassword(email, password);  ///burda bor problem var profile page de foto bos geliyor
        return _user;
      } else {
        return null;
      }
    } finally {
      userState = ViewState.Idle;
    }

  }

  bool _emailPasswordControl(String email, String password) {
    print("control noktasi : .$email.      .$password.");
    bool result = true;
    errorEmailMessage = null;
    errorPasswordMessage = null;
    if(!email.contains("@")){
      errorEmailMessage = "Email is not correct";
    } else if(password.length <6){
      errorPasswordMessage = "Password most be greater then 6 characters.";
    }
    return result;
  }

  Future<bool> updateUsername(String userID, String newUserName) async {
    bool result = await _userRepository.updateUserName(userID, newUserName);
    if(result)
      _user.userName = newUserName;
    return result;
  }

  Future<String> uploadFile(String userID, String fileName, File image) async {
    var result = await _userRepository.uploadFile(userID, fileName, image);
    return result;
  }

//  Future<List<User>> getAllUsersPagination(User lastUser, int itemCount)async{
//    return await _userRepository.getAllUsersPagination(lastUser, itemCount);
//  }

  Stream<List<Message>> getMeessages(String currentUser, String talkingUser) {
    try{
      return _userRepository.getMessages(currentUser, talkingUser);
    } catch(e){print(e.toString());}

  }

  Future<bool> sendMessage(message) {
   return _userRepository.saveMessage(message);
  }

  Future<List<Chat>> getAllChats(String userID)async{
    try {
      var result = await _userRepository.getAllChats(userID);
      return result;
    } on PlatformException catch (e){
      print(e.toString());
    }
  }
}
