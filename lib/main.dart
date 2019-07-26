import 'package:flutter/material.dart';
import 'package:myotaw/helper/myoTawConstant.dart';
import 'SplashScreen.dart';
import 'NewsFeedScreen.dart';
import 'DashBoardScreen.dart';
import 'NotificationScreen.dart';
import 'customIcons/my_flutter_app_icons.dart';

void main() => runApp(MaterialApp(
      home: splashScreen(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: myColor.colorPrimary
        ),
        scaffoldBackgroundColor: myColor.colorGrey,
      ),
));

class MainScreen extends StatefulWidget {
  @override
  _mainState createState() => _mainState();
}

class _mainState extends State<MainScreen> with TickerProviderStateMixin {
  TabController _tabController;
  bool _isNewsFeed = true;
  bool _isDashBoard = false;
  bool _isNotification = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    _tabController.addListener((){
      if(_tabController.index == 0){
        setState(() {
          _isNewsFeed = true;
          _isDashBoard = false;
          _isNotification = false;
        });
      }else if(_tabController.index == 1){
        setState(() {
          _isNewsFeed = false;
          _isDashBoard = true;
          _isNotification = false;
        });
      }else{
        setState(() {
          _isNewsFeed = false;
          _isDashBoard = false;
          _isNotification = true;
        });
      }
    });
    return SafeArea(
      top: false,
      bottom: true,
      left: false,
      right: false,
      child: Scaffold(
        body: TabBarView(
          children: [
            newsFeedScreen(),
            dashBoardScreen(),
            notificationScreen(),
          ],
          controller: _tabController,
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: TabBar(
            indicatorColor: Colors.white,
            labelColor: myColor.colorPrimary,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2.0,
            unselectedLabelColor: myColor.colorGreyDark,
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(MyFlutterApp.newsfeed, size: 20.0,)),
              Tab(icon: Image.asset("images/dashboard.png",width: 20.0, height: 20.0,color: _isDashBoard? myColor.colorPrimary:myColor.colorGreyDark,)),
              Tab(icon: Image.asset("images/notification.png",width: 20.0, height: 20.0,color: _isNotification? myColor.colorPrimary:myColor.colorGreyDark,))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }
}

