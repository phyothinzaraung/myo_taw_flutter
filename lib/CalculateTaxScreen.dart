import 'package:flutter/material.dart';
import 'MlmPropertyTaxCalculatorScreen.dart';
import 'helper/MyoTawConstant.dart';
import 'MlmBizTaxCalculatorScreen.dart';
import 'TgyPropertyTaxCalculatorScreen.dart';
import 'helper/SharePreferencesHelper.dart';
import 'TgyBizTaxCalculatorScreen.dart';

class CalculateTaxScreen extends StatefulWidget {
  @override
  _CalculateTaxScreenState createState() => _CalculateTaxScreenState();
}

class _CalculateTaxScreenState extends State<CalculateTaxScreen> {
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharePref();
  }

  initSharePref()async{
    _sharepreferenceshelper.initSharePref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.txt_calculate_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),)
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                children: <Widget>[
                  Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/calculate_tax_no_circle.png', width: 30.0, height: 30.0,)),
                  Text(MyString.title_calculate_tax, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){

                      switch (_sharepreferenceshelper.getRegionCode()){
                        case MyString.TGY_REGIONCODE:
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TgyPropertyTaxCalculatorScreen()));
                          break;
                        case MyString.MLM_REGIONCODE:
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MlmPropertyTaxCalculatorScreen()));
                          break;
                      }

                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Image.asset('images/tax.png')),
                          Text(MyString.txt_property_tax, textAlign: TextAlign.center,style: TextStyle(fontSize: FontSize.textSizeNormal))
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                      switch (_sharepreferenceshelper.getRegionCode()){
                        case MyString.TGY_REGIONCODE:
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TgyBizTaxCalculatorScreen()));
                          break;
                        case MyString.MLM_REGIONCODE:
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MlmBizTaxCalculatorScreen()));
                          break;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Image.asset('images/business_license.png')),
                          Text(MyString.txt_biz_tax, textAlign: TextAlign.center,style: TextStyle(fontSize: FontSize.textSizeNormal),)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
