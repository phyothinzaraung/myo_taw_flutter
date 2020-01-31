import 'package:flutter/material.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/model/UserModel.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import '../OnlineTaxScreen.dart';
import '../SmartWaterMeterScreen.dart';

class OnlineTaxPinRequestDialogWidget extends StatefulWidget {
  String _type;
  UserModel _userModel;
  OnlineTaxPinRequestDialogWidget(this._type, this._userModel);
  @override
  _OnlineTaxPinRequestDialogWidgetState createState() => _OnlineTaxPinRequestDialogWidgetState();
}

class _OnlineTaxPinRequestDialogWidgetState extends State<OnlineTaxPinRequestDialogWidget> {
  bool _hasError = false;
  TextEditingController _pinCodeController = new TextEditingController();

  _dialogPinRequest(){
    return SimpleDialog(
      contentPadding: EdgeInsets.all(20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      children: <Widget>[
        Column(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Image.asset('images/close.png', width: 25.0, height: 25.0,)),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Image.asset('images/pin_lock.png', width: 50.0, height: 50.0,)),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(MyString.txt_fill_pin_code,
                style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack,),textAlign: TextAlign.center,),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              alignment: Alignment.center,
              child: PinCodeTextField(
                pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                pinTextAnimatedSwitcherDuration: Duration(milliseconds: 100),
                pinBoxHeight: 40,
                pinBoxWidth: 40,
                defaultBorderColor: MyColor.colorPrimary,
                hideCharacter: true,
                maskCharacter: '*',
                hasTextBorderColor: Colors.white,
                pinTextStyle: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),
                controller:  _pinCodeController,
                autofocus: true,
                hasError: _hasError,
                onDone: (str){
                  if(widget._userModel.pinCode.toString() == str){
                    Navigator.of(context).pop();
                    if(widget._type == 'OnlineTax'){
                      /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => OnlineTaxScreen(),
                        settings: RouteSettings(name: ScreenName.ONLINE_TAX_SCREEN)
                      ));*/
                      NavigatorHelper().MyNavigatorPush(context, OnlineTaxScreen(), ScreenName.ONLINE_TAX_SCREEN);
                    }else{
                      /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => SmartWaterMeterScreen(widget._userModel),
                          settings: RouteSettings(name: ScreenName.SMART_WATER_METER_SCREEN)
                      ));*/
                      NavigatorHelper().MyNavigatorPush(context, SmartWaterMeterScreen(widget._userModel), ScreenName.SMART_WATER_METER_SCREEN);
                    }

                    setState(() {
                      _hasError = false;
                      _pinCodeController.text = '';
                    });
                  }else{
                    setState(() {
                      _hasError = true;
                      _pinCodeController.text = '';
                    });
                  }
                },
              ),
            ),
          ],
        )
      ],);
  }
  @override
  Widget build(BuildContext context) {
    return _dialogPinRequest();
  }
}
