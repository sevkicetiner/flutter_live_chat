import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:livechat/notification_handler.dart';
import 'package:livechat/app/profilePage.dart';
import 'package:livechat/app/usersPage.dart';
import 'package:livechat/app/my_custom_buttom_navbar.dart';
import 'package:livechat/app/tab_item.dart';
import 'package:livechat/viewmodels/UserViewModels.dart';
import 'package:livechat/models/user.dart';
import 'package:livechat/viewmodels/all_users_view_model.dart';
import 'package:provider/provider.dart';

import 'chats_list_page.dart';

class HomePage extends StatefulWidget {
  User user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Users;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Users : GlobalKey<NavigatorState>(),
    TabItem.Chats : GlobalKey<NavigatorState>(),
    TabItem.Profile : GlobalKey<NavigatorState>()
  };

  Map<TabItem, Widget> allPages() {
    return {
      TabItem.Users: ChangeNotifierProvider(child: UsersPage(), create: (context)=>AllUserViewModel(),),
      TabItem.Chats: ChatsListPage(),
      TabItem.Profile: ProfilePage()};
  }

//  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
//    if (message.containsKey('data')) {
//      // Handle data message
//      final dynamic data = message['data'];
//      print(data.toString());
//    }
//
//    if (message.containsKey('notification')) {
//      // Handle notification message
//      final dynamic notification = message['notification'];
//    }
//
//    // Or do other work.
//  }

  @override
  void initState() {
    super.initState();
    NotificationHandler().initializeFCMNotification(context);
//    _firebaseMessaging.subscribeToTopic("all");
//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print("onMessage: tetiklendi : ${message.toString()}");
//      },
//      onBackgroundMessage: myBackgroundMessageHandler,
//      onLaunch: (Map<String, dynamic> message) async {
//        print("onLaunch: tetiklendi: ${message.toString()}");
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print("onResume: tetiklendi: ${message.toString()}");
//      },
//    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WillPopScope(
        onWillPop: ()async => !await navigatorKeys[_currentTab].currentState.maybePop(),  // geri gelmememsi icin
        child: MyCustomButtomNavBar(
          keyBuilder: navigatorKeys,
          pageBuilder: allPages(),
          currentItem: _currentTab,
          onSelectecTab: (selectedTab) {
            
            if(selectedTab == _currentTab){
              navigatorKeys[selectedTab].currentState.popUntil((route)=>route.isFirst);
            } else {
              setState(() {
                _currentTab = selectedTab;
              });
            }
          },
        ),
      ),
    );
  }
}
