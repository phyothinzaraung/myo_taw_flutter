import 'package:flutter/material.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:sms_retriever/sms_retriever.dart';
import 'helper/MyoTawConstant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dio/dio.dart';
import 'helper/ServiceHelper.dart';
import 'model/UserModel.dart';
import 'package:connectivity/connectivity.dart';
import 'helper/SharePreferencesHelper.dart';
import 'package:myotaw/Database/UserDb.dart';
import 'OtpScreen.dart';
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
  Response response;
  Sharepreferenceshelper _sharePrefHelper = new Sharepreferenceshelper();
  TextEditingController _phoneNoController = new TextEditingController();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cityList = [_dropDownCity,MyString.TGY_CITY,MyString.MLM_CITY];
    _sharePrefHelper.initSharePref();
  }

  void _getOtp()async{
    setState(() {
      _showLoading = true;
    });
    String _hasyKey = await SmsRetriever.getAppSignature();
    try{
      response = await ServiceHelper().getOtpCode(_normalizedPhNo, _hasyKey);
      var result = response.data;
      if(result != null){
        if(result['code'] == '002'){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpScreen(_normalizedPhNo, _regionCode)));
        }
      }else{
        WarningSnackBar(_globalKey, MyString.txt_try_again);
      }
    }catch(e){
      print(e);
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
                                  child: RaisedButton(onPressed: () async{
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
                                          default:
                                        }
                                        bool _isValid = await _checkPhNoValid();
                                        if(_isValid){
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          _getOtp();
                                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpScreen(_normalizedPhNo, _regionCode)));
                                        }else{
                                          //Fluttertoast.showToast(msg: MyString.txt_wrong_phNo , backgroundColor: Colors.black.withOpacity(0.7));
                                          WarningSnackBar(_globalKey, MyString.txt_wrong_phNo);
                                        }
                                      }else{
                                        //Fluttertoast.showToast(msg: MyString.txt_no_internet, backgroundColor: Colors.black.withOpacity(0.7));
                                        WarningSnackBar(_globalKey, MyString.txt_no_internet);
                                      }
                                    }else if (_dropDownCity == 'နေရပ်ရွေးပါ'){
                                      //Fluttertoast.showToast(msg: MyString.txt_choose_city, backgroundColor: Colors.black.withOpacity(0.7));
                                      WarningSnackBar(_globalKey, MyString.txt_choose_city);
                                    }else{
                                      //Fluttertoast.showToast(msg: MyString.txt_fill_phno, backgroundColor: Colors.black.withOpacity(0.7));
                                      WarningSnackBar(_globalKey, MyString.txt_fill_phno);
                                    }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(right: 20),
                                            child: Text(MyString.txt_get_otp,style: TextStyle(color: Colors.white),)),
                                        Image.asset('images/get_otp.png', width: 25, height: 25,)
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
}
