import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/WardAdminContributionListScreen.dart';
import 'package:myotaw/database/UserDb.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/helper/ServiceHelper.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/main.dart';
import 'package:myotaw/model/DashBoardModel.dart';
import 'package:myotaw/model/UserModel.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'FloodReportListScreen.dart';
import 'helper/NavigatorHelper.dart';
import 'dart:io';

class WardAdminFeatureChooseScreen extends StatelessWidget {
  List<DashBoardModel> _list = List();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserDb _userDb = UserDb();

  _init(BuildContext context){
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

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
        },
        onResume: (Map<String, dynamic> message) async {
          print('on resume ${message['data']['noti']}');
          /*if(message['data']['noti'] == 'yes'){
            NavigatorHelper().MyNavigatorPush(context, MainScreen(true), null);
          }*/
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('on launch ${message['data']['noti']}');
          /*if(message['data']['noti'] == 'yes'){
            NavigatorHelper().MyNavigatorPush(context, MainScreen(true), null);
          }*/
        }
    );

    _firebaseMessaging.onTokenRefresh.listen((refreshToken)async{
      await _sharepreferenceshelper.initSharePref();
      if(_sharepreferenceshelper.getToken() != refreshToken){
        try{
          var response = await ServiceHelper().updateUserToken(_sharepreferenceshelper.getUserUniqueKey(), refreshToken, Platform.isAndroid?'Android' : 'Ios');
          await _userDb.openUserDb();
          await _userDb.insert(UserModel.fromJson(response.data));
          _userDb.closeUserDb();
          _sharepreferenceshelper.setUserToken(refreshToken);
        }catch(e){
          print(e);
        }
        print('update user token');
      }
      print('on Token refresh : ' + refreshToken);
    });
  }

  _widget(BuildContext context, int i){
    return GestureDetector(
      onTap: (){
        switch(_list[i].title){
          case MyString.txt_ward_admin_feature:
            NavigatorHelper().MyNavigatorPush(context, WardAdminContributionListScreen(), ScreenName.WARD_ADMIN_CONTRIBUTION_LIST_SCREEN);
            /*Navigator.push(context, MaterialPageRoute(builder: (context) => WardAdminContributionListScreen(),
                settings: RouteSettings(name: ScreenName.WARD_ADMIN_CONTRIBUTION_LIST_SCREEN)));*/
            break;
          case MyString.txt_myotaw_feature:
            NavigatorHelper().MyNavigatorPush(context, MainScreen(false), null);
            //Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
            break;
          case MyString.txt_flood_level:
            NavigatorHelper().MyNavigatorPush(context, FloodReportListScreen(), ScreenName.FLOOD_REPORT_LIST_SCREEN);
            /*Navigator.push(context, MaterialPageRoute(builder: (context) => FloodReportListScreen(),
                settings: RouteSettings(name: ScreenName.FLOOD_REPORT_LIST_SCREEN)));*/
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

  Widget _body(){
    return ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index){
          return _widget(context, index);
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    _init(context);
    return CustomScaffoldWidget(
        title: Center(
          child: Text(MyString.txt_choose_feature,maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
        ),
        body: _body());
    /*return Scaffold(
      body: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: MyColor.colorPrimary,
            middle: Text(MyString.txt_choose_feature, style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal)),
          ),
          child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index){
                return _widget(context, index);
              }
          )
      ),
    );*/
    /*return Scaffold(
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
    );*/
  }
}
