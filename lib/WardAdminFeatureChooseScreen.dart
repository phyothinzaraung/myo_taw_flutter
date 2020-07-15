import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/NewsFeedScreen.dart';
import 'package:myotaw/FormScreen.dart';
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
    model2.title = MyString.txt_myotaw_channel;

    DashBoardModel model3 = new DashBoardModel();
    model3.image = 'images/flood_report.png';
    model3.title = MyString.txt_flood_level;

    DashBoardModel model4 = new DashBoardModel();
    model4.image = 'images/profile_placeholder.png';
    model4.title = MyString.txt_form;

    _list = [model1,model3, model2, model4];
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
          case MyString.txt_myotaw_channel:
            NavigatorHelper.myNavigatorPush(context, MainScreen(), ScreenName.MYOTAW_CHANNEL);
            break;
          case MyString.txt_flood_level:
            NavigatorHelper.myNavigatorPush(context, FloodReportListScreen(), ScreenName.FLOOD_REPORT_LIST_SCREEN);
            break;
          case MyString.txt_form:
            NavigatorHelper.myNavigatorPush(context, FormScreen(), ScreenName.FORM_SCREEN);
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.only(right: 20, left: 20, top: 20),
        color: MyColor.colorGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //image dao
            //i!=0?Divider(thickness: 2, color: MyColor.colorPrimary,) : Container(),
            Flexible(
              flex: 3,
              child: Image.asset(_list[i].image,),
            ),
            SizedBox(
              height: 5,
            ),
            //text title
            Flexible(
              flex: 1,
              child: Text(_list[i].title,textAlign: TextAlign.center,
                style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorTextBlack, height: 1.4),),
            ),
          ],),
      ),
    );
  }

  Widget _body(){
    return Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index){
                  return _widget(context, index);
                },childCount: _list.length),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 0
                ))
          ],
        )
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
