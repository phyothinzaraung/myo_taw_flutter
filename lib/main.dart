import 'package:flutter/material.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'SplashScreen.dart';
import 'NewsFeedScreen.dart';
import 'DashBoardScreen.dart';
import 'NotificationScreen.dart';
import 'customIcons/my_flutter_app_icons.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MaterialApp(
      home: SplashScreen(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: MyColor.colorPrimary
        ),
        scaffoldBackgroundColor: MyColor.colorGrey,
      ),
));

class MainScreen extends StatefulWidget {

  @override
  _mainState createState() => _mainState();
}

class _mainState extends State<MainScreen> with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    _requestPermission();
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
              onTap: (index){
                if(index == 0){

                }
              },
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

