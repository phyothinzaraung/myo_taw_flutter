import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:myotaw/customIcons/MyoTawCustomIcon.dart';
import 'package:myotaw/database/NotificationDb.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:notifier/notifier.dart';
import 'Database/UserDb.dart';
import 'SplashScreen.dart';
import 'NewsFeedScreen.dart';
import 'DashBoardScreen.dart';
import 'NotificationScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'helper/PlatformHelper.dart';
import 'helper/ServiceHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'model/UserModel.dart';
import 'ProfileFormScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'model/NotificationModel.dart';
import 'dart:convert';
import 'helper/NavigatorHelper.dart';
import 'NotificationDetailScreen.dart';


void main() {
  /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: MyColor.colorPrimaryDark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));*/
  WidgetsFlutterBinding.ensureInitialized();
  try {
    FlutterStatusbarcolor.setStatusBarColor(MyColor.colorPrimaryDark);
  }  catch (e) {
    print(e);
  }
  FirebaseAnalytics fireBaseAnalytics = FirebaseAnalytics();
  FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: fireBaseAnalytics);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(
      NotifierProvider(
        child: PlatformHelper.isAndroid()? MaterialApp(
          home: SplashScreen(),
          navigatorObservers: [
            observer
          ],
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              color: MyColor.colorPrimary,
            ),
            accentColor: MyColor.colorPrimaryDark,
            scaffoldBackgroundColor: MyColor.colorGrey,
          ),
        ) : CupertinoApp(
          home: SplashScreen(),
          navigatorObservers: [
            observer
          ],
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          theme: CupertinoThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
            scaffoldBackgroundColor: MyColor.colorGrey,
          ),
        ),
      )
    );
  });


}

class MainScreen extends StatefulWidget {
  bool _isNoti;
  MainScreen(this._isNoti);

  @override
  _mainState createState() => _mainState();
}

