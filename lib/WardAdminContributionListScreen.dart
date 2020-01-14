import 'package:async_loader/async_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/database/UserDb.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/model/UserModel.dart';

import 'ProfileScreen.dart';
import 'helper/MyoTawConstant.dart';
import 'myWidget/NoConnectionWidget.dart';

class WardAdminContributionListScreen extends StatefulWidget {
  @override
  _WardAdminContributionListScreenState createState() => _WardAdminContributionListScreenState();
}

class _WardAdminContributionListScreenState extends State<WardAdminContributionListScreen> {
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  String _userUniqueKey,_city;
  UserDb _userDb = new UserDb();
  UserModel _userModel;
  ImageProvider _profilePhoto;
  int _organizationId;
  bool _isCon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
  }

  _getUser() async{
    await _sharepreferenceshelper.initSharePref();
    _userUniqueKey = _sharepreferenceshelper.getUserUniqueKey();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    await _userDb.closeUserDb();
    if(mounted){
      setState(() {
        _userModel = model;
      });
    }
    _initHeaderTitle();
  }

  Widget _renderLoad(){
    return Container(
      margin: EdgeInsets.only(top: 24.0, bottom: 20.0, left: 15.0, right: 15.0),
      child: Column(
        children: <Widget>[
          _headerContribution(),
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
  Widget _headerContribution(){
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_city!=null?_city:'', style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeLarge)),
                  Text(MyString.txt_contributions, style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeExtraNormal),),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(_sharepreferenceshelper.isWardAdmin())));

              },
              child: CircleAvatar(backgroundImage: _userModel!=null?
              _profilePhoto:AssetImage('images/profile_placeholder.png'),
                backgroundColor: MyColor.colorGrey, radius: 25.0,),
            )
          ],
        ),
      ],
    );
  }

  _initHeaderTitle(){
    _profilePhoto = new CachedNetworkImageProvider(BaseUrl.USER_PHOTO_URL+_userModel.photoUrl);
    switch(_userModel.currentRegionCode){
      case MyString.TGY_REGIONCODE:
        _city = _userModel.isWardAdmin==1? MyString.TGY_CITY +' '+'(Ward admin)':MyString.TGY_CITY;
        _organizationId = OrganizationId.TGY_ORGANIZATION_ID;
        break;
      case MyString.MLM_REGIONCODE:
        _city = _userModel.isWardAdmin==1? MyString.MLM_CITY +' '+'(Ward admin)': MyString.MLM_CITY;
        _organizationId = OrganizationId.MLM_ORGANIZATION_ID;
        break;
      default:
    }
  }

  Widget _noConWidget(){
    return Container(
      margin: EdgeInsets.only(top: 24.0, bottom: 20.0, left: 15.0, right: 15.0),
      child: Column(
        children: <Widget>[
          _headerContribution(),
          Expanded(child: noConnectionWidget(asyncLoaderState))
        ],
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    await _checkCon();
    /*setState(() {
      page = 0;
      page ++;
      _newsFeedReactModel.clear();
    });*/
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await _getUser(),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => _noConWidget(),
        renderSuccess: ({data}) => Container(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 24.0, bottom: 20.0, left: 15.0, right: 15.0),
                    child: _headerContribution())
              ],
            )
          ),
        )
    );
    return Scaffold(
      key: _globalKey,
      body: SafeArea(child: _asyncLoader),
    );
  }
}
