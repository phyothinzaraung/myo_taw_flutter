import 'package:flutter/material.dart';
import 'package:myotaw/OnlineTaxScreen.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'PinCodeSetUpScreen.dart';
import 'helper/MyoTawConstant.dart';
import 'SmartWaterMeterScreen.dart';
import 'model/UserModel.dart';

class OnlineTaxChooseScreen extends StatefulWidget {
  UserModel _model;
  OnlineTaxChooseScreen(this._model);
  @override
  _OnlineTaxChooseScreenState createState() => _OnlineTaxChooseScreenState(this._model);
}

class _OnlineTaxChooseScreenState extends State<OnlineTaxChooseScreen> {
  UserModel _userModel;
  _OnlineTaxChooseScreenState(this._userModel);
  TextEditingController _pinCodeController = new TextEditingController();
  bool _hasError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _dialogPinRequest(String type){
    return showDialog(context: context, builder: (context){
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
                  hasError: _hasError,
                  onDone: (str){
                    if(_userModel.pinCode.toString() == str){
                      Navigator.of(context).pop();
                      if(type == 'OnlineTax'){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => OnlineTaxScreen()));
                      }else{
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SmartWaterMeterScreen()));
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
              /*RaisedButton(onPressed: (){

                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SmartWaterMeterScreen()));

                },child: Text(MyString.txt_profile_set_up,
                style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),)*/
            ],
          )
        ],);
    }, barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(MyString.txt_online_payment_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),)
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              //text header
              child: Row(
                children: <Widget>[
                  Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/calculate_tax_no_circle.png', width: 30.0, height: 30.0,)),
                  Text(MyString.txt_online_tax, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                      if(_userModel.pinCode != null){
                        setState(() {
                          _hasError = false;
                        });
                        _dialogPinRequest('OnlineTax');
                      }else{
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PinCodeSetUpScreen(_userModel)));
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          //image biz license tax
                          Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Image.asset('images/online_tax.png')),
                          //text biz license tax
                          Text(MyString.title_online_tax_payment, textAlign: TextAlign.center,style: TextStyle(fontSize: FontSize.textSizeNormal),)
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                      if(_userModel.pinCode != null){
                        _dialogPinRequest('SmartWm');
                      }else{
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PinCodeSetUpScreen(_userModel)));
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          //image property tax
                          Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Image.asset('images/smart_water_meter.png')),
                          //text property tax
                          Text(MyString.title_smart_water_meter, textAlign: TextAlign.center,style: TextStyle(fontSize: FontSize.textSizeNormal))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


