import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/PlatformHelper.dart';
import 'dart:io';

import '../helper/MyoTawConstant.dart';

class CustomButtonWidget extends StatelessWidget {
  @required final VoidCallback onPress;
  @required final Widget child;
  final Color color;
  final ShapeBorder shape;
  final double elevation;
  final BorderRadius borderRadius;
  final bool isFlatButton;

  CustomButtonWidget({this.onPress, this.child, this.color, this.shape, this.elevation, this.borderRadius, this.isFlatButton:false}) :
        assert(onPress != null), assert(child != null);


  @override
  Widget build(BuildContext context) {
    return PlatformHelper.isAndroid()?


    !isFlatButton?RaisedButton(
      onPressed: onPress,
      child: Container(
          margin: EdgeInsets.all(10),
          child: child),
      color: color,
      shape: shape,
      elevation: elevation,
    ):
    FlatButton(
      onPressed: onPress,
      child: Container(
          margin: EdgeInsets.all(5),
          child: child),
      color: color,
      shape: shape,
    )

        :

    CupertinoButton(
        borderRadius: borderRadius,
        padding: EdgeInsets.all(10),
        color: color,
        child: child,
        onPressed: onPress);
  }
}

