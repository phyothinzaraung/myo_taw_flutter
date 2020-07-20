import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myotaw/helper/NumConvertHelper.dart';
import 'package:myotaw/helper/PlatformHelper.dart';
import '../helper/MyoTawConstant.dart';
import 'dart:io';

import 'CustomButtonWidget.dart';

class CustomDialogWidget {

  Future customSuccessDialog({
    BuildContext context,
    String content,
    String img,
    String buttonText,
    VoidCallback onPress,
  }) {
    return PlatformHelper.isAndroid() ?
    showDialog(
        context: context,
        builder: (context) {
          return _androidSuccessDialog(
            context: context,
            content: content,
            img: img,
            buttonText: buttonText,
            onPress: onPress,
          );
        }
    ) :
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return _iosSuccessDialog(
            context: context,
            content: content,
            img: img,
            buttonText: buttonText,
            onPress: onPress,
          );
        }
    );
  }

  Future customConfirmDialog({
    BuildContext context,
    String content,
    String img,
    String textYes,
    String textNo,
    VoidCallback onPress
  }) {
    return PlatformHelper.isAndroid() ?
    showDialog(
        context: context,
        builder: (context) {
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
        builder: (context) {
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


  Future customCalculateTaxDialog({
    BuildContext context,
    String taxValue,
    VoidCallback onPress,
    String titleTax
  }) {
    return PlatformHelper.isAndroid() ?
    showDialog(
        context: context,
        builder: (context) {
          return _androidCalculateTaxDialog(
              context: context,
              onPress: onPress,
              taxValue: taxValue,
              titleTax: titleTax
          );
        }
    ) :
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return _iosCalculateTaxDialog(
              context: context,
              onPress: onPress,
              taxValue: taxValue,
              titleTax: titleTax
          );
        }
    );
  }


  Future customSpecialGradeCalculateTaxDialog({
    BuildContext context,
    String taxValue,
    VoidCallback onPress,
    String titleTax
  }) {
    return PlatformHelper.isAndroid() ?
    showDialog(
        context: context,
        builder: (context) {
          return _androidSpecialGradeCalculateTaxDialog(
              context: context,
              onPress: onPress,
              taxValue: taxValue,
              titleTax: titleTax
          );
        }
    ) :
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return _iosSpecialGradeCalculateTaxDialog(
              context: context,
              onPress: onPress,
              taxValue: taxValue,
              titleTax: titleTax
          );
        }
    );
  }

  Future customChannelChooserDialog({
    BuildContext context,
    String title,
    String generalText,
    String blockText,
    VoidCallback onPressGeneral,
    VoidCallback onPressBlockLevel,
  }) {
    return PlatformHelper.isAndroid() ?
    showDialog(
        context: context,
        builder: (context) {
          return _androidCustomChannelChooserDialog(
            context: context,
            title: title,
            generalText: generalText,
            blockText: blockText,
            onPressGeneral: onPressGeneral,
            onPressBlockLevel: onPressBlockLevel,
          );
        }) :
    showCupertinoDialog(
        context: context, builder: (context){
          return _iosCustomChannelChooserDialog(
            context: context,
            title: title,
            generalText: generalText,
            blockText: blockText,
            onPressGeneral: onPressGeneral,
            onPressBlockLevel: onPressBlockLevel,
          );
    });
  }

  Widget _androidSuccessDialog({BuildContext context,
    String content,
    String img,
    String buttonText,
    VoidCallback onPress,
  }) {
    return WillPopScope(
      child: SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Image.asset(
                      'images/$img', width: 50.0, height: 50.0,)),
                Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(content,
                      style: TextStyle(fontSize: FontSize.textSizeSmall),
                      textAlign: TextAlign.center,)),
                Container(
                  width: 200.0,
                  child: CustomButtonWidget(onPress: onPress,
                    child: Text(
                      buttonText == null ? MyString.txt_close : buttonText,
                      style: TextStyle(fontSize: FontSize.textSizeSmall,
                          color: Colors.white),),
                    color: MyColor.colorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),),
                )
              ],
            ),
          )
        ],
      ), onWillPop: () {},
    );
  }

  Widget _iosSuccessDialog({
    BuildContext context,
    String content,
    String img,
    String buttonText,
    VoidCallback onPress,
  }) {
    return WillPopScope(
      onWillPop: () {},
      child: CupertinoAlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Image.asset('images/$img', width: 50.0, height: 50.0,)),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(content,
                style: TextStyle(fontSize: FontSize.textSizeSmall, height: 1.5),
                textAlign: TextAlign.center,),),
          ],
        ),
        actions: <Widget>[
          CupertinoDialogAction(child: Text(
            buttonText == null ? MyString.txt_close : buttonText,
            style: TextStyle(
                fontSize: FontSize.textSizeSmall, color: Colors.blue),),
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
  }) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(margin: EdgeInsets.only(bottom: 10.0),
                  child: Image.asset(
                    'images/$img', width: 50.0, height: 50.0,)),
              Container(
                  margin: EdgeInsets.only(bottom: 10.0), child: Text(content,
                style: TextStyle(fontSize: FontSize.textSizeSmall,
                    color: MyColor.colorTextBlack),)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 40.0,
                    width: 90.0,
                    child: RaisedButton(onPressed: () {
                      Navigator.of(context).pop();
                    },
                      child: Text(textNo, style: TextStyle(
                          fontSize: FontSize.textSizeSmall,
                          color: MyColor.colorTextBlack),),
                      color: MyColor.colorGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),),
                  ),
                  Container(
                    height: 40.0,
                    width: 90.0,
                    child: RaisedButton(onPressed: onPress,
                      child: Text(textYes, style: TextStyle(
                          fontSize: FontSize.textSizeSmall,
                          color: Colors.white),),
                      color: MyColor.colorPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),),
                  ),

                ],
              )
            ],
          ),
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
  }) {
    return WillPopScope(
      onWillPop: () {},
      child: CupertinoAlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Image.asset('images/$img', width: 50.0, height: 50.0,)),
            Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  content, style: TextStyle(fontSize: FontSize.textSizeSmall),
                  textAlign: TextAlign.center,)),
          ],
        ),
        actions: <Widget>[
          CupertinoDialogAction(child: Text(textNo, style: TextStyle(
              fontSize: FontSize.textSizeSmall, color: Colors.red),),
            onPressed: () => Navigator.of(context).pop(),),
          CupertinoDialogAction(child: Text(textYes, style: TextStyle(
              fontSize: FontSize.textSizeSmall, color: Colors.blue),),
            onPressed: onPress,),
        ],
      ),
    );
  }

  Widget _androidCalculateTaxDialog({
    BuildContext context,
    String taxValue,
    VoidCallback onPress,
    String titleTax
  }) {
    return WillPopScope(
        child: SimpleDialog(
          contentPadding: EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Image.asset(
                      'images/calculate_tax_no_circle.png', width: 60.0,
                      height: 60.0,)),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(titleTax,
                    style: TextStyle(fontSize: FontSize.textSizeSmall,
                      color: MyColor.colorTextBlack,),
                    textAlign: TextAlign.center,),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(taxValue,
                    style: TextStyle(fontSize: FontSize.textSizeLarge,
                      color: MyColor.colorPrimary,),
                    textAlign: TextAlign.center,),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 0.0),
                  child: Text(MyString.txt_kyat,
                    style: TextStyle(fontSize: FontSize.textSizeLarge,
                      color: MyColor.colorTextBlack,),
                    textAlign: TextAlign.center,),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text('ဖြစ်ပါသည်။',
                    style: TextStyle(fontSize: FontSize.textSizeNormal,
                      color: MyColor.colorTextBlack,),
                    textAlign: TextAlign.center,),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(MyString.txt_thanks,
                    style: TextStyle(fontSize: FontSize.textSizeExtraSmall,
                      color: MyColor.colorPrimary,),
                    textAlign: TextAlign.center,),
                ),
                CustomButtonWidget(
                  onPress: onPress,
                  child: Text(MyString.txt_close,
                    style: TextStyle(fontSize: FontSize.textSizeSmall,
                        color: Colors.white),),
                  color: MyColor.colorPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0)),
                  borderRadius: BorderRadius.circular(10),
                )
              ],
            )
          ],), onWillPop: () {});
  }

  Widget _iosCalculateTaxDialog({
    BuildContext context,
    String taxValue,
    VoidCallback onPress,
    String titleTax
  }) {
    return WillPopScope(
        child: CupertinoAlertDialog(
          actions: <Widget>[
            CupertinoDialogAction(child: Text(MyString.txt_close,
              style: TextStyle(
                  fontSize: FontSize.textSizeSmall, color: Colors.blue),),
                onPressed: onPress),
          ],
          content: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Image.asset(
                    'images/calculate_tax_no_circle.png', width: 60.0,
                    height: 60.0,)),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(titleTax,
                  style: TextStyle(fontSize: FontSize.textSizeSmall,
                    color: MyColor.colorTextBlack,),
                  textAlign: TextAlign.center,),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Text(taxValue,
                  style: TextStyle(fontSize: FontSize.textSizeLarge,
                    color: MyColor.colorPrimary,),
                  textAlign: TextAlign.center,),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(MyString.txt_kyat,
                  style: TextStyle(fontSize: FontSize.textSizeLarge,
                    color: MyColor.colorTextBlack,),
                  textAlign: TextAlign.center,),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text('ဖြစ်ပါသည်။',
                  style: TextStyle(fontSize: FontSize.textSizeNormal,
                    color: MyColor.colorTextBlack,),
                  textAlign: TextAlign.center,),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(MyString.txt_thanks,
                  style: TextStyle(fontSize: FontSize.textSizeExtraSmall,
                      color: MyColor.colorPrimary,
                      height: 1.5), textAlign: TextAlign.center,),
              ),
            ],
          ),
        ), onWillPop: () {});
  }

  Widget _androidSpecialGradeCalculateTaxDialog({
    BuildContext context,
    String taxValue,
    VoidCallback onPress,
    String titleTax
  }) {
    return WillPopScope(
        child: SimpleDialog(
          contentPadding: EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Image.asset(
                      'images/calculate_tax_no_circle.png', width: 60.0,
                      height: 60.0,)),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(titleTax,
                    style: TextStyle(fontSize: FontSize.textSizeSmall,
                      color: MyColor.colorTextBlack,),
                    textAlign: TextAlign.center,),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(taxValue,
                    style: TextStyle(fontSize: FontSize.textSizeLarge,
                      color: MyColor.colorPrimary,),
                    textAlign: TextAlign.center,),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text('ဖြစ်ပါသည်။',
                    style: TextStyle(fontSize: FontSize.textSizeNormal,
                      color: MyColor.colorTextBlack,),
                    textAlign: TextAlign.center,),
                ),
                CustomButtonWidget(
                  onPress: onPress,
                  child: Text(MyString.txt_close,
                    style: TextStyle(fontSize: FontSize.textSizeSmall,
                        color: Colors.white),),
                  color: MyColor.colorPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0)),
                  borderRadius: BorderRadius.circular(10),
                )
              ],
            )
          ],), onWillPop: () {});
  }

  Widget _iosSpecialGradeCalculateTaxDialog({
    BuildContext context,
    String taxValue,
    VoidCallback onPress,
    String titleTax
  }) {
    return WillPopScope(
        child: CupertinoAlertDialog(
          actions: <Widget>[
            CupertinoDialogAction(child: Text(MyString.txt_close,
              style: TextStyle(
                  fontSize: FontSize.textSizeSmall, color: Colors.blue),),
                onPressed: onPress),
          ],
          content: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Image.asset(
                    'images/calculate_tax_no_circle.png', width: 60.0,
                    height: 60.0,)),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(titleTax,
                  style: TextStyle(fontSize: FontSize.textSizeSmall,
                    color: MyColor.colorTextBlack,),
                  textAlign: TextAlign.center,),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Text(taxValue,
                  style: TextStyle(fontSize: FontSize.textSizeLarge,
                    color: MyColor.colorPrimary,),
                  textAlign: TextAlign.center,),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text('ဖြစ်ပါသည်။',
                  style: TextStyle(fontSize: FontSize.textSizeNormal,
                    color: MyColor.colorTextBlack,),
                  textAlign: TextAlign.center,),
              ),
            ],
          ),
        ), onWillPop: () {});
  }

  Widget _androidCustomChannelChooserDialog({
    BuildContext context,
    String title,
    String generalText,
    String blockText,
    VoidCallback onPressGeneral,
    VoidCallback onPressBlockLevel,
  }) {
    return WillPopScope(
        child: SimpleDialog(
          contentPadding: EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(title,
                    style: TextStyle(fontSize: FontSize.textSizeExtraNormal,
                      color: MyColor.colorTextBlack,),
                    textAlign: TextAlign.center,),
                ),
                CustomButtonWidget(
                  onPress: onPressGeneral,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 10.0, bottom: 10.0),
                        child: Image.asset('images/newsfeed.png',
                          width: 30.0,
                          height: 30.0,),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Text(generalText,
                          style: TextStyle(fontSize: FontSize.textSizeSmall,
                              color: MyColor.colorTextBlack),),
                      )
                    ],
                  ),),
                Container(
                  height: 1.0,
                  color: Colors.grey,
                ),
                CustomButtonWidget(
                  onPress: onPressBlockLevel,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 10.0, top: 10.0),
                        child: Image.asset('images/newsfeed.png',
                          width: 30.0,
                          height: 30.0,),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Text(blockText,
                          style: TextStyle(fontSize: FontSize.textSizeSmall,
                              color: MyColor.colorTextBlack),),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],), onWillPop: (){});
  }

  Widget _iosCustomChannelChooserDialog({
    BuildContext context,
    String title,
    String generalText,
    String blockText,
    VoidCallback onPressGeneral,
    VoidCallback onPressBlockLevel,
  }) {
    return WillPopScope(
        child: CupertinoAlertDialog(
          content:
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(title,
                  style: TextStyle(fontSize: FontSize.textSizeExtraNormal,
                    color: MyColor.colorTextBlack,),
                  textAlign: TextAlign.center,),
              ),
              CustomButtonWidget(
                onPress: onPressGeneral,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10.0, bottom: 10.0),
                      child: Image.asset('images/newsfeed.png',
                        width: 30.0,
                        height: 30.0,),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(generalText,
                        style: TextStyle(fontSize: FontSize.textSizeSmall,
                            color: MyColor.colorTextBlack),),
                    )
                  ],
                ),),
              Container(
                height: 1.0,
                color: Colors.grey,
              ),
              CustomButtonWidget(
                onPress: onPressBlockLevel,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10.0, top: 10.0),
                      child: Image.asset('images/newsfeed.png',
                        width: 30.0,
                        height: 30.0,),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(blockText,
                        style: TextStyle(fontSize: FontSize.textSizeSmall,
                            color: MyColor.colorTextBlack),),
                    )
                  ],
                ),
              ),
            ],
          )
        ), onWillPop: () {});
  }
}







