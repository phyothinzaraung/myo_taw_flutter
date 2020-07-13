import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/WardAdminContributionListScreen.dart';
import 'package:myotaw/database/NotificationDb.dart';
import 'package:myotaw/database/UserDb.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/helper/ServiceHelper.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/main.dart';
import 'package:myotaw/model/DashBoardModel.dart';
import 'package:myotaw/model/UserModel.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:notifier/main_notifier.dart';
import 'FloodReportListScreen.dart';
import 'NotificationDetailScreen.dart';
import 'helper/NavigatorHelper.dart';
import 'dart:convert';
import 'helper/PlatformHelper.dart';
import 'model/NotificationModel.dart';

class WardAdminFeatureChooseScreen extends StatelessWidget {
  List<DashBoardModel> _list = List();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserDb _userDb = UserDb();
  Notifier _notifier;

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
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.configure(
        onResume: (Map<String, dynamic> message) async {
          print('on resume ${message['data']['notification']}');

          if(message.isNotEmpty){
            String json = message['data']['notification'];
            Map<String, dynamic> temp = jsonDecode(json);
            NotificationModel model = NotificationModel.fromJson(temp);
            if(message['data']['notification'] != null ){
              _sharepreferenceshelper.setNotificationAdd(true);
              NavigatorHelper.myNavigatorPush(context, NotificationDetailScreen(model.iD), ScreenName.NOTIFICATION_DETAIL_SCREEN);
            }
          }
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('on launch ${message['data']['notification']}');

          if (message.isNotEmpty) {
            String json = message['data']['notification'];
            Map<String, dynamic> temp = jsonDecode(json);
            NotificationModel model = NotificationModel.fromJson(temp);
            if(message['data']['notification'] != null){
              _sharepreferenceshelper.setNotificationAdd(true);
              NavigatorHelper.myNavigatorPush(context, NotificationDetailScreen(model.iD), ScreenName.NOTIFICATION_DETAIL_SCREEN);
            }
          }
        }
    );

    _firebaseMessaging.onTokenRefresh.listen((refreshToken)async{
      await _sharepreferenceshelper.initSharePref();
      if(_sharepreferenceshelper.getToken() != refreshToken){
        try{
          var response = await ServiceHelper().updateUserToken(_sharepreferenceshelper.getUserUniqueKey(), refreshToken, PlatformHelper.isAndroid()?'Android' : 'Ios');
          await _userDb.openUserDb();
          await _userDb.insert(UserModel.fromJson(response.data));
          _userDb.closeUserDb();
          _sharepreferenceshelper.setUserToken(refreshToken);
        }catch(e){
          print(e);
        }
        print('update user token');
      }
      print('Token refresh : ' + refreshToken);
    });
  }

  _widget(BuildContext context, int i){
    return GestureDetector(
      onTap: (){
        switch(_list[i].title){
          case MyString.txt_ward_admin_feature:
            NavigatorHelper.myNavigatorPush(context, WardAdminContributionListScreen(), ScreenName.WARD_ADMIN_CONTRIBUTION_LIST_SCREEN);

            break;
          case MyString.txt_myotaw_feature:
            NavigatorHelper.myNavigatorPush(context, MainScreen(), null);
            //Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
            break;
          case MyString.txt_flood_level:
            NavigatorHelper.myNavigatorPush(context, FloodReportListScreen(), ScreenName.FLOOD_REPORT_LIST_SCREEN);

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
        title: Text(MyString.txt_choose_feature,maxLines: 1, overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal),
        ),
        centerTitle: true,
        body: _body());
  }
}
