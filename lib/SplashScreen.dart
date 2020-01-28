import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myotaw/WardAdminFeatureChooseScreen.dart';
import 'package:myotaw/helper/ServiceHelper.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
    _updateUserActiveTime();
  }
  _init()async{
    await _sharepreferenceshelper.initSharePref();
    if(_sharepreferenceshelper.getRegionCode()!=null){
      //await getUserData();
      switch(_sharepreferenceshelper.getRegionCode()){
        case MyString.TGY_REGIONCODE:
          setState(() {
            _logo = 'images/tgy_logo.png';
            _title = MyString.txt_welcome_tgy;
          });
          break;
        case MyString.MLM_REGIONCODE:
          setState(() {
            _logo = 'images/mlm_logo.png';
            _title = MyString.txt_welcome_mlm;
          });
          break;
        default:
      }
    }
    await _locationInit();
    navigateMainScreen();
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
    await _locationDb.closeLocationDb();
    setState(() {
      _isDbSetup = isSetup;
    });
    if(!isSetup){
      var stringJson = await rootBundle.loadString('assets/location.json');
      var list = jsonDecode(stringJson);
      for(var i in list){
        await _locationDb.openLocationDb();
        await _locationDb.insert(LocationModel.fromJson(i));
        await _locationDb.closeLocationDb();
      }
      print('locationDbsetup');
    }
  }

  navigateMainScreen() {
    if(_sharepreferenceshelper.isLogin()){
      Future.delayed(Duration(seconds: 2), (){
        if(_sharepreferenceshelper.isWardAdmin()){
          Navigator.pushReplacement(context, PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 1000),
              pageBuilder: (context,value,ani) => WardAdminFeatureChooseScreen(), settings: RouteSettings(name: ScreenName.WARD_ADMIN_FEATURE_SCREEN)
          ));
        }else{
          Navigator.pushReplacement(context, PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 1000),
              pageBuilder: (context,value,ani) => MainScreen()
          ));
        }
      });
    }else{
      Future.delayed(Duration(seconds: 2), (){
        Navigator.pushReplacement(context, PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 1000),
            pageBuilder: (context,value,ani) => LoginScreen(), settings: RouteSettings(name: ScreenName.LOGIN_SCREEN)
        ));
      });
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
              Flexible(
                flex: 1,
                child: _logo!=null?
                Container(margin: EdgeInsets.only(bottom: 20.0),child: Image.asset(_logo, width: 150.0, height: 150.0,)):Container(width: 0.0,height: 0.0,),
              ),
              Flexible(
                flex: 1,
                child: _title!=null?Container(
                  child: Text(_title,
                    style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal,),softWrap: true,maxLines: 3, textAlign: TextAlign.center,),
                ):Container(width: 0.0,height: 0.0,),
              ),
              Flexible(flex: 2,
                  child: Container(
                      margin: EdgeInsets.only(bottom: 30, top: 20),
                      child: Hero(
                          tag: 'myotaw',
                          child: Image.asset('images/myo_taw_logo_eng.png', width: 100.0, height: 100.0,)))),
              /*Flexible(
                flex: 1,
                child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text('Myo Taw', style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: Colors.white),)),
              ),*/
              !_isDbSetup?Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: SpinKitCircle(
                    size: 80,
                    controller: AnimationController(vsync: this, duration: Duration(seconds: 2),
                  ), color: Colors.white,),
                ),
              ) : Container(),
              Flexible(
                  flex: 1,
                  child: Text("Version 1.2", style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),)),
            ],
          ),
        ),
      )
    );
  }
}
