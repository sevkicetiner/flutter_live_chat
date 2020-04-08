import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livechat/app/home_page.dart';
import 'package:livechat/common_widgets/alert_platform_spec.dart';
import 'package:livechat/common_widgets/social_log_in_button.dart';
import 'package:livechat/viewmodels/UserViewModels.dart';
import 'package:livechat/models/user.dart';
import 'package:provider/provider.dart';

enum FormType { Login, Register }

class EmailPasswordLoginPage extends StatefulWidget {
  @override
  _EmailPasswordLoginPageState createState() => _EmailPasswordLoginPageState();
}

class _EmailPasswordLoginPageState extends State<EmailPasswordLoginPage> {
  String email, password;
  String _buttonText, _linkText;
  var _formTyp = FormType.Login;
  final _formKey = GlobalKey<FormState>();

  void _formSubmit() async {
    _formKey.currentState.save();
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);

    try {
      if (_formTyp == FormType.Login) {
        User user = await _userModel.signInWithEmailPassword(email, password);
        if (user == null) print("Sign in mail password  user null geldi ");
      } else {
        User user = await _userModel.createWithEmailPassword(email, password);
        if (user == null) {
          print("Create in email password da user null geldi");
        }
      }
    } on PlatformException catch (e) {
      AlertPlatformSpec(
        content: e.message,
        title: "Error ",
        mainButtonText: "OK",
      ).show(context);
    }

    print("email = $email   password = $password");
    if (_userModel.user != null) {
      Navigator.pop(context);
    } else {
      setState(() {});
    }
  }

  void _degistir() {
    setState(() {
      _formTyp =
          _formTyp == FormType.Login ? FormType.Register : FormType.Login;
    });
  }

  @override
  Widget build(BuildContext context) {
    _buttonText = _formTyp == FormType.Login ? "Sign In" : "Register";
    _linkText = _formTyp == FormType.Login
        ? "Dont have a accaunt? Register"
        : "Sign In?";

    UserModel _userModel = Provider.of<UserModel>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text("Sign in / up"),
        ),
        body: SingleChildScrollView(
          child: _userModel.userState == ViewState.Busy
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              border: OutlineInputBorder(),
                              labelText: "Email",
                              hintText: "Email",
                              errorText: _userModel.errorPasswordMessage),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) {
                            email = value.trim();
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                              labelText: "Password",
                              hintText: "Password",
                              errorText: _userModel.errorPasswordMessage),
                          onSaved: (value) {
                            password = value.trim();
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SocialLoginButton(
                          buttonText: _buttonText,
                          onPressed: _formSubmit,
                          buttonColor: Colors.cyan,
                          textColor: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FlatButton(
                          child: Text(_linkText),
                          onPressed: _degistir,
                        )
                      ],
                    ),
                  ),
                ),
        ));
  }
}
