import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'dart:io';

import 'package:myotaw/helper/PlatformHelper.dart';

class CustomProgressIndicatorWidget extends StatelessWidget {

  Widget _androidIndicator(){
    return Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.5),
        ),
        child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColor.colorPrimary)))
    );
  }

  Widget _iosIndicator(){
    return CupertinoTheme(
      data: CupertinoThemeData(
          brightness: Brightness.dark
      ),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.5),
        ),
        child: Center(
          child: CupertinoActivityIndicator(radius: 13,),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformHelper.isAndroid()? _androidIndicator() : _iosIndicator();
  }
}
