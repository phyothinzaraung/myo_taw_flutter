import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myotaw/TaxCalculator/TgyPropertyTax.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/NumConvertHelper.dart';
import 'helper/PlatformHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'myWidget/CustomButtonWidget.dart';
import 'myWidget/DropDownWidget.dart';
import 'myWidget/IosPickerWidget.dart';

class TgyPropertyTaxCalculatorScreen extends StatefulWidget {
  @override
  _TgyPropertyTaxCalculatorScreenState createState() => _TgyPropertyTaxCalculatorScreenState();
}

class _TgyPropertyTaxCalculatorScreenState extends State<TgyPropertyTaxCalculatorScreen> {
  String _dropDownBuildingType = MyString.txt_no_selected;
  List<String> _buildingTypeList;
  String _dropDownRoad = MyString.txt_no_selected;
  List<String> _roadList;
  String _dropDownBlockNo = MyString.txt_no_selected;
  List<String> _blockNoList;
  TextEditingController _lengthContorller = new TextEditingController();
  TextEditingController _widthContorller = new TextEditingController();
  TextEditingController _storyContorller = new TextEditingController();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();

  List<Widget> _buildingTypeWidgetList = List();
  List<Widget> _roadTypeWidgetList = List();
  List<Widget> _blockNoWidgetList = List();
  int _buildingTypePickerIndex, _roadTypePickerIndex, _blockNoPickerIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _buildingTypeList = [_dropDownBuildingType];
    _buildingTypeList.addAll(MyStringList.property_tgy_building_type);
    _roadList = [_dropDownRoad];
    _roadList.addAll(MyStringList.property_tgy_road);
    _blockNoList = [_dropDownRoad];
    _blockNoList.addAll(MyStringList.property_tgy_block_no);

    _buildingTypePickerIndex = 0;
    _roadTypePickerIndex = 0;
    _blockNoPickerIndex = 0;

