

import 'package:livechat/models/chats.dart';
import 'package:livechat/models/message.dart';
import 'package:livechat/models/user.dart';

abstract class DBBase{
  Future<bool> saveUser(User user);
  Future<User> readUser(String userID);
  Future<bool> updateUserName(String userID, String newUserName);
  Future<bool> updateProfileFoto(String userID, String profilFotoUrl);
  Future<List<User>> getAllUserPagination(User lastUser, int itemCount);
  Future<List<Chat>> getAllChats(String userID);
  Stream<List<Message>> getMessages(String currentUserID, String talkingUserID);
  Future<bool> saveMessage(Message message);
}