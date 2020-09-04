import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:myotaw/NewsFeedScreen.dart';
import 'package:myotaw/WardAdminFeatureChooseScreen.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/myWidget/CustomProgressIndicator.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'package:package_info/package_info.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/PlatformHelper.dart';
import 'main.dart';
import 'helper/ServiceHelper.dart';
import 'model/UserModel.dart';
import 'package:connectivity/connectivity.dart';
import 'helper/SharePreferencesHelper.dart';
import 'package:myotaw/Database/UserDb.dart';
import 'myWidget/ButtonLoadingIndicatorWidget.dart';
import 'myWidget/CustomButtonWidget.dart';

class OtpScreen extends StatefulWidget {
  String _phNo, _regionCode;
  OtpScreen(this._phNo, this._regionCode);
  @override
  _OtpScreenState createState() => _OtpScreenState(this._phNo, this._regionCode);
}

class _OtpScreenState extends State<OtpScreen> {
  String  _regionCode, _platForm, _phNo, _otpCode;
  bool _isExpire, _showLoading = false,_isCupertinoLoading = false;
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
  String _appVersion = '';
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List _isFormRegionCode = [MyString.HLY_REGION_CODE];

  _OtpScreenState(this._phNo, this._regionCode);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sharePrefHelper.initSharePref();
    _isExpire = false;
    _startTimer();
    _smsStartListening();
    PackageInfo.fromPlatform().then((info){
      setState(() {
        _appVersion = info.version;
      });
    });
  }

  _smsStartListening() async{
    await SmsAutoFill().listenForCode;
    SmsAutoFill().code.listen((code){
      if(code.isNotEmpty && code != null){
        setState(() {
          _otpCodeController.text = code;
        });
        _verifyOtp(code);
      }
      print('otp code : $code');
    });
  }

  bool isForm(){

  }

  void _logIn()async{
    setState(() {
      PlatformHelper.isAndroid()? _showLoading = true : _isCupertinoLoading = true;
    });
    String fcmToken = await _firebaseMessaging.getToken();
    if(PlatformHelper.isAndroid()){
      _platForm = 'Android';
    }else{
      _platForm = 'Ios';
    }
    try{
      print('$_phNo $_regionCode $fcmToken $_platForm' );
      response = await ServiceHelper().userLogin(_phNo, _regionCode, fcmToken, _platForm);
      var result = response.data;
      print('user : $result');
      if(result != null){
        _userModel = UserModel.fromJson(result);
        _sharePrefHelper.setLoginSharePreference(_userModel.uniqueKey, _userModel.phoneNo,
            _regionCode, _userModel.isWardAdmin?true:false, _userModel.wardName, fcmToken);
        await _userDb.openUserDb();
        await _userDb.insert(_userModel);
        _userDb.closeUserDb();
        if(_userModel.isWardAdmin){

          NavigatorHelper.myNavigatorPushReplacement(context,
              WardAdminFeatureChooseScreen(isForm: _userModel.currentRegionCode == MyString.HLY_REGION_CODE?true:false), ScreenName.WARD_ADMIN_FEATURE_SCREEN);
        }else{

          NavigatorHelper.myNavigatorPushReplacement(context, MainScreen(), null);
        }

      }else{
        WarningSnackBar(_globalKey, MyString.txt_try_again);
      }
    }catch(e){
      print(e);
      WarningSnackBar(_globalKey, MyString.txt_try_again);
    }

    setState(() {
      PlatformHelper.isAndroid()? _showLoading = false : _isCupertinoLoading = false;
    });
  }

  _verifyOtp(String code) async{
    setState(() {
      PlatformHelper.isAndroid()? _showLoading = true : _isCupertinoLoading = true;
    });
    response = await ServiceHelper().verifyOtp(_phNo, code);
    var result = response.data;
    if(result != null){
      if(result['code'] == '002'){
        _logIn();
      }else{
        WarningSnackBar(_globalKey, MyString.txt_wrong_pin_code);
      }
    }else{
      WarningSnackBar(_globalKey, MyString.txt_try_again);
    }

    setState(() {
      PlatformHelper.isAndroid()? _showLoading = false : _isCupertinoLoading = false;
    });
  }

  void _getOtp()async{
    setState(() {
      PlatformHelper.isAndroid()? _showLoading = true : _isCupertinoLoading = true;
    });
    String _hasyKey = await SmsAutoFill().getAppSignature;
    response = await ServiceHelper().getOtpCode(_phNo, _hasyKey);
    var result = response.data;
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

    setState(() {
      PlatformHelper.isAndroid()? _showLoading = false : _isCupertinoLoading = false;
    });
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

  Widget _body(BuildContext context){
    return ModalProgressHUD(
      inAsyncCall: _isCupertinoLoading,
      progressIndicator: CustomProgressIndicatorWidget(),
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
              margin: EdgeInsets.only(top: 50),
              child: ListView(
                children: <Widget>[
                  Hero(
                      tag: 'myotaw',
                      child: Image.asset("images/myo_taw_logo_eng.png", width: 90, height: 80,)),
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
                                maxLength: 4,
                              ),
                            ),
                            Container(
                              width: double.maxFinite,
                              margin: EdgeInsets.only(bottom: 20),
                              child: CustomButtonWidget(onPress: () async{
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
                                        //_logIn();
                                      }else{
                                        WarningSnackBar(_globalKey, MyString.txt_otp_not_exceed_4);
                                      }

                                    }else{
                                      WarningSnackBar(_globalKey, MyString.txt_enter_otp);
                                    }
                                  }

                                }else{
                                  WarningSnackBar(_globalKey, MyString.txt_no_internet);
                                }
                              },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(right: PlatformHelper.isAndroid()? 20 : 0),
                                        child: Text(_isExpire?MyString.txt_get_otp:MyString.txt_login,
                                          style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeSmall),
                                        )
                                    ),
                                    PlatformHelper.isAndroid()?_showLoading?ButtonLoadingIndicatorWidget():Image.asset('images/get_otp.png', width: 25, height: 25,) :
                                    Container()
                                  ],
                                ),
                                color: MyColor.colorPrimary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            _isExpire? Container() :
                            Text('OTP will expire in - $_minute : $_sec min', style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorPrimary),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(_appVersion, style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorTextGrey),)
                    ),
                  ),
                ],
              ),
            ),
            //tv version
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
        backgroundColor: Colors.white,
        body: _body(context)
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    SmsAutoFill().unregisterListener();
  }
}
