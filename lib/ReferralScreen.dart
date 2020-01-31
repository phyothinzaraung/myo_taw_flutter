import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'model/UserModel.dart';
//import 'package:unique_identifier/unique_identifier.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'model/ReferralModel.dart';
import 'helper/ServiceHelper.dart';
import 'model/ReferralResponseModel.dart';
import 'myWidget/WarningSnackBarWidget.dart';

class ReferralScreen extends StatefulWidget {
  UserModel model;
  ReferralScreen(this.model);
  @override
  _ReferralScreenState createState() => _ReferralScreenState(this.model);
}

class _ReferralScreenState extends State<ReferralScreen> {
  UserModel _userModel;
  bool _isLoading = true;
  String _uniqueId = '';
  bool _isLoad = false;
  Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController _webViewController;
  String _scanResult;
  List<String> _data = List<String>();
  ReferralModel _referralModel = new ReferralModel();
  var _response;
  bool _isCon;
  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();
  _ReferralScreenState(this._userModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUniqueId();
  }

  Future<void> initUniqueId() async {
    String id;
//    try {
//      id = await UniqueIdentifier.serial;
//    } on PlatformException {
//      id = 'Failed to get Unique Identifier';
//    }
    setState(() {
      _uniqueId = id;
    });
    print('uniqueId: ${id}');
  }

  Future<void> _barcode() async {
    try {
      /*_scanResult =
      await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true);*/
    } on PlatformException {
      _scanResult = 'Failed to get platform version.';
    }
    if (!mounted) return;
    if(_scanResult != null && _scanResult.isNotEmpty){
      setState(() {
        _isLoad = true;
      });
      _data = _scanResult.split('-');
      if(_data.length == 2){
        _referralModel.referPhNo = _userModel.phoneNo;
        _referralModel.userPhNo = _data[0];
        _referralModel.referDate = DateTime.now().toString();
        _referralModel.imei = _data[1];
        _referralModel.application = 'CityApp';
        print('qrCodeData: ${_referralModel.referPhNo} ${_referralModel.userPhNo} ${_referralModel.referDate} ${_referralModel.imei}}');
        _callWebService();
      }else{
        setState(() {
          _isLoad = false;
        });
        _dialogWrongApp();
      }
    }
  }

  _callWebService() async{
    try{
      _response = await ServiceHelper().postReferral(_referralModel);
      if(_response.data != null){
        ReferralResponseModel model = ReferralResponseModel.fromJson(_response.data);
        _dialogFinish(model.message);
      }else{
        WarningSnackBar(_scaffoldState, MyString.txt_try_again);
      }
    }catch(e){
      print(e);
      WarningSnackBar(_scaffoldState, MyString.txt_try_again);
    }

    setState(() {
      _isLoad = false;
    });
  }

  _dialogFinish(String mess){
    return showDialog(context: context, builder: (context){
      return WillPopScope(
          child: SimpleDialog(
            contentPadding: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Image.asset('images/ic_launcher.png', width: 60.0, height: 60.0,)),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(mess,
                      style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack,),textAlign: TextAlign.center,),
                  ),
                  RaisedButton(onPressed: (){
                    Navigator.of(context).pop();
                    setState(() {
                      _webViewController.loadUrl(BaseUrl.REFERRAL_URL+_userModel.phoneNo);
                    });
                    },child: Text(MyString.txt_close,
                    style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),),
                ],
              )
            ],), onWillPop: (){});
    }, barrierDismissible: false);
  }

  _dialogWrongApp(){
    return showDialog(context: context, builder: (context){
      return WillPopScope(
          child: SimpleDialog(
            contentPadding: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Image.asset('images/warning.png', width: 60.0, height: 60.0,)),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(MyString.txt_referral_wrong_app,
                      style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack,),textAlign: TextAlign.center,),
                  ),
                  RaisedButton(onPressed: (){
                    Navigator.of(context).pop();
                    setState(() {
                      _webViewController.loadUrl(BaseUrl.REFERRAL_URL+_userModel.phoneNo);
                    });
                  },child: Text(MyString.txt_close,
                    style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),),
                ],
              )
            ],), onWillPop: (){});
    }, barrierDismissible: false);
  }

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState ,
      appBar: AppBar(
        title: Text(MyString.txt_referral, style: TextStyle(fontSize: FontSize.textSizeNormal),),
        actions: <Widget>[
          GestureDetector(
            onTap: () async{
              await _checkCon();
              if(_isCon){
                _barcode();
              }else{
                _scaffoldState.currentState.showSnackBar(SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(margin: EdgeInsets.only(right: 20.0),child: Image.asset('images/no_connection.png', width: 30.0, height: 30.0,)),
                      Text('Check internet connection', style: TextStyle(fontSize: FontSize.textSizeNormal),),
                    ],
                  ),duration: Duration(seconds: 5),backgroundColor: Colors.red,));
              }

            },
            child: Container(
                margin: EdgeInsets.only(right: 15.0),
                child: Image.asset('images/qr_code_scan.png', width: 30, height: 30,)),
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoad,
        progressIndicator: modalProgressIndicator(),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: QrImage(
                    data: _userModel.phoneNo+'-'+_uniqueId,
                    version: QrVersions.auto,
                    size: 80.0,
                  ),
                  //Image.asset('images/referral.png', width: 100, height: 100,)
                )],),
            Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(MyString.txt_scan_qr_code)),
            Expanded(
              child: Stack(
                children: <Widget>[
                  WebView(
                    initialUrl: BaseUrl.REFERRAL_URL+_userModel.phoneNo,
                    onWebViewCreated: (wv){
                      _controller.complete(wv);
                      _webViewController = wv;
                    },
                    onPageFinished: (finish){
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
                  _isLoading? Container(
                    alignment: FractionalOffset.center,
                    child: CircularProgressIndicator(),
                  ) : Container()
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
