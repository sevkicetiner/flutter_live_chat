import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:livechat/models/user.dart';
import 'package:livechat/services/auth_base.dart';
import 'package:livechat/services/firestore_db_service.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FirebaseAuthSevice implements AuthBase {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<User> currentUser() async {

    try{
      FirebaseUser user = await _firebaseAuth.currentUser();
      return _userFromFirebase(user);
    } catch(e){
      print("HATA currentUser ${e.toString()}");
      return null;
    }
  }

  User _userFromFirebase(FirebaseUser user){
    if(user == null){
      print("user null bulundu  ${user.uid}");
      return null;
    } else return User(userID: user.uid ,email: user.email );
  }


  @override
  Future<bool> signOut()  async {

    try{
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    //  await FacebookLogin().logOut();
      return true;
    }catch(e){
      print("sign out hata: "+e.toString());
      return false;
    }


  }

  @override
  Future<User> signInAnonymously() async {
    try{
      AuthResult result = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(result.user);
    }catch(e){
      print("HATA signInAnonymously :" +e.toString());
      return null;
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount _googleUser = await _googleSignIn.signIn();

    if(_googleUser != null ){
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if(_googleAuth.idToken !=null && _googleAuth.accessToken != null){
        AuthResult result = await _firebaseAuth.signInWithCredential(GoogleAuthProvider.getCredential(idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken));
        FirebaseUser _user = result.user;
        return _userFromFirebase(_user);
      }else return null;
    }else return null;
  }

  @override
  Future<User> signInWithFacebook() async {
//    final _facebookLogin = FacebookLogin();
//    FacebookLoginResult _facebookLoginResult = await _facebookLogin.logIn(['public_profile', 'email']);
//    switch(_facebookLoginResult.status){
//
//      case FacebookLoginStatus.loggedIn:
//        if(_facebookLoginResult.accessToken !=null){
//          AuthResult result = await _firebaseAuth.signInWithCredential(FacebookAuthProvider.getCredential(accessToken: _facebookLoginResult.accessToken.token));
//          FirebaseUser _user = result.user;
//          return _userFromFirebase(_user);
//        }
//        break;
//      case FacebookLoginStatus.cancelledByUser:
//        // TODO: Handle this case.
//        break;
//      case FacebookLoginStatus.error:
//        // TODO: Handle this case.
//        break;
//    }
    return null;
  }

  @override
  Future<User> signInWithEmailPassword(email, password) async {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user);
  }

  @override
  Future<User> createWithEmailPassword(String email, String password) async {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user);
  }

}