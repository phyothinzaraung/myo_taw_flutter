
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'PlatformHelper.dart';

class NavigatorHelper{
  static var _navigator;

  static Future<dynamic> myNavigatorPush(BuildContext context, Widget screen, String screenName){
    _navigator = Navigator.push(context, PlatformHelper.isAndroid()? MaterialPageRoute(builder: (context) => screen,
        settings: RouteSettings(name: screenName)) :

    CupertinoPageRoute(builder: (context) => screen,
        settings: RouteSettings(name: screenName)));

    return _navigator;

  }

  static Future<dynamic> myNavigatorPushAndRemoveUntil(BuildContext context, Widget screen, String screenName){

    _navigator = Navigator.of(context).pushAndRemoveUntil( PlatformHelper.isAndroid()? MaterialPageRoute(builder: (context) => screen,
        settings: RouteSettings(name: screenName)
    ) :
    CupertinoPageRoute(builder: (context) => screen,
        settings: RouteSettings(name: screenName)
    )
        ,(Route<dynamic>route) => false);

    return _navigator;

  }

  static Future<dynamic> myNavigatorPushReplacement(BuildContext context, Widget screen, String screenName){


    _navigator = Navigator.pushReplacement(context, PlatformHelper.isAndroid()? MaterialPageRoute(builder: (context) => screen,
    settings: RouteSettings(name: screenName)) :

    CupertinoPageRoute(builder: (context) => screen,
    settings: RouteSettings(name: screenName)));

    return _navigator;

  }
}