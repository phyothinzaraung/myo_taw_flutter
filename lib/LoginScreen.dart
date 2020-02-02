import 'package:flutter/material.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/myWidget/ButtonLoadingIndicatorWidget.dart';
import 'package:package_info/package_info.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'OtpScreen.dart';
import 'helper/MyoTawConstant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dio/dio.dart';
import 'helper/ServiceHelper.dart';
import 'package:connectivity/connectivity.dart';
import 'helper/SharePreferencesHelper.dart';
import 'OtpScreen.dart';
import 'myWidget/CustomButtonWidget.dart';
import 'myWidget/WarningSnackBarWidget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> _cityList;
  String _dropDownCity = 'နေရပ်ရွေးပါ', _regionCode , _normalizedPhNo;
  bool _showLoading = false;
  bool _isCon = false;
  var response;
  Sharepreferenceshelper _sharePrefHelper = new Sharepreferenceshelper();
  TextEditingController _phoneNoController = new TextEditingController();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  String _appVersion = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cityList = [_dropDownCity,MyString.TGY_CITY,MyString.MLM_CITY, MyString.LKW_CITY];
    _sharePrefHelper.initSharePref();
    PackageInfo.fromPlatform().then((info){
      setState(() {
        _appVersion = info.version;
      });
    });
  }

  void _getOtp()async{
    setState(() {
      _showLoading = true;
    });
    String _hasyKey = await SmsAutoFill().getAppSignature;
    response = await ServiceHelper().getOtpCode(_normalizedPhNo, _hasyKey);
    var result = response.data;
    if(result != null){
      if(result['code'] == '002'){
        NavigatorHelper().MyNavigatorPushReplacement(context, OtpScreen(_normalizedPhNo, _regionCode), ScreenName.OTP_SCREEN);
      }
    }else{
      WarningSnackBar(_globalKey, MyString.txt_try_again);
    }

    setState(() {
      _showLoading = false;
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

  Future<bool> _checkPhNoValid() async{
    bool _isValid = false;
    _normalizedPhNo = await PhoneNumberUtil.normalizePhoneNumber(phoneNumber: _phoneNoController.text, isoCode: 'MM');
    _isValid = await PhoneNumberUtil.isValidPhoneNumber(phoneNumber: _phoneNoController.text, isoCode: 'MM');

    return _isValid && !_normalizedPhNo.contains('+951');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
        backgroundColor: Colors.white,
        body: Center(
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
                                  child: Text(MyString.txt_welcome, style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorPrimary), textAlign: TextAlign.center,)),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: MyColor.colorPrimary, width: 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                                ),
                                margin: EdgeInsets.only(bottom: 20),
                                padding: EdgeInsets.only(left: 15, right: 15),
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
                                margin: EdgeInsets.only(bottom: 30.0),
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.0),
                                    border: Border.all(color: MyColor.colorPrimary, style: BorderStyle.solid, width: 0.80)
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: Icon(Icons.phone, color: MyColor.colorPrimary,),
                                    hintText: '09xxxxxx',
                                  ),
                                  cursorColor: MyColor.colorPrimary,
                                  controller: _phoneNoController,
                                  style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack,),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 45.0,
                                child: CustomButtonWidget(onPress: () async{
                                  if(_dropDownCity != 'နေရပ်ရွေးပါ' && _phoneNoController.text.isNotEmpty){
                                    await _checkCon();
                                    if(_isCon){
                                      switch(_dropDownCity){
                                        case MyString.TGY_CITY:
                                          _regionCode = MyString.TGY_REGIONCODE;
                                          break;
                                        case MyString.MLM_CITY:
                                          _regionCode = MyString.MLM_REGIONCODE;
                                          break;
                                        case MyString.LKW_CITY:
                                          _regionCode = MyString.LKW_REGIONCODE;
                                          break;
                                        default:
                                      }
                                      bool _isValid = await _checkPhNoValid();
                                      if(_isValid){
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        _getOtp();
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(_normalizedPhNo, _regionCode)));
                                        //print(await SmsAutoFill().getAppSignature);
                                      }else{
                                        WarningSnackBar(_globalKey, MyString.txt_wrong_phNo);
                                      }
                                    }else{
                                      WarningSnackBar(_globalKey, MyString.txt_no_internet);
                                      }
                                    }else if (_dropDownCity == 'နေရပ်ရွေးပါ'){
                                      WarningSnackBar(_globalKey, MyString.txt_choose_city);
                                      }else{
                                        WarningSnackBar(_globalKey, MyString.txt_fill_phno);
                                      }
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(_normalizedPhNo, _regionCode)));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 20),
                                          child: Text(MyString.txt_get_otp,style: TextStyle(color: Colors.white),)),
                                      _showLoading?ButtonLoadingIndicatorWidget():Image.asset('images/get_otp.png', width: 25, height: 25,)
                                    ],
                                  ),
                                    color: MyColor.colorPrimary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(_appVersion, style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorTextGrey),)),
                  ],
                ),
              ),
              //tv version

            ],
          ),
        )
    );
  }
}
