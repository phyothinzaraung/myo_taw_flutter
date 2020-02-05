import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/FireBaseAnalyticsHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/NumConvertHelper.dart';
import 'myWidget/CustomButtonWidget.dart';
import 'myWidget/DropDownWidget.dart';
import 'myWidget/IosPickerWidget.dart';

class MlmBizTaxCalculatorScreen extends StatefulWidget {
  @override
  _MlmBizTaxCalculatorScreenState createState() => _MlmBizTaxCalculatorScreenState();
}

class _MlmBizTaxCalculatorScreenState extends State<MlmBizTaxCalculatorScreen> {
  String _dropDownBizLicenseType = MyString.txt_no_selected;
  List<String> _bizLicenseTypeList;
  String _dropDownBizType = MyString.txt_no_selected;
  List<String> _bizList;
  String _taxRange;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();

  List<Widget> _bizLicenseTypeWidgetList = List();
  List<Widget> _bizTypeWidgetList = List();
  int _bizLicenseTypePickerIndex, _bizTypePickerIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bizLicenseTypeList = [_dropDownBizLicenseType];
    _bizLicenseTypeList.addAll(MyStringList.biz_mlm_license);
    _bizList = [_dropDownBizType];

    _bizLicenseTypePickerIndex = 0;
    _bizTypePickerIndex = 0;

