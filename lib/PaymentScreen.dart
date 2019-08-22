import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/NumConvertHelper.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController _invoicNoController = TextEditingController();
  TextEditingController _taxAmountController = TextEditingController();
  String _dropDownTaxType = 'သတ်မှတ်ထားခြင်းမရှိ';
  List<String> _taxTypeList = List<String>();
  bool _isLoading = false;
  String _taxAmount = NumConvertHelper().getMyanNumString('0');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taxTypeList = [_dropDownTaxType,'ပစ္စည်းခွန် (စံငှားခွန်)','လုပ်ငန်းလိုင်စင်','ရေမီတာခွန်','ဈေးဆိုင်ခန်းခွန်','ဘီးခွန်','ကြော်ငြာဆိုင်းဘုတ်ခွန်'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.txt_online_payment_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ListView(
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
                        child: Text(MyString.txt_invoice_no, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),)),
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
                          hintStyle: TextStyle(fontSize: FontSize.textSizeSmall)
                        ),
                        keyboardType: TextInputType.number,
                        controller: _invoicNoController,
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
                          onChanged: (String value){
                            setState(() {
                              _dropDownTaxType = value;
                            });

                          },
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
                            Text(MyString.txt_tax_amount, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                            Text(_taxAmount + MyString.txt_kyat, style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),)
                          ],
                        )),
                    Container(
                      height: 45.0,
                      width: double.maxFinite,
                      child: RaisedButton(onPressed: ()async{
                        if(_invoicNoController.text.isNotEmpty && _dropDownTaxType != 'သတ်မှတ်ထားခြင်းမရှိ'){

                        }else if (_invoicNoController.text.isEmpty){
                          Fluttertoast.showToast(msg: 'Please fill invoice no', fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));

                        }else if (_dropDownTaxType == 'သတ်မှတ်ထားခြင်းမရှိ'){
                          Fluttertoast.showToast(msg: 'Choose tax type', fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));

                        }

                        }, child: Text(MyString.txt_pay_tax, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                        color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                    ),

                  ],
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
