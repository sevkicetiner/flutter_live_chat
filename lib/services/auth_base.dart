

import 'package:livechat/models/user.dart';

abstract class AuthBase {
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<bool> signOut();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithEmailPassword(String email, String password);
  Future<User> createWithEmailPassword(String email, String password);
}