    _initBizLicenseTypeIosPickerWidgetList();
  }

  _initBizLicenseTypeIosPickerWidgetList(){
    for(var i in _bizLicenseTypeList){
      _bizLicenseTypeWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  _initBizTypeIosPickerWidgetList(){
    for(var i in _bizList){
      _bizTypeWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  _getBizByLicenseType(){
    switch (_dropDownBizLicenseType){
      case 'စားသောက်ဆိုင်လုပ်ငန်းလိုင်စင်':
        setState(() {
          _bizList = [_dropDownBizType];
          _bizList.addAll(MyStringList.biz_mlm_food);
        });
        break;
      case 'ဘေးအန္တရာယ်လုပ်ငန်းလိုင်စင်':
        setState(() {
          _bizList = [_dropDownBizType];
          _bizList.addAll(MyStringList.biz_mlm_danger);
        });
        break;
      case 'ပုဂ္ဂလိကအိမ်ဆိုင်လုပ်ငန်းလိုင်စင်':
        setState(() {
          _bizList = [_dropDownBizType,];
          _bizList.addAll(MyStringList.biz_mlm_store);
        });
        break;
    }

    _initBizTypeIosPickerWidgetList();
  }

  String _getTaxRange(){
    switch(_dropDownBizLicenseType){
      case 'စားသောက်ဆိုင်လုပ်ငန်းလိုင်စင်':
        switch (_dropDownBizType){
          case "လက်ဘက်ရည်":
            _taxRange = "10000 - 80000";
            break;
          case "အချိုရည်":
            _taxRange = "10000 - 60000";
            break;
          case "စားသောက်":
            _taxRange = "20000 - 150000";
            break;
          case "ထမင်း":
            _taxRange = "10000 - 30000";
            break;
          case "မုန့်ဟင်းခါး":
            _taxRange = "10000 - 25000";
            break;
          case "ကြေးအိုး/ဆီချက်":
            _taxRange = "10000 - 60000";
            break;
          case "ကွမ်းယာ":
            _taxRange = "10000 - 15000";
            break;
          case "မုန့်ဆိုင်/သစ်သီး":
            _taxRange = "10000 - 60000";
            break;
        }
        break;
      case 'ဘေးအန္တရာယ်လုပ်ငန်းလိုင်စင်':
        switch(_dropDownBizType){
          case "ပရိဘောဂ":
            _taxRange = "25000 - 50000 ";
            break;
          case "ကွန်ပျူတာ":
            _taxRange = "10000 - 40000";
            break;
          case "ဆေးရွက်ကြီး":
            _taxRange = "20000 - 50000";
            break;
          case "ဝါး":
            _taxRange = "10000 - 30000";
            break;
          case "စက်ပြင်":
            _taxRange = "10000 - 60000";
            break;
          case "ထင်း/မီးသွေး":
            _taxRange = "10000 - 250000";
            break;
          case "ရာဘာ":
            _taxRange = "20000 - 400000";
            break;
          case "ကွမ်းသီး":
            _taxRange = "15000 - 60000";
            break;
          case "အိုး":
            _taxRange = "10000";
            break;
          case "ဆေးလိပ်ခုံ":
            _taxRange = "15000 - 20000";
            break;
          case "စက်သုံးဆီ":
            _taxRange = "10000 - 300000";
            break;
          case "ပဲဆီ":
            _taxRange = "20000 - 30000";
            break;
          case "ဓာတ်မြေဩဇာ":
            _taxRange = "10000 - 50000";
            break;
          case "ဘတ္ထရီ":
            _taxRange = "40000";
            break;
          case "ဆေးဆိုင်":
            _taxRange = "10000 - 60000";
            break;
          case "ကားအရောင်းပြခန်း":
            _taxRange = "100000 - 300000";
            break;
          case "သစ်စက်ဆိုင်":
            _taxRange = "15000 - 50000";
            break;
          case "ရေခဲစက်":
            _taxRange = "30000 - 80000";
            break;
          case "ရေသန့်":
            _taxRange = "35000 - 100000";
            break;
          case "အကြော်ဖို/မုန့်တီဖို":
            _taxRange = "10000 - 40000";
            break;
          case "သံပုံးပုလင်း":
            _taxRange = "15000 - 80000";
            break;
          case "ဗီဒီယိုခွေဌား":
            _taxRange = "10000 - 15000";
            break;
          case "ဆားစက်/ရောင်း":
            _taxRange = "10000 - 35000";
            break;
          case "ပလပ်စတစ်":
            _taxRange = "30000";
            break;
          case "ဆေးခန်း၊ ဓာတ်ခွဲခန်း":
            _taxRange = "15000 - 300000";
            break;
          case "အရက်ချက်စက်ရုံ":
            _taxRange = "200000";
            break;
          case "အခြား":
            _taxRange = "10000 - 100000";
            break;
        }
        break;
      case 'ပုဂ္ဂလိကအိမ်ဆိုင်လုပ်ငန်းလိုင်စင်':
        switch (_dropDownBizType){
          case "ကုန်မာ":
            _taxRange = "15000 - 1500000";
            break;
          case "သံမူလီ/သံဟောင်း":
            _taxRange = "10000 - 25000";
            break;
          case "ရွှေပန်းထိမ်":
            _taxRange = "60000 - 100000";
            break;
          case "ရွှေဆိုင်":
            _taxRange = "15000 - 40000";
            break;
          case "အပ်ချုပ်":
            _taxRange = "10000 - 40000";
            break;
          case "တီဗီရောင်း":
            _taxRange = "30000 - 50000";
            break;
          case "ပလပ်စတစ်":
            _taxRange = "10000 - 20000";
            break;
          case "တီဗီပြင်":
            _taxRange = "10000 - 20000";
            break;
          case "မျက်မှန်/မှန်":
            _taxRange = "10000 - 12000";
            break;
          case "နာရီ":
            _taxRange = "10000 - 20000";
            break;
          case "စာအုပ်ဌား":
            _taxRange = "10000 - 15000";
            break;
          case "စတိုး":
            _taxRange = "15000 - 50000";
            break;
          case "ဖိနပ်":
            _taxRange = "10000 - 40000";
            break;
          case "အလှကုန်":
            _taxRange = "10000 - 50000";
            break;
          case "စာအုပ်နှင့် စာရေးကိရိယာ":
            _taxRange = "15000 - 50000";
            break;
          case "အလှပြင်":
            _taxRange = "20000 - 50000";
            break;
          case "ဆံသဆိုင်":
            _taxRange = "10000 - 30000";
            break;
          case "ပွဲရုံ":
            _taxRange = "30000 - 60000";
            break;
          case "ဆန်":
            _taxRange = "10000 - 60000";
            break;
          case "ကုန်စုံ":
            _taxRange = "10000 - 30000";
            break;
          case "လျှပ်စစ်":
            _taxRange = "10000 - 50000";
            break;
          case "လယ်ယာသုံး":
            _taxRange = "30000 - 50000";
            break;
          case "စက်ပစ္စည်း":
            _taxRange = "10000 - 40000";
            break;
          case "အခြား":
            _taxRange = "10000 - 100000";
            break;
        }
        break;
    }
    return '${NumConvertHelper.getMyanNumString(_taxRange)}';
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
                  CustomButtonWidget(onPress: (){
                    Navigator.of(context).pop();
                    clear();
                    },child: Text(MyString.txt_close,
                    style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                    borderRadius: BorderRadius.circular(10),
                  )
                ],
              )
            ],), onWillPop: (){});
    }, barrierDismissible: false);
  }

  clear(){
    setState(() {
      _dropDownBizLicenseType = MyString.txt_no_selected;
      _dropDownBizType = MyString.txt_no_selected;
    });
  }

  Widget _body(BuildContext context){
    return ListView(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              headerTitleWidget(MyString.title_biz_tax_calculate, 'calculate_tax_no_circle'),
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
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            border: Border.all(
                                color: MyColor.colorPrimary,style: BorderStyle.solid, width: 0.80
                            )
                        ),
                        child: Platform.isAndroid?

                        DropDownWidget(
                          value: _dropDownBizLicenseType,
                          onChange: (value){
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              _dropDownBizLicenseType = value;
                            });
                            _bizList.clear();
                            _bizTypeWidgetList.clear();
                            setState(() {
                              _dropDownBizType = MyString.txt_no_selected;
                            });
                            _bizList = [_dropDownBizType];
                            _getBizByLicenseType();
                          },
                          list: _bizLicenseTypeList,
                        )
                            :
                        IosPickerWidget(
                          text: _dropDownBizLicenseType,
                          fixedExtentScrollController: FixedExtentScrollController(initialItem: _bizLicenseTypePickerIndex),
                          onSelectedItemChanged: (index){
                            _bizLicenseTypePickerIndex = index;
                          },
                          onPress: (){
                            setState(() {
                              _dropDownBizLicenseType = _bizLicenseTypeList[_bizLicenseTypePickerIndex];
                            });
                            _bizList.clear();
                            _bizTypeWidgetList.clear();
                            setState(() {
                              _dropDownBizType = MyString.txt_no_selected;
                            });
                            _bizList = [_dropDownBizType];
                            _getBizByLicenseType();
                            Navigator.pop(context);
                          },
                          children: _bizLicenseTypeWidgetList,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(MyString.txt_biz_type,
                          style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            border: Border.all(
                                color: MyColor.colorPrimary,style: BorderStyle.solid, width: 0.80
                            )
                        ),
                        child: Platform.isAndroid?

                        DropDownWidget(
                          value: _dropDownBizType,
                          onChange: (value){
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              _dropDownBizType = value;
                            });
                          },
                          list: _bizList,
                        )
                            :
                        IosPickerWidget(
                          text: _dropDownBizType,
                          fixedExtentScrollController: FixedExtentScrollController(initialItem: _bizTypePickerIndex),
                          onSelectedItemChanged: (index){
                            _bizTypePickerIndex = index;
                          },
                          onPress: (){
                            setState(() {
                              _dropDownBizType = _bizList[_bizTypePickerIndex];
                            });
                            Navigator.pop(context);
                          },
                          children: _bizTypeWidgetList,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40.0),
                        width: double.maxFinite,
                        height: 50.0,
                        child: CustomButtonWidget(
                          onPress: ()async{
                            if(_dropDownBizType != MyString.txt_no_selected && _dropDownBizLicenseType != MyString.txt_no_selected){
                              CustomDialogWidget().customCalculateTaxDialog(
                                context: context,
                                titleTax: MyString.txt_biz_tax_range,
                                taxValue: _getTaxRange(),
                                onPress: (){
                                  Navigator.of(context).pop();
                                  clear();
                                }
                              );
                              await _sharepreferenceshelper.initSharePref();
                              FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.MLM_BIZ_TAX_CALCULATOR_SCREEN, ClickEvent.CALCULATE_BIZ_TAX_CLICK_EVENT,
                                  _sharepreferenceshelper.getUserUniqueKey());
                            }else if(_dropDownBizLicenseType == MyString.txt_no_selected){
                              WarningSnackBar(_globalKey, MyString.txt_choose_building_type);

                            }else if(_dropDownBizType == MyString.txt_no_selected){
                              WarningSnackBar(_globalKey, MyString.txt_choose_story);
                            }
                          },color: MyColor.colorPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Text(MyString.txt_calculate, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: Text(MyString.txt_calculate_tax,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(context),
      globalKey: _globalKey,
    );
    /*return Scaffold(
      key: _globalKey,
      appBar: AppBar(
          title: Text(MyString.txt_calculate_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),)
      ),
      body:
    );*/
  }
}
