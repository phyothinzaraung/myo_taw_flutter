
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';

class CustomScaffoldWidget extends StatelessWidget {
  @required String title;
  @required Widget body;
  List<Widget> action;
  Widget trailing;
  Widget floatingActionButton;
  GlobalKey globalKey = GlobalKey();

  CustomScaffoldWidget({this.title, this.body, this.action, this.trailing, this.floatingActionButton, this.globalKey});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: Platform.isAndroid?AppBar(
          actions: action,
          title: Center(
              child:
              Text(title, style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), )),
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
                    middle: Text(title, style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal)),
                  ),
                  child: body
              ),
            ),
        floatingActionButton: floatingActionButton,
    );
  }
}
