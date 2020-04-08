
import 'dart:io';

import 'package:flutter/material.dart';

abstract class PlatformSpecWidget extends StatelessWidget {

  Widget buildAndroidWidget(BuildContext context);
  Widget buildIOSWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid)
      return buildAndroidWidget(context);
    else
      return buildIOSWidget(context);
  }

}