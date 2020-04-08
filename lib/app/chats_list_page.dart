import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livechat/app/chat_page.dart';
import 'package:livechat/models/chats.dart';
import 'package:livechat/models/user.dart';
import 'package:livechat/viewmodels/UserViewModels.dart';
import 'package:livechat/viewmodels/chat_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:livechat/viewmodels/all_users_view_model.dart';

class ChatsListPage extends StatefulWidget {
  @override
  _ChatsListPageState createState() => _ChatsListPageState();
}

class _ChatsListPageState extends State<ChatsListPage> {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("My Chats"),
        ),
        body: Container(
          color: Colors.white,
          child: FutureBuilder(
            future: _userModel.getAllChats(_userModel.user.userID),
            builder:
                (BuildContext context, AsyncSnapshot<List<Chat>> snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        var chat = snapshot.data[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider<
                                            ChatListViewModel>(
                                          create: (context) => ChatListViewModel(
                                              currentUser: _userModel.user,
                                              talkingUser: User.idProfileUrl(
                                                  userID: snapshot
                                                      .data[index].withWho,
                                                  userName: snapshot.data[index]
                                                      .withWhoUserName,
                                                  profilURL: snapshot
                                                      .data[index]
                                                      .withWhoProfileURL)),
                                          child: ChatPage(),
                                        )));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(chat.withWhoProfileURL, scale: 1.0),
                            ),
                            title: Text(
                              chat.withWhoUserName,
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                Expanded(child: Text(chat.content)),
                                Text(DateFormat.Hm()
                                    .format(chat.sendTime.toDate())),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.check,
                                  color: chat.isShowed
                                      ? Colors.green
                                      : Colors.grey,
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                );
              } else
                return Container(color: Colors.white);
            },
          ),
        ));
  }

  Future<void> _refresh() async {
    Future.delayed(Duration(seconds: 2));
    setState(() {});
  }
}
