import 'package:flutter/material.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';

void ApplyBizLicenseFormSnackBarWidget(GlobalKey<ScaffoldState> globalKey, String string){
  globalKey.currentState.showSnackBar(
      SnackBar(
          content: Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(right: 20.0),
                  child: Image.asset('images/star.png', width: 15.0, height: 15.0,)),
              Expanded(
                  child: Text(MyString.txt_apply_license_need_to_fill,
                    style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white), textAlign: TextAlign.center,)),
            ],
          ),
        duration: Duration(milliseconds: 1500),
        backgroundColor: MyColor.colorPrimary,
      )
  );
}