    _initIosPickerWidgetList();
  }

  _initIosPickerWidgetList(){
    for(var i in _buildingTypeList){
      _buildingTypeWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }

    for(var i in _roadList){
      _roadTypeWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }

    for(var i in _blockNoList){
      _blockNoWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  clearText(){
    setState(() {
      _dropDownBuildingType = MyString.txt_no_selected;
      _dropDownBlockNo = MyString.txt_no_selected;
      _dropDownRoad = MyString.txt_no_selected;
      _widthContorller.clear();
      _lengthContorller.clear();
      _storyContorller.clear();

      _buildingTypePickerIndex = 0;
      _roadTypePickerIndex = 0;
      _blockNoPickerIndex = 0;
    });
  }

  String _buildingGrade(){
    if(_dropDownBuildingType == "တိုက်" || _dropDownBuildingType == "RC" || _dropDownBuildingType == "Steel structure"){
      return MyString.BUILDING_GRADE_A;
    }else if(_dropDownBuildingType == "နံကပ်"){
      return MyString.BUILDING_GRADE_B;
    }else if(_dropDownBuildingType == "အစိုးရအဆောက်အဦးများ"){
      return MyString.GOV_BUILDING;
    }else {
      return MyString.BUILDING_GRADE_C;
    }
  }

  int _roadType(){
    if(_dropDownRoad == "လမ်းမကြီး"){
      return 1;
    }else if (_dropDownRoad == "လမ်းကျယ်"){
      return 2;
    }else{
      return 3;
    }
  }

  int _zone(){
    if(_dropDownBlockNo == "ရတနာသီရိရပ်ကွက်" || _dropDownBlockNo == "ဘုရားဖြူရပ်ကွက်" || _dropDownBlockNo == "ချမ်းသာရပ်ကွက်" ||
        _dropDownBlockNo == "ချမ်းမြသာစည်ရပ်ကွက်" || _dropDownBlockNo == "ကျောင်းကြီးစုရပ်ကွက်"){
      return 2;
    }else if(_dropDownBlockNo == "ကံကြီးရပ်ကွက်" || _dropDownBlockNo == "ကံသာရပ်ကွက်" || _dropDownBlockNo == "စဝ်စံထွန်းရပ်ကွက်" ||
        _dropDownBlockNo == "စိန်ပန်းရပ်ကွက်" || _dropDownBlockNo == "ရွှေတောင်ရပ်ကွက်"){
      return 3;
    }else {
      return 1;
    }
  }

  Widget _body(){
    return ListView(
      children: <Widget>[
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
                        width: double.maxFinite,
                        margin: EdgeInsets.only(bottom: 20),
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
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              _dropDownBuildingType = value;
                            });
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
                        margin: EdgeInsets.only(right: 10.0, bottom: 20),
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            border: Border.all(color: MyColor.colorPrimary, style: BorderStyle.solid, width: 0.80)
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          cursorColor: MyColor.colorPrimary,
                          controller: _storyContorller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(MyString.txt_road,
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
                          value: _dropDownRoad,
                          onChange: (value){
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              _dropDownRoad = value;
                            });
                          },
                          list: _roadList,
                        )
                            :
                        IosPickerWidget(
                          text: _dropDownRoad,
                          fixedExtentScrollController: FixedExtentScrollController(initialItem: _roadTypePickerIndex),
                          onSelectedItemChanged: (index){
                            _roadTypePickerIndex = index;
                          },
                          onPress: (){
                            setState(() {
                              _dropDownRoad = _roadList[_roadTypePickerIndex];
                            });
                            Navigator.pop(context);
                          },
                          children: _roadTypeWidgetList,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(MyString.txt_blockNo,
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
                          value: _dropDownBlockNo,
                          onChange: (value){
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              _dropDownBlockNo = value;
                            });
                          },
                          list: _blockNoList,
                        )
                            :
                        IosPickerWidget(
                          text: _dropDownBlockNo,
                          fixedExtentScrollController: FixedExtentScrollController(initialItem: _blockNoPickerIndex),
                          onSelectedItemChanged: (index){
                            _blockNoPickerIndex = index;
                          },
                          onPress: (){
                            setState(() {
                              _dropDownBlockNo = _blockNoList[_blockNoPickerIndex];
                            });
                            Navigator.pop(context);
                          },
                          children: _blockNoWidgetList,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(MyString.txt_site_area,
                          style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7.0),
                                          border: Border.all(color: MyColor.colorPrimary, style: BorderStyle.solid, width: 0.80)
                                      ),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        cursorColor: MyColor.colorPrimary,
                                        controller: _lengthContorller,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Text(MyString.txt_unit_feet, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),))
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7.0),
                                          border: Border.all(color: MyColor.colorPrimary, style: BorderStyle.solid, width: 0.80)
                                      ),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        cursorColor: MyColor.colorPrimary,
                                        controller: _widthContorller,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Text(MyString.txt_unit_feet, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40.0),
                        width: double.maxFinite,
                        child: CustomButtonWidget(
                          onPress: ()async{

                            if(_dropDownRoad != MyString.txt_no_selected && _dropDownBuildingType != MyString.txt_no_selected &&
                                _dropDownBlockNo != MyString.txt_no_selected && _lengthContorller.text.isNotEmpty && _widthContorller.text.isNotEmpty &&
                                _storyContorller.text.isNotEmpty){
                              CustomDialogWidget().customCalculateTaxDialog(
                                context: context,
                                titleTax: MyString.txt_biz_tax_property,
                                taxValue: TgyPropertyTax.getArv(
                                  buildingGrade: _buildingGrade(),
                                  roadType: _roadType(),
                                  zone: _zone(),
                                  length: _lengthContorller.text,
                                  width: _widthContorller.text,
                                  story: double.parse(_storyContorller.text)
                                ),
                                onPress: (){
                                  Navigator.of(context).pop();
                                  clearText();
                                }
                              );
                              FocusScope.of(context).requestFocus(FocusNode());
                              await _sharepreferenceshelper.initSharePref();
                              FireBaseAnalyticsHelper.trackClickEvent(ScreenName.TGY_PROPERTY_TAX_CALCULATOR_SCREEN, ClickEvent.CALCULATE_PROPERTY_TAX_CLICK_EVENT,
                                  _sharepreferenceshelper.getUserUniqueKey());

                            }else if(_dropDownBuildingType == MyString.txt_no_selected){
                              WarningSnackBar(_globalKey, MyString.txt_choose_building_type);

                            }else if (_storyContorller.text.isEmpty){
                              WarningSnackBar(_globalKey, MyString.txt_type_story);
                              
                            }else if(_dropDownRoad == MyString.txt_no_selected){
                              WarningSnackBar(_globalKey, MyString.txt_choose_road);

                            }else if(_dropDownBlockNo == MyString.txt_no_selected){
                              WarningSnackBar(_globalKey, MyString.txt_choose_blockNo);

                            }else if(_lengthContorller.text.isEmpty){
                              WarningSnackBar(_globalKey, MyString.txt_type_length);

                            }else if(_widthContorller.text.isEmpty){
                              WarningSnackBar(_globalKey, MyString.txt_type_width);

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
      body: _body(),
      globalKey: _globalKey,
    );
  }
}
