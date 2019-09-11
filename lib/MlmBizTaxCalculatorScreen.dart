import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/NumConvertHelper.dart';

class MlmBizTaxCalculatorScreen extends StatefulWidget {
  @override
  _MlmBizTaxCalculatorScreenState createState() => _MlmBizTaxCalculatorScreenState();
}

class _MlmBizTaxCalculatorScreenState extends State<MlmBizTaxCalculatorScreen> {
  String _dropDownBizLicenseType = MyString.txt_no_selected;
  List<String> _bizLicenseTypeList;
  String _dropDownBizType = MyString.txt_no_selected;
  List<String> _bizList;
  int _taxRange ,_taxRange1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bizLicenseTypeList = [_dropDownBizLicenseType,'စားသောက်ဆိုင်လုပ်ငန်းလိုင်စင်','ဘေးအန္တရာယ်လုပ်ငန်းလိုင်စင်','ကိုယ်ပိုင်ဈေး၊ စတိုးဆိုင်လိုင်စင်','တည်းခိုခန်း/ဘော်ဒါဆောင်/မင်္ဂလာခန်းမလုပ်ငန်းလိုင်စင်'];
    _bizList = [_dropDownBizType];
  }

  _getBizByLicenseType(){
    switch (_dropDownBizLicenseType){
      case 'စားသောက်ဆိုင်လုပ်ငန်းလိုင်စင်':
        setState(() {
          _bizList = [_dropDownBizType,'၆ ထပ် နှင့်အထက်','၄ ထပ် မှ ၆ ထပ်','၃ ထပ်','၂ ထပ်','၁ ထပ်'];
        });
        break;
      case 'ဘေးအန္တရာယ်လုပ်ငန်းလိုင်စင်':
        setState(() {
          _bizList = [_dropDownBizType,'၂ ထပ်','၁ ထပ်'];
        });
        break;
      case 'ကိုယ်ပိုင်ဈေး':
        setState(() {
          _bizList = [_dropDownBizType,'၂ ထပ်'];
        });
        break;
      case 'စတိုးဆိုင်လိုင်စင်':
        setState(() {
          _bizList = [_dropDownBizType,'၂ ထပ်'];
        });
        break;
      case 'တည်းခိုခန်း/ဘော်ဒါဆောင်/မင်္ဂလာခန်းမလုပ်ငန်းလိုင်စင်':
        setState(() {
          _bizList = [_dropDownBizType,'၂ ထပ်','၁ ထပ်'];
        });
        break;
    }
  }

  String _getTaxRange(){
    switch(_dropDownBizLicenseType){
      case 'RC':
        switch(_dropDownBizType){
          case '၆ ထပ် နှင့်အထက်':
            _taxRange = 2500000;
            _taxRange1 = 5000000;
            break;
          case "၄ ထပ် မှ ၆ ထပ်":
            _taxRange = 800000;
            _taxRange1 = 3000000;
            break;
          case "၃ ထပ်":
            _taxRange = 100000;
            _taxRange1 = 1200000;
            break;
          case "၂ ထပ်":
            _taxRange = 30000;
            _taxRange1 = 800000;
            break;
          case "၁ ထပ်":
            _taxRange = 20000;
            _taxRange1 = 100000;
            break;
        }
        break;
      case 'အုတ်ညှပ်':
        switch (_dropDownBizType){
          case "၂ ထပ်":
            _taxRange = 25000;
            _taxRange1 = 50000;
            break;
          case "၁ ထပ်":
            _taxRange = 15000;
            _taxRange1 = 40000;
            break;
        }
        break;
      case 'တိုက်ခံသွပ်မိုး':
        _taxRange = 25000;
        _taxRange1 = 50000;
        break;
      case 'ပျဉ်ထောင်':
        _taxRange = 25000;
        _taxRange1 = 50000;
        break;
      case 'ပျဉ်ထောင်သွပ်မိုး':
        switch (_dropDownBizType){
          case "၂ ထပ်":
            _taxRange = 25000;
            _taxRange1 = 50000;
            break;
          case "၁ ထပ်":
            _taxRange = 15000;
            _taxRange1 = 40000;
            break;
        }
        break;
      case 'တိုက်ခံပျဉ်ထောင်':
        _taxRange = 25000;
        _taxRange1 = 50000;
        break;
      case 'ပျဉ်ထောင်ဖက်မိုး':
        _taxRange = 2500;
        _taxRange1 = 10000;
        break;
      case "ထရံကာသွပ်မိုး":
        _taxRange = 2500;
        _taxRange1 = 10000;
        break;
      case "ထရံကာဖက်မိုး":
        _taxRange = 2500;
        _taxRange1 = 10000;
        break;
    }
    return '${NumConvertHelper().getMyanNumInt(_taxRange)} - ${NumConvertHelper().getMyanNumInt(_taxRange1)}';
  }

  _calculateTaxDialog(){
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
                      child: Image.asset('images/calculate_tax_no_circle.png', width: 60.0, height: 60.0,)),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(MyString.txt_biz_tax_range,
                      style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack,),textAlign: TextAlign.center,),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(_getTaxRange(),
                      style: TextStyle(fontSize: FontSize.textSizeLarge, color: MyColor.colorPrimary,),textAlign: TextAlign.center,),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 0.0),
                    child: Text(MyString.txt_kyat,
                      style: TextStyle(fontSize: FontSize.textSizeLarge, color: MyColor.colorTextBlack,),textAlign: TextAlign.center,),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text('ဖြစ်ပါသည်။',
                      style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack,),textAlign: TextAlign.center,),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(MyString.txt_thanks,
                      style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorPrimary,),textAlign: TextAlign.center,),
                  ),
                  RaisedButton(onPressed: (){
                    Navigator.of(context).pop();
                    },child: Text(MyString.txt_close,
                    style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),)
                ],
              )
            ],), onWillPop: (){});
    }, barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(MyString.txt_calculate_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),)
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
              child: Row(
                children: <Widget>[
                  Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/tax_nocircle.png', width: 30.0, height: 30.0,)),
                  Text(MyString.title_property_tax_calculate, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 0, right: 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              color: Colors.white,
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(MyString.txt_choose_license_type,
                        style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(
                              color: MyColor.colorPrimary,style: BorderStyle.solid, width: 0.80
                          )
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          style: new TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),
                          isExpanded: true,
                          iconEnabledColor: MyColor.colorPrimary,
                          value: _dropDownBizLicenseType,
                          onChanged: (String value){
                            setState(() {
                              _dropDownBizLicenseType = value;
                            });
                            _bizList.clear();
                            setState(() {
                              _dropDownBizType = MyString.txt_no_selected;
                            });
                            _bizList = [_dropDownBizType];
                            _getBizByLicenseType();
                          },
                          items: _bizLicenseTypeList.map<DropdownMenuItem<String>>((String str){
                            return DropdownMenuItem<String>(
                              value: str,
                              child: Text(str),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(MyString.txt_biz_type,
                        style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(
                              color: MyColor.colorPrimary,style: BorderStyle.solid, width: 0.80
                          )
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          style: new TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),
                          isExpanded: true,
                          iconEnabledColor: MyColor.colorPrimary,
                          value: _dropDownBizType,
                          onChanged: (String value){
                            setState(() {
                              _dropDownBizType = value;
                            });
                          },
                          items: _bizList.map<DropdownMenuItem<String>>((String str){
                            return DropdownMenuItem<String>(
                              value: str,
                              child: Text(str),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40.0),
                      width: double.maxFinite,
                      height: 50.0,
                      child: RaisedButton(
                        onPressed: (){
                          if(_dropDownBizType != MyString.txt_no_selected && _dropDownBizLicenseType != MyString.txt_no_selected){
                            _calculateTaxDialog();
                          }else if(_dropDownBizLicenseType == MyString.txt_no_selected){
                            Fluttertoast.showToast(msg: 'Choose Building Type', backgroundColor: Colors.black.withOpacity(0.7));
                          }else if(_dropDownBizType == MyString.txt_no_selected){
                            Fluttertoast.showToast(msg: 'Choose Story', backgroundColor: Colors.black.withOpacity(0.7));
                          }
                        },color: MyColor.colorPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        child: Text(MyString.txt_calculate, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
