import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../helper/MyoTawConstant.dart';
import 'dart:io';

import 'CustomButtonWidget.dart';

class CustomDialogWidget {

  Future CustomSuccessDialog({
    BuildContext context,
    String content,
    String img,
    VoidCallback onPress,
  }){
    return Platform.isAndroid?
    showDialog(
        context: context,
        builder: (context){
          return _androidSuccessDialog(
            context: context,
            content: content,
            img: img,
            onPress: onPress,
          );
        }
    ) :
    showCupertinoDialog(
        context: context,
        builder: (context){
          return _iosSuccessDialog(
              context: context,
              content: content,
              img: img,
              onPress: onPress,
          );
        }
    );
  }

  Future CustomConfirmDialog({
    BuildContext context,
    String content,
    String img,
    String textYes,
    String textNo,
    VoidCallback onPress
  }){
    return Platform.isAndroid?
    showDialog(
        context: context,
        builder: (context){
          return _androidConfirmDialog(
            context: context,
            content: content,
            textYes: textYes,
            textNo: textNo,
            img: img,
            onPress: onPress,
          );
        }
    ) :
    showCupertinoDialog(
        context: context,
        builder: (context){
          return _iosConfirmDialog(
            context: context,
            content: content,
            img: img,
            textYes: textYes,
            textNo: textNo,
            onPress: onPress,
          );
        }
    );
  }




  Widget _androidSuccessDialog(
      {BuildContext context,
        String content,
        String img,
        VoidCallback onPress,
      }){
    return WillPopScope(
      child: SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Image.asset('images/$img', width: 50.0, height: 50.0,)),
                Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(content, style: TextStyle(fontSize: FontSize.textSizeSmall),textAlign: TextAlign.center,)),
                Container(
                  width: 200.0,
                  height: 45.0,
                  child: CustomButtonWidget(onPress: onPress, child: Text(MyString.txt_close, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                    color: MyColor.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                )
              ],
            ),
          )
        ],
      ),onWillPop: (){},
    );
  }

  Widget _iosSuccessDialog({
    BuildContext context,
    String content,
    String img,
    VoidCallback onPress,
  }){
    return WillPopScope(
      onWillPop: (){},
      child: CupertinoAlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Image.asset('images/$img', width: 50.0, height: 50.0,)),
            Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(content, style: TextStyle(fontSize: FontSize.textSizeSmall),textAlign: TextAlign.center,),),
          ],
        ),
        actions: <Widget>[
          CupertinoDialogAction(child: Text(MyString.txt_close, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.blue),),
            onPressed: onPress,)
        ],
      ),
    );
  }


  Widget _androidConfirmDialog({
    BuildContext context,
    String content,
    String img,
    String textYes,
    String textNo,
    VoidCallback onPress
  }){
    return SimpleDialog(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(margin: EdgeInsets.only(bottom: 10.0),child: Image.asset('images/$img', width: 50.0, height: 50.0,)),
            Container(margin: EdgeInsets.only(bottom: 10.0),child: Text(content,
              style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 40.0,
                  width: 90.0,
                  child: RaisedButton(onPressed: (){
                    Navigator.of(context).pop();
                  },child: Text(textNo,style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),
                    color: MyColor.colorGrey,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
                ),
                Container(
                  height: 40.0,
                  width: 90.0,
                  child: RaisedButton(onPressed: onPress,child: Text(textYes,style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                    color: MyColor.colorPrimary,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
                ),

              ],
            )
          ],
        )
      ],
    );
  }


  Widget _iosConfirmDialog({
    BuildContext context,
    String content,
    String img,
    String textYes,
    String textNo,
    VoidCallback onPress
  }){
    return WillPopScope(
      onWillPop: (){},
      child: CupertinoAlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Image.asset('images/$img', width: 50.0, height: 50.0,)),
            Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(content, style: TextStyle(fontSize: FontSize.textSizeSmall),textAlign: TextAlign.center,)),
          ],
        ),
        actions: <Widget>[
          CupertinoDialogAction(child: Text(textNo, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.red),),
            onPressed: ()=> Navigator.of(context).pop(),),
          CupertinoDialogAction(child: Text(textYes, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.blue),),
            onPressed: onPress,),
        ],
      ),
    );
  }


}







