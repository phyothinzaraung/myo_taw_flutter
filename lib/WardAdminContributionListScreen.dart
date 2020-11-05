import 'dart:io';

import 'package:async_loader/async_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/WardAdminContributionDetailScreen.dart';
import 'package:myotaw/database/UserDb.dart';
import 'package:myotaw/helper/MyoTawCitySetUpHelper.dart';
import 'package:myotaw/helper/ServiceHelper.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/model/ContributionModel.dart';
import 'package:myotaw/model/UserModel.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/myWidget/NativeProgressIndicator.dart';
import 'package:myotaw/myWidget/NativePullRefresh.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ProfileScreen.dart';
import 'helper/MyLoadMore.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/PlatformHelper.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'myWidget/CustomScaffoldWidget.dart';
import 'myWidget/EmptyViewWidget.dart';
import 'myWidget/NoConnectionWidget.dart';
import 'WardAdminContributionScreen.dart';

class WardAdminContributionListScreen extends StatefulWidget {
  @override
  _WardAdminContributionListScreenState createState() => _WardAdminContributionListScreenState();
}

class _WardAdminContributionListScreenState extends State<WardAdminContributionListScreen> {
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  String _city;
  UserDb _userDb = new UserDb();
  UserModel _userModel;
  ImageProvider _profilePhoto;
  bool _isCon, _isEnd;
  List<ContributionModel> _contributionModelList = new List();
  int page = 1;
  int pageCount = 10;

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
    print(_sharepreferenceshelper.getUserUniqueKey());
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    _userDb.closeUserDb();
    if(mounted){
      setState(() {
        _userModel = model;
      });
    }
    _initHeaderTitle();
    await _getContributionList(page);
  }

  _getContributionList(int p)async{
    await _sharepreferenceshelper.initSharePref();
    var response = await ServiceHelper().getContributionList(_sharepreferenceshelper.getRegionCode(), p, pageCount, _sharepreferenceshelper.getUserUniqueKey());
    var result = response.data['Results'];
    print(p);
    if(result.length > 0){
      for(var i in result){
        _contributionModelList.add(ContributionModel.fromJson(i));
      }
      if(mounted){
        setState(() {
          _isEnd = false;
        });
      }
    }else{
      if(mounted){
        setState(() {
          _isEnd = true;
        });
      }
    }
  }

  Widget _renderLoad(){
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[NativeProgressIndicator()],)
        ],
      ),
    );
  }

  /*Widget _headerContribution(){
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Icon(PlatformHelper.isAndroid()?Icons.arrow_back: CupertinoIcons.back, color: Colors.black,size: 30,),
                    ),
                  ),
                  Text(_city!=null?_city:'', style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeLarge)),
                  Text(MyString.txt_contributions, style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeExtraNormal),),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                NavigatorHelper.myNavigatorPush(context, ProfileScreen(), ScreenName.PROFILE_SCREEN);

              },
              child: Hero(
                tag: 'profile',
                child: CircleAvatar(backgroundImage: _profilePhoto,
                  backgroundColor: MyColor.colorGrey, radius: 25.0,),
              ),
            )
          ],
        ),
      ],
    );
  }*/

  Widget _listView(){
    return ListView.builder(
        padding: EdgeInsets.only(top: 20),
        itemCount: _contributionModelList.length,
        itemBuilder: (context, index){
          return _contributionListWidget(index);
    });
  }

  String _contributionIconType(String type){
    String icon = '';
    switch(type){
      case MyString.FIX_ROAD_CONTRIBUTE:
        icon = MyString.FIX_ROAD_ICON;
          break;
      case MyString.GARBAGE_CONTRIBUTE:
        icon = MyString.GARBAGE_ICON;
        break;
      case MyString.DRAINAGE_CONTRIBUTE:
        icon = MyString.DRAINAGE_ICON;
        break;
      case MyString.FLOOD_CONTRIBUTE:
        icon = MyString.FLOOD_ICON;
        break;
      case MyString.ELECTRIC_CONTRIBUTE:
        icon = MyString.ELECTRIC_ICON;
        break;
      case MyString.ANIMAL_CONTRIBUTE:
        icon = MyString.ANIMAL_ICON;
        break;
      case MyString.WATER_DISTRIBUTION_CONTRIBUTE:
        icon = MyString.WATER_DISTRIBUTION_ICON;
        break;
      case MyString.PUBLIC_PLACE_CONTRIBUTE:
        icon = MyString.PUBLIC_PLACE_ICON;
        break;
      case MyString.TRAFFIC_CONTRIBUTE:
        icon = MyString.TRAFFIC_ICON;
        break;
      case MyString.CRIME_CONTRIBUTE:
        icon = MyString.CRIME_ICON;
        break;
      case MyString.OTHER_CONTRIBUTE:
        icon = MyString.OTHER_ICON;
        break;
      case MyString.ROAD_HOLD_CONTRIBUTE:
        icon = MyString.ROAD_HOLE_ICON;
        break;
      case MyString.COVID_19_CONTRIBUTE:
        icon = MyString.COVID_19_ICON;
        break;
      case MyString.LOCK_DOWN_AREA_CONTRIBUTE:
        icon = MyString.LOCK_DOWN_ICON;
        break;
      default:
        icon = 'suggestion';
        break;
    }
    return icon;
  }

  Widget _contributionListWidget(int i){
    return Card(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Container(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                NavigatorHelper.myNavigatorPush(context,
                    WardAdminContributionDetailScreen(_contributionModelList[i]), ScreenName.CONTRIBUTION_DETAIL_SCREEN);
              },
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        children: <Widget>[
                          //image calendar
                          Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Image.asset("images/calendar.png", width: 15, height: 15,)),
                          //calendar date
                          Expanded(child: Text(ShowDateTimeHelper.showDateTimeDifference(_contributionModelList[i].accesstime), style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextGrey),)),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Image.asset('images/${_contributionIconType(_contributionModelList[i].subject)}.png', width: 30, height: 30,)),
                          //title
                          Text(_contributionModelList[i].subject!=null?_contributionModelList[i].subject:'---',
                            style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack), maxLines: 1, overflow: TextOverflow.ellipsis,)
                        ],),
                    ),
                    Hero(
                      tag: _contributionModelList[i].photoUrl,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(7), bottomRight: Radius.circular(7)),
                        child: CachedNetworkImage(
                          imageUrl: BaseUrl.CONTRIBUTE_PHOTO_URL+_contributionModelList[i].photoUrl,
                          imageBuilder: (context, image){
                            return Container(
                              width: double.maxFinite,
                              height: 180.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: image,
                                    fit: BoxFit.cover),
                              ),);
                          },
                          placeholder: (context, url) => Center(child: Container(
                            child: Center(child: NativeProgressIndicator()), width: double.maxFinite, height: 150.0,)),
                          errorWidget: (context, url, error)=> Image.asset('images/placeholder_newsfeed.jpg'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _initHeaderTitle(){
    _profilePhoto = _userModel.photoUrl!=null?
    new CachedNetworkImageProvider(BaseUrl.USER_PHOTO_URL+_userModel.photoUrl) :
    AssetImage('images/profile_placeholder.png');
    _city = _userModel.isWardAdmin? MyoTawCitySetUpHelper.getCity(_userModel.currentRegionCode) +' '+'(Ward admin)': MyoTawCitySetUpHelper.getCity(_userModel.currentRegionCode);
  }

  Widget _noConWidget(){
    return Container(
      margin: EdgeInsets.only(top: 24.0, bottom: 20.0, left: 15.0, right: 15.0),
      child: noConnectionWidget(asyncLoaderState)
    );
  }

  Future<Null> _handleRefresh() async {
    await _checkCon();
    setState(() {
      page = 0;
      page ++;
      _contributionModelList.clear();
    });
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  Future<bool> _loadMore() async {
    await _checkCon();
    if(_isCon){
      page++;
      await _getContributionList(page);
    }
    return _isCon;
  }

  Widget _emptyView(){
    return Container(
      margin: EdgeInsets.only(top: 24.0, bottom: 20.0, left: 15.0, right: 15.0),
      child: emptyView(asyncLoaderState,MyString.txt_empty_contribution)
    );
  }

  _navigateToWardAdminContributionScreen()async{
    Map result = await NavigatorHelper.myNavigatorPush(context, WardAdminContributionScreen(), ScreenName.WARD_ADMIN_CONTRIBUTION_SCREEN);
    if(result != null && result['isRefresh'] == true){
      await _handleRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await _getContributionList(page),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => _noConWidget(),
        renderSuccess: ({data}) => NativePullRefresh(
          onRefresh: _handleRefresh,
          child: _contributionModelList.isNotEmpty?
          LoadMore(
              isFinish: _isEnd,
              onLoadMore: _loadMore,
              delegate: DefaultLoadMoreDelegate(),
              textBuilder: DefaultLoadMoreTextBuilder.english,
              child: _listView()
          ) : _emptyView(),
        )
    );
    return CustomScaffoldWidget(
        title: Text(MyString.txt_contributions,maxLines: 1, overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal),
        ),
        globalKey: _globalKey,
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            onPressed: (){
              _navigateToWardAdminContributionScreen();
            }, label: Text(MyString.txt_to_contribute, style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.create, color: Colors.white,), backgroundColor: MyColor.colorPrimary,),
        ),
        body: _asyncLoader);
    return Scaffold(
      key: _globalKey,
      body: SafeArea(child: _asyncLoader),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
            onPressed: (){
              _navigateToWardAdminContributionScreen();
            }, label: Text(MyString.txt_to_contribute, style: TextStyle(color: Colors.white),),
          icon: Icon(Icons.create, color: Colors.white,), backgroundColor: MyColor.colorPrimary,),
      ),
    );
  }
}
