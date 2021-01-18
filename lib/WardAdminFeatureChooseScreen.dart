
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/NewsFeedScreen.dart';
import 'package:myotaw/FormListScreen.dart';
import 'package:myotaw/NotificationScreen.dart';
import 'package:myotaw/ProfileScreen.dart';
import 'package:myotaw/SaveNewsFeedScreen.dart';
import 'package:myotaw/WardAdminContributionListScreen.dart';
import 'package:myotaw/database/UserDb.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/helper/ServiceHelper.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/model/DashBoardModel.dart';
import 'package:myotaw/model/UserModel.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'FloodReportListScreen.dart';
import 'NotificationDetailScreen.dart';
import 'helper/NavigatorHelper.dart';
import 'dart:convert';
import 'helper/PlatformHelper.dart';
import 'model/NotificationModel.dart';

class WardAdminFeatureChooseScreen extends StatefulWidget {
  final bool isForm;
  WardAdminFeatureChooseScreen({this.isForm:false});
  @override
  _WardAdminFeatureChooseScreenState createState() => _WardAdminFeatureChooseScreenState();
}

class _WardAdminFeatureChooseScreenState extends State<WardAdminFeatureChooseScreen> {

  List<DashBoardModel> _list = List();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserDb _userDb = UserDb();
  bool _isBadgeShow = false;
  Notifier _notifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermission();
    _init();
    _initBadge();
  }

  _init()async{
    DashBoardModel model1 = new DashBoardModel();
    model1.image = 'images/suggestion.png';
    model1.title = MyString.txt_ward_admin_feature;

    DashBoardModel model2 = new DashBoardModel();
    model2.image = 'images/newsfeed_circle.png';
    model2.title = MyString.txt_myotaw_channel;

    DashBoardModel model3 = new DashBoardModel();
    model3.image = 'images/flood_report.png';
    model3.title = MyString.txt_flood_level;

    DashBoardModel model4 = new DashBoardModel();
    model4.image = 'images/form_circle.png';
    model4.title = MyString.txt_form;

    DashBoardModel model5 = new DashBoardModel();
    model5.image = 'images/profile_placeholder.png';
    model5.title = MyString.txt_profile;

    DashBoardModel model6 = new DashBoardModel();
    model6.image = 'images/noti_circle.png';
    model6.title = MyString.txt_title_notification;

    DashBoardModel model7 = new DashBoardModel();
    model7.image = 'images/save_file.png';
    model7.title = MyString.txt_save_newsFeed;

    _list = [model1,model3, model2, model5, model6, model7];

    if(widget.isForm){
      _list.insert(3, model4);
    }

    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on resume ${message['data']['notification']}');

          if(message.isNotEmpty){
            //show badge push noti is incoming
            _notifier.notify('noti_count', 1);
          }
        },
        onResume: (Map<String, dynamic> message) async {
          print('on resume ${message['data']['notification']}');

          if(message.isNotEmpty){
            String json = message['data']['notification'];
            Map<String, dynamic> temp = jsonDecode(json);
            NotificationModel model = NotificationModel.fromJson(temp);
            NavigatorHelper.myNavigatorPush(context, NotificationDetailScreen(model.iD), ScreenName.NOTIFICATION_DETAIL_SCREEN);
          }
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('on launch ${message['data']['notification']}');

          if (message.isNotEmpty) {
            String json = message['data']['notification'];
            Map<String, dynamic> temp = jsonDecode(json);
            NotificationModel model = NotificationModel.fromJson(temp);
            NavigatorHelper.myNavigatorPush(context, NotificationDetailScreen(model.iD), ScreenName.NOTIFICATION_DETAIL_SCREEN);
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

  _initBadge()async{
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    UserModel model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    _userDb.closeUserDb();
    try{
      //for unRead count
      var response = await ServiceHelper().getNotification(_sharepreferenceshelper.getRegionCode(),_sharepreferenceshelper.getUserUniqueKey(), model.wardName);
      if(response.data != null) {
        var _count = response.data['unReadCount'];
        if(_count != 0){
          setState(() {
            _isBadgeShow = true;
          });
          _sharepreferenceshelper.saveNotiUnreadCount(_count);
        }else{
          setState(() {
            _isBadgeShow = false;
          });
        }
      }

    }catch(e){
      print(e);
    }
  }

  _widget(BuildContext context, int i){
    return GestureDetector(
      onTap: (){
        switch(_list[i].title){
          case MyString.txt_ward_admin_feature:
            NavigatorHelper.myNavigatorPush(context, WardAdminContributionListScreen(), ScreenName.WARD_ADMIN_CONTRIBUTION_LIST_SCREEN);
            break;
          case MyString.txt_myotaw_channel:
          //NavigatorHelper.myNavigatorPush(context, MainScreen(), ScreenName.MYOTAW_CHANNEL);
            CustomDialogWidget().customChannelChooserDialog(
                context: context,
                title: MyString.txt_myotaw_channel_chooser,
                generalText: MyString.txt_myotaw_channel_general,
                blockText: MyString.txt_myotaw_channel_blocklevel,
                onPressGeneral: ()async{
                  await _sharepreferenceshelper.initSharePref();
                  await _userDb.openUserDb();
                  UserModel userModel = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
                  _userDb.closeUserDb();
                  Navigator.of(context).pop();
                  NavigatorHelper.myNavigatorPush(context, NewsFeedScreen(channelType: userModel.memberType, isWardAdmin: true,), ScreenName.MYO_TAW_GENERAL_CHANNEL);
                },
                onPressBlockLevel: ()async{
                  Navigator.of(context).pop();
                  NavigatorHelper.myNavigatorPush(context, NewsFeedScreen(channelType: MyString.NEWS_FEED_CHANNEL_TYPE_BLOCK, isWardAdmin: true,), ScreenName.MYO_TAW_BLOCK_CHANNEL);
                }
            );
            break;
          case MyString.txt_flood_level:
            NavigatorHelper.myNavigatorPush(context, FloodReportListScreen(), ScreenName.FLOOD_REPORT_LIST_SCREEN);
            break;
          case MyString.txt_form:
            NavigatorHelper.myNavigatorPush(context, FormListScreen(), ScreenName.FORM_LIST_SCREEN);
            break;
          case MyString.txt_profile:
            NavigatorHelper.myNavigatorPush(context, ProfileScreen(isWardAdmin: true,), ScreenName.PROFILE_SCREEN);
            break;
          case MyString.txt_title_notification:
            NavigatorHelper.myNavigatorPush(context, NotificationScreen(_sharepreferenceshelper), ScreenName.NOTIFICATION_SCREEN);
            break;
          case MyString.txt_save_newsFeed:
            NavigatorHelper.myNavigatorPush(context, SaveNewsFeedScreen(), ScreenName.SAVED_NEWS_FEED_SCREEN);
            break;
        }
      },
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
          color: MyColor.colorGrey,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //image dao
                  //i!=0?Divider(thickness: 2, color: MyColor.colorPrimary,) : Container(),
                  Flexible(
                    flex: 4,
                    child: Image.asset(_list[i].title == MyString.txt_title_notification? _isBadgeShow? 'images/noti_alert.png' : _list[i].image : _list[i].image,),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //text title
                  Flexible(
                    flex: 1,
                    child: Text(_list[i].title,textAlign: TextAlign.center,
                      style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack,),
                    ),
                  ),
                ],
              ),
              /*_list[i].title == MyString.txt_title_notification?Container(
                margin: EdgeInsets.only(bottom: 70, left: 35),
                alignment: Alignment.center,
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: _isBadgeShow? Colors.red : Colors.transparent,
                ),
              ) : Container(),*/
            ],
          )
      ),
    );
  }

  Widget _body(){
    return Notifier.of(context).register<int>('noti_count', (value){
      if(value.data != null){
        if(value.data == 0){
          _isBadgeShow = false;
        }else{
          _isBadgeShow = true;
        }
      }
      return Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index){
                    return _widget(context, index);
                  },childCount: _list.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ))
            ],
          )
      );
    });
  }

  _requestPermission()async{
    var _isCamera = await Permission.camera.isGranted;
    var _isStorage = await Permission.storage.isGranted;
    var _isPhoto = await Permission.photos.isGranted;
    var _isLocation = await Permission.location.isGranted;
    if(!_isCamera) {
      await Permission.camera.request();
    }
    if(!_isStorage) {
      await Permission.storage.request();
    }
    if(!_isPhoto){
      await Permission.photos.request();
    }
    if(!_isLocation){
      await Permission.location.request();
    }
  }
  @override
  Widget build(BuildContext context) {
    _notifier = NotifierProvider.of(context);
    return CustomScaffoldWidget(
        title: Text(MyString.txt_choose_feature,maxLines: 1, overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal),
        ),
        centerTitle: true,
        body: _body());
  }
}
