
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';

class CustomScaffoldWidget extends StatelessWidget {
  @required final Widget title;
  @required final Widget body;
  final List<Widget> action;
  final Widget trailing;
  final Widget floatingActionButton;
  final GlobalKey globalKey;

  CustomScaffoldWidget({this.title, this.body, this.action, this.trailing, this.floatingActionButton, this.globalKey}) :
  assert(body != null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: Platform.isAndroid?AppBar(
          actions: action,
          title: title,
        ) : null,
        body: Platform.isAndroid?body :
            CupertinoTheme(
              data: CupertinoThemeData(
                brightness: Brightness.light,
                primaryColor: Colors.white,
                scaffoldBackgroundColor: MyColor.colorGrey,
              ),
              child: CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    trailing: trailing,
                    transitionBetweenRoutes: true,
                    backgroundColor: MyColor.colorPrimary,
                    middle: title,
                  ),
                  child: body
              ),
            ),
        floatingActionButton: floatingActionButton,
    );
  }
}
