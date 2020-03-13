
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/PlatformHelper.dart';

class NativeProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformHelper.isAndroid() ? CircularProgressIndicator(strokeWidth: 3,) : CupertinoActivityIndicator(radius: 13,);
  }
}
