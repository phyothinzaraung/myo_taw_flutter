import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'SplashScreen.dart';
import 'NewsFeedScreen.dart';
import 'DashBoardScreen.dart';
import 'NotificationScreen.dart';
import 'customIcons/my_flutter_app_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'model/UserModel.dart';
import 'ProfileFormScreen.dart';

void main() {
  /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: MyColor.colorPrimaryDark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));*/
  try {
    FlutterStatusbarcolor.setStatusBarColor(MyColor.colorPrimaryDark);
  }  catch (e) {
    print(e);
  }
  runApp(MaterialApp(
    home: SplashScreen(),
    theme: ThemeData(
      appBarTheme: AppBarTheme(
          color: MyColor.colorPrimary,
      ),
      accentColor: MyColor.colorAccent,
      scaffoldBackgroundColor: MyColor.colorGrey,
    ),
  ));
}

class MainScreen extends StatefulWidget {
  UserModel model;
  MainScreen(this.model);

  @override
  _mainState createState() => _mainState(this.model);
}

class _mainState extends State<MainScreen> with TickerProviderStateMixin {
  TabController _tabController;
  UserModel _userModel;
  _mainState(this._userModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    _requestPermission();
    Future.delayed(Duration(seconds: 1)).whenComplete((){
      if(_userModel.name == null){
        _dialogProfileSetup();
      }
    });
  }

  _navigateToProfileFormScreen()async{
    Map result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileFormScreen()));
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
                  RaisedButton(onPressed: (){
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      left: false,
      right: false,
      child: Scaffold(
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
                Tab(icon: Icon(MyFlutterApp.newsfeed, size: 20.0,)),
                Tab(icon: Icon(Icons.dashboard)),
                Tab(icon: Icon(Icons.notifications))
              ],
            ),
          ),
        ),
      ),
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

