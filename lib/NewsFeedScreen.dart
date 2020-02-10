import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';
import 'package:html/parser.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/model/NewsFeedReactModel.dart';
import 'package:myotaw/myWidget/PrimaryColorSnackBarWidget.dart';
import 'helper/ServiceHelper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'NewsFeedDetailScreen.dart';
import 'helper/MyLoadMore.dart';
import 'package:connectivity/connectivity.dart';
import 'helper/SharePreferencesHelper.dart';
import 'model/UserModel.dart';
import 'helper/MyoTawConstant.dart';
import 'Database/SaveNewsFeedDb.dart';
import 'model/SaveNewsFeedModel.dart';
import 'ProfileScreen.dart';
import 'Database/UserDb.dart';
import 'myWidget/EmptyViewWidget.dart';
import 'myWidget/NoConnectionWidget.dart';
import 'model/NewsFeedModel.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> with AutomaticKeepAliveClientMixin<NewsFeedScreen> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  var response;
  List<NewsFeedReactModel> _newsFeedReactModelList = new List<NewsFeedReactModel>();
  ScrollController _scrollController = new ScrollController();
  bool _isEnd = false, _isCon= false;
  int page = 1;
  int pageCount = 10;
  UserModel _userModel;
  String _city, _userUniqueKey;
  SaveNewsFeedDb _saveNewsFeedDb = SaveNewsFeedDb();
  int _organizationId;
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  SaveNewsFeedModel _saveNewsFeedModel = SaveNewsFeedModel();
  ImageProvider _profilePhoto;
  UserDb _userDb = UserDb();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  bool _isTop = true;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener((){
      if(_scrollController.offset > 500){
        setState(() {
          _isTop = false;
        });
      }else{
        setState(() {
          _isTop = true;
        });
      }
    });
    FireBaseAnalyticsHelper().TrackCurrentScreen(ScreenName.NEWS_FEED_SCREEN);
  }


  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
  }

  String photoOrThumbNail(String photo, String thumbNail, bool isPhoto){
    String url = '';
    if(isPhoto){
      if(photo != null && photo.isNotEmpty){
        url = BaseUrl.NEWS_FEED_CONTENT_URL+photo;
      }else{
        url = '';
      }
    }else{
      if(thumbNail != null && thumbNail.isNotEmpty){
        url = thumbNail;
      }else{
        url = '';
      }
    }
    return url;
  }

  bool _isPhoto(String type){
    if(type == 'Photo'){
      return true;
    }else{
      return false;
    }
  }

  String _parseHtmlString(String htmlString) {

    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  _saveNewsFeed(NewsFeedModel model)async{
    await _saveNewsFeedDb.openSaveNfDb();
    bool _isNewsfeedSaved = await _saveNewsFeedDb.isNewsFeedSaved(model.uniqueKey);
    if(!_isNewsfeedSaved){
      _saveNewsFeedModel.id = model.uniqueKey;
      _saveNewsFeedModel.title = model.title;
      _saveNewsFeedModel.body = model.body;
      _saveNewsFeedModel.photoUrl = model.photoUrl;
      _saveNewsFeedModel.videoUrl = model.videoUrl;
      _saveNewsFeedModel.thumbNail = model.thumbNail;
      _saveNewsFeedModel.contentType = model.uploadType;
      _saveNewsFeedModel.accessTime = DateTime.now().toString();
      await _saveNewsFeedDb.insert(_saveNewsFeedModel);
      //PrimaryColorSnackBarWidget(_globalKey, MyString.txt_save_newsFeed_success);
    }
    _saveNewsFeedDb.closeSaveNfDb();
  }

  _getUser() async{
    await _sharepreferenceshelper.initSharePref();
    _userUniqueKey = _sharepreferenceshelper.getUserUniqueKey();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    _userDb.closeUserDb();
    if(mounted){
      setState(() {
        _userModel = model;
      });
    }
    _initHeaderTitle();
    await _getNewsFeed(page);
  }

  _getNewsFeed(int p) async{
    response = await ServiceHelper().getNewsFeed(_organizationId,p,pageCount,_userUniqueKey);
    var result = response.data['Results'];
    //var result = [];
    print('loadmore: ${p}');
    if(result != null && result.length > 0){
      for(var i in result){
        NewsFeedReactModel _newsFeedReactModel = NewsFeedReactModel.fromJson(i);
        await _saveNewsFeedDb.openSaveNfDb();
        bool isSaved = await _saveNewsFeedDb.isNewsFeedSaved(_newsFeedReactModel.newsFeedModel.uniqueKey);
        _saveNewsFeedDb.closeSaveNfDb();
        _newsFeedReactModel.newsFeedModel.isSaved = isSaved;
        _newsFeedReactModelList.add(_newsFeedReactModel);
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
    print('isEnd: ${_isEnd}');
  }

  Future<bool> _loadMore() async {
    await _checkCon();
    if(_isCon){
      page++;
      await _getNewsFeed(page);
    }
    return _isCon;
  }

  Future<Null> _handleRefresh() async {
    await _checkCon();
    setState(() {
      page = 0;
      page ++;
      _newsFeedReactModelList.clear();
    });
    asyncLoaderState.currentState.reloadState();
    return null;
  }


  _initHeaderTitle(){
    _profilePhoto = _userModel.photoUrl!=null?
    new CachedNetworkImageProvider(BaseUrl.USER_PHOTO_URL+_userModel.photoUrl) :
    AssetImage('images/profile_placeholder.png');
    switch(_userModel.currentRegionCode){
      case MyString.TGY_REGIONCODE:
        _city = _userModel.isWardAdmin==1? MyString.TGY_CITY +' '+'(Ward admin)':MyString.TGY_CITY;
        _organizationId = OrganizationId.TGY_ORGANIZATION_ID;
        break;
      case MyString.MLM_REGIONCODE:
        _city = _userModel.isWardAdmin==1? MyString.MLM_CITY +' '+'(Ward admin)': MyString.MLM_CITY;
        _organizationId = OrganizationId.MLM_ORGANIZATION_ID;
        break;
      case MyString.LKW_REGIONCODE:
        _city = _userModel.isWardAdmin==1? MyString.LKW_CITY +' '+'(Ward admin)': MyString.LKW_CITY;
        _organizationId = OrganizationId.LKW_ORGANIZATION_ID;
        break;
      default:
    }
  }


  Widget _newsFeedListWidget(int i){
    NewsFeedModel newsFeedModel = _newsFeedReactModelList[i].newsFeedModel;
    String newsFeedPhoto = newsFeedModel.photoUrl;
    String newsFeedThumbNail = newsFeedModel.thumbNail;
    String title = newsFeedModel.title;
    String body = newsFeedModel.body;
    String date = ShowDateTimeHelper().showDateTimeDifference(newsFeedModel.accesstime);
    bool isPhoto = _isPhoto(newsFeedModel.uploadType);
    return Card(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Container(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                /*Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewsFeedDetailScreen(newsFeedModel, _newsFeedReactModelList[i].photoList),
                  settings: RouteSettings(name: ScreenName.NEWS_FEED_DETAIL_SCREEN)
                ));*/
                NavigatorHelper().MyNavigatorPush(context, NewsFeedDetailScreen(newsFeedModel, _newsFeedReactModelList[i].photoList), ScreenName.NEWS_FEED_DETAIL_SCREEN);
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
                          Text(date, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextGrey),)
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //title
                          Expanded(child: Text(title!=null?title:'---',
                            style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorTextBlack), maxLines: 1, overflow: TextOverflow.ellipsis,))
                        ],),
                    ),
                    Container(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: <Widget>[
                          //newsfeed image
                          CachedNetworkImage(
                            imageUrl: photoOrThumbNail(newsFeedPhoto, newsFeedThumbNail, isPhoto),
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
                            errorWidget: (context, url, error)=> Image.asset('images/placeholder_newsfeed.jpg', width: double.maxFinite,
                              height: 180, fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      //newsfeed body
                      child: Text(_parseHtmlString(body), maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10, left: 10),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: MyColor.colorPrimary
                  ),
                  //like count
                  child: Text('${newsFeedModel.likeCount} ${newsFeedModel.likeCount > 1? 'Likes':'Like'}',
                    style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeSmall),),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
              child: Row(
                children: <Widget>[
                  //like button
                  GestureDetector(
                    onTap: (){
                      //print('like: ${isLike}');
                      setState(() {
                        if(_newsFeedReactModelList[i].reactType == null){
                          newsFeedModel.likeCount++;
                          _newsFeedReactModelList[i].reactType = 'like';
                        }else{
                          _newsFeedReactModelList[i].reactType = null;
                          if(newsFeedModel.likeCount >= 0){
                            newsFeedModel.likeCount--;
                          }
                        }
                        FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.NEWS_FEED_SCREEN, ClickEvent.NEWS_FEED_LIKE_CLICK_EVENT, _userUniqueKey);
                        _callLikeWebService(newsFeedModel.uniqueKey);
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Container(margin: EdgeInsets.only(right: 5.0),
                            child: Image.asset(_newsFeedReactModelList[i].reactType!=null?'images/like_fill.png':'images/like.png',
                              width: 20.0,height: 20.0,)),
                        Text('${MyString.txt_like}',
                          style: TextStyle(color: MyColor.colorPrimary, fontSize: FontSize.textSizeSmall),)
                      ],
                    ),
                  ),
                  //save newsfeed button
                  Expanded(child: GestureDetector(onTap: (){
                    FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.NEWS_FEED_SCREEN, ClickEvent.NEWS_FEED_SAVE_CLICK_EVENT, _userUniqueKey);
                    _saveNewsFeed(newsFeedModel);
                    if(!newsFeedModel.isSaved){
                      setState(() {
                        newsFeedModel.isSaved = true;
                      });
                    }
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 5),
                            child: Image.asset(newsFeedModel.isSaved? 'images/done.png' : 'images/save.png', width: 20.0,height: 20.0,)),
                        Text(newsFeedModel.isSaved?MyString.txt_saved_news_feed : MyString.txt_save,
                          style: TextStyle(color: MyColor.colorPrimary, fontSize: FontSize.textSizeSmall),)
                      ],),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _callLikeWebService(String newsFeedId)async{
    response = await ServiceHelper().likeReact(_userUniqueKey, newsFeedId, 'like');
    print('responseLike: ${response}');
  }

  Widget _headerNewsFeed(){
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _userModel!=null?_userModel.isWardAdmin==1?GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Icon(Platform.isAndroid?Icons.arrow_back: CupertinoIcons.back,),
                    ),
                  ) : Container() : Container(),
                  Text(_city!=null?_city:'', style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeLarge)),
                  Text(MyString.txt_newsfeed, style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeExtraNormal),),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                NavigatorHelper().MyNavigatorPush(context, ProfileScreen(), ScreenName.PROFILE_SCREEN);

              },
              child: Hero(
                tag: 'profile',
                child: CircleAvatar(backgroundImage: _profilePhoto,
                  backgroundColor: MyColor.colorGrey, radius: 30.0,),
              ),
            )
          ],
        ),
      ],
    );
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
                    _userModel!=null?_userModel.isWardAdmin==1?GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Icon(Platform.isAndroid?Icons.arrow_back: CupertinoIcons.back,),
                      ),
                    ) : Container() : Container(),
                    Text(_city!=null?_city:'', style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeLarge)),
                    Text(MyString.txt_newsfeed, style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeExtraNormal),),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: CircleAvatar(backgroundImage:_profilePhoto,
                  backgroundColor: MyColor.colorGrey, radius: 25.0,),
              )
            ],
          ),
          Expanded(child: emptyView(asyncLoaderState,MyString.txt_no_newsFeed_data))
        ],
      ),
    );
  }

  Widget _listView(){
    return ListView.builder(
        itemCount: _newsFeedReactModelList.length,
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int i){
          return Column(
            children: <Widget>[
              i==0?Container(
                margin: EdgeInsets.only(top: 24.0, bottom: 20.0, left: 15.0, right: 15.0),
                child: Column(
                  children: <Widget>[
                    _headerNewsFeed(),
                  ],
                ),
              ):Container(width: 0.0,height: 0.0,),
              _newsFeedListWidget(i)
            ],
          );
        }
    );
  }

  Widget _noConWidget(){
    return Container(
      margin: EdgeInsets.only(top: 24.0, bottom: 20.0, left: 15.0, right: 15.0),
      child: Column(
        children: <Widget>[
          _headerNewsFeed(),
          Expanded(child: noConnectionWidget(asyncLoaderState))
        ],
      ),
    );
  }

  Widget _renderLoad(){
    return Container(
      margin: EdgeInsets.only(top: 24.0, bottom: 20.0, left: 15.0, right: 15.0),
      child: Column(
        children: <Widget>[
          _headerNewsFeed(),
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }

  Widget _floatActionButton(){
    if(!_isTop){
      return FloatingActionButton(
        onPressed: (){
          FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.NEWS_FEED_SCREEN, ClickEvent.GO_TO_TOP_CLICK_EVENT, _userUniqueKey);
          _topToScreen();
        },
        child: Icon(Icons.arrow_upward, color: Colors.white, size: 20,),
        mini: true,
      );
    }else{
      return null;
    }
  }

  void _topToScreen(){
    _scrollController.animateTo(0, duration: Duration(milliseconds: 700), curve: Curves.easeIn);
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    var _asyncLoader = new AsyncLoader(
      key: asyncLoaderState,
      initState: () async => await _getUser(),
      renderLoad: () => _renderLoad(),
      renderError: ([error]) => _noConWidget(),
      renderSuccess: ({data}) => Container(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: _newsFeedReactModelList.isNotEmpty?
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
      body: _asyncLoader,
      floatingActionButton: _floatActionButton()
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    if(_userDb.isUserDbOpen()){
      _userDb.closeUserDb();
    }
  }
}
