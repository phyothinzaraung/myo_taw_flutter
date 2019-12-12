import 'package:flutter/material.dart';
import 'package:myotaw/Helper/MyoTawConstant.dart';

Widget headerTitleWidget(String title){
  return Container(
    margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
    child: Row(
      children: <Widget>[
        Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/business_license_nocircle.png', width: 30.0, height: 30.0,)),
        Text(title, style: TextStyle(fontSize: FontSize.textSizeSmall),)
      ],
    ),
  );
}
