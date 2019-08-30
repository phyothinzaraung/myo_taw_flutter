import 'dart:async';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'model/UserModel.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'model/ReferralModel.dart';

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
  _ReferralScreenState(this._userModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUniqueId();
  }

  Future<void> initUniqueId() async {
    String id;
    try {
      id = await UniqueIdentifier.serial;
    } on PlatformException {
      id = 'Failed to get Unique Identifier';
    }
    setState(() {
      _uniqueId = id;
    });
    print('uniqueId: ${id}');
  }

  Future<void> _barcode() async {
    try {
      _scanResult =
      await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true);
    } on PlatformException {
      _scanResult = 'Failed to get platform version.';
    }
    if (!mounted) return;
    if(_scanResult != null && _scanResult.isNotEmpty){
      setState(() {
        _isLoad = true;
      });
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        _isLoad = false;
      });
      _data = _scanResult.split('-');
      if(_data.length == 2){
        print('qrCodeData: ${_data[0]} ${_data[1]}');
        _dialogFinish('Success');
      }else{
        _dialogFinish('Fail');
      }
    }
  }

  _dialogFinish(String str){
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
                      child: Image.asset('images/payment_success.png', width: 60.0, height: 60.0,)),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(str,
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
      appBar: AppBar(
        title: Text(MyString.txt_referral, style: TextStyle(fontSize: FontSize.textSizeNormal),),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              _barcode();
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
