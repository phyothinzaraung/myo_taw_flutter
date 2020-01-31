import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'helper/FireBaseAnalyticsHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/NumConvertHelper.dart';
import 'helper/SharePreferencesHelper.dart';
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
  int _taxRange ,_taxRange1;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _buildingTypeList = [_dropDownBuildingType];
    _buildingTypeList.addAll(MyStringList.property_mlm_building);
    _storyList = [_dropDownStory];
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
  }

  String _getTaxRange(){
    switch(_dropDownBuildingType){
      case 'RC':
        switch(_dropDownStory){
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
        switch (_dropDownStory){
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
        switch (_dropDownStory){
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
    return '${NumConvertHelper.getMyanNumInt(_taxRange)} - ${NumConvertHelper.getMyanNumInt(_taxRange1)}';
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
                    clear();
                    },child: Text(MyString.txt_close,
                    style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),)
                ],
              )
            ],), onWillPop: (){});
    }, barrierDismissible: false);
  }

  clear(){
    setState(() {
      _dropDownBuildingType = MyString.txt_no_selected;
      _dropDownStory = MyString.txt_no_selected;
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
                          value: _dropDownBuildingType,
                          onChanged: (String value){
                            setState(() {
                              _dropDownBuildingType = value;
                            });
                            _storyList.clear();
                            setState(() {
                              _dropDownStory = MyString.txt_no_selected;
                            });
                            _storyList = [_dropDownStory];
                            _getStoryByBuildingType();
                          },
                          items: _buildingTypeList.map<DropdownMenuItem<String>>((String str){
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
                      child: Text(MyString.txt_story,
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
                          value: _dropDownStory,
                          onChanged: (String value){
                            setState(() {
                              _dropDownStory = value;
                            });
                          },
                          items: _storyList.map<DropdownMenuItem<String>>((String str){
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
                        onPressed: ()async{
                          if(_dropDownStory != MyString.txt_no_selected && _dropDownBuildingType != MyString.txt_no_selected){
                            _calculateTaxDialog();
                            await _sharepreferenceshelper.initSharePref();
                            FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.MLM_PROPERTY_TAX_CALCULATOR_SCREEN, ClickEvent.CALCULATE_PROPERTY_TAX_CLICK_EVENT,
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
                        child: Text(MyString.txt_calculate, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),),
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
      title: MyString.txt_calculate_tax,
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
