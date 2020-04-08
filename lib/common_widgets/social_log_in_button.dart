import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double hight;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  SocialLoginButton(
      {Key key,
      @required this.buttonText,
      this.buttonColor : Colors.blue,
      this.textColor : Colors.white,
      this.radius : 8,
      this.hight : 50,
      this.buttonIcon,
      this.onPressed})
      : assert(buttonText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Row(children: <Widget>[
        buttonIcon == null ? SizedBox(width: 40,) : buttonIcon,
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              buttonText,
              style: TextStyle(color: textColor),
            ),
          ),
        )
      ],),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius))),
      color: buttonColor,
    );
  }
}
