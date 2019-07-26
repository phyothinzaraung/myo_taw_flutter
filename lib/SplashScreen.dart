import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter/services.dart';
import 'package:myotaw/helper/myoTawConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splashScreen extends StatefulWidget {
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateMainScreen();
    initSharePref();
  }

  navigateMainScreen() async{
    Future.delayed(Duration(seconds: 2), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
      MainScreen()));
    });
  }

  initSharePref()async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: myColor.colorPrimaryDark,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/myo_taw_splash_screen.jpg", scale: 7,),
            Padding(padding: EdgeInsets.only(bottom: 5.0),
                child: Text('Myo Taw', style: TextStyle(fontSize: fontSize.textSizeLarge, color: myColor.colorPrimary),)),
            Text("Version 1.0", style: TextStyle(fontSize: fontSize.textSizeNormal, color: myColor.colorTextGrey),)
          ],
        ),
      )
    );
  }
}
