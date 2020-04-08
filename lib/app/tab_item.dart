import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { Users, Chats, Profile }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.Profile: TabItemData("Profile", Icons.person),
    TabItem.Chats : TabItemData("Chats",  Icons.chat),
    TabItem.Users: TabItemData("Users", Icons.supervised_user_circle)
  };
}
