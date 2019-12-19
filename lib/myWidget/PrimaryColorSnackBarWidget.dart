import 'package:flutter/material.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';

Widget PrimaryColorSnackBarWidget(GlobalKey<ScaffoldState> globalKey, String string){
  globalKey.currentState.showSnackBar(
      SnackBar(
          content: Text(string, style: TextStyle(fontSize: FontSize.textSizeExtraSmall), textAlign: TextAlign.center,),
        duration: Duration(milliseconds: 1500),
        backgroundColor: MyColor.colorPrimary,
      )
  );

}