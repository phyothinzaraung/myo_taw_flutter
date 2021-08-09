import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myotaw/WardAdminFeatureChooseScreen.dart';
import 'package:myotaw/database/UserDb.dart';
import 'package:myotaw/helper/MyoTawCitySetUpHelper.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/helper/ServiceHelper.dart';
import 'package:myotaw/model/UserModel.dart';
import 'package:package_info/package_info.dart';
import 'database/NotificationDb.dart';
import 'helper/MyoTawConstant.dart';
import 'main.dart';
import 'package:flutter/services.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'helper/SharePreferencesHelper.dart';
import 'LoginScreen.dart';
import 'Database/LocationDb.dart';
import 'model/LocationModel.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  LocationDb _locationDb = LocationDb();
  String _logo, _title;
  bool _isDbSetup = true;
  String _appVersion = '';
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  NotificationDb _notificationDb = new NotificationDb();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isAdmin = false;
  UserDb _userDb = UserDb();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
    _createNotificationChannel();
    _updateUserActiveTime();
    _firebaseMessaging.subscribeToTopic('all');
  }
  _init()async{
    await _sharepreferenceshelper.initSharePref();
    _isAdmin = _sharepreferenceshelper.isWardAdmin();
    PackageInfo.fromPlatform().then((info){
      _appVersion = info.version;
    });
    if(_sharepreferenceshelper.getRegionCode()!=null){
      //await getUserData();
      setState(() {
        _logo = MyoTawCitySetUpHelper.getCityLogo(_sharepreferenceshelper.getRegionCode());
        if(_isAdmin){
          _title = MyoTawCitySetUpHelper.getCityWelcomeTitle(_sharepreferenceshelper.getRegionCode()).replaceAll('စည်ပင်သာယာရေး', '');
        }else{
          _title = MyoTawCitySetUpHelper.getCityWelcomeTitle(_sharepreferenceshelper.getRegionCode());
        }
      });
    }
    await _notificationDb.openNotificationDb();
    bool _isTableExists = await _notificationDb.isNotiTableExist();
    if(_isTableExists){
      await _notificationDb.dropNotificationTable();
      print('drop notification table');
    }
    print('table exists $_isTableExists');
    _notificationDb.closeSaveNotificationDb();
    await _locationInit();
    navigateMainScreen();
  }

  _createNotificationChannel(){
    var androidPlatformChannelSpecifics = AndroidNotificationChannel(
        'Myotaw app channel id', 'Myotaw app', 'Myotaw notification', importance: Importance.max);
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidPlatformChannelSpecifics);
    print('create notification channel');
  }

  _updateUserActiveTime() async{
    await _sharepreferenceshelper.initSharePref();
    try{
      var response = await ServiceHelper().updateUserActiveTime(_sharepreferenceshelper.getUserUniqueKey());
      print(response.data);
    }catch(e){
      print(e);
    }
  }

  _locationInit()async{
    await _locationDb.openLocationDb();
    bool isSetup = await _locationDb.isLocationDbSetup();
    _locationDb.closeLocationDb();
    setState(() {
      _isDbSetup = isSetup;
    });
    if(!isSetup){
      var stringJson = await rootBundle.loadString('assets/location.json');
      var list = jsonDecode(stringJson);
      for(var i in list){
        await _locationDb.openLocationDb();
        await _locationDb.insert(LocationModel.fromJson(i));
        _locationDb.closeLocationDb();
      }
      print('locationDbsetup');
    }
  }

  bool _isForm(){
    if(MyStringList.isFormRegionCode.contains(_sharepreferenceshelper.getRegionCode())){
      return true;
    }else{
      return false;
    }
  }

  navigateMainScreen(){
    if(_sharepreferenceshelper.isLogin()){
      Future.delayed(Duration(milliseconds: 1500), ()async{
        if(_sharepreferenceshelper.isWardAdmin()){

          await _userDb.openUserDb();
          UserModel _model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
          _userDb.closeUserDb();

          if(_model.isActive){
            NavigatorHelper.myNavigatorPushReplacement(context,
                WardAdminFeatureChooseScreen(isForm: _isForm()), ScreenName.WARD_ADMIN_FEATURE_SCREEN);
          }else{
            NavigatorHelper.myNavigatorPushReplacement(context, MainScreen(), null);
          }

        }else{
          NavigatorHelper.myNavigatorPushReplacement(context, MainScreen(), null);
        }
      });
    }else{
      Future.delayed(Duration(seconds: 2), (){
        NavigatorHelper.myNavigatorPushReplacement(context, LoginScreen(), ScreenName.LOGIN_SCREEN);
      });
    }
  }


  Widget _logoWidget(){
    if(_logo == null || _isAdmin){
      return Flexible(
          flex: 2,
          child: Container(
              margin: EdgeInsets.only(bottom: 20, top: 20),
              child: Hero(
                  tag: 'myotaw',
                  child: Image.asset('images/myo_taw_logo_eng.png', width: 100.0, height: 100.0,))
          )
      );
    }else{
      return Flexible(
        flex: 1,
        child: Container(margin: EdgeInsets.only(bottom: 20.0),child: Image.asset(_logo, width: 150.0, height: 150.0,)),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorPrimary,
      body: Center(
        child: Container(
          width: 250.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _logoWidget(),
              Flexible(
                flex: 1,
                child: _title!=null?Text(_title,
                  style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal,),
                  softWrap: true,maxLines: 3, textAlign: TextAlign.center,) : Container(width: 0,height: 0,),
              ),
              !_isDbSetup?Flexible(
                flex: 1,
                child: SpinKitCircle(
                  size: 80,
                  controller: AnimationController(vsync: this,duration: Duration(seconds: 2),
                ), color: Colors.white),
              ) : Container(),
              Flexible(
                  flex: 1,
                  child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(_appVersion, style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: Colors.white),))
              ),
            ],
          ),
        ),
      )
    );
  }
}
