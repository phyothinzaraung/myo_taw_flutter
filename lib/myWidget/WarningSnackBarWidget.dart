import 'package:flutter/material.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';

void WarningSnackBar(GlobalKey<ScaffoldState> globalKey, String string){
  globalKey.currentState.showSnackBar(
      SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/warning.png', width: 25, height: 25, color: Colors.white,),
              Expanded(child: Text(string, style: TextStyle(fontSize: FontSize.textSizeExtraSmall), textAlign: TextAlign.center,))
            ],
          ),
        duration: Duration(milliseconds: 500),
        backgroundColor: Colors.redAccent,
      )
  );

}