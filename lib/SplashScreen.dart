import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter/services.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'helper/SharePreferencesHelper.dart';
import 'LoginScreen.dart';
import 'helper/UserDb.dart';
import 'model/UserModel.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  UserDb _userDb = UserDb.instance;
  UserModel _userModel;
  String _logo, _title;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }
  _init()async{
    await _sharepreferenceshelper.initSharePref();
    await getUserData();
    if(_sharepreferenceshelper.getRegionCode()!=null){
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
    navigateMainScreen();
  }

  navigateMainScreen() {
    if(_sharepreferenceshelper.getUserPhoneNo()!=null){
      Future.delayed(Duration(seconds: 2), (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(_userModel)));
      });
    }else{
      Future.delayed(Duration(seconds: 2), (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }
  }

   getUserData() async{
    final model = await _userDb.getUserById(_sharepreferenceshelper.getUniqueKey());
    _userModel = model;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: MyColor.colorPrimary,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 250.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _logo!=null?
              Container(margin: EdgeInsets.only(bottom: 20.0),child: Image.asset(_logo, width: 100.0, height: 100.0,)):Container(width: 0.0,height: 0.0,),
              _title!=null?Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Text(_title,
                  style: TextStyle(color: MyColor.colorPrimary, fontSize: FontSize.textSizeSmall,),softWrap: true,maxLines: 3, textAlign: TextAlign.center,),
              ):Container(width: 0.0,height: 0.0,),
              Image.asset('images/myo_taw_splash_screen.jpg', width: 250.0, height: 250.0,),
              Padding(padding: EdgeInsets.only(bottom: 5.0),
                  child: Text('Myo Taw', style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorPrimary),)),
              Text("Version 1.0", style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextGrey),)
            ],
          ),
        ),
      )
    );
  }
}
