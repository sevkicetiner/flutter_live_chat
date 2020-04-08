


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:livechat/locator.dart';
import 'package:livechat/models/user.dart';
import 'package:livechat/repository/user_respository.dart';

enum AllUserViewState {Idle, Loaded,Busy}
class AllUserViewModel with ChangeNotifier {

  AllUserViewState _state = AllUserViewState.Idle;
  List<User>_userList;
  User _lastUser;
  static final itemCount = 15;
  UserRepository _userRepository = getIt<UserRepository>();

  bool _hasMore = true;

  get hasMoreLoading => _hasMore;


  List<User> get userList => _userList;

  AllUserViewState  get state => _state;
  set state (AllUserViewState value){
    _state = value;
    notifyListeners();
  }

  AllUserViewModel() {
    _userList = [];
    _lastUser = null;
    getUsersWithPagination(_lastUser, false);
  }


  Future<void> getUsersWithPagination(User lastUser, bool gettingNewUsers)async {
    if(_userList.length > 0){
      _lastUser = userList.last;
      print("last username  :"+_lastUser.userName);
    }

    if(!gettingNewUsers)
      state =AllUserViewState.Busy;

    List<User> newUserList = await _userRepository.getAllUsersPagination(lastUser, itemCount);

    if(newUserList.length <itemCount){
      _hasMore = false;
    }

    _userList.addAll(newUserList);
    state = AllUserViewState.Loaded;
  }

  Future<void> getMoreUser() async {
    print("getMoreUSer  tetiklendi");
    if(_hasMore) getUsersWithPagination(_lastUser, true);

    await Future.delayed(Duration(seconds: 2));

  }

  Future<Null> refresh() async{
    _hasMore=true;
    _lastUser = null;
    _userList = [];
    getUsersWithPagination(_lastUser, true);
    return null;
  }
}