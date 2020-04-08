import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livechat/app/sign_in/email_password_login_page.dart';
import 'package:livechat/common_widgets/social_log_in_button.dart';
import 'package:livechat/viewmodels/UserViewModels.dart';
import 'package:livechat/models/user.dart';
import 'package:livechat/services/auth_base.dart';
import 'package:livechat/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';


class SignInPage extends StatelessWidget {


  void _anonymous(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    User _user = await _userModel.signInAnonymously();
    print("Anonymous oturum acildi  id : "+_user.userID);
  }
  _googleSignIn(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    User _user = await _userModel.signInWithGoogle();
    print("Google oturum acildi  id : ${_user.userID}");
  }

  void _facebookSignIn(BuildContext context) async {
//    final _userModel = Provider.of<UserModel>(context, listen: false);
//    User _user = await _userModel.signInWithFacebook();
//    print("FAcebook oturum acildi  id : "+_user.userID);
  }

  void _emailPasswordLogin(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EmailPasswordLoginPage(), fullscreenDialog: true));
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Live Chat"),
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sign In",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            SocialLoginButton(
              buttonText: "Sign in with Google",
              buttonIcon: Image.asset("assets/images/google.png", height: 30, width: 30,),
              buttonColor: Colors.white,
              textColor: Colors.black87,
              onPressed: () =>_googleSignIn(context),
            ),
            SocialLoginButton(
              buttonText: "Sign in with Facebook",
              buttonIcon: Image.asset("assets/images/facebook.png", height: 40, width: 40,),
              onPressed: (){_facebookSignIn(context);},
            ),
            SocialLoginButton(
              buttonText: "Sign in with Email",
              buttonIcon: Icon(Icons.mail, color: Colors.black54,),
              buttonColor: Colors.grey.shade300,
              textColor: Colors.black87,
              onPressed: (){_emailPasswordLogin(context);},
            ),
            SocialLoginButton(
              buttonText: "Sign in as Anonim",
              onPressed: (){_anonymous(context);},
              buttonColor: Colors.white,
              textColor: Colors.black87,
            )
          ],
        ),
      ),
    );
  }






}
