import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myotaw/TaxCalculator/TgyBizTax.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/FireBaseAnalyticsHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/NumConvertHelper.dart';
import 'helper/PlatformHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'myWidget/CustomButtonWidget.dart';
import 'myWidget/DropDownWidget.dart';
import 'myWidget/IosPickerWidget.dart';

class TgyBizTaxCalculatorScreen extends StatefulWidget {
  @override
  _TgyBizTaxCalculatorScreenState createState() => _TgyBizTaxCalculatorScreenState();
}

class _TgyBizTaxCalculatorScreenState extends State<TgyBizTaxCalculatorScreen> {
  String _dropDownBizLicenseType = MyString.txt_no_selected;
  List<String> _bizLicenseTypeList;
  String _dropDownBizType = MyString.txt_no_selected;
  List<String> _bizList;
  String _dropDownGrade = MyString.txt_no_selected;
  List<String> _gradeList;
  String _dropDownSquareFeet = MyString.txt_no_selected;
  List<String> _squareFeetList;

  bool _isHotel = false;
  bool _isSquareFeet = false;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();

  List<Widget> _bizLicenseTypeWidgetList = List();
  List<Widget> _bizTypeWidgetList = List();
  List<Widget> _gradeWidgetList = List();
  List<Widget> _squareFeetWidgetList = List();
  int _bizLicenseTypePickerIndex, _bizTypePickerIndex, _gradePickerIndex, _squareFeetPickerIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bizLicenseTypeList = [_dropDownBizLicenseType];
    _bizLicenseTypeList.addAll(MyStringList.biz_tgy_license);
    _bizList = [_dropDownBizType];
    _gradeList = [_dropDownGrade];
    _squareFeetList = [_dropDownSquareFeet];
    _gradeList.addAll(MyStringList.biz_tgy_grade);
    _squareFeetList.add('ပေ (၁၀၀၀၀) အထက်');
    _squareFeetList.add('ပေ (၁၀၀၀၀) အောက်');

    _bizLicenseTypePickerIndex = 0;
    _bizTypePickerIndex = 0;
    _gradePickerIndex = 0;
    _squareFeetPickerIndex = 0;

