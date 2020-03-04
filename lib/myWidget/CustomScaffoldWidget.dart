
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/helper/PlatformHelper.dart';

class CustomScaffoldWidget extends StatelessWidget {
  @required final Widget title;
  @required final Widget body;
  final List<Widget> action;
  final Widget trailing;
  final Widget floatingActionButton;
  final GlobalKey globalKey;
  bool centerTitle = false;

  CustomScaffoldWidget({this.title, this.body, this.action, this.trailing, this.floatingActionButton, this.globalKey, this.centerTitle}) :
  assert(body != null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: PlatformHelper.isAndroid()?AppBar(
          actions: action,
          title: title,
          centerTitle: centerTitle,
        ) : null,
        body: PlatformHelper.isAndroid()?body :
        CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              trailing: trailing,
              transitionBetweenRoutes: true,
              backgroundColor: MyColor.colorPrimary,
              middle: title,
            ),
            child: body
        ),
        floatingActionButton: floatingActionButton,
    );
  }
}
