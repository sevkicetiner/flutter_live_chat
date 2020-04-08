import 'package:flutter/material.dart';
import 'package:livechat/app/landing_page.dart';
import 'package:livechat/locator.dart';
import 'package:livechat/viewmodels/UserViewModels.dart';
import 'package:livechat/repository/user_respository.dart';
import 'package:livechat/services/fake_auth_service.dart';
import 'package:livechat/services/firebase_auth_service.dart';
import 'package:livechat/app/sign_in/sign_in_page.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context)=>UserModel(),
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.cyan,
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
    ));
  }
}
