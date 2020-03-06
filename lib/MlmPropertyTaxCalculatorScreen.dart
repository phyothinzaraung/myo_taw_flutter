import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myotaw/TaxCalculator/MlmPropertyTax.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'helper/FireBaseAnalyticsHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/NumConvertHelper.dart';
import 'helper/PlatformHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'myWidget/CustomButtonWidget.dart';
import 'myWidget/DropDownWidget.dart';
import 'myWidget/IosPickerWidget.dart';
import 'myWidget/WarningSnackBarWidget.dart';

class MlmPropertyTaxCalculatorScreen extends StatefulWidget {
  @override
  _MlmPropertyTaxCalculatorScreenState createState() => _MlmPropertyTaxCalculatorScreenState();
}

class _MlmPropertyTaxCalculatorScreenState extends State<MlmPropertyTaxCalculatorScreen> {
  String _dropDownBuildingType = MyString.txt_no_selected;
  List<String> _buildingTypeList;
  String _dropDownStory = MyString.txt_no_selected;
  List<String> _storyList;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();

  List<Widget> _buildingTypeWidgetList = List();
  List<Widget> _storyTypeWidgetList = List();
  int _buildingTypePickerIndex, _storyTypePickerIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _buildingTypeList = [_dropDownBuildingType];
    _buildingTypeList.addAll(MyStringList.property_mlm_building);
    _storyList = [_dropDownStory];

    _buildingTypePickerIndex = 0;
    _storyTypePickerIndex = 0;

    _initBuildingTypeIosPickerWidgetList();
  }

  _initBuildingTypeIosPickerWidgetList(){
    for(var i in _buildingTypeList){
      _buildingTypeWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  _initStoryIosPickerWidgetList(){
    for(var i in _storyList){
      _storyTypeWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  _getStoryByBuildingType(){
    switch (_dropDownBuildingType){
      case 'RC':
        setState(() {
          _storyList = [_dropDownStory,'၆ ထပ် နှင့်အထက်','၄ ထပ် မှ ၆ ထပ်','၃ ထပ်','၂ ထပ်','၁ ထပ်'];
        });
        break;
      case 'အုတ်ညှပ်':
        setState(() {
          _storyList = [_dropDownStory,'၂ ထပ်','၁ ထပ်'];
        });
        break;
      case 'တိုက်ခံသွပ်မိုး':
        setState(() {
          _storyList = [_dropDownStory,'၂ ထပ်'];
        });
        break;
      case 'ပျဉ်ထောင်':
        setState(() {
          _storyList = [_dropDownStory,'၂ ထပ်'];
        });
        break;
      case 'ပျဉ်ထောင်သွပ်မိုး':
        setState(() {
          _storyList = [_dropDownStory,'၂ ထပ်','၁ ထပ်'];
        });
        break;
      case 'တိုက်ခံပျဉ်ထောင်':
        setState(() {
          _storyList = [_dropDownStory,'၂ ထပ်'];
        });
        break;
      case 'ပျဉ်ထောင်ဖက်မိုး':
        setState(() {
          _storyList = [_dropDownStory,'၁ ထပ်'];
        });
        break;
      case 'ထရံကာသွပ်မိုး':
        setState(() {
          _storyList = [_dropDownStory,'၁ ထပ်'];
        });
        break;
      case 'ထရံကာဖက်မိုး':
        setState(() {
          _storyList = [_dropDownStory,'၁ ထပ်'];
        });
        break;
    }

    _initStoryIosPickerWidgetList();
  }


  clear(){
    setState(() {
      _dropDownBuildingType = MyString.txt_no_selected;

      _storyList.clear();
      _storyTypeWidgetList.clear();

      _buildingTypePickerIndex = 0;
      _storyTypePickerIndex = 0;
      _storyList = [MyString.txt_no_selected];
      _dropDownStory = MyString.txt_no_selected;

      _initStoryIosPickerWidgetList();
    });
  }

  Widget _body(BuildContext context){
    return ListView(children: <Widget>[
      Container(
        child: Column(
          children: <Widget>[
            headerTitleWidget(MyString.title_property_tax_calculate, 'calculate_tax_no_circle'),
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
                      child: Text(MyString.txt_building_type,
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
                        value: _dropDownBuildingType,
                        onChange: (value){
                          setState(() {
                            _dropDownBuildingType = value;
                          });
                          _storyList.clear();
                          _storyTypeWidgetList.clear();
                          setState(() {
                            _dropDownStory = MyString.txt_no_selected;
                          });
                          _storyList = [_dropDownStory];
                          _getStoryByBuildingType();
                        },
                        list: _buildingTypeList,
                      )
                          :
                      IosPickerWidget(
                        text: _dropDownBuildingType,
                        fixedExtentScrollController: FixedExtentScrollController(initialItem: _buildingTypePickerIndex),
                        onSelectedItemChanged: (index){
                          _buildingTypePickerIndex = index;
                        },
                        onPress: (){
                          setState(() {
                            _dropDownBuildingType = _buildingTypeList[_buildingTypePickerIndex];
                          });
                          _storyList.clear();
                          _storyTypeWidgetList.clear();
                          setState(() {
                            _dropDownStory = MyString.txt_no_selected;
                          });
                          _storyList = [_dropDownStory];
                          _getStoryByBuildingType();
                          Navigator.pop(context);
                        },
                        children: _buildingTypeWidgetList,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(MyString.txt_story,
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
                        value: _dropDownStory,
                        onChange: (value){
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            _dropDownStory = value;
                          });
                        },
                        list: _storyList,
                      )
                          :
                      IosPickerWidget(
                        text: _dropDownStory,
                        fixedExtentScrollController: FixedExtentScrollController(initialItem: _storyTypePickerIndex),
                        onSelectedItemChanged: (index){
                          _storyTypePickerIndex = index;
                        },
                        onPress: (){
                          setState(() {
                            _dropDownStory = _storyList[_storyTypePickerIndex];
                          });
                          Navigator.pop(context);
                        },
                        children: _storyTypeWidgetList,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40.0),
                      width: double.maxFinite,
                      height: 50.0,
                      child: CustomButtonWidget(
                        onPress: ()async{
                          if(_dropDownStory != MyString.txt_no_selected && _dropDownBuildingType != MyString.txt_no_selected){
                            CustomDialogWidget().customCalculateTaxDialog(
                              context: context,
                              titleTax: MyString.txt_biz_tax_range,
                              taxValue: MlmPropertyTax.getTax(
                                buildingType: _dropDownBuildingType,
                                story: _dropDownStory
                              ),
                              onPress: (){
                                Navigator.of(context).pop();
                                clear();
                              }
                            );
                            await _sharepreferenceshelper.initSharePref();
                            FireBaseAnalyticsHelper.TrackClickEvent(ScreenName.MLM_PROPERTY_TAX_CALCULATOR_SCREEN, ClickEvent.CALCULATE_PROPERTY_TAX_CLICK_EVENT,
                                _sharepreferenceshelper.getUserUniqueKey());

                          }else if(_dropDownBuildingType == MyString.txt_no_selected){
                            WarningSnackBar(_globalKey, MyString.txt_choose_building_type);

                          }else if(_dropDownStory == MyString.txt_no_selected){
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
    ],);

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
