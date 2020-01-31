import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'package:myotaw/model/UserModel.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'helper/ServiceHelper.dart';
import 'package:dio/dio.dart';
import 'Database/UserDb.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PinCodeSetUpScreen extends StatefulWidget {
  UserModel model;
  PinCodeSetUpScreen(this.model);
  @override
  _PinCodeSetUpScreenState createState() => _PinCodeSetUpScreenState(this.model);
}

class _PinCodeSetUpScreenState extends State<PinCodeSetUpScreen> {
  UserModel _userModel;
  TextEditingController _pinCodeController = TextEditingController();
  Response _response;
  bool _isCon, _isLoading = false;
  UserDb _userDb = UserDb();
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  _PinCodeSetUpScreenState(this._userModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
  }

  _finishDialogBox(){
    return showDialog(
        context: context,
        builder: (ctxt){
          return WillPopScope(
            child: SimpleDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: Image.asset('images/pin_lock.png', width: 50.0, height: 50.0,)),
                      Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text(MyString.txt_pin_set_up_success,
                            style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),textAlign: TextAlign.center,)),
                      Container(
                        width: 200.0,
                        height: 45.0,
                        child: RaisedButton(onPressed: ()async{
                          Navigator.of(context).pop();
                          Navigator.of(context).pop({'isNeedRefresh' : true});

                        }, child: Text(MyString.txt_close, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                          color: MyColor.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                      )
                    ],
                  ),
                )
              ],
            ),onWillPop: (){},
          );
        }, barrierDismissible: false);
  }

  void _updateUser()async{
    await _checkCon();
    setState(() {
      _isLoading = true;
    });
    if(_isCon){
      try{
        _response = await ServiceHelper().updateUserInfo(_userModel);
        if(_response.data != null){
          await _userDb.openUserDb();
          await _userDb.insert(UserModel.fromJson(_response.data));
          await _userDb.closeUserDb();
          _finishDialogBox();
        }else{
          WarningSnackBar(_scaffoldState, MyString.txt_try_again);
        }
      }catch(e){
        print(e);
        WarningSnackBar(_scaffoldState, MyString.txt_try_again);
      }

    }else{
      WarningSnackBar(_scaffoldState, MyString.txt_no_internet);
    }
    setState(() {
      _isLoading = false;
    });
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
                  child: Text('Loading......',style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack))),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColor.colorPrimary))
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(){
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: modalProgressIndicator(),
      child: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
                  child: Row(
                    children: <Widget>[
                      Container(margin: EdgeInsets.only(right: 10.0),
                          child: Image.asset('images/online_tax_no_circle.png', width: 30.0, height: 30.0,)),
                      Text(MyString.txt_online_tax, style: TextStyle(fontSize: FontSize.textSizeSmall),)
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  height: 380.0,
                  child: Card(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                    color: MyColor.colorPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            child: CircleAvatar(
                              backgroundImage: _userModel.photoUrl==null?AssetImage('images/profile_placeholder.png'):
                              NetworkImage(BaseUrl.USER_PHOTO_URL+_userModel.photoUrl),
                              backgroundColor: MyColor.colorGrey,
                              radius: 60.0,
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(bottom: 20.0),
                              child: Text(_userModel.name, style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),)),
                          Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            alignment: Alignment.center,
                            child: PinCodeTextField(
                              pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                              pinTextAnimatedSwitcherDuration: Duration(milliseconds: 100),
                              pinBoxHeight: 40,
                              pinBoxWidth: 40,
                              defaultBorderColor: Colors.white,
                              hideCharacter: false,
                              maskCharacter: '*',
                              hasTextBorderColor: Colors.white,
                              pinTextStyle: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),
                              controller:  _pinCodeController,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            height: 45.0,
                            width: double.maxFinite,
                            child: RaisedButton(onPressed: (){
                              if(_pinCodeController.text.isNotEmpty){
                                _userModel.pinCode = int.parse(_pinCodeController.text);
                                FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.PIN_CODE_SET_UP_SCREEN, ClickEvent.PIN_CODE_SET_UP_CLICK_EVENT, _userModel.uniqueKey);
                                _updateUser();
                              }else{
                                WarningSnackBar(_scaffoldState, MyString.txt_need_pin_code);
                              }

                            }, child: Text(MyString.txt_create_pin, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                              color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                          ),

                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: MyString.txt_online_tax,
      body: _body(),
      globalKey: _scaffoldState,
    );
    /*return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text(MyString.txt_online_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body:
    );*/
  }
}
