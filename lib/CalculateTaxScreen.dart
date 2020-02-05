import 'package:flutter/material.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'MlmPropertyTaxCalculatorScreen.dart';
import 'helper/MyoTawConstant.dart';
import 'MlmBizTaxCalculatorScreen.dart';
import 'TgyPropertyTaxCalculatorScreen.dart';
import 'helper/SharePreferencesHelper.dart';
import 'TgyBizTaxCalculatorScreen.dart';
import 'model/DashBoardModel.dart';

class CalculateTaxScreen extends StatefulWidget {
  @override
  _CalculateTaxScreenState createState() => _CalculateTaxScreenState();
}

class _CalculateTaxScreenState extends State<CalculateTaxScreen> {
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  List<DashBoardModel> _widgetList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharePref();
  }

  initSharePref()async{
    await _sharepreferenceshelper.initSharePref();
    _initCalculateTaxWidget();
  }

  _initCalculateTaxWidget(){
    DashBoardModel model1 = new DashBoardModel();
    model1.image = 'images/tax.png';
    model1.title = MyString.txt_property_tax;

    DashBoardModel model2 = new DashBoardModel();
    model2.image = 'images/business_license.png';
    model2.title = MyString.txt_biz_tax;

    setState(() {
      _widgetList.add(model1);
      _widgetList.add(model2);
    });
  }

  _listView(){
    return Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    //margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
                    child: headerTitleWidget(MyString.title_calculate_tax, 'calculate_tax_no_circle'),
                  )
                ])),
            SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index){
                  return GestureDetector(
                    onTap: (){
                      if(index == 0){
                        switch (_sharepreferenceshelper.getRegionCode()){
                          case MyString.TGY_REGIONCODE:
                            /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => TgyPropertyTaxCalculatorScreen(),
                              settings: RouteSettings(name: ScreenName.TGY_PROPERTY_TAX_CALCULATOR_SCREEN)
                            ));*/
                            NavigatorHelper().MyNavigatorPush(context, TgyPropertyTaxCalculatorScreen(), ScreenName.TGY_PROPERTY_TAX_CALCULATOR_SCREEN);
                            break;
                          case MyString.MLM_REGIONCODE:
                            /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => MlmPropertyTaxCalculatorScreen(),
                                settings: RouteSettings(name: ScreenName.MLM_PROPERTY_TAX_CALCULATOR_SCREEN)
                            ));*/
                            NavigatorHelper().MyNavigatorPush(context, MlmPropertyTaxCalculatorScreen(), ScreenName.MLM_PROPERTY_TAX_CALCULATOR_SCREEN);
                            break;
                        }
                      }else{
                        switch (_sharepreferenceshelper.getRegionCode()){
                          case MyString.TGY_REGIONCODE:
                            /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => TgyBizTaxCalculatorScreen(),
                                settings: RouteSettings(name: ScreenName.TGY_BIZ_TAX_CALCULATOR_SCREEN)
                            ));*/
                            NavigatorHelper().MyNavigatorPush(context, TgyBizTaxCalculatorScreen(), ScreenName.TGY_BIZ_TAX_CALCULATOR_SCREEN);
                            break;
                          case MyString.MLM_REGIONCODE:
                            /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => MlmBizTaxCalculatorScreen(),
                                settings: RouteSettings(name: ScreenName.MLM_BIZ_TAX_CALCULATOR_SCREEN)
                            ));*/
                            NavigatorHelper().MyNavigatorPush(context, MlmBizTaxCalculatorScreen(), ScreenName.MLM_BIZ_TAX_CALCULATOR_SCREEN);
                            break;
                        }
                      }
                    },
                    child: Container(
                      //margin: EdgeInsets.only(top: 7, bottom: 7),
                      child: Column(
                        children: <Widget>[
                          //image dao
                          Flexible(flex: 2,child: Image.asset(_widgetList[index].image,)),
                          //text title
                          Flexible(flex: 1,child: Text(_widgetList[index].title,textAlign: TextAlign.center,
                            style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorTextBlack),))],),),
                  );
                },childCount: _widgetList.length),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250.0,
                  crossAxisSpacing: 0.0,))
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: Text(MyString.txt_calculate_tax,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _listView(),
    );
    /*return Scaffold(
      appBar: AppBar(
        title: Text(MyString.txt_calculate_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),)
      ),
      body: _listView()
    );*/
  }
}
