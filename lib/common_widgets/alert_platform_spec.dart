import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:livechat/common_widgets/platform_specific_widget.dart';
import 'package:livechat/main.dart';

class AlertPlatformSpec extends PlatformSpecWidget {
  final String title;
  final String content;
  final String mainButtonText;
  final String cancelButtonText;

  AlertPlatformSpec(
      {@required this.title,
      @required this.content,
      @required this.mainButtonText,
      this.cancelButtonText});

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    // TODO: implement buildAndroidWidget
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogActionButtonCreate(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    // TODO: implement buildIOSWidget
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text(mainButtonText),
          onPressed: () {},
        )
      ],
    );
  }

  List<Widget> _dialogActionButtonCreate(BuildContext context) {
    final allActionButtons = <Widget>[];

    if (Platform.isIOS) {
      if(cancelButtonText != null){
        allActionButtons.add(CupertinoDialogAction(child: Text(cancelButtonText), onPressed: () => Navigator.pop(context, false),));
      }
      allActionButtons.add(CupertinoDialogAction(
        child: Text(mainButtonText),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ));

    } else {
      if(cancelButtonText != null){
        allActionButtons.add(FlatButton(child: Text(cancelButtonText), onPressed: () => Navigator.pop(context, false),));
      }
      allActionButtons.add(FlatButton(
        child: Text(mainButtonText),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ));

    }

    return allActionButtons;
  }
}
