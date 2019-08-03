import 'package:flutter/material.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'SplashScreen.dart';
import 'NewsFeedScreen.dart';
import 'DashBoardScreen.dart';
import 'NotificationScreen.dart';
import 'customIcons/my_flutter_app_icons.dart';
import 'model/UserModel.dart';

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
  UserModel model;
  MainScreen(this.model);

  @override
  _mainState createState() => _mainState(this.model);
}

class _mainState extends State<MainScreen> with TickerProviderStateMixin {
  TabController _tabController;
  UserModel userModel;
  _mainState(this.userModel);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
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
            NewsFeedScreen(userModel),
            DashBoardScreen(),
            NotificationScreen(),
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
              Tab(icon: Icon(Icons.dashboard)),
              Tab(icon: Icon(Icons.notifications))
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

