import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/NumConvertHelper.dart';

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
  static const int base_value = 70;
  double buildingValue, roadValue, zoneValue, rentalRate, arv;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _buildingTypeList = [_dropDownBuildingType];
    _buildingTypeList.addAll(MyArray.property_tgy_building_type);
    _roadList = [_dropDownRoad];
    _roadList.addAll(MyArray.property_tgy_road);
    _blockNoList = [_dropDownRoad];
    _blockNoList.addAll(MyArray.property_tgy_block_no);
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
                    child: Text(_getArv(),
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
                    clearText();
                    },child: Text(MyString.txt_close,
                    style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),)
                ],
              )
            ],), onWillPop: (){});
    }, barrierDismissible: false);
  }

  clearText(){
    setState(() {
      _dropDownBuildingType = MyString.txt_no_selected;
      _dropDownBlockNo = MyString.txt_no_selected;
      _dropDownRoad = MyString.txt_no_selected;
      _widthContorller.clear();
      _lengthContorller.clear();
    });
  }

  String _getArv(){
    switch (_buildingGrade()){
      case MyString.BUILDING_GRADE_A:
        buildingValue = 0;
        break;
      case MyString.BUILDING_GRADE_B:
        buildingValue = -0.2;
        break;
      case MyString.BUILDING_GRADE_C:
        buildingValue = -0.8;
        break;
      case MyString.GOV_BUILDING:
        buildingValue = -0.15;
        break;
    }

    switch (_roadType()){
      case 1:
        roadValue = 0.1;
        break;
      case 2:
        roadValue = 0.05;
        break;
      case 3:
        roadValue = 0;
        break;
    }

    switch (_zone()){
      case 1:
        zoneValue = 0.5;
        break;
      case 2:
        zoneValue = 0.25;
        break;
      case 3:
        zoneValue = 0;
        break;
    }

    rentalRate = base_value + buildingValue * base_value + roadValue *base_value + zoneValue *base_value;
    arv = double.parse(_lengthContorller.text) * double.parse(_widthContorller.text) * rentalRate;
    int lastTwoDigit = arv.round() % 100;
    int finalArv;
    if (lastTwoDigit >= 50){
      finalArv = arv.round() + (100 - lastTwoDigit);

    }else {
      finalArv = arv.round() - lastTwoDigit;
    }
    print('rentalRate : ${rentalRate}');

    return NumConvertHelper().getMyanNumInt((finalArv * 0.02 + finalArv * 0.02).round());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(MyString.txt_calculate_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),)
      ),
      body: ListView(
        children: <Widget>[
          Container(
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
                          child: Text(MyString.txt_choose_building_type,
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
                          child: Text(MyString.txt_choose_road,
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
                              value: _dropDownRoad,
                              onChanged: (String value){
                                setState(() {
                                  _dropDownRoad = value;
                                });
                              },
                              items: _roadList.map<DropdownMenuItem<String>>((String str){
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
                          child: Text(MyString.txt_choose_blockNo,
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
                              value: _dropDownBlockNo,
                              onChanged: (String value){
                                setState(() {
                                  _dropDownBlockNo = value;
                                });
                              },
                              items: _blockNoList.map<DropdownMenuItem<String>>((String str){
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
                          height: 50.0,
                          child: RaisedButton(
                            onPressed: (){

                              if(_dropDownRoad != MyString.txt_no_selected && _dropDownBuildingType != MyString.txt_no_selected &&
                                _dropDownBlockNo != MyString.txt_no_selected && _lengthContorller.text.isNotEmpty && _widthContorller.text.isNotEmpty){
                                _calculateTaxDialog();
                              }else if(_dropDownBuildingType == MyString.txt_no_selected){
                                Fluttertoast.showToast(msg: 'Choose Building Type', backgroundColor: Colors.black.withOpacity(0.7));
                              }else if(_dropDownRoad == MyString.txt_no_selected){
                                Fluttertoast.showToast(msg: 'Choose Story', backgroundColor: Colors.black.withOpacity(0.7));
                              }else if(_dropDownBlockNo == MyString.txt_no_selected){
                                Fluttertoast.showToast(msg: 'Choose Block No', backgroundColor: Colors.black.withOpacity(0.7));
                              }else if(_lengthContorller.text.isEmpty){
                                Fluttertoast.showToast(msg: 'Enter Length', backgroundColor: Colors.black.withOpacity(0.7));
                              }else if(_widthContorller.text.isEmpty){
                                Fluttertoast.showToast(msg: 'Enter Width', backgroundColor: Colors.black.withOpacity(0.7));
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
