import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/NumConvertHelper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dio/dio.dart';
import 'helper/ServiceHelper.dart';
import 'model/PaymentLogModel.dart';
import 'helper/SharePreferencesHelper.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController _invoiceNoController = TextEditingController();
  TextEditingController _taxAmountController = TextEditingController();
  String _dropDownTaxType = 'သတ်မှတ်ထားခြင်းမရှိ';
  List<String> _taxTypeList = List<String>();
  bool _isLoading = false;
  bool _isCon = false;
  bool _isInvoiceNoEnable = true;
  bool _isDropDownEnable = true;
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  int _taxAmount = 0;
  String _taxType;
  Response _response;
  PaymentLogModel _paymentLogModel = PaymentLogModel();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taxTypeList = [_dropDownTaxType,MyString.MYAN_PROPERTY_TAX, MyString.MYAN_BIZ_LICENSE, MyString.MYAN_WATER_METER, MyString.MYAN_MARKET_TAX, MyString.MYAN_WHEEL_TAX,
      MyString.MYAN_SIGNBOARD_TAX];
  }

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
  }

  _getAmount()async{
    setState(() {
      _isLoading = true;
    });
    print(_taxType);
    _response = await ServiceHelper().getAmountFromInvoiceNo(_taxType, _invoiceNoController.text);
    if(_response != null){
      if(_response.data != 0){
        setState(() {
          _isLoading = false;
        });
        _taxAmount = _response.data;
        _isInvoiceNoEnable = false;
        _isDropDownEnable = false;

      }else{
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: 'Wrong invoice or tax type', backgroundColor: Colors.black.withOpacity(0.7), fontSize: FontSize.textSizeNormal);
      }
    }else{
      Fluttertoast.showToast(msg: 'Try again', backgroundColor: Colors.black.withOpacity(0.7), fontSize: FontSize.textSizeNormal);
      setState(() {
        _isLoading = false;
      });
    }

  }

  _payTax()async{
    setState(() {
      _isLoading = true;
    });
    _response = await ServiceHelper().postPayment(_paymentLogModel);
    if(_response.data != null){
      _dialogPaymentSuccess();
      setState(() {
        _isLoading = false;
      });
    }else{
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Try again', backgroundColor: Colors.black.withOpacity(0.7), fontSize: FontSize.textSizeNormal);
    }

  }

  _dialogPaymentSuccess(){
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
                      child: Image.asset('images/payment_success.png', width: 60.0, height: 60.0,)),
                  //text are u sure
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(MyString.txt_pay_tax_success,
                      style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack,),textAlign: TextAlign.center,),
                  ),
                  RaisedButton(onPressed: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pop({'isNeedRefresh' : true});

                    },child: Text(MyString.txt_close,
                    style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),)
                ],
              )
            ],), onWillPop: (){});
    }, barrierDismissible: false);
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
                      RaisedButton(onPressed: () async{
                        await _sharepreferenceshelper.initSharePref();
                        _paymentLogModel.uniqueKey = _sharepreferenceshelper.getUserUniqueKey();
                        _paymentLogModel.useAmount = _taxAmount;
                        _paymentLogModel.taxType = _taxType;
                        _paymentLogModel.invoiceNo = _invoiceNoController.text;
                        _payTax();
                        Navigator.of(context).pop();

                        },child: Text(MyString.txt_pay_tax_confirm,
                        style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),),
                      //btn out
                      RaisedButton(onPressed: (){
                        Navigator.of(context).pop();

                        },child: Text(MyString.txt_log_out,
                        style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),color: MyColor.colorGrey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),)
                    ],)
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

   _getTaxType(){
    switch(_dropDownTaxType){
      case MyString.MYAN_PROPERTY_TAX:
        _taxType = MyString.PROPERTY_TAX;
        break;
      case MyString.MYAN_BIZ_LICENSE:
        _taxType = MyString.BIZ_LICENSE;
        break;
      case MyString.MYAN_WATER_METER:
        _taxType = MyString.WATER_METER;
        break;
      case MyString.MYAN_MARKET_TAX:
        _taxType = MyString.MARKET_TAX;
        break;
      case MyString.MYAN_WHEEL_TAX:
        _taxType = MyString.WHEEL_TAX;
        break;
      case MyString.MYAN_SIGNBOARD_TAX:
        _taxType = MyString.SIGNBOARD_TAX;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text(MyString.txt_online_payment_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: modalProgressIndicator(),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 10.0),
                          child: Image.asset('images/online_tax_no_circle.png', width: 30.0, height: 30.0,)),
                      Text(MyString.txt_online_tax, style: TextStyle(fontSize: FontSize.textSizeSmall),)
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: double.maxFinite,
              height: 390.0,
              child: Card(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                color: MyColor.colorPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Text(MyString.txt_invoice_no, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),)),
                              IconButton(icon: Icon(Icons.refresh), onPressed: (){
                                setState(() {
                                  _invoiceNoController.clear();
                                  _dropDownTaxType = 'သတ်မှတ်ထားခြင်းမရှိ';
                                  _taxAmount = 0;
                                  _isInvoiceNoEnable = true;
                                  _isDropDownEnable = true;
                                });
                              }, color: Colors.white,)
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.white, style: BorderStyle.solid, width: 0.80),
                            color: Colors.white
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: MyString.txt_invoice_no,
                            enabled: _isInvoiceNoEnable,
                            hintStyle: TextStyle(fontSize: FontSize.textSizeSmall)
                          ),
                          controller: _invoiceNoController,
                          style: TextStyle(fontSize: FontSize.textSizeNormal),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Text(MyString.txt_choose_tax_type, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        margin: EdgeInsets.only(bottom: 20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.white, style: BorderStyle.solid, width: 0.80),
                            color: Colors.white
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            style: new TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),
                            isExpanded: true,
                            iconEnabledColor: MyColor.colorPrimary,
                            value: _dropDownTaxType,
                            hint: Text(_dropDownTaxType),
                            onChanged: _isDropDownEnable==true?(String value){
                              setState(() {
                                _dropDownTaxType = value;
                              });

                            } : null,
                            items: _taxTypeList.map<DropdownMenuItem<String>>((String str){
                              return DropdownMenuItem<String>(
                                value: str,
                                child: Text(str),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Text(MyString.txt_tax_amount, style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),)),
                              Text(NumConvertHelper().getMyanNumInt(_taxAmount) +' '+MyString.txt_kyat, style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),)
                            ],
                          )),
                      Container(
                        height: 45.0,
                        width: double.maxFinite,
                        child: RaisedButton(onPressed: ()async{
                          await _checkCon();
                          if(_isCon){
                            if(_taxAmount == 0){
                              if(_invoiceNoController.text.isNotEmpty && _dropDownTaxType != 'သတ်မှတ်ထားခြင်းမရှိ'){
                                _getTaxType();
                                _getAmount();

                              }else if (_invoiceNoController.text.isEmpty){
                                Fluttertoast.showToast(msg: 'Please fill invoice no', fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));

                              }else if (_dropDownTaxType == 'သတ်မှတ်ထားခြင်းမရှိ'){
                                Fluttertoast.showToast(msg: 'Choose tax type', fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));

                              }
                            }else{
                              _dialogConfirm();
                            }
                          }else{
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(margin: EdgeInsets.only(right: 20.0),child: Image.asset('images/no_connection.png', width: 30.0, height: 30.0,)),
                                  Text('Check internet connection', style: TextStyle(fontSize: FontSize.textSizeNormal),),
                                ],
                              ),duration: Duration(seconds: 2),backgroundColor: Colors.red,));
                          }

                          }, child: Text(_taxAmount == 0?MyString.txt_get_tax_amount : MyString.txt_pay_tax, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                          color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                      ),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
