import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/FireBaseAnalyticsHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/NumConvertHelper.dart';
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
  String _taxRange;
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

  String _getTaxRange(){
    switch (_dropDownBizType){
    //food biz
      case "ကုန်စုံဆိုင်/မုန့်ဆိုင်":
        _taxRange = "၁၅,၀၀၀ - ၁၀၀,၀၀၀";
        break;
      case "မုန့်ဖုတ်ခြင်း/ရောင်းချခြင်း":
        _taxRange = "၃၀,၀၀၀ - ၁၀၀,၀၀၀";
        break;
      case "အအေးနှင့်ဖျော်ရည်ပြုလုပ်ရောင်းချခြင်း":
        _taxRange = "၂၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "ရေခဲစက်/ဘိလပ်ရည်စက်နှင့်ရေခဲချောင်းလုပ်ငန်း":
        _taxRange = "၄၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "လ္ဘက်ရည်/ကော်ဖီစသည့်အလားတူပြင်ဆင်ရောင်းချခြင်း":
        _taxRange = "၃၀,၀၀၀ - ၂၀၀,၀၀၀";
        break;
      case "ထမင်း/ခေါက်ဆွဲ(အကြော်/အပြုတ်)":
        _taxRange = "၃၀,၀၀၀ - ၁၀၀,၀၀၀";
        break;
      case "ကြာဇံ/မုန့်ဟင်းခါး/တိုဖူးနွေး/ရှမ်းခေါက်ဆွဲစသည့် အလားတူလုပ်ငန်း":
        _taxRange = "၂၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "ဆီနှင့်ကြော်သော အကြော်မျိုးစုံ":
        _taxRange = "၃၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "စားသောက်ဆိုင်ကြီး/ပျော်ပွဲစားရုံ/ဟိုတယ်ဆိုင်ကြီးများ":
        _taxRange = "၈၀,၀၀၀ - ၃၀၀,၀၀၀";
        break;
      case "ကွမ်းယာရောင်းခြင်း":
        _taxRange = "၁၀,၀၀၀ - ၄၀,၀၀၀";
        break;
      case "နေကြာစေ့/ကွာစေ့/ယိုစုံ/ချိုချဉ် စသည့်အိမ်တွင်းမှုစားသောက်ကုန်လုပ်ငန်း":
        _taxRange = "၃၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "ချဉ်ဖတ်လုပ်ငန်း":
        _taxRange = "၄၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "မုန့်တီလုပ်ငန်း":
        _taxRange = "၅၀,၀၀၀";
        break;
    //danger biz
      case "အလုပ်ရုံများ(စက်မှု၊ လက်မှု)":
        _taxRange = "၂၀,၀၀၀ - ၁၀၀,၀၀၀";
        break;
      case "လေထိုး၊ တာယာ၊ ကျွတ်လုပ်ငန်း":
        _taxRange = "၂၀,၀၀၀ - ၄၀,၀၀၀";
        break;
      case "စက်ချုပ်ဆိုင်၊ မိုးကာ ကူရှင်ချုပ်လုပ်ငန်း":
        _taxRange = "၂၀,၀၀၀ - ၅၀,၀၀၀";
        break;
      case "လျှပ်စစ်ဘက်ထရီလုပ်ငန်း":
        _taxRange = "၂၀,၀၀၀ - ၅၀,၀၀၀";
        break;
      case "ထင်း၊ မီးသွေး၊ ဝါး၊ ကြိမ်၊ သစ်ခွဲသား၊ သက်ကယ် သိုလှောင်ခြင်း":
        _taxRange = "၂၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "လဲမှို့၊ ဝါဂွမ်း၊ ဆေးဆိုး၊ သိုးမွေးလုပ်ငန်း":
        _taxRange = "၄၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "ဆံသနှင့်အလှပြင်လုပ်ငန်းများ":
        _taxRange = "၂၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "ပုံနှိပ်လုပ်ငန်း":
        _taxRange = "၅၀,၀၀၀ - ၇၀,၀၀၀";
        break;
      case "စက်ဘီးပြင်၊ ထီးပြင်၊ ဖိနပ်ပြင်လုပ်ငန်း":
        _taxRange = "၈,၀၀၀ - ၁၅,၀၀၀";
        break;
      case "ကျွဲကော်ပစ္စည်းသိုလှောင်ခြင်း(ပလပ်စတစ်လုပ်ငန်း)":
        _taxRange = "၅၀,၀၀၀ - ၇၀,၀၀၀";
        break;
      case "စက်ရုံများ(သစ်ခွဲစက်၊ အမှုန့်ကြိတ်စက်၊ ဆီစက်၊ ဆပ်ပြာစက်)":
        _taxRange = "၄၀,၀၀၀ - ၂၀၀,၀၀၀";
        break;
      case "သဲ၊ အုတ်သိုလှောင်ရေး(အုတ်လုပ်ငန်း)":
        _taxRange = "၅၀,၀၀၀ - ၁၀၀,၀၀၀";
        break;
      case "ဆေးခန်း(ရောဂါရှာဖွေရေး၊ ဓါတ်ခွဲခန်း၊ အရေပြားအလှပြုပြင်ရေးဆေးခန်းအပါအဝင်)အလားတူလုပ်ငန်းများ":
        _taxRange = "၃၀,၀၀၀ - ၁၀၀,၀၀၀";
        break;
      case "ပုဂ္ဂလိကဆေးရုံကြီးများ":
        _taxRange = "၂၀၀,၀၀၀ - ၅၀၀,၀၀၀";
        break;
      case "ဆေးနှင့်ဆေးပစ္စည်းအရောင်းဆိုင်များ":
        _taxRange = "၃၀,၀၀၀ - ၇၀,၀၀၀";
        break;
      case "ဗီဒီယို၊ ဓါတ်ပုံ၊ ရုပ်မြင်လုပ်ငန်းလိုင်စင်နှင့်အလားတူလုပ်ငန်းများ":
        _taxRange = "၂၀,၀၀၀ - ၃၀၀,၀၀၀";
        break;
      case "ဆန်၊ ဂျုံ၊ ပဲနှင့်အခြားကောက်ပဲသီးနှံ\u200Bရောင်းဝယ်ရေး":
        _taxRange = "၃၀,၀၀၀ - ၃၀၀,၀၀၀";
        break;
      case "ဆေးရွက်ကြီး၊ ဆေးရိုး၊ သနပ်ဖက်နှင့်အလားတူပစ္စည်းသိုလှောင်ခြင်း(ဆေးလိပ်ခုံ)":
        _taxRange = "၄၀,၀၀၀ - ၁၀၀,၀၀၀";
        break;
      case "စားသောက်ကုန်စည်ပစ္စည်းသိုလှောင်ခြင်း(ပွဲရုံ)":
        _taxRange = "၃၀,၀၀၀ - ၁၀၀,၀၀၀";
        break;
    //hotel biz
      case "တည်းခိုခန်း":
        switch (_dropDownGrade){
          case "(၁)ယောက်ခန်းတစ်ခန်းလျှင်":
            _taxRange = "၈,၀၀၀";
            break;
          case "(၂)ယောက်ခန်းတစ်ခန်းလျှင်":
            _taxRange = "၁၀,၀၀၀";
            break;
          case "မိသားစုတစ်ခန်းလျှင်":
            _taxRange = "၁၂,၀၀၀";
            break;
        }
        break;
      case "ဘော်ဒါဆောင်":
        _taxRange = "၄,၀၀၀";
        break;
    //water biz
      case "သောက်ရေသန့်လုပ်ငန်း":
        _taxRange = "၁၅၀,၀၀၀ - ၃၀၀,၀၀၀";
        break;
      case "ကိုယ်ပိုင်ဈေးစတိုး":
        _taxRange = "၁၅၀,၀၀၀ - ၃၀၀,၀၀၀";
        break;
      case "ကုန်တိုက်နှင့်အလားတူလုပ်ငန်းများ၊ အရောင်းဆိုင်ကြီးများ(၁ စတုန်ရန်းပေလျှင်)":
        switch (_dropDownSquareFeet){
          case "ပေ (၁၀၀၀၀) အထက်":
            _taxRange = "၁ စတုရန်းပေလျှင် ၅၀";
            break;
          case "ပေ (၁၀၀၀၀) အောက်":
            _taxRange = "၁ စတုရန်းပေလျှင် ၁၀၀";
            break;
        }
        break;
      case "အုပ်စုလိုက်/အတန်းလိုက်ရှိသောစတိုးဆိုင်များ/TV၊ ဖုန်း၊ အလှကုန်၊ လူသုံးကုန်၊ အိမ်ဆောက်ပစ္စည်း၊ ကား/ဆိုင်ကယ်အရောင်းဆိုင်၊ ပစ္စည်းအရောင်းဆိုင်နှင့်ဝန်ဆောင်မှုလုပ်ငန်းများ":
        _taxRange = "၃၀,၀၀၀ - ၃၀၀,၀၀၀";
        break;
      case "မင်္ဂလာခန်းမ":
        _taxRange = "၁၀၀,၀၀၀ - ၃၀၀,၀၀၀";
        break;
    }
    return '${NumConvertHelper.getMyanNumString(_taxRange)}';
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
                        child: Platform.isAndroid?

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
                        child: Platform.isAndroid?

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
                              child: Platform.isAndroid?

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
                              child: Platform.isAndroid?

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
                                    taxValue: _getTaxRange(),
                                      titleTax: MyString.txt_biz_tax_range
                                  );
                                  await _sharepreferenceshelper.initSharePref();
                                  FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.TGY_BIZ_TAX_CALCULATOR_SCREEN, ClickEvent.CALCULATE_BIZ_TAX_CLICK_EVENT,
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
                                      taxValue: _getTaxRange(),
                                      titleTax: MyString.txt_biz_tax_range
                                  );
                                  await _sharepreferenceshelper.initSharePref();
                                  FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.TGY_BIZ_TAX_CALCULATOR_SCREEN, ClickEvent.CALCULATE_BIZ_TAX_CLICK_EVENT,
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
                                    taxValue: _getTaxRange(),
                                    titleTax: MyString.txt_biz_tax_range
                                );
                                await _sharepreferenceshelper.initSharePref();
                                FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.TGY_BIZ_TAX_CALCULATOR_SCREEN, ClickEvent.CALCULATE_BIZ_TAX_CLICK_EVENT,
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
      _dropDownGrade = MyString.txt_no_selected;
      _dropDownBizType = MyString.txt_no_selected;
      _dropDownBizLicenseType = MyString.txt_no_selected;
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
    /*return Scaffold(
      key: _globalKey,
      appBar: AppBar(
          title: Text(MyString.txt_calculate_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),)
      ),
      body:
    );*/
  }
}
