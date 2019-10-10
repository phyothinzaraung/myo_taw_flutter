import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main.dart';
import 'package:flutter/services.dart';
import 'package:flutter_account_kit/flutter_account_kit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dio/dio.dart';
import 'helper/ServiceHelper.dart';
import 'model/UserModel.dart';
import 'package:connectivity/connectivity.dart';
import 'helper/SharePreferencesHelper.dart';
import 'package:myotaw/Database/UserDb.dart';
import 'dart:io';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> _cityList;
  String _dropDownCity = 'နေရပ်ရွေးပါ', _regionCode, _platForm;
  FlutterAccountKit _flutterAccountKit = new FlutterAccountKit();
  bool _isInitialized, _showLoading = false;
  bool _isCon = false;
  Response response;
  UserModel _userModel;
  Sharepreferenceshelper _sharePrefHelper = new Sharepreferenceshelper();
  UserDb _userDb = UserDb();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cityList = [_dropDownCity,MyString.TGY_CITY,MyString.MLM_CITY];
    initAccountkit();
    _sharePrefHelper.initSharePref();
  }

  _initTargetPlatform(){
    if(Platform.isAndroid){
      _platForm = 'Android';
    }else{
      _platForm = 'ios';
    }
  }

  Future<void> initAccountkit()async{
    print('Init account kit called');
    bool initialized = false;
    try{
      await _flutterAccountKit.configure(
        Config(
          theme: AccountKitTheme(
              headerBackgroundColor: MyColor.colorPrimary,
              backgroundColor: MyColor.colorPrimaryDark,
              statusBarStyle: StatusBarStyle.lightStyle,
              headerButtonTextColor: Colors.white,
              titleColor: Colors.white,
              headerTextColor: Colors.white,
              textColor: Colors.white,
              iconColor: Colors.white,

              buttonBackgroundColor: MyColor.colorPrimaryDark,
              buttonBorderColor: Colors.white,
              buttonTextColor: Colors.white,
              buttonDisabledBackgroundColor: MyColor.colorGreyDark,
              buttonDisabledBorderColor: MyColor.colorGrey,
              buttonDisabledTextColor: MyColor.colorGrey,

              inputBackgroundColor: MyColor.colorPrimaryDark,
              inputBorderColor: Colors.white,
              inputTextColor: Colors.white,
          ),
          facebookNotificationsEnabled: true,
          receiveSMS: true,
          readPhoneStateEnabled: false,
        )
      );
    }on PlatformException{
      print('Failed to Init Account kit');
    }

    if(!mounted) return;
    setState(() {
      _isInitialized = initialized;
      print('Initialized ${_isInitialized}');
    });
  }

  Future<void> _loginAccountKit() async{
    final result = await _flutterAccountKit.logInWithPhone();
    final Account account = await _flutterAccountKit.currentAccount;
    if(result.accessToken != null){
      webService(account.phoneNumber.toString());
      print('userPhone: ${result.status}${account.phoneNumber}');
    }else{
      print('userPhone: ${result.status}');
    }
  }

  void webService(String phoneNo)async{
    setState(() {
      _showLoading = true;
    });
    String fcmtoken = 'doRMZhpJvpY:APA91bG4XW1tHVIxf_jbUAT8WekmgAlDd4JZAKQm9o3DUDYqVCoWmmmaznHTgbyMxXXNZZ9FwFewZz5DcSE7ooxdLZAPdUDXeD7iD16IUP1P0DwGzzWlsRxovB1zq16FHKUcdgDGud4t';
    response = await ServiceHelper().userLogin(phoneNo, _regionCode, fcmtoken, _platForm);
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
        Fluttertoast.showToast(msg: 'Login Success', backgroundColor: Colors.black.withOpacity(0.7));
        if(_userModel.name != null){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen(_userModel)));
        }else{

        }
      }else{
        Fluttertoast.showToast(msg: 'နောက်တစ်ကြိမ်လုပ်ဆောင်ပါ။', backgroundColor: Colors.black.withOpacity(0.7));
      }
    }else{
      Fluttertoast.showToast(msg: 'နောက်တစ်ကြိမ်လုပ်ဆောင်ပါ။', backgroundColor: Colors.black.withOpacity(0.7));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: _showLoading,
          progressIndicator: modalProgressIndicator(),
          child: Center(
            child: Container(
              margin: EdgeInsets.only(left: 70.0, right: 70.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("images/myo_taw_splash_screen.jpg"),
                  Padding(padding: EdgeInsets.only(bottom: 5.0),
                      child: Text('Myo Taw', style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorPrimary),)),
                  Text("Version 1.0", style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextGrey),),
                  Container(
                    width: 300.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColor.colorPrimary, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    padding: EdgeInsets.only(left:10.0, right: 10.0),
                    margin: EdgeInsets.only(top: 70.0,bottom: 30.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        style: new TextStyle(fontSize: 13.0, color: Colors.black87),
                        isExpanded: true,
                        icon: Icon(Icons.location_city),
                        iconEnabledColor: MyColor.colorPrimary,
                        value: _dropDownCity,
                        onChanged: (String value){
                          setState(() {
                            _dropDownCity = value;
                          });
                        },
                        items: _cityList.map<DropdownMenuItem<String>>((String str){
                          return DropdownMenuItem<String>(
                            value: str,
                            child: Text(str),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    width: 300.0,
                    height: 45.0,
                    child: RaisedButton(onPressed: () async{
                      if(_dropDownCity == 'နေရပ်ရွေးပါ'){
                        Fluttertoast.showToast(msg: 'Please Choose City', backgroundColor: Colors.black.withOpacity(0.7));
                      }else{
                        await _checkCon();
                        if(_isCon){
                          _initTargetPlatform();
                          switch(_dropDownCity){
                            case MyString.TGY_CITY:
                              _regionCode = MyString.TGY_REGIONCODE;
                              break;
                            case MyString.MLM_CITY:
                              _regionCode = MyString.MLM_REGIONCODE;
                              break;
                            default:
                          }
                          _loginAccountKit();
                          //webService('+959254900916');
                          //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen(_userModel)));
                        }else{
                          Fluttertoast.showToast(msg: 'No Internet Connection', backgroundColor: Colors.black.withOpacity(0.7));
                        }
                      }
                      },child: Text('ဝင်မည်',style: TextStyle(color: Colors.white),),
                      color: MyColor.colorPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
