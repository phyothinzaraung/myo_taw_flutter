
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorHelper{
  var _navigator;

  Future<dynamic> MyNavigatorPush(BuildContext context, Widget screen, String screenName){
    _navigator = Navigator.push(context, Platform.isAndroid? MaterialPageRoute(builder: (context) => screen,
        settings: RouteSettings(name: screenName)) :

    CupertinoPageRoute(builder: (context) => screen,
        settings: RouteSettings(name: screenName)));

    return _navigator;

  }

  Future<dynamic> MyNavigatorPushAndRemoveUntil(BuildContext context, Widget screen, String screenName){

    _navigator = Navigator.of(context).pushAndRemoveUntil( Platform.isAndroid? MaterialPageRoute(builder: (context) => screen,
        settings: RouteSettings(name: screenName)
    ) :
    CupertinoPageRoute(builder: (context) => screen,
        settings: RouteSettings(name: screenName)
    )
        ,(Route<dynamic>route) => false);

    return _navigator;

  }

  Future<dynamic> MyNavigatorPushReplacement(BuildContext context, Widget screen, String screenName){


    _navigator = Navigator.pushReplacement(context, Platform.isAndroid? MaterialPageRoute(builder: (context) => screen,
    settings: RouteSettings(name: screenName)) :

    CupertinoPageRoute(builder: (context) => screen,
    settings: RouteSettings(name: screenName)));

    return _navigator;

  }
}