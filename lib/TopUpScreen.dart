import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'model/UserModel.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'helper/ServiceHelper.dart';

class TopUpScreen extends StatefulWidget {
  UserModel model;
  TopUpScreen(this.model);
  @override
  _TopUpScreenState createState() => _TopUpScreenState(this.model);
}

class _TopUpScreenState extends State<TopUpScreen> {
  UserModel _userModel;
  TextEditingController _prepaidCodeController = TextEditingController();
  TextEditingController _pinCodeController = TextEditingController();
  bool _isLoading = false;
  bool _hasError = false;
  bool _isCon = false;
  var _response;
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  _TopUpScreenState(this._userModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _callWebService() async{
    setState(() {
      _isLoading = true;
    });
    _response = await ServiceHelper().getTopUp(_prepaidCodeController.text, _userModel.uniqueKey);
    if(_response.data == 'Success'){
      Navigator.of(context).pop({'isNeedRefresh' : true});
    }else if(_response.data == 'Expired Date'){
      WarningSnackBar(_scaffoldState, MyString.txt_top_up_expired);
    }else{
      WarningSnackBar(_scaffoldState, MyString.txt_top_up_already);
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

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
  }

  _dialogConfirm(){
    return showDialog(context: context, builder: (context){
      return WillPopScope(
          child: SimpleDialog(
            contentPadding: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
            children: <Widget>[
              Column(
                children: <Widget>[
                  //image
                  Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Image.asset('images/online_tax_no_circle.png', width: 60.0, height: 60.0,)),
                  //text are u sure
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(MyString.txt_are_u_sure,
                      style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack,),textAlign: TextAlign.center,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //btn top up
                    RaisedButton(onPressed: (){
                      Navigator.of(context).pop();
                      _callWebService();

                      },child: Text(MyString.txt_top_up,
                      style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),),
                    //btn out
                    RaisedButton(onPressed: (){
                      Navigator.pop(context);

                      },child: Text(MyString.txt_log_out,
                      style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),color: MyColor.colorGrey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),)
                  ],)
                ],
              )
            ],), onWillPop: (){});
    }, barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text(MyString.title_top_up, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: modalProgressIndicator(),
        child: ListView(
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
              height: 480.0,
              child: Card(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                color: MyColor.colorPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //profile photo
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: CircleAvatar(
                          backgroundImage: _userModel.photoUrl==null?AssetImage('images/profile_placeholder.png'):
                          NetworkImage(BaseUrl.USER_PHOTO_URL+_userModel.photoUrl),
                          backgroundColor: MyColor.colorGrey,
                          radius: 60.0,
                        ),
                      ),
                      //text name
                      Container(
                        alignment: Alignment.center,
                          child: Text(_userModel.name, style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),)),
                      //text prepaid code
                      Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Text(MyString.txt_prepaid_code, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),)),
                      //text field prepaid code
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.white, style: BorderStyle.solid, width: 0.80),
                            color: Colors.white
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Image.asset('images/top_up_card.png', scale: 2.5,),
                          ),
                          keyboardType: TextInputType.number,
                          controller: _prepaidCodeController,
                          style: TextStyle(fontSize: FontSize.textSizeNormal),
                        ),
                      ),
                      //text pin code
                      Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Text(MyString.txt_pin_code, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),)),
                      //pin code text field
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        alignment: Alignment.center,
                        child: PinCodeTextField(
                          pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                          pinTextAnimatedSwitcherDuration: Duration(milliseconds: 100),
                          pinBoxHeight: 40,
                          pinBoxWidth: 40,
                          defaultBorderColor: Colors.white,
                          hideCharacter: true,
                          maskCharacter: '*',
                          hasTextBorderColor: Colors.white,
                          hasError: _hasError,
                          errorBorderColor: Colors.red,
                          controller: _pinCodeController,
                          pinTextStyle: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),
                          onDone: (str){
                            if(str == _userModel.pinCode.toString()){
                              print('pin correct');
                              setState(() {
                                _hasError = false;
                              });
                            }else{
                              setState(() {
                                _hasError = true;
                              });
                              _pinCodeController.clear();
                            }
                          },
                        ),
                      ),
                      //btn out
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 10.0),
                                height: 45.0,
                                child: RaisedButton(onPressed: ()async{
                                  Navigator.of(context).pop();
                                  }, child: Text(MyString.txt_top_up_cancel, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                                  color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                              ),
                            ),
                            //btn top up
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10.0),
                                height: 45.0,
                                child: RaisedButton(onPressed: ()async{
                                  if(_prepaidCodeController.text.isNotEmpty && _pinCodeController.text.isNotEmpty){
                                    if(_hasError == false){
                                      await _checkCon();
                                      if(_isCon){
                                        _dialogConfirm();
                                      }else{
                                        _scaffoldState.currentState.showSnackBar(SnackBar(
                                          content: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(margin: EdgeInsets.only(right: 20.0),child: Image.asset('images/no_connection.png', width: 30.0, height: 30.0,)),
                                              Text(MyString.txt_check_internet, style: TextStyle(fontSize: FontSize.textSizeNormal),),
                                            ],
                                          ),duration: Duration(seconds: 2),backgroundColor: Colors.red,));
                                      }
                                    }else{
                                      //Fluttertoast.showToast(msg: MyString.txt_wrong_pin_code, fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
                                      WarningSnackBar(_scaffoldState, MyString.txt_wrong_pin_code);
                                    }
                                  }else if(_prepaidCodeController.text.isEmpty){
                                    //Fluttertoast.showToast(msg: MyString.txt_need_prepaid_code, fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
                                    WarningSnackBar(_scaffoldState, MyString.txt_need_prepaid_code);
                                  }else if(_pinCodeController.text.isEmpty){
                                    //Fluttertoast.showToast(msg: MyString.txt_need_pin_code, fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
                                    WarningSnackBar(_scaffoldState, MyString.txt_need_pin_code);
                                  }

                                  }, child: Text(MyString.txt_top_up, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                                  color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
