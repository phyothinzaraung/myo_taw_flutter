import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../helper/MyoTawConstant.dart';

class CustomButtonWidget extends StatelessWidget {
  @required final VoidCallback onPress;
  @required final Widget child;
  final Color color;
  final ShapeBorder shape;
  final double elevation;
  final BorderRadius borderRadius;

  CustomButtonWidget({this.onPress, this.child, this.color, this.shape, this.elevation, this.borderRadius}) :
        assert(onPress != null), assert(child != null);


  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid?


    RaisedButton(
      onPressed: onPress,
      child: Container(
          margin: EdgeInsets.all(10),
          child: child),
      color: color,
      shape: shape,
      elevation: elevation,
    )

        :

    CupertinoButton(
        borderRadius: borderRadius,
        color: color,
        child: child,
        onPressed: onPress);
  }
}

