import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livechat/app/tab_item.dart';

class MyCustomButtomNavBar extends StatelessWidget {
  final TabItem currentItem;
  final ValueChanged<TabItem> onSelectecTab;
  final Map<TabItem, Widget> pageBuilder;
  final Map<TabItem, GlobalKey<NavigatorState>> keyBuilder;
  const  MyCustomButtomNavBar({Key key, @required this.currentItem, @required this.onSelectecTab, @required this.pageBuilder, @required this.keyBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: [
          _navItemOlustur(TabItem.Users),
          _navItemOlustur(TabItem.Chats),
          _navItemOlustur(TabItem.Profile)
        ],
        onTap: (index)=>onSelectecTab(TabItem.values[index]),),
         tabBuilder: (context, index){
           final gosterilecekItem = TabItem.values[index];
          return CupertinoTabView(
            navigatorKey: keyBuilder[gosterilecekItem],
            builder: (context){
              return pageBuilder[gosterilecekItem];
            },
          );
    });
  }



  BottomNavigationBarItem _navItemOlustur(TabItem tabItem){

    final olusturulacakTab = TabItemData.tumTablar[tabItem];

    return BottomNavigationBarItem(
      icon: Icon(olusturulacakTab.icon),
      title: Text(olusturulacakTab.title)
    );
  }
}
