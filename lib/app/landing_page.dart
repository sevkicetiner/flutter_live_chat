
import 'package:flutter/material.dart';
import 'package:livechat/app/home_page.dart';
import 'package:livechat/viewmodels/UserViewModels.dart';
import 'package:livechat/app/sign_in/sign_in_page.dart';
import 'package:provider/provider.dart';


class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _userModel = Provider.of<UserModel>(context, listen: true);

    print(_userModel == null);


    if (_userModel.userState == ViewState.Idle) {

      if(_userModel.user == null){
        return SignInPage();
      } else {
        return HomePage(key:key,user: _userModel.user);
      }

    } else {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

  }
}