class _mainState extends State<MainScreen> with TickerProviderStateMixin {
  TabController _tabController;
  UserModel _userModel;
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  UserDb _userDb = UserDb();
  FirebaseMessaging _firebaseMesssaging = FirebaseMessaging();
  NotificationDb _notificationDb = NotificationDb();
  bool _isBadgeShow = false;
  int _noticount = 0;
  Notifier _notifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    _requestPermission();
    getUserData();
    if(widget._isNoti){
      _tabController.animateTo(1,duration: Duration(milliseconds: 500),curve: Curves.easeIn);
      _tabController.animateTo(2,duration: Duration(milliseconds: 500),curve: Curves.easeIn);
    }
  }

  initBadge()async{
    try{
      await _sharepreferenceshelper.initSharePref();
      var response = await ServiceHelper().getNotification(_sharepreferenceshelper.getRegionCode());
      if(response.data != null) {
        var result = response.data;
        await _notificationDb.openNotificationDb();
        var l = await _notificationDb.getNotification();

        if(l.length == 0){
          for(var i in result){
            //_notificationList.add(NotificationModel.fromJson(i));
            bool isSave = await _notificationDb.isNotificationSaved(NotificationModel.fromJson(i).iD);
            NotificationModel model = NotificationModel.fromJson(i);
            model.isSeen = true;
            if(!isSave){
              _notificationDb.insert(model);
            }
          }
        }else{
          for(var i in result){
            //_notificationList.add(NotificationModel.fromJson(i));
            bool isSave = await _notificationDb.isNotificationSaved(NotificationModel.fromJson(i).iD);
            if(!isSave){
              _notificationDb.insert(NotificationModel.fromJson(i));
            }
          }
        }
        await _notificationDb.openNotificationDb();
        //var isBadge = await _notificationDb.isBadge();
        var count = await _notificationDb.getUnReadNotificationCount();
        _notificationDb.closeSaveNotificationDb();
        print(count);
        if(count != 0){
          setState(() {
            _isBadgeShow = true;
            _noticount = count;
          });
        }else{
          _isBadgeShow = false;
        }
      }

    }catch(e){
      print(e);
    }
  }

  getUserData() async{
    await initBadge();
    await _userDb.openUserDb();
    final model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    _userModel = model;
    _userDb.closeUserDb();
     Future.delayed(Duration(milliseconds: 100)).whenComplete((){
       if(_userModel.name == null){
         CustomDialogWidget().customSuccessDialog(
           context: context,
           content: MyString.txt_profile_set_up_need,
           img: 'logout_icon.png',
           buttonText: MyString.txt_profile_set_up,
           onPress: (){
             _navigateToProfileFormScreen();
           }
         );
       }
     });

     if(_userModel.isWardAdmin == 0){
       _firebaseMesssaging.subscribeToTopic('all');
       _firebaseMesssaging.configure(
           onMessage: (Map<String, dynamic> message) async {
             print('on message $message');

             if(message != null){
               String json = message['data']['notification'];
               Map<String, dynamic> temp = jsonDecode(json);
               await _notificationDb.openNotificationDb();
               await _notificationDb.insert(NotificationModel.fromJson(temp));
               var count = await _notificationDb.getUnReadNotificationCount();
               _notificationDb.closeSaveNotificationDb();
               _notifier.notify('noti_count', count);
               _notifier.notify('noti_add', temp);
             }
           },
           onResume: (Map<String, dynamic> message) async {
             print('on resume ${message['data']['screen']}');

             if(message != null){
               String json = message['data']['notification'];
               Map<String, dynamic> temp = jsonDecode(json);
               await _notificationDb.openNotificationDb();
               NotificationModel model = NotificationModel.fromJson(temp);
               model.isSeen = true;
               await _notificationDb.insert(model);
               _notificationDb.closeSaveNotificationDb();
               if(message['data']['notification'] != null){
                 NavigatorHelper.MyNavigatorPush(context, NotificationDetailScreen(model), ScreenName.NOTIFICATION_DETAIL_SCREEN);
               }
             }
           },
           onLaunch: (Map<String, dynamic> message) async {
             print('on launch ${message['data']['screen']}');

             if (message != null) {
               String json = message['data']['notification'];
               Map<String, dynamic> temp = jsonDecode(json);
               await _notificationDb.openNotificationDb();
               NotificationModel model = NotificationModel.fromJson(temp);
               model.isSeen = true;
               await _notificationDb.insert(model);
               _notificationDb.closeSaveNotificationDb();
               if(message['data']['notification'] != null){
                 NavigatorHelper.MyNavigatorPush(context, NotificationDetailScreen(model), ScreenName.NOTIFICATION_DETAIL_SCREEN);
               }
             }
           }
       );

       _firebaseMesssaging.onTokenRefresh.listen((refreshToken)async{
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
  }

  _navigateToProfileFormScreen()async{
    Map result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileFormScreen(_userModel.isWardAdmin==1?true:false)));
    if(result != null && result.containsKey('isNeedRefresh') == true){
      Navigator.of(context).pop();
    }
  }

  _requestPermission()async{
    await PermissionHandler().requestPermissions([PermissionGroup.camera, PermissionGroup.storage,PermissionGroup.photos, PermissionGroup.location]);
  }

  Widget _androidBottomNavigation(){
    return Scaffold(
      body: TabBarView(
        children: [
          NewsFeedScreen(),
          DashBoardScreen(),
          NotificationScreen(),
        ],
        controller: _tabController,
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: WillPopScope(
          onWillPop: onWillPop,
          child: TabBar(
            indicatorColor: Colors.white,
            labelColor: MyColor.colorPrimary,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2.0,
            unselectedLabelColor: MyColor.colorGreyDark,
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(MyoTawCustomIcon.News_feed_icon, size: 25,)),
              Tab(icon: Icon(MyoTawCustomIcon.Dash_board_icon, size: 25,)),
              Tab(icon: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Icon(MyoTawCustomIcon.Notification_icon, size: 25,),
                  _isBadgeShow?Container(
                    alignment: Alignment.center,
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.red,
                    ),
                    child: Notifier.of(context).register<int>('noti_count', (value){
                      //_noticount = value.data;
                      if(value.data != null && value.data == 0){
                        _isBadgeShow = false;
                      }
                      return Text('${value.data??_noticount}', style: TextStyle(fontSize: 8, color: Colors.white),);
                    }),
                  ) : Container(width: 0, height: 0,)
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _iosTabBarNavigation(){
    return CupertinoPageScaffold(
        child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              activeColor: MyColor.colorPrimary,
              inactiveColor: MyColor.colorGreyDark,
              backgroundColor: Colors.white,
              items: [
                BottomNavigationBarItem(icon: Icon(MyoTawCustomIcon.News_feed_icon, size: 25,)),
                BottomNavigationBarItem(icon: Icon(MyoTawCustomIcon.Dash_board_icon, size: 25,)),
                BottomNavigationBarItem(icon: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Icon(MyoTawCustomIcon.Notification_icon, size: 25,),
                    _isBadgeShow?Container(
                      alignment: Alignment.center,
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.red,
                      ),
                      child: Notifier.of(context).register<int>('noti_count', (value){
                        //_noticount = value.data;
                        if(value.data != null && value.data == 0){
                          _isBadgeShow = false;
                        }
                        return Text('${value.data??_noticount}', style: TextStyle(fontSize: 8, color: Colors.white),);
                      }),
                    ) : Container(width: 0, height: 0,)
                  ],
                )),
              ],
            ),
            tabBuilder: (context, index){
              switch (index){
                case 0:
                  return NewsFeedScreen();
                  break;
                case 1:
                  return DashBoardScreen();
                  break;
                case 2:
                  return NotificationScreen();
              }
              return null;
            }
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    _notifier = NotifierProvider.of(context);
    return SafeArea(
      top: true,
      bottom: true,
      left: false,
      right: false,
      child: PlatformHelper.isAndroid()? _androidBottomNavigation() : _iosTabBarNavigation(),
    );
  }

  Future<bool> onWillPop() {
    if (_tabController.index == 0) {
      return Future.value(true);
    }
    _tabController.animateTo(0);
    return Future.value(false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }
}

