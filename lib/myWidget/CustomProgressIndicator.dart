import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'dart:io';

class CustomProgressIndicatorWidget extends StatelessWidget {

  Widget _androidIndicator(){
    return Center(
      child: Card(
        child: Container(
          width: 220.0,
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(margin: EdgeInsets.only(right: 30.0),
                  child: Text('Loading......',style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.black))),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColor.colorPrimary))
            ],
          ),
        ),
      ),
    );
  }

  Widget _iosIndicator(){
    return Container(
      color: Colors.black.withOpacity(0.2),
      width: double.maxFinite,
      height: double.maxFinite,
      child: Center(
        child: CupertinoActivityIndicator(radius: 20,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid? _androidIndicator() : _iosIndicator();
  }
}
