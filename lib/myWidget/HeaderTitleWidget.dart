import 'package:flutter/material.dart';
import 'package:myotaw/Helper/MyoTawConstant.dart';

Widget headerTitleWidget(String title, String image){
  return Container(
    margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
    child: Row(
      children: <Widget>[
        Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/$image.png', width: 30.0, height: 30.0,)),
        Text(title, style: TextStyle(fontSize: FontSize.textSizeSmall),)
      ],
    ),
  );
}
