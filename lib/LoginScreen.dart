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
import 'helper/UserDb.dart';
import 'helper/DbHelper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> _cityList;
  String _dropDownCity = 'နေရပ်ရွေးပါ', _phoneNo;
  FlutterAccountKit _flutterAccountKit = new FlutterAccountKit();
  bool _isInitialized, _showLoading = false;
  bool _isCon = false;
  Response response;
  UserModel _userModel;
  Sharepreferenceshelper _sharePrefHelper = new Sharepreferenceshelper();
  final userDb = UserDb.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cityList = [_dropDownCity,'တောင်ကြီးမြို့','မော်လမြိုင်မြို့'];
    initAccountkit();
    _sharePrefHelper.initSharePref();
  }

  Future<void> initAccountkit()async{
    print('Init account kit called');
    bool initialized = false;
    try{
      final theme =
      await _flutterAccountKit.configure(
        Config(
          theme: AccountKitTheme(
              headerBackgroundColor: Colors.lightBlueAccent,
              buttonBackgroundColor: Colors.white,
              buttonBorderColor: Colors.lightBlue,
              buttonTextColor: Colors.teal,
              backgroundColor: Colors.teal,
              statusBarStyle: StatusBarStyle.defaultStyle,
              inputBackgroundColor: Colors.teal
          ),
          facebookNotificationsEnabled: true,
          receiveSMS: true,
          readPhoneStateEnabled: true,
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
    response = await ServiceHelper().userLogin(phoneNo, 'TGY', fcmtoken, 'Android');
    var result = response.data;
    setState(() {
      _showLoading = false;
    });
    if(response.statusCode == 200){
      if(result != null){
        _userModel = UserModel.fromJson(result);
        _sharePrefHelper.setLoginSharePreference(_userModel.uniqueKey, _userModel.phoneNo, _userModel.currentRegionCode);
        await _insert(_userModel);
        Fluttertoast.showToast(msg: 'Login Success', backgroundColor: Colors.black.withOpacity(0.7));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
        print('userModel: ${_userModel.uniqueKey} ${_userModel.state}');
      }else{
        Fluttertoast.showToast(msg: 'နောက်တစ်ကြိမ်လုပ်ဆောင်ပါ။', backgroundColor: Colors.black.withOpacity(0.7));
      }
    }else{
      Fluttertoast.showToast(msg: 'နောက်တစ်ကြိမ်လုပ်ဆောင်ပါ။', backgroundColor: Colors.black.withOpacity(0.7));
    }
  }

 void _insert(UserModel model)async{
   Map<String, dynamic> row = {
     DbHelper.COLUMN_USER_UNIQUE : model.uniqueKey,
     DbHelper.COLUMN_USER_NAME : model.name,
     DbHelper.COLUMN_USER_PHONE_NO : model.phoneNo,
     DbHelper.COLUMN_USER_PHOTO_URL : model.photoUrl,
     DbHelper.COLUMN_USER_STATE : model.state,
     DbHelper.COLUMN_USER_TOWNSHIP : model.township,
     DbHelper.COLUMN_USER_ADDRESS : model.address,
     DbHelper.COLUMN_USER_REGISTERED_DATE : model.registeredDate,
     DbHelper.COLUMN_USER_ACCESSTIME : model.accesstime,
     DbHelper.COLUMN_USER_IS_DELETED : model.isDeleted,
     DbHelper.COLUMN_USER_RESOURCE : model.resource,
     DbHelper.COLUMN_USER_ANDROID_TOKEN : model.androidToken,
     DbHelper.COLUMN_USER_CURRENT_REGION_CODE : model.currentRegionCode,
     DbHelper.COLUMN_USER_PIN_CODE : model.pinCode,
     DbHelper.COLUMN_USER_AMOUNT : model.amount
   };
   await userDb.insert(row);
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
                  child: Text('Loading......',style: TextStyle(fontSize: fontSize.textSizeNormal, color: Colors.black))),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(myColor.colorPrimary))
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
                      child: Text('Myo Taw', style: TextStyle(fontSize: fontSize.textSizeNormal, color: myColor.colorPrimary),)),
                  Text("Version 1.0", style: TextStyle(fontSize: fontSize.textSizeSmall, color: myColor.colorTextGrey),),
                  Container(
                    width: 300.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: myColor.colorPrimary, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    padding: EdgeInsets.only(left:10.0, right: 10.0),
                    margin: EdgeInsets.only(top: 70.0,bottom: 30.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        style: new TextStyle(fontSize: 13.0, color: Colors.black87),
                        isExpanded: true,
                        icon: Icon(Icons.location_city),
                        iconEnabledColor: myColor.colorPrimary,
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
                          //_loginAccountKit();
                          //webService('+959254900916');
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainScreen()));
                        }else{
                          Fluttertoast.showToast(msg: 'No Internet Connection', backgroundColor: Colors.black.withOpacity(0.7));
                        }
                      }
                      },child: Text('ဝင်မည်',style: TextStyle(color: Colors.white),),
                      color: myColor.colorPrimary,
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
