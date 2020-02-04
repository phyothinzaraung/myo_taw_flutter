import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:myotaw/customIcons/MyoTawCustomIcon.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'Database/UserDb.dart';
import 'SplashScreen.dart';
import 'NewsFeedScreen.dart';
import 'DashBoardScreen.dart';
import 'NotificationScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'helper/SharePreferencesHelper.dart';
import 'model/UserModel.dart';
import 'ProfileFormScreen.dart';
import 'myWidget/CustomButtonWidget.dart';

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
    runApp(MaterialApp(
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
    ));
  });
}

class MainScreen extends StatefulWidget {

  @override
  _mainState createState() => _mainState();
}

class _mainState extends State<MainScreen> with TickerProviderStateMixin {
  TabController _tabController;
  UserModel _userModel;
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  UserDb _userDb = UserDb();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    _requestPermission();
    _sharepreferenceshelper.initSharePref();
    getUserData();
  }

  getUserData() async{
    await _userDb.openUserDb();
    final model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    _userModel = model;
    await _userDb.closeUserDb();
     Future.delayed(Duration(milliseconds: 100)).whenComplete((){
       if(_userModel.name == null){
         _dialogProfileSetup();
       }
     });
  }

  _navigateToProfileFormScreen()async{
    Map result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileFormScreen(_userModel.isWardAdmin==1?true:false)));
    if(result != null && result.containsKey('isNeedRefresh') == true){
      Navigator.of(context).pop();
    }
  }

  _dialogProfileSetup(){
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
                      child: Image.asset('images/logout_icon.png', width: 60.0, height: 60.0,)),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(MyString.txt_profile_set_up_need,
                      style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack,),textAlign: TextAlign.center,),
                  ),
                  CustomButtonWidget(onPress: (){
                    _navigateToProfileFormScreen();

                  },child: Text(MyString.txt_profile_set_up,
                    style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),)
                ],
              )
            ],), onWillPop: (){});
    }, barrierDismissible: false);
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
              Tab(icon: Icon(Icons.notifications_none, size: 30,))
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
                BottomNavigationBarItem(icon: Icon(Icons.notifications_none, size: 30,)),
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
    return SafeArea(
      top: true,
      bottom: true,
      left: false,
      right: false,
      child: Platform.isAndroid? _androidBottomNavigation() : _iosTabBarNavigation(),
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

