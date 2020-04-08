
import 'package:livechat/models/user.dart';
import 'package:livechat/services/auth_base.dart';

class FakeAuthenticationService implements AuthBase{

  String userId= "25234535234524523";

  @override
  Future<User> currentUser() async {
    return await Future.value(User(userID: userId, email: 'face@famemail.com'));
  }

  @override
  Future<bool> signOut() async {
    return Future.value(true);
  }

  @override
  Future<User> signInAnonymously() async {
    return await Future.delayed(Duration(seconds: 2),()=>User(userID: userId, email: 'face@famemail.com'));
  }

  @override
  Future<User> signInWithGoogle() async {
    return await Future.delayed(Duration(seconds: 2),()=>User(userID: userId, email: 'face@famemail.com'));
  }

  @override
  Future<User> signInWithFacebook() async {
    return await Future.delayed(Duration(seconds: 2),()=>User(userID: userId, email: 'face@famemail.com'));
  }

  @override
  Future<User> signInWithEmailPassword(email, password) {

  }

  @override
  Future<User> createWithEmailPassword(String email, String password) {
    // TODO: implement createWithEmailPassword
    return null;
  }

}