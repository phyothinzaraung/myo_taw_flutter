import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter/services.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'helper/SharePreferencesHelper.dart';
import 'LoginScreen.dart';
import 'helper/UserDb.dart';
import 'model/UserModel.dart';

class splashScreen extends StatefulWidget {
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  UserDb _userDb = UserDb.instance;
  UserModel _userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateMainScreen();
  }

  navigateMainScreen() async{
    await _sharepreferenceshelper.initSharePref();
    await getUserData();
    if(_sharepreferenceshelper.getUserPhoneNo()!=null){
      Future.delayed(Duration(seconds: 2), (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
            MainScreen(_userModel)));
      });
    }else{
      Future.delayed(Duration(seconds: 2), (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
            LoginScreen()));
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
      statusBarColor: myColor.colorPrimaryDark,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/myo_taw_splash_screen.jpg", scale: 7,),
            Padding(padding: EdgeInsets.only(bottom: 5.0),
                child: Text('Myo Taw', style: TextStyle(fontSize: fontSize.textSizeNormal, color: myColor.colorPrimary),)),
            Text("Version 1.0", style: TextStyle(fontSize: fontSize.textSizeSmall, color: myColor.colorTextGrey),)
          ],
        ),
      )
    );
  }
}
