import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/model/InvoiceModel.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/NumConvertHelper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'helper/ServiceHelper.dart';
import 'model/PaymentLogModel.dart';
import 'helper/SharePreferencesHelper.dart';
import 'myWidget/CustomButtonWidget.dart';
import 'myWidget/CustomProgressIndicator.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController _invoiceNoController = TextEditingController();
  String _dropDownTaxType = 'သတ်မှတ်ထားခြင်းမရှိ';
  List<String> _taxTypeList = List<String>();
  bool _isLoading = false;
  bool _isCon = false;
  bool _isInvoiceNoEnable = true;
  bool _isDropDownEnable = true;
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  int _taxAmount = 0;
  String _taxType;
  var _response;
  PaymentLogModel _paymentLogModel = PaymentLogModel();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  InvoiceModel _invoiceModel;

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
    _invoiceModel = InvoiceModel.fromJson(_response.data);
    if(_invoiceModel != null){
      if(_invoiceModel.totalAmt != 0){

       setState(() {
         _taxAmount = _invoiceModel.totalAmt;
         _isInvoiceNoEnable = false;
         _isDropDownEnable = false;
       });

      }else{
        WarningSnackBar(_scaffoldState, MyString.txt_wrong_invoice_or_tax_type);
      }
    }else{
      WarningSnackBar(_scaffoldState, MyString.txt_wrong_invoice_or_tax_type);
    }

    setState(() {
      _isLoading = false;
    });

  }

  _payTax()async{
    setState(() {
      _isLoading = true;
    });
    try{
      _response = await ServiceHelper().postPayment(_paymentLogModel);
      if(_response.data != null){
        CustomDialogWidget().customSuccessDialog(
          context: context,
          content: MyString.txt_pay_tax_success,
          img: 'payment_success.png',
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


    setState(() {
      _isLoading = false;
    });

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

  Widget _body(BuildContext context){
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: CustomProgressIndicatorWidget(),
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
                        child: Text(MyString.txt_tax_type, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),)),
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
                            Text(NumConvertHelper.getMyanNumInt(_taxAmount) +' '+MyString.txt_kyat, style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),)
                          ],
                        )),
                    Container(
                      height: 45.0,
                      width: double.maxFinite,
                      child: CustomButtonWidget(onPress: ()async{
                        await _checkCon();
                        if(_isCon){
                          if(_taxAmount == 0){
                            if(_invoiceNoController.text.isNotEmpty && _dropDownTaxType != MyString.txt_no_selected){
                              _getTaxType();
                              _getAmount();
                              await _sharepreferenceshelper.initSharePref();
                              FireBaseAnalyticsHelper.trackClickEvent(ScreenName.ONLINE_TAX_PAYMENT_SCREEN, ClickEvent.GET_TAX_AMOUNT_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
                            }else if (_invoiceNoController.text.isEmpty){
                              WarningSnackBar(_scaffoldState, MyString.txt_need_invoice_no);

                            }else if (_dropDownTaxType == MyString.txt_no_selected){
                              WarningSnackBar(_scaffoldState, MyString.txt_choose_tax_type);

                            }
                          }else{
                            await _sharepreferenceshelper.initSharePref();
                            FireBaseAnalyticsHelper.trackClickEvent(ScreenName.ONLINE_TAX_PAYMENT_SCREEN, ClickEvent.PAY_TAX_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
                            CustomDialogWidget().customConfirmDialog(
                              context: context,
                              content: MyString.txt_are_u_sure,
                              textNo: MyString.txt_log_out,
                              textYes: MyString.txt_pay_tax_confirm,
                              img: 'online_tax_no_circle.png',
                              onPress: ()async{
                                await _sharepreferenceshelper.initSharePref();
                                _paymentLogModel.uniqueKey = _sharepreferenceshelper.getUserUniqueKey();
                                _paymentLogModel.useAmount = _taxAmount;
                                _paymentLogModel.taxType = _taxType;
                                _paymentLogModel.invoiceNo = _invoiceNoController.text;
                                _payTax();
                                Navigator.of(context).pop();
                              }
                            );
                          }
                        }else{
                          WarningSnackBar(_scaffoldState, MyString.txt_no_internet);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: Text(MyString.txt_online_payment_tax,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(context),
    );
  }
}
