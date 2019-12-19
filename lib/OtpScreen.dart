import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'package:sms_retriever/sms_retriever.dart';
import 'helper/MyoTawConstant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dio/dio.dart';
import 'helper/ServiceHelper.dart';
import 'model/UserModel.dart';
import 'package:connectivity/connectivity.dart';
import 'helper/SharePreferencesHelper.dart';
import 'package:myotaw/Database/UserDb.dart';

class OtpScreen extends StatefulWidget {
  String _phNo, _regionCode;
  OtpScreen(this._phNo, this._regionCode);
  @override
  _OtpScreenState createState() => _OtpScreenState(this._phNo, this._regionCode);
}

class _OtpScreenState extends State<OtpScreen> {
  String  _regionCode, _platForm, _phNo, _otpCode;
  bool _isExpire, _showLoading = false;
  bool _isCon = false;
  var response;
  UserModel _userModel;
  Sharepreferenceshelper _sharePrefHelper = new Sharepreferenceshelper();
  UserDb _userDb = UserDb();
  TextEditingController _otpCodeController = new TextEditingController();
  Timer _timer;
  int _minute = 9;
  int _sec = 59;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();

  _OtpScreenState(this._phNo, this._regionCode);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sharePrefHelper.initSharePref();
    _isExpire = false;
    _startTimer();
    _smsStartListening();
  }

  _smsStartListening() async{
    String _sms = await SmsRetriever.startListening();
    List _smsList = _sms.split(':');
    if(_smsList.length == 2){
      String _string = _smsList[1];
      List _list1 = _string.split(' ');
      _otpCode = _list1[1];
      print('otpCode : ${_list1[1]}');
    }
    setState(() {
      _otpCodeController.text = _otpCode;
    });
    _verifyOtp(_otpCode);
  }

  void _logIn()async{
    setState(() {
      _showLoading = true;
    });
    String fcmtoken = 'doRMZhpJvpY:APA91bG4XW1tHVIxf_jbUAT8WekmgAlDd4JZAKQm9o3DUDYqVCoWmmmaznHTgbyMxXXNZZ9FwFewZz5DcSE7ooxdLZAPdUDXeD7iD16IUP1P0DwGzzWlsRxovB1zq16FHKUcdgDGud4t';
    response = await ServiceHelper().userLogin(_phNo, _regionCode, fcmtoken, _platForm);
    var result = response.data;
    setState(() {
      _showLoading = false;
    });
    if(response.statusCode == 200){
      if(result != null){
        _userModel = UserModel.fromJson(result);
        _sharePrefHelper.setLoginSharePreference(_userModel.uniqueKey, _userModel.phoneNo, _regionCode);
        await _userDb.openUserDb();
        await _userDb.insert(_userModel);
        await _userDb.closeUserDb();
        //Fluttertoast.showToast(msg: 'Login Success', backgroundColor: Colors.black.withOpacity(0.7));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
      }else{
        //WarningSnackBar(_globalKey, MyString.txt_try_again);
        WarningSnackBar(_globalKey, MyString.txt_try_again);
      }
    }else{
      //WarningSnackBar(_globalKey, MyString.txt_try_again);
      WarningSnackBar(_globalKey, MyString.txt_try_again);
    }
  }

  _verifyOtp(String code) async{
    setState(() {
      _showLoading = true;
    });
    response = await ServiceHelper().verifyOtp(_phNo, code);
    var result = response.data;
    if(response.statusCode == 200){
      if(result != null){
        if(result['code'] == '002'){
          _logIn();
        }
      }else{
        setState(() {
          _showLoading = false;
        });
        WarningSnackBar(_globalKey, MyString.txt_try_again);
      }
    }else{
      setState(() {
        _showLoading = false;
      });
      WarningSnackBar(_globalKey, MyString.txt_try_again);
    }
  }

  void _getOtp()async{
    setState(() {
      _showLoading = true;
    });
    String _hasyKey = await SmsRetriever.getAppSignature();
    response = await ServiceHelper().getOtpCode(_phNo, _hasyKey);
    var result = response.data;
    setState(() {
      _showLoading = false;
    });
    if(response.statusCode == 200){
      if(result != null){
        if(result['code'] == '002'){
          setState(() {
            _minute = 9;
            _sec = 59;
            _isExpire = false;
            _startTimer();
          });
        }
      }else{
        WarningSnackBar(_globalKey, MyString.txt_try_again);
      }
    }else{
      WarningSnackBar(_globalKey, MyString.txt_try_again);
    }
  }

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
    print('isCon : ${_isCon}');
  }

  Widget modalProgressIndicator(){
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

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (time){
      setState(() {
        if(_minute == 0 && _sec == 0){
          _timer.cancel();
          _isExpire = true;
          return;
        }
        _sec = _sec - 1;
        if(_sec == 0 && _minute != 0){
          setState(() {
            _sec = 59;
            _minute = _minute - 1;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: _showLoading,
          progressIndicator: modalProgressIndicator(),
          child: Center(
            child: Stack(
              children: <Widget>[
                //color primary bg
                Container(
                  color: MyColor.colorPrimary,
                  width: double.maxFinite,
                  height: 300,
                ),
                //login card
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(bottom: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("images/myotaw_icon_white.png", width: 90, height: 80,),
                      Container(
                        margin: EdgeInsets.all(30),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            margin: EdgeInsets.all(30),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(bottom: 30),
                                    child: Text(MyString.txt_enter_otp, style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorPrimary), textAlign: TextAlign.center,)),
                                Container(
                                  margin: EdgeInsets.only(bottom: 30.0),
                                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      border: Border.all(color: MyColor.colorPrimary, style: BorderStyle.solid, width: 0.80)
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon: Icon(Icons.phone_android, color: MyColor.colorPrimary,),
                                      hintText: 'xxxxxx',
                                    ),
                                    cursorColor: MyColor.colorPrimary,
                                    controller: _otpCodeController,
                                    style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack,),
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                                Container(
                                  width: double.maxFinite,
                                  height: 45.0,
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: RaisedButton(onPressed: () async{
                                    //_logIn();
                                    await _checkCon();
                                    if(_isCon){
                                      if(_isExpire){
                                        _getOtp();

                                      }else{
                                        if(_otpCodeController.text.isNotEmpty && _otpCodeController.text != null){
                                          if(_otpCodeController.text.length == 4){
                                            FocusScope.of(context).requestFocus(FocusNode());
                                            _verifyOtp(_otpCodeController.text);
                                          }else{
                                            //Fluttertoast.showToast(msg: MyString.txt_otp_not_exceed_4, backgroundColor: Colors.black.withOpacity(0.7));
                                            WarningSnackBar(_globalKey, MyString.txt_otp_not_exceed_4);
                                          }

                                        }else{
                                          //Fluttertoast.showToast(msg: MyString.txt_enter_otp, backgroundColor: Colors.black.withOpacity(0.7));
                                          WarningSnackBar(_globalKey, MyString.txt_enter_otp);
                                        }
                                      }

                                    }else{
                                      //Fluttertoast.showToast(msg: MyString.txt_no_internet, backgroundColor: Colors.black.withOpacity(0.7));
                                      WarningSnackBar(_globalKey, MyString.txt_no_internet);
                                    }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(right: 20),
                                            child: Text(_isExpire?MyString.txt_get_otp:MyString.txt_fill_otp,style: TextStyle(color: Colors.white),)),
                                        Image.asset(_isExpire?'images/get_otp.png':'images/send_otp.png', width: 25, height: 25,)
                                      ],
                                    ),
                                      color: MyColor.colorPrimary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
                                ),
                                _isExpire? Container() :
                                Text('OTP expire in - $_minute : $_sec min', style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorPrimary),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //tv version
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text("Version 1.0", style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextGrey),)),
                ),
              ],
            ),
          ),
        )
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SmsRetriever.stopListening();
    _timer.cancel();
  }
}
