import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/FireBaseAnalyticsHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/NumConvertHelper.dart';
import 'helper/SharePreferencesHelper.dart';

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
  String _taxRange;
  bool _isHotel = false;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bizLicenseTypeList = [_dropDownBizLicenseType];
    _bizLicenseTypeList.addAll(MyStringList.biz_tgy_license);
    _bizList = [_dropDownBizType];
    _gradeList = [_dropDownBizType];
    _gradeList.addAll(MyStringList.biz_tgy_grade);
  }

  _getBizByLicenseType(){
    switch (_dropDownBizLicenseType){
      case 'စားသောက်ဆိုင်လုပ်ငန်းလိုင်စင်':
        setState(() {
          _bizList = [_dropDownBizType];
          _bizList.addAll(MyStringList.biz_tgy_food);
        });
        break;
      case 'ဘေးအန္တရာယ်လုပ်ငန်းလိုင်စင်':
        setState(() {
          _bizList = [_dropDownBizType];
          _bizList.addAll(MyStringList.biz_tgy_danger);
        });
        break;
      case 'ကိုယ်ပိုင်ဈေး၊ စတိုးဆိုင်လိုင်စင်':
        setState(() {
          _bizList = [_dropDownBizType];
          _bizList.addAll(MyStringList.biz_tgy_store);
        });
        break;
      case 'တည်းခိုခန်း/ဘော်ဒါဆောင်/မင်္ဂလာခန်းမလုပ်ငန်းလိုင်စင်':
        setState(() {
          _bizList = [_dropDownBizType];
          _bizList.addAll(MyStringList.biz_tgy_hotel);
        });
        break;
    }
  }

  String _getTaxRange(){
    switch(_dropDownBizLicenseType){
      case 'စားသောက်ဆိုင်လုပ်ငန်းလိုင်စင်':
        switch (_dropDownBizType){
          case "မုန့်ဖုတ်ခြင်း/ရောင်းချခြင်း":
            _taxRange = "၃၀၀၀၀ - ၄၀၀၀၀";
            break;
          case "အအေး/ဖျော်ရည်ပြုလုပ်ရောင်းချခြင်း":
            _taxRange = "၃၀၀၀၀ - ၄၀၀၀၀";
            break;
          case "ရေခဲစက်/ဘိလပ်ရည်စက်နှင့်ရေခဲချောင်းလုပ်ငန်း":
            _taxRange = "၄၀၀၀၀";
            break;
          case "လ္ဘက်ရည်/ကော်ဖီစသည့် အလားတူပြင်ဆင်ရောင်းချခြင်း":
            _taxRange = "၃၀၀၀၀ - ၁၃၀၀၀၀";
            break;
          case "ထမင်း/ခေါက်ဆွဲ (အကြော်/အပြုတ်)":
            _taxRange = "၃၀၀၀၀ - ၈၀၀၀၀";
            break;
          case "ကြာဇံ/မုန့်ဟင်းခါး/တိုဟူးနွေး ရှမ်းခေါက်ဆွဲစသည့်အလားတူလုပ်ငန်း":
            _taxRange = "၂၀၀၀၀ - ၄၀၀၀၀";
            break;
          case "စားသောက်ဆိုင်ကြီးများ ဟိုတယ်ဆိုင်ကြီးများ":
            _taxRange = "၈၀၀၀၀ - ၂၀၀၀၀၀";
            break;
          case "ကွမ်းယာရောင်းချခြင်း":
            _taxRange = "၁၀၀၀၀ - ၃၀၀၀၀";
            break;
          case "ဆီနှင့်ကြော်သောအကြော်မျိုးစုံ":
            _taxRange = "၂၀၀၀၀ - ၄၀၀၀၀";
            break;
          case "နေကြာစေ့/ကွာစေ့/ယိုစုံ/ချိုချဉ် စသည့်အလားတူလုပ်ငန်း":
            _taxRange = "၃၀၀၀၀ - ၄၀၀၀၀";
            break;
          case "ချဉ်ဖတ်လုပ်ငန်း":
            _taxRange = "၃၀၀၀၀ - ၄၀၀၀၀";
            break;
          case "နို့ဆီရောင်းချခြင်း/မလိုင်မုန့်လုပ်ငန်း":
            _taxRange = "၂၀၀၀၀";
            break;
        }
        break;
      case 'ဘေးအန္တရာယ်လုပ်ငန်းလိုင်စင်':
        switch(_dropDownBizType){
          case "ဆန်၊ ဂျုံ၊ ပဲနှင့်အခြားကောက်ပဲသီးနှံရောင်းဝယ်ရေး":
            _taxRange = "၃၀၀၀၀ - ၅၀၀၀၀";
            break;
          case "ဆေးရွက်ကြီး၊ ဆေးရိုး၊ သနပ်ဖက်၊ ဆေးလိပ်ခုံ":
            _taxRange = "၃၀၀၀၀ - ၆၀၀၀၀";
            break;
          case "စားသောက်ကုန်စည်ပစ္စည်းသိုလှောင်ခြင်း(ပွဲရုံ)":
            _taxRange = "၃၀၀၀၀ - ၆၀၀၀၀";
            break;
          case "အလုပ်ရုံများ (စက်မှု)":
            _taxRange = "၄၀၀၀၀ - ၆၀၀၀၀";
            break;
          case "အလုပ်ရုံများ (လက်မှု)":
            _taxRange = "၂၅၀၀၀ - ၃၀၀၀၀";
            break;
          case "လေထိုး၊ တာယာ၊ ကျွတ်လုပ်ငန်း":
            _taxRange = "၂၀၀၀၀ - ၃၀၀၀၀";
            break;
          case "စက်ချုပ်ဆိုင်၊ မိုးကာကူရှင်ချုပ်လုပ်ငန်း":
            _taxRange = "၂၀၀၀၀ - ၃၀၀၀၀";
            break;
          case "လျှပ်စစ်၊ ဘတ္တရီလုပ်ငန်း":
            _taxRange = "၂၀၀၀၀ - ၂၅၀၀၀";
            break;
          case "ထင်း၊ မီးသွေး၊ ဝါး ကြိမ်၊ သစ်ခွဲသား၊ သက်ကယ်သိုလှောင်ခြင်း":
            _taxRange = "၃၀၀၀၀ - ၄၀၀၀၀";
            break;
          case "လဲမှို့၊ ဝါဂွမ်း၊ ဆေးဆိုး၊ သိုးမွေးလုပ်ငန်း":
            _taxRange = "၄၀၀၀၀ - ၅၀၀၀၀";
            break;
          case "ဆံသနှင့်အလှပြင်လုပ်ငန်း":
            _taxRange = "၂၀၀၀၀ - ၅၀၀၀၀";
            break;
          case "ပုံနှိပ်လုပ်ငန်း":
            _taxRange = "၅၀၀၀၀ - ၆၀၀၀၀";
            break;
          case "စက်ဘီးပြင်၊ ထီးပြင်၊ ဘိနပ်ပြင်လုပ်ငန်း":
            _taxRange = "၈၀၀၀ - ၁၅၀၀၀";
            break;
          case "ကျွဲကော်ပစ္စည်းသိုလှောင်ခြင်း (ပလပ်စတစ်လုပ်ငန်း)":
            _taxRange = "၅၀၀၀၀ - ၆၀၀၀၀";
            break;
          case "စက်ရုံများ (သစ်ခွဲစက်၊ အမှုန့်ကြိတ်စက်၊ ဆီစက်၊ ဆန်စက်)":
            _taxRange = "၃၀၀၀၀ - ၆၀၀၀၀";
            break;
          case "သဲ၊ အုတ်သိုလှောင်ရေး (အုတ်လုပ်ငန်း)":
            _taxRange = "၄၀၀၀၀ - ၆၀၀၀၀";
            break;
          case "ဓါတ်ပုံ၊ ဗီဒီယို၊ တေးသံသွင်း၊ ဘလောက်လုပ်ငန်း":
            _taxRange = "၂၀၀၀၀ - ၄၀၀၀၀";
            break;
        }
        break;
      case 'ကိုယ်ပိုင်ဈေး၊ စတိုးဆိုင်လိုင်စင်':
        switch (_dropDownBizType){
          case "ကုန်စုံဆိုင်/မုန့်ဆိုင်/အိမ်ဆိုင်":
            _taxRange = "၁၀၀၀၀ - ၄၀၀၀၀";
            break;
          case "ကိုယ်ပိုင်ဈေးများ(စတိုးဆိုင်)":
            _taxRange = "၃၀၀၀၀ - ၂၀၀၀၀၀";
            break;
          case "Super Center, Mini Mart":
            _taxRange = "၃၀၀၀၀ - ၁၀၀၀၀၀";
            break;
        }
        break;
      case 'တည်းခိုခန်း/ဘော်ဒါဆောင်/မင်္ဂလာခန်းမလုပ်ငန်းလိုင်စင်':
        switch (_dropDownBizType){
          case "တည်းခိုခန်း":
            switch (_dropDownGrade){
              case "(၁)ယောက်ခန်းတစ်ခန်းလျှင်":
                _taxRange = "၆၀၀၀";
                break;
              case "(၂)ယောက်ခန်းတစ်ခန်းလျှင်":
                _taxRange = "၈၀၀၀";
                break;
              case "မိသားစုတစ်ခန်းလျှင်":
                _taxRange = "၁၀၀၀၀";
                break;
            }
            break;
          case "ဘော်ဒါဆောင်":
            _taxRange = "၃၀၀၀၀";
            break;
          case "မင်္ဂလာခန်းမ":
            _taxRange = "၁၅၀၀၀၀";
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
                  RaisedButton(onPressed: (){
                    Navigator.of(context).pop();
                    clearDropDown();
                    setState(() {
                      _isHotel = false;
                    });
                    },child: Text(MyString.txt_close,
                    style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),)
                ],
              )
            ],), onWillPop: (){});
    }, barrierDismissible: false);
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
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
          title: Text(MyString.txt_calculate_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),)
      ),
      body: ListView(
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
                                  _isHotel = false;
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
                              value: _dropDownBizType,
                              onChanged: (String value){
                                setState(() {
                                  _dropDownBizType = value;
                                  _dropDownBizType == MyStringList.biz_tgy_hotel[0]? _isHotel = true : _isHotel = false;
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
                                    value: _dropDownGrade,
                                    onChanged: (String value){
                                      setState(() {
                                        _dropDownGrade = value;
                                      });
                                    },
                                    items: _gradeList.map<DropdownMenuItem<String>>((String str){
                                      return DropdownMenuItem<String>(
                                        value: str,
                                        child: Text(str),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ) : Container(),
                        Container(
                          margin: EdgeInsets.only(top: 40.0),
                          width: double.maxFinite,
                          height: 50.0,
                          child: RaisedButton(
                            onPressed: ()async{
                              if(_dropDownBizType != MyString.txt_no_selected && _dropDownBizLicenseType != MyString.txt_no_selected){
                                if(_isHotel){
                                  if(_dropDownGrade != MyString.txt_no_selected){
                                    _calculateTaxDialog();
                                    await _sharepreferenceshelper.initSharePref();
                                    FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.TGY_BIZ_TAX_CALCULATOR_SCREEN, ClickEvent.CALCULATE_BIZ_TAX_CLICK_EVENT,
                                        _sharepreferenceshelper.getUserUniqueKey());
                                  }else{
                                    WarningSnackBar(_globalKey, MyString.txt_choose_grade);
                                  }
                                }else{
                                  _calculateTaxDialog();
                                  await _sharepreferenceshelper.initSharePref();
                                  FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.TGY_BIZ_TAX_CALCULATOR_SCREEN, ClickEvent.CALCULATE_BIZ_TAX_CLICK_EVENT,
                                      _sharepreferenceshelper.getUserUniqueKey());
                                }

                              }else if(_dropDownBizLicenseType == MyString.txt_no_selected){
                                WarningSnackBar(_globalKey, MyString.txt_choose_building_type);
                              }else if(_dropDownBizType == MyString.txt_no_selected){
                                WarningSnackBar(_globalKey, MyString.txt_choose_biz_license);
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
        ],
      )
    );
  }
}
