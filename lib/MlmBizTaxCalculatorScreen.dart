import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myotaw/TaxCalculator/MlmBizTax.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/FireBaseAnalyticsHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/NumConvertHelper.dart';
import 'helper/PlatformHelper.dart';
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
        _bizList.addAll(MyStringList.biz_mlm_food);
        break;
      case 'ဘေးအန္တရာယ်လုပ်ငန်းလိုင်စင်':
        _bizList.addAll(MyStringList.biz_mlm_danger);
        break;
      case 'ပုဂ္ဂလိကအိမ်ဆိုင်လုပ်ငန်းလိုင်စင်':
        _bizList.addAll(MyStringList.biz_mlm_store);
        break;
    }

    _initBizTypeIosPickerWidgetList();
  }



  clear(){
    setState(() {
      _dropDownBizLicenseType = MyString.txt_no_selected;

      _bizList.clear();
      _bizTypeWidgetList.clear();
      _bizList = [MyString.txt_no_selected];
      _dropDownBizType = MyString.txt_no_selected;

      _bizLicenseTypePickerIndex = 0;
      _bizTypePickerIndex = 0;

      _initBizTypeIosPickerWidgetList();
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
                        child: Text(MyString.txt_license_type,
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
                        child: PlatformHelper.isAndroid()?

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
                        child: PlatformHelper.isAndroid()?

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
                        child: CustomButtonWidget(
                          onPress: ()async{
                            if(_dropDownBizType != MyString.txt_no_selected && _dropDownBizLicenseType != MyString.txt_no_selected){
                              CustomDialogWidget().customCalculateTaxDialog(
                                context: context,
                                titleTax: MyString.txt_biz_tax_range,
                                taxValue: MlmBizTax.getTax(
                                  bizLicenseType: _dropDownBizLicenseType,
                                  bizType: _dropDownBizType
                                ),
                                onPress: (){
                                  Navigator.of(context).pop();
                                  clear();
                                }
                              );
                              await _sharepreferenceshelper.initSharePref();
                              FireBaseAnalyticsHelper.trackClickEvent(ScreenName.MLM_BIZ_TAX_CALCULATOR_SCREEN, ClickEvent.CALCULATE_BIZ_TAX_CLICK_EVENT,
                                  _sharepreferenceshelper.getUserUniqueKey());
                            }else if(_dropDownBizLicenseType == MyString.txt_no_selected){
                              WarningSnackBar(_globalKey, MyString.txt_choose_biz_license_type);

                            }else if(_dropDownBizType == MyString.txt_no_selected){
                              WarningSnackBar(_globalKey, MyString.txt_choose_biz_type);
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
  }
}