    _initBizLicensePickerWidgetList();
    _initGradePickerWidgetList();
    _initSquareFeetPickerWidgetList();
  }

  _initBizLicensePickerWidgetList(){
    for(var i in _bizLicenseTypeList){
      _bizLicenseTypeWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  _initBizPickerWidgetList(){

    for(var i in _bizList){
      _bizTypeWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  _initSquareFeetPickerWidgetList(){

    for(var i in _squareFeetList){
      _squareFeetWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  _initGradePickerWidgetList(){

    for(var i in _gradeList){
      _gradeWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  _getBizByLicenseType(){
    switch (_dropDownBizLicenseType){
      case 'စားသောက်ဆိုင်လုပ်ငန်းလိုင်စင်':
        _bizList.addAll(MyStringList.biz_tgy_food);
        break;
      case 'ဘေးအန္တရာယ်လုပ်ငန်းလိုင်စင်':
        _bizList.addAll(MyStringList.biz_tgy_danger);
        break;
      case 'တည်းခိုခန်းလုပ်ငန်းလိုင်စင်':
        _bizList.addAll(MyStringList.biz_tgy_hotel);
        break;
      case 'ကိုယ်ပိုင်စီးပွားဖြစ်(ရေပေးရေးလုပ်ငန်း) လိုင်စင်':
        _bizList.add('သောက်ရေသန့်လုပ်ငန်း');
        break;
      case 'ကိုယ်ပိုင်ဈေး(စတိုးဆိုင်) လုပ်ငန်းလိုင်စင်':
        _bizList.add('ကုန်တိုက်နှင့်အလားတူလုပ်ငန်းများ၊ အရောင်းဆိုင်ကြီးများ(၁ စတုန်ရန်းပေလျှင်)');
        _bizList.add('အုပ်စုလိုက်/အတန်းလိုက်ရှိသောစတိုးဆိုင်များ/TV၊ ဖုန်း၊ အလှကုန်၊ လူသုံးကုန်၊ အိမ်ဆောက်ပစ္စည်း၊ ကား/ဆိုင်ကယ်အရောင်းဆိုင်၊ ပစ္စည်းအရောင်းဆိုင်နှင့်ဝန်ဆောင်မှုလုပ်ငန်းများ');
        break;
      case 'မင်္ဂလာခန်းမလိုင်စင်':
        _bizList.add('မင်္ဂလာခန်းမ');
        break;
      case "သတ်မှတ်ထားခြင်းမရှိ":
        clearDropDown();
        _isHotel = false;
        _isSquareFeet = false;
        break;
    }

    _initBizPickerWidgetList();
  }

  Widget _body(){
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
                              _isHotel = false;
                              _isSquareFeet = false;
                            });
                            _bizList.clear();
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
                              _isHotel = false;
                              _isSquareFeet = false;
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
                          value: _dropDownBizType,
                          onChange: (value){
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              _dropDownBizType = value;
                              _dropDownBizType == MyStringList.biz_tgy_hotel[0]? _isHotel = true : _isHotel = false;
                              _dropDownBizType == 'ကုန်တိုက်နှင့်အလားတူလုပ်ငန်းများ၊ အရောင်းဆိုင်ကြီးများ(၁ စတုန်ရန်းပေလျှင်)'? _isSquareFeet = true : _isSquareFeet = false;
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
                              _dropDownBizType == MyStringList.biz_tgy_hotel[0]? _isHotel = true : _isHotel = false;
                              _dropDownBizType == 'ကုန်တိုက်နှင့်အလားတူလုပ်ငန်းများ၊ အရောင်းဆိုင်ကြီးများ(၁ စတုန်ရန်းပေလျှင်)'? _isSquareFeet = true : _isSquareFeet = false;
                            });
                            Navigator.pop(context);
                          },
                          children: _bizTypeWidgetList,
                        ),
                      ),
                      _isHotel?Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(MyString.txt_grade,
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
                                value: _dropDownGrade,
                                onChange: (value){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  setState(() {
                                    _dropDownGrade = value;
                                  });
                                },
                                list: _gradeList,
                              )
                                  :
                              IosPickerWidget(
                                text: _dropDownGrade,
                                fixedExtentScrollController: FixedExtentScrollController(initialItem: _gradePickerIndex),
                                onSelectedItemChanged: (index){
                                  _gradePickerIndex = index;
                                },
                                onPress: (){
                                  setState(() {
                                    _dropDownGrade = _gradeList[_gradePickerIndex];
                                  });
                                  Navigator.pop(context);
                                },
                                children: _gradeWidgetList,
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),

                      _isSquareFeet?Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(MyString.txt_square_feet,
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
                                value: _dropDownSquareFeet,
                                onChange: (value){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  setState(() {
                                    _dropDownSquareFeet = value;
                                  });
                                },
                                list: _squareFeetList,
                              )
                                  :
                              IosPickerWidget(
                                text: _dropDownSquareFeet,
                                fixedExtentScrollController: FixedExtentScrollController(initialItem: _squareFeetPickerIndex),
                                onSelectedItemChanged: (index){
                                  _squareFeetPickerIndex = index;
                                },
                                onPress: (){
                                  setState(() {
                                    _dropDownSquareFeet = _squareFeetList[_squareFeetPickerIndex];
                                  });
                                  Navigator.pop(context);
                                },
                                children: _squareFeetWidgetList,
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),

                      Container(
                        margin: EdgeInsets.only(top: 40.0),
                        width: double.maxFinite,
                        child: CustomButtonWidget(
                          onPress: ()async{
                            if(_dropDownBizType != MyString.txt_no_selected && _dropDownBizLicenseType != MyString.txt_no_selected){
                              if(_isHotel){
                                if(_dropDownGrade != MyString.txt_no_selected){
                                  CustomDialogWidget().customCalculateTaxDialog(
                                    context: context,
                                    onPress: (){
                                      Navigator.of(context).pop();
                                      clearDropDown();
                                      setState(() {
                                        _isHotel = false;
                                        _isSquareFeet = false;
                                      });
                                    },
                                    taxValue: TgyBizTax.getTax(
                                      bizType: _dropDownBizType,
                                      grade: _dropDownGrade,
                                      squareFeet: _dropDownSquareFeet
                                    ),
                                      titleTax: MyString.txt_biz_tax_range
                                  );
                                  await _sharepreferenceshelper.initSharePref();
                                  FireBaseAnalyticsHelper.trackClickEvent(ScreenName.TGY_BIZ_TAX_CALCULATOR_SCREEN, ClickEvent.CALCULATE_BIZ_TAX_CLICK_EVENT,
                                      _sharepreferenceshelper.getUserUniqueKey());
                                }else{
                                  WarningSnackBar(_globalKey, MyString.txt_choose_grade);
                                }
                              }else if(_isSquareFeet){
                                if(_dropDownSquareFeet != MyString.txt_no_selected){
                                  CustomDialogWidget().customCalculateTaxDialog(
                                      context: context,
                                      onPress: (){
                                        Navigator.of(context).pop();
                                        clearDropDown();
                                        setState(() {
                                          _isSquareFeet = false;
                                          _isHotel = false;
                                        });
                                      },
                                      taxValue: TgyBizTax.getTax(
                                          bizType: _dropDownBizType,
                                          grade: _dropDownGrade,
                                          squareFeet: _dropDownSquareFeet
                                      ),
                                      titleTax: MyString.txt_biz_tax_range
                                  );
                                  await _sharepreferenceshelper.initSharePref();
                                  FireBaseAnalyticsHelper.trackClickEvent(ScreenName.TGY_BIZ_TAX_CALCULATOR_SCREEN, ClickEvent.CALCULATE_BIZ_TAX_CLICK_EVENT,
                                      _sharepreferenceshelper.getUserUniqueKey());
                                }else{
                                  WarningSnackBar(_globalKey, MyString.txt_choose_square_feet);
                                }
                              }else{
                                CustomDialogWidget().customCalculateTaxDialog(
                                    context: context,
                                    onPress: (){
                                      Navigator.of(context).pop();
                                      clearDropDown();
                                      setState(() {
                                        _isHotel = false;
                                      });
                                    },
                                    taxValue: TgyBizTax.getTax(
                                        bizType: _dropDownBizType,
                                        grade: _dropDownGrade,
                                        squareFeet: _dropDownSquareFeet
                                    ),
                                    titleTax: MyString.txt_biz_tax_range
                                );
                                await _sharepreferenceshelper.initSharePref();
                                FireBaseAnalyticsHelper.trackClickEvent(ScreenName.TGY_BIZ_TAX_CALCULATOR_SCREEN, ClickEvent.CALCULATE_BIZ_TAX_CLICK_EVENT,
                                    _sharepreferenceshelper.getUserUniqueKey());
                              }

                            }else if(_dropDownBizLicenseType == MyString.txt_no_selected){
                              WarningSnackBar(_globalKey, MyString.txt_choose_license_type);
                            }else if(_dropDownBizType == MyString.txt_no_selected){
                              WarningSnackBar(_globalKey, MyString.txt_choose_biz_license);
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

  clearDropDown(){
    setState(() {
      _dropDownBizLicenseType = MyString.txt_no_selected;

      _bizList.clear();
      _bizTypeWidgetList.clear();

      _bizList = [MyString.txt_no_selected];
      _initBizPickerWidgetList();

      _bizTypePickerIndex = 0;
      _bizLicenseTypePickerIndex = 0;
      _gradePickerIndex = 0;
      _squareFeetPickerIndex = 0;

      _dropDownBizType = MyString.txt_no_selected;
      _dropDownGrade = MyString.txt_no_selected;
      _dropDownSquareFeet = MyString.txt_no_selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: Text(MyString.txt_calculate_tax,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(),
      globalKey: _globalKey,
    );
  }
}
