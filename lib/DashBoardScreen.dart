import 'package:flutter/material.dart';
import 'package:myotaw/FloodReportListScreen.dart';
import 'package:myotaw/WardAdminContributionScreen.dart';
import 'package:myotaw/helper/MyoTawCitySetUpHelper.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/myWidget/PrimaryColorSnackBarWidget.dart';
import 'helper/FireBaseAnalyticsHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'model/UserModel.dart';
import 'package:myotaw/ProfileScreen.dart';
import 'SaveNewsFeedScreen.dart';
import 'FaqScreen.dart';
import 'model/DashBoardModel.dart';
import 'DaoScreen.dart';
import 'helper/SharePreferencesHelper.dart';
import 'Database/UserDb.dart';
import 'ContributionScreen.dart';
import 'BizLicenseScreen.dart';
import 'TaxUseScreen.dart';
import 'ReferralScreen.dart';
import 'CalculateTaxScreen.dart';
import 'OnlineTaxChooseScreen.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> with AutomaticKeepAliveClientMixin {
  UserModel _userModel;
  String _city, _regionCode;
  List _widget = new List();
  List<DashBoardModel> _dashBoardModelList = new List<DashBoardModel>();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserDb _userDb = UserDb();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
    FireBaseAnalyticsHelper.trackCurrentScreen(ScreenName.DASHBOARD_SCREEN);
  }

  _getUser()async{
    await _sharepreferenceshelper.initSharePref();
    if(mounted){
      await _userDb.openUserDb();
      setState(() {
        _regionCode = _sharepreferenceshelper.getRegionCode();
      });
      var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
      _userDb.closeUserDb();
      setState(() {
        _userModel = model;
      });
    }
    _city = MyoTawCitySetUpHelper.getCity(_regionCode);
    _initDashBoardWidget();

    /*if(Platform.isIOS){
      _widget.removeLast();
    }*/
  }

  _initDashBoardWidget(){
    DashBoardModel model1 = new DashBoardModel();
    model1.image = 'images/dao.png';
    model1.title = MyString.txt_municipal;

    DashBoardModel model2 = new DashBoardModel();
    model2.image = 'images/about_tax.png';
    model2.title = MyString.txt_tax;

    DashBoardModel model3 = new DashBoardModel();
    model3.image = 'images/suggestion.png';
    model3.title = MyString.txt_suggestion;

    DashBoardModel model4 = new DashBoardModel();
    model4.image = 'images/business_license.png';
    model4.title = MyString.txt_business_tax;

    DashBoardModel model5 = new DashBoardModel();
    model5.image = 'images/online_tax.png';
    model5.title = MyString.txt_online_tax;

    DashBoardModel model6 = new DashBoardModel();
    model6.image = 'images/tax_used.png';
    model6.title = MyString.txt_tax_use;

    DashBoardModel model7 = new DashBoardModel();
    model7.image = 'images/calculate_tax.png';
    model7.title = MyString.txt_calculate_tax;

    DashBoardModel model8 = new DashBoardModel();
    model8.image = 'images/questions.png';
    model8.title = MyString.txt_faq;

    DashBoardModel model9 = new DashBoardModel();
    model9.image = 'images/save_file.png';
    model9.title = MyString.txt_save_newsFeed;

    DashBoardModel model10 = new DashBoardModel();
    model10.image = 'images/profile_placeholder.png';
    model10.title = MyString.txt_profile;

    DashBoardModel model11 = new DashBoardModel();
    model11.image = 'images/referral.png';
    model11.title = MyString.txt_referral;

    DashBoardModel model12 = new DashBoardModel();
    model12.image = 'images/flood_report.png';
    model12.title = MyString.txt_flood_level;

    _dashBoardModelList = [model1,model2,model3, model12, model4,model5,model6,model7,model8,model9,model10];

    for(var i in _dashBoardModelList){
        _widget.add(GestureDetector(
        onTap: (){
          switch(i.title){
            case MyString.txt_municipal:

              NavigatorHelper.myNavigatorPush(context, DaoScreen(''), ScreenName.ABOUT_DAO_SCREEN);
              break;
            case MyString.txt_tax:

              NavigatorHelper.myNavigatorPush(context, DaoScreen('Tax'), ScreenName.ABOUT_TAX_SCREEN);
              break;
            case MyString.txt_suggestion:
              NavigatorHelper.myNavigatorPush(context, _sharepreferenceshelper.isWardAdmin()?WardAdminContributionScreen():
              ContributionScreen(), _sharepreferenceshelper.isWardAdmin()?ScreenName.WARD_ADMIN_CONTRIBUTION_SCREEN : ScreenName.CONTRIBUTION_SCREEN);
              break;
            case MyString.txt_business_tax:

              NavigatorHelper.myNavigatorPush(context, BizLicenseScreen(), ScreenName.BIZ_LICENSE_SCREEN);
              break;
            case MyString.txt_online_tax:
              _regionCode == MyString.TGY_REGION_CODE?

              NavigatorHelper.myNavigatorPush(context, OnlineTaxChooseScreen(), ScreenName.ONLINE_TAX_CHOOSE_SCREEN)
              :
              PrimaryColorSnackBarWidget(_globalKey, MyString.txt_coming_soon);
              break;
            case MyString.txt_tax_use:

              NavigatorHelper.myNavigatorPush(context, TaxUserScreen(), ScreenName.TAX_USE_SCREEN);
              break;
            case MyString.txt_calculate_tax:
              NavigatorHelper.myNavigatorPush(context, CalculateTaxScreen(), ScreenName.CALCULATE_TAX_SCREEN);
              break;
            case MyString.txt_faq:

              NavigatorHelper.myNavigatorPush(context, FaqScreen(), ScreenName.FAQ_SCREEN);
              break;
            case MyString.txt_save_newsFeed:

              NavigatorHelper.myNavigatorPush(context, SaveNewsFeedScreen(), ScreenName.SAVED_NEWS_FEED_SCREEN);
              break;
            case MyString.txt_profile:

              NavigatorHelper.myNavigatorPush(context, ProfileScreen(), ScreenName.PROFILE_SCREEN);
              break;
            case MyString.txt_referral:
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReferralScreen(_userModel),));
              break;
            case MyString.txt_flood_level:

              NavigatorHelper.myNavigatorPush(context, FloodReportListScreen(), ScreenName.FLOOD_REPORT_LIST_SCREEN);
              break;
            default:
          }
        },
        child: Container(
          child: Column(children: <Widget>[
            Flexible(flex: 3,child: Image.asset(i.image,)),
            SizedBox(height: 5,),
            Flexible(flex: 1,child: Text(i.title,style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),))],),),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _globalKey,
      body: SafeArea(
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  margin: EdgeInsets.only(top: 24.0, bottom: 20.0, left: 15.0, right: 15.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_city??'', style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeLarge)),
                                Text(MyString.txt_title_dashboard, style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeExtraNormal),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ])),
              SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index){
                    return _widget[index];
                  },childCount: _widget.length),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      crossAxisSpacing: 30.0,
                      mainAxisSpacing: 10))
            ],
          )
        ),
      )
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_userDb.isUserDbOpen()){
      _userDb.closeUserDb();
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
