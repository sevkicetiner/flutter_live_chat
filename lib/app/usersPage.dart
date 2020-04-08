import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:livechat/app/chat_page.dart';
import 'package:livechat/locator.dart';
import 'package:livechat/models/user.dart';
import 'package:livechat/viewmodels/UserViewModels.dart';
import 'package:livechat/viewmodels/all_users_view_model.dart';
import 'package:livechat/viewmodels/chat_list_view_model.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Users"),
        ),
        body: Consumer<AllUserViewModel>(
          builder: (context, model, child) {
            if (model.state == AllUserViewState.Busy) {
              return Center(child: CircularProgressIndicator());
            } else if (model.state == AllUserViewState.Loaded) {
              return RefreshIndicator(
                onRefresh: model.refresh,
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: model.hasMoreLoading
                        ? model.userList.length + 1
                        : model.userList.length,
                    itemBuilder: (context, index) {
                      if (model.userList.length == 1) {
                        return Container(child: Center(child: Text(
                            "baska kullanici yok"),),);
                      } else if (model.hasMoreLoading &&
                          index == model.userList.length) {
                        return _newItemsWaitingIndicator();
                      } else {
                        return _userListItemBuild(index);
                      }
                    }),
              );
            } else {
              return Container();
            }
          },
        )
    );
  }


  Padding _newItemsWaitingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator()
      ),
    );
  }

  Future<Null> refreshUserList() async {
    return null;
  }

  _scrollControllerListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("Listenin en altındayız ");
      getMoreUser();
    }
  }

  void getMoreUser() async {
    if (_isLoading == false) {
      _isLoading = true;
      final _tumKullanicilarViewModel = Provider.of<AllUserViewModel>(
          context, listen: false);
      await _tumKullanicilarViewModel.getMoreUser();
      _isLoading = false;
    }
  }

  Widget _userListItemBuild(int index) {
    final _userModel = Provider.of<UserModel>(context);
    final _allUserViewModel = Provider.of<AllUserViewModel>(context);
    User _oAnkiUser = _allUserViewModel.userList[index];
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_oAnkiUser.profilURL),
      ),
      title: Text(_oAnkiUser.userName),
      subtitle: Text(_oAnkiUser.email),
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(
            builder: (context) =>
                ChangeNotifierProvider(
                  create: (context)=>ChatListViewModel(currentUser: _userModel.user, talkingUser: _oAnkiUser),
                  child: ChatPage(),
                )));
      },
    );
  }

}

