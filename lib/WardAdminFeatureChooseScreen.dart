import 'package:flutter/material.dart';
import 'package:myotaw/WardAdminContributionListScreen.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/main.dart';
import 'package:myotaw/model/DashBoardModel.dart';

import 'FloodReportListScreen.dart';

class WardAdminFeatureChooseScreen extends StatelessWidget {
  List<DashBoardModel> _list = List();

  _init(){
    DashBoardModel model1 = new DashBoardModel();
    model1.image = 'images/suggestion.png';
    model1.title = MyString.txt_ward_admin_feature;

    DashBoardModel model2 = new DashBoardModel();
    model2.image = 'images/profile_placeholder.png';
    model2.title = MyString.txt_myotaw_feature;

    DashBoardModel model3 = new DashBoardModel();
    model3.image = 'images/flood_report.png';
    model3.title = MyString.txt_flood_level;

    _list = [model1,model3, model2];
  }

  _widget(BuildContext context, int i){
    return GestureDetector(
      onTap: (){
        switch(_list[i].title){
          case MyString.txt_ward_admin_feature:
            Navigator.push(context, MaterialPageRoute(builder: (context) => WardAdminContributionListScreen(),
                settings: RouteSettings(name: ScreenName.WARD_ADMIN_CONTRIBUTION_LIST_SCREEN)));
            break;
          case MyString.txt_myotaw_feature:
            Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
            break;
          case MyString.txt_flood_level:
            Navigator.push(context, MaterialPageRoute(builder: (context) => FloodReportListScreen(),
                settings: RouteSettings(name: ScreenName.FLOOD_REPORT_LIST_SCREEN)));
            break;
        }
      },
      child: Container(
        color: MyColor.colorGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //image dao
            i!=0?Divider(thickness: 2, color: MyColor.colorPrimary,) : Container(),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                margin: EdgeInsets.only(bottom: 20),
                child: Image.asset(_list[i].image, width: 130, height: 130,)),
            //text title
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Text(_list[i].title,textAlign: TextAlign.center,
                style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorPrimary),),
            ),
          ],),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child:
            Text(MyString.txt_choose_feature, style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), )),
      ),
      body: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index){
            return _widget(context, index);
          }
      )
    );
  }
}
