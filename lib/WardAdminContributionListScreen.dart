import 'package:async_loader/async_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/WardAdminContributionDetailScreen.dart';
import 'package:myotaw/database/UserDb.dart';
import 'package:myotaw/helper/ServiceHelper.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/model/ContributionModel.dart';
import 'package:myotaw/model/UserModel.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ProfileScreen.dart';
import 'helper/MyLoadMore.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/ShowDateTimeHelper.dart';
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
    _requestPermission();
  }

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
  }

  _requestPermission()async{
    await PermissionHandler().requestPermissions([PermissionGroup.camera, PermissionGroup.storage,PermissionGroup.photos, PermissionGroup.location]);
  }

  _getUser() async{
    await _sharepreferenceshelper.initSharePref();
    print(_sharepreferenceshelper.getUserUniqueKey());
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    await _userDb.closeUserDb();
    if(mounted){
      setState(() {
        _userModel = model;
      });
    }
    _initHeaderTitle();
    await _getContributionList(page);
  }

  _getContributionList(int p)async{
    var response = await ServiceHelper().getContributionList(_sharepreferenceshelper.getRegionCode(), p, pageCount, _sharepreferenceshelper.getUserUniqueKey());
    var result = response.data['Results'];
    print(p);
    if(result.length > 0){
      for(var i in result){
        _contributionModelList.add(ContributionModel.fromJson(i));
      }
      setState(() {
        _isEnd = false;
      });
    }else{
      setState(() {
        _isEnd = true;
      });
    }
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));

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
  }

  Widget _listView(){
    return ListView.builder(
        itemCount: _contributionModelList.length,
        itemBuilder: (context, index){
          return Column(
            children: <Widget>[
              index==0?Container(
                margin: EdgeInsets.only(top: 24.0, bottom: 20.0, left: 15.0, right: 15.0),
                child: Column(
                  children: <Widget>[
                    _headerContribution(),
                  ],
                ),
              ):Container(width: 0.0,height: 0.0,),
              _contributionListWidget(index)
            ],
          );
    });
  }

  Widget _contributionListWidget(int i){
    return Card(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Container(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => WardAdminContributionDetailScreen(_contributionModelList[i])));
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
                          Expanded(child: Text(showDateTimeDifference(_contributionModelList[i].accesstime), style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextGrey),)),
                          Image.asset('images/suggestion_no_circle.png', width: 25, height: 25,)
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //title
                          Expanded(child: Text(_contributionModelList[i].subject!=null?_contributionModelList[i].subject:'---',
                            style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorTextBlack), maxLines: 1, overflow: TextOverflow.ellipsis,))
                        ],),
                    ),
                    Container(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: <Widget>[
                          //contribute image
                          Hero(
                            tag: _contributionModelList[i].photoUrl,
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
                                child: Center(child: new CircularProgressIndicator(strokeWidth: 2.0,)), width: double.maxFinite, height: 150.0,)),
                              errorWidget: (context, url, error)=> Image.asset('images/placeholder_newsfeed.jpg'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      //contribute body
                      child: Text(_contributionModelList[i].message, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
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
    switch(_userModel.currentRegionCode){
      case MyString.TGY_REGIONCODE:
        _city = _userModel.isWardAdmin==1? MyString.TGY_CITY +' '+'(Ward admin)':MyString.TGY_CITY;
        break;
      case MyString.MLM_REGIONCODE:
        _city = _userModel.isWardAdmin==1? MyString.MLM_CITY +' '+'(Ward admin)': MyString.MLM_CITY;
        break;
      case MyString.MDY_REGIONCODE:
        _city = _userModel.isWardAdmin==1? MyString.MDY_CITY +' '+'(Ward admin)': MyString.MDY_CITY;
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
      child: Column(
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: CircleAvatar(backgroundImage: _profilePhoto,
                  backgroundColor: MyColor.colorGrey, radius: 25.0,),
              )
            ],
          ),
          Expanded(child: emptyView(asyncLoaderState,MyString.txt_empty_contribution))
        ],
      ),
    );
  }

  _navigateToWardAdminContributionScreen()async{
    Map result = await Navigator.push(context, MaterialPageRoute(builder: (context) => WardAdminContributionScreen()));
    if(result != null && result.containsKey('isNeedRefresh') == true){
      await _handleRefresh();
    }
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
            child: _contributionModelList.isNotEmpty?
            LoadMore(
                isFinish: _isEnd,
                onLoadMore: _loadMore,
                delegate: DefaultLoadMoreDelegate(),
                textBuilder: DefaultLoadMoreTextBuilder.english,
                child: _listView()
            ) : _emptyView(),
          ),
        )
    );
    return Scaffold(
      key: _globalKey,
      body: SafeArea(child: _asyncLoader),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            _navigateToWardAdminContributionScreen();
          }, label: Text(MyString.txt_to_contribute, style: TextStyle(color: Colors.white),),
        icon: Icon(Icons.create, color: Colors.white,), backgroundColor: MyColor.colorPrimary,),
    );
  }
}
