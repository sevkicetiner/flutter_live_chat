import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livechat/common_widgets/alert_platform_spec.dart';
import 'package:livechat/common_widgets/social_log_in_button.dart';
import 'package:livechat/models/user.dart';
import 'package:livechat/viewmodels/UserViewModels.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController usernameCont= TextEditingController();
  UserModel _userModel;
  File _image;

  @override
  Widget build(BuildContext context) {

    final _scaffoldKey = GlobalKey<ScaffoldState>();
    _userModel = Provider.of<UserModel>(context, listen: false);
    User _user = _userModel.user;
    usernameCont.text = _user.userName;
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Profile"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _signOut(context);
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: (){
                      _scaffoldKey.currentState.showBottomSheet((context){
                        return Container(
                          height: 250,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('Take a foto?'),
                                onTap: ()=>takeFoto(),
                              ),
                              ListTile(
                                onTap: ()=>selectFoto(),
                                leading: Icon(Icons.image),
                                title: Text('Select a from galery?"'),
                              )
                            ],
                          ),
                        );
                      },
                      backgroundColor: Colors.cyan.shade300,
                      );
                    },
                    child: CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.white,
                      backgroundImage: _image != null ? FileImage(_image) :  _user.profilURL != null ? NetworkImage(_user.profilURL,) :null,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: _user.email,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: usernameCont,
                    decoration: InputDecoration(
                        labelText: "User Name",
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SocialLoginButton(
                    buttonText: "Save",
                    onPressed: (){
                      _usernameGuncelle(context);
                      _profilFotoUdate(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future<bool> _signOut(BuildContext context) async {
    bool resultAlert = await AlertPlatformSpec(
      title: "Sign Out",
      content: "Are you sure you want to log out?",
      mainButtonText: "Yes",
      cancelButtonText: "No",
    ).show(context);

    if (resultAlert) {
      final _userModel = Provider.of<UserModel>(context, listen: false);
      bool result = await _userModel.signOut();
      return result;
    } else {
      print("sonuc  $resultAlert");
    }
  }

  void _usernameGuncelle(BuildContext context) async {
    if(_userModel.user.userName != usernameCont.text){

        bool updateResult = await _userModel.updateUsername(
            _userModel.user.userID, usernameCont.text);

        if (updateResult) {
          AlertPlatformSpec(
            title: 'Username Update',
            content: 'Username update is succes!',
            mainButtonText: 'OK',
          );
        }
        else {
          AlertPlatformSpec(
            title: "User Update",
            content: "User update is not succes",
            mainButtonText: "ok",
          ).show(context);
        }
    }
    usernameCont.text = _userModel.user.userName;
  }

  takeFoto() async {
    _image = await ImagePicker.pickImage(source: ImageSource.camera);
   setState(() {

   });
  }

  selectFoto() async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
  setState(() {

  });
  }

  void _profilFotoUdate(BuildContext context) async {
    if(_image!=null){
      var url = await _userModel.uploadFile(_userModel.user.userID, "profil_foto", _image);
      print("gelen indirme linki "+url);
      if(url !=null){
        AlertPlatformSpec(
          title: 'Message',
          content: 'Update is succes!',
          mainButtonText: 'OK',
        );
      }
    }
  }
}
