import 'package:flutter/material.dart';
import 'package:myotaw/myWidget/PrimaryColorSnackBarWidget.dart';
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

class _DashBoardScreenState extends State<DashBoardScreen> {
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
  }

  _getUser()async{
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    if(mounted){
      setState(() {
        _regionCode = _sharepreferenceshelper.getRegionCode();
      });
    }
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    await _userDb.closeUserDb();
    if(mounted){
      setState(() {
        _userModel = model;
      });
    }
    _initHeaderTitle();
    _initDashBoardWidget();
    /*if(Platform.isIOS){
      _widget.removeLast();
    }*/
  }

  _initHeaderTitle(){
    switch(_userModel.currentRegionCode){
      case MyString.TGY_REGIONCODE:
        _city = MyString.TGY_CITY;
        break;
      case MyString.MLM_REGIONCODE:
        _city = MyString.MLM_CITY;
        break;
      case MyString.MDY_REGIONCODE:
        _city = MyString.MDY_CITY;
        break;
    }
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

    _dashBoardModelList = [model1,model2,model3,model4,model5,model6,model7,model8,model9,model10];

    for(var i in _dashBoardModelList){
        _widget.add(GestureDetector(
        onTap: (){
          switch(i.title){
            case MyString.txt_municipal:
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DaoScreen('')));
              break;
            case MyString.txt_tax:
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DaoScreen('Tax')));
              break;
            case MyString.txt_suggestion:
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContributionScreen()));
              break;
            case MyString.txt_business_tax:
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BizLicenseScreen()));
              break;
            case MyString.txt_online_tax:
              _regionCode == MyString.TGY_REGIONCODE?
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => OnlineTaxChooseScreen())) :
              PrimaryColorSnackBarWidget(_globalKey, MyString.txt_coming_soon);
              break;
            case MyString.txt_tax_use:
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaxUserScreen()));
              break;
            case MyString.txt_calculate_tax:
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CalculateTaxScreen()));
              break;
            case MyString.txt_faq:
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FaqScreen()));
              break;
            case MyString.txt_save_newsFeed:
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SaveNewsFeedScreen()));
              break;
            case MyString.txt_profile:
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(_userModel.isWardAdmin==1?true:false)));
              break;
            case MyString.txt_referral:
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReferralScreen(_userModel)));
              break;
            default:
          }
        },
        child: Container(
          child: Column(children: <Widget>[
            Flexible(flex: 3,child: Image.asset(i.image,)),
            Flexible(flex: 1,child: Text(i.title,style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),))],),),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                Text(_city!=null?_city:'', style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeLarge)),
                                Text('သတင်းများ', style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeExtraNormal),),
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
                      crossAxisSpacing: 50.0,
                      mainAxisSpacing: 10))
            ],
          )
        ),
      )
    );
  }
}
