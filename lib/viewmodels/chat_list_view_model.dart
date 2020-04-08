
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:livechat/locator.dart';
import 'package:livechat/models/chats.dart';
import 'package:livechat/models/message.dart';
import 'package:livechat/models/user.dart';
import 'package:livechat/repository/user_respository.dart';
import 'package:provider/provider.dart';

enum ChatViewState{idle, busy, loaded}

class ChatListViewModel with ChangeNotifier {
  List<Message> _allMessages;
  final User currentUser;
  final User talkingUser;
  ChatViewState _state = ChatViewState.idle;
  UserRepository _userRepository = getIt<UserRepository>();
  Message _lastMessage;
  final itemCount = 15;
  bool newMessageListener = false;
  Message _firsMessage ;
  StreamSubscription _streamSubscription;

  ChatListViewModel({this.currentUser, this.talkingUser}){
    _allMessages = [];
    getMessagesWithPagination();
  }

  List<Message> get allMessage => _allMessages;

  ChatViewState get state => _state;

  bool _hasMore =true;
  bool get hasMoreLoading => _hasMore;
  set state(ChatViewState value){
    _state = value;
    notifyListeners();
  }

  void getMessagesWithPagination() async{

    if(_allMessages.length>0){
      _lastMessage = _allMessages.last;
    }

    state = ChatViewState.busy;
    List<Message> newMessages = await _userRepository.getMessagesWithPagination(currentUser.userID, talkingUser.userID, _lastMessage, itemCount);


    _allMessages.addAll(newMessages);
    if(_allMessages.length>0){
      _firsMessage = _allMessages.first;
    }

    //print("listeye eklenen ilk mesaj"+ _firsMessage.content);
    if(newMessages.length<itemCount){
      _hasMore =false;
    }

    state = ChatViewState.idle;

    if(newMessageListener == false) {
      newMessageListener =true;
      print('listener yok o yuzden atanacak');
      newMessageListenerDefine();
    }


  }

  Future<bool> sendMessage(String messageContext) {
    Message _message = Message(
        fromWho: currentUser.userID,
        toWho: talkingUser.userID,
        content: messageContext,
        isMy: true);
    return _userRepository.saveMessage(_message);
  }

  Future<void> getMoreMessages() async {
    if(_hasMore){
      getMessagesWithPagination();
    }

    await Future.delayed(Duration(seconds: 2));
  }

  void newMessageListenerDefine() {
     _streamSubscription = _userRepository.getLastMessage(currentUser.userID, talkingUser.userID).listen((message){
      if(message.isNotEmpty){
        print("son dinlenen mesaj ${message[0].content}");
        if(message[0].dateTime != null){
          if(_firsMessage==null){
            _allMessages.insert(0, message[0]);
          }else if(_firsMessage.dateTime.millisecondsSinceEpoch != message[0].dateTime.millisecondsSinceEpoch){
            _allMessages.insert(0, message[0]);
          }
          //if(fistMessage.dateTime.microsecondsSinceEpoch != message[0].dateTime.microsecondsSinceEpoch)

        }
        state = ChatViewState.loaded;
      }
    });
  }

  @override
  void dispose() {
    print("dispos edildi");
    _streamSubscription.cancel();
    super.dispose();
  }
}