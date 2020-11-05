import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'package:myotaw/model/UserModel.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'helper/ServiceHelper.dart';
import 'package:dio/dio.dart';
import 'Database/UserDb.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'myWidget/CustomButtonWidget.dart';
import 'myWidget/CustomProgressIndicator.dart';

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
          _userDb.closeUserDb();
          CustomDialogWidget().customSuccessDialog(
            context: context,
            content: MyString.txt_pin_set_up_success,
            img: 'pin_lock.png',
            onPress: (){
              Navigator.of(context).pop();
              Navigator.of(context).pop({'isRefresh' : true});
            }
          );
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

  Widget _body(){
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: CustomProgressIndicatorWidget(),
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
                  height: 400.0,
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
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            child: PinCodeTextField(
                              pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                              pinTextAnimatedSwitcherDuration: Duration(milliseconds: 100),
                              pinBoxHeight: 40,
                              pinBoxWidth: 40,
                              wrapAlignment: WrapAlignment.center,
                              pinBoxRadius: 5,
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
                            width: double.maxFinite,
                            child: CustomButtonWidget(onPress: (){
                              if(_pinCodeController.text.isNotEmpty){
                                _userModel.pinCode = int.parse(_pinCodeController.text);
                                FireBaseAnalyticsHelper.trackClickEvent(ScreenName.PIN_CODE_SET_UP_SCREEN, ClickEvent.PIN_CODE_SET_UP_CLICK_EVENT, _userModel.uniqueKey);
                                _updateUser();
                              }else{
                                WarningSnackBar(_scaffoldState, MyString.txt_need_pin_code);
                              }

                            }, child: Text(MyString.txt_create_pin, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                              color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              borderRadius: BorderRadius.circular(10),
                            ),
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
      title: Text(MyString.txt_online_tax,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(),
      globalKey: _scaffoldState,
    );
  }
}
