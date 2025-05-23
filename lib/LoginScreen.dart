
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:myotaw/MyoTawPolicyWebViewScreen.dart';
import 'package:myotaw/helper/MyoTawCitySetUpHelper.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/myWidget/ButtonLoadingIndicatorWidget.dart';
import 'package:myotaw/myWidget/CustomProgressIndicator.dart';
import 'package:myotaw/myWidget/DropDownWidget.dart';
import 'package:myotaw/myWidget/IosPickerWidget.dart';
import 'package:package_info/package_info.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'OtpScreen.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/PlatformHelper.dart';
import 'helper/ServiceHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'myWidget/CustomButtonWidget.dart';
import 'myWidget/WarningSnackBarWidget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> _cityList;
  String _dropDownCity = 'နေရပ်ရွေးပါ', _regionCode , _normalizedPhNo;
  bool _showLoading = false, _isCupertinoLoading = false,_isCon = false;
  var response;
  Sharepreferenceshelper _sharePrefHelper = new Sharepreferenceshelper();
  TextEditingController _phoneNoController = new TextEditingController();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  String _appVersion = '';

  List<Widget> _loginLocationWidgetList = List();
  int _locationPickerIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cityList = [_dropDownCity];
    _cityList.addAll(MyoTawCitySetUpHelper.getCityList());
    _sharePrefHelper.initSharePref();
    PackageInfo.fromPlatform().then((info){
      setState(() {
        _appVersion = info.version;
      });
    });

    _initLocationPickerWidget();
  }

  _initLocationPickerWidget(){
    for(var i in _cityList){
      _loginLocationWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  void _getOtp()async{
    _normalizedPhNo = await PhoneNumberUtil.normalizePhoneNumber(phoneNumber: _phoneNoController.text, isoCode: 'MM');
    setState(() {
      PlatformHelper.isAndroid()? _showLoading = true : _isCupertinoLoading = true;
    });
    String _hasyKey = await SmsAutoFill().getAppSignature;
    response = await ServiceHelper().getOtpCode(_normalizedPhNo, _hasyKey);
    print(response.data);
    var result = response.data;
    if(result != null){
      if(result['code'] == '002'){
        NavigatorHelper.myNavigatorPushReplacement(context, OtpScreen(_normalizedPhNo, _regionCode), ScreenName.OTP_SCREEN);
      }else{
        WarningSnackBar(_globalKey, MyString.txt_wrong_phNo);
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

  /*void _checkPhNoValid() async{
    bool _isValid = false;
    _isValid = await PhoneNumberUtil.isValidPhoneNumber(phoneNumber: _phoneNoController.text, isoCode: 'MM');
    PhoneNumberType type = await PhoneNumberUtil.getNumberType(phoneNumber: _phoneNoController.text, isoCode: 'MM');
    if(_isValid && type == PhoneNumberType.mobile){
      return true;
    }else{
      return false;
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
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
                        margin: EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 10),
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
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: MyColor.colorPrimary, width: 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),
                                  margin: EdgeInsets.only(bottom: 20),
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  child: PlatformHelper.isAndroid()?
                                      DropDownWidget(
                                       list: _cityList,
                                       value: _dropDownCity,
                                       onChange: (value){
                                         setState(() {
                                           _dropDownCity = value;
                                         });
                                       },
                                      ) :
                                      IosPickerWidget(
                                        children: _loginLocationWidgetList,
                                        text: _dropDownCity,
                                        fixedExtentScrollController: FixedExtentScrollController(initialItem: _locationPickerIndex),
                                        onPress: (){
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _dropDownCity = _cityList[_locationPickerIndex];
                                          });
                                        },
                                        onSelectedItemChanged: (i){
                                          _locationPickerIndex = i;
                                        },
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
                                  child: CustomButtonWidget(onPress: () async{

                                    if(MyString.For_Testing){
                                      //pass otp login for testing purpose
                                      _regionCode = MyoTawCitySetUpHelper.getRegionCode(_dropDownCity);
                                      _normalizedPhNo = await PhoneNumberUtil.normalizePhoneNumber(phoneNumber: _phoneNoController.text, isoCode: 'MM');
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpScreen(_normalizedPhNo, _regionCode)));
                                    }else{
                                      if(_dropDownCity != 'နေရပ်ရွေးပါ' && _phoneNoController.text.isNotEmpty){
                                        await _checkCon();
                                        if(_isCon){
                                          _regionCode = MyoTawCitySetUpHelper.getRegionCode(_dropDownCity);
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          _getOtp();
                                        }else{
                                            WarningSnackBar(_globalKey, MyString.txt_no_internet);
                                          }
                                        }else if (_dropDownCity == 'နေရပ်ရွေးပါ'){
                                            WarningSnackBar(_globalKey, MyString.txt_choose_city);
                                          }else{
                                            WarningSnackBar(_globalKey, MyString.txt_fill_phno);
                                      }
                                    }

                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(right: PlatformHelper.isAndroid()? 20 : 0),
                                            child: Text(MyString.txt_get_otp,style: TextStyle(color: Colors.white,fontSize: FontSize.textSizeSmall),)),
                                        PlatformHelper.isAndroid()?_showLoading?ButtonLoadingIndicatorWidget():Image.asset('images/get_otp.png', width: 25, height: 25,) :
                                        Container()
                                      ],
                                    ),
                                      color: MyColor.colorPrimary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                      borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              margin: EdgeInsets.only(bottom: 30),
                              child: InkWell(
                                onTap: (){
                                  NavigatorHelper.myNavigatorPush(context, MyoTawPolicyWebViewScreen(), ScreenName.MYO_TAW_POLICY_SCREEN);
                                },
                                child: Text(MyString.txt_myotaw_app_policy,
                                  style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorPrimary,decoration: TextDecoration.underline),
                                  textAlign: TextAlign.center,
                                  ),
                              ),)),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(_appVersion, style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorTextGrey),)),
                    ],
                  ),
                ),
                //tv version

              ],
            ),
          ),
        )
    );
  }
}
