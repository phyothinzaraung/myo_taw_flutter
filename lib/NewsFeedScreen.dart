import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'helper/ServiceHelper.dart';
import 'Model/NewsFeedReactModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'Model/NewsFeedModel.dart';
import 'NewsFeedDetailScreen.dart';
import 'helper/MyLoadMore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'helper/SharePreferencesHelper.dart';
import 'model/UserModel.dart';
import 'helper/MyoTawConstant.dart';
import 'Database/SaveNewsFeedDb.dart';
import 'model/SaveNewsFeedModel.dart';
import 'ProfileScreen.dart';
import 'Database/UserDb.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> with AutomaticKeepAliveClientMixin<NewsFeedScreen> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  Response response;
  List<NewsFeedReactModel> _newsFeedReactModel = new List<NewsFeedReactModel>();
  ScrollController _scrollController = new ScrollController();
  bool _isEnd = false, _isCon= false, _isRefresh = false;
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkCon();
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
    _saveNewsFeedModel.id = model.uniqueKey;
    _saveNewsFeedModel.title = model.title;
    _saveNewsFeedModel.body = model.body;
    _saveNewsFeedModel.photoUrl = model.photoUrl;
    _saveNewsFeedModel.videoUrl = model.videoUrl;
    _saveNewsFeedModel.thumbNail = model.thumbNail;
    _saveNewsFeedModel.contentType = model.uploadType;
    _saveNewsFeedModel.accessTime = DateTime.now().toString();
    await _saveNewsFeedDb.insert(_saveNewsFeedModel);
    await _saveNewsFeedDb.closeSaveNfDb();
    Fluttertoast.showToast(msg: 'Save Successful', fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
  }

  _callLikeWebService(String newsFeedId)async{
    response = await ServiceHelper().likeReact(_userUniqueKey, newsFeedId, 'like');
    print('responseLike: ${response}');
  }

  _getUser()async{
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
    await _getNewsFeed(page);
    setState(() {
      _isRefresh = false;
    });
  }

  _getNewsFeed(int p) async{
    response = await ServiceHelper().getNewsFeed(organizationId: 7,page: p,pageSize: pageCount,userUniqueKey: _userUniqueKey);
    List result = response.data['Results'];
    print('loadmore: ${p}');
    if(result != null){
      for(var i in result){
        _newsFeedReactModel.add(NewsFeedReactModel.fromJson(i));
      }
      setState(() {
        result.isNotEmpty?_isEnd = false : _isEnd = true;
      });
    }else{
      setState(() {
        _isEnd = true;
      });
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
      _isRefresh = true;
    });
    if(_isCon){
      _newsFeedReactModel.clear();
      page = 0;
      page++;
      _getUser();
      //await _getNewsFeed(page);
    }else{
      Fluttertoast.showToast(msg: 'Check Connection', backgroundColor: Colors.black.withOpacity(0.7), fontSize: FontSize.textSizeSmall);
    }
    return null;
  }

  bool _isAdminWard(){
    bool _result = false;
    for(var ph in MyArray.adminPhno){
      if(ph == _sharepreferenceshelper.getUserPhoneNo()){
        _result = true;
      }
    }
    return _result;
  }


  _initHeaderTitle(){
    _profilePhoto = new CachedNetworkImageProvider(BaseUrl.USER_PHOTO_URL+_userModel.photoUrl);
    switch(_userModel.currentRegionCode){
      case MyString.TGY_REGIONCODE:
        _city = _isAdminWard()? MyString.TGY_CITY +' '+'(Ward admin)':MyString.TGY_CITY;
        _organizationId = OrganizationId.TGY_ORGANIZATION_ID;
        break;
      case MyString.MLM_REGIONCODE:
        _city = _isAdminWard()? MyString.MLM_CITY +' '+'(Ward admin)': MyString.MLM_CITY;
        _organizationId = OrganizationId.MLM_ORGANIZATION_ID;
        break;
      default:
    }
  }


  Widget _newsFeedList(int i){
    NewsFeedModel newsFeedModel = _newsFeedReactModel[i].newsFeedModel;
    String newsFeedPhoto = newsFeedModel.photoUrl;
    String newsFeedThumbNail = newsFeedModel.thumbNail;
    String title = newsFeedModel.title;
    String body = newsFeedModel.body;
    String date = showDateTimeDifference(newsFeedModel.accesstime);
    bool isPhoto = _isPhoto(newsFeedModel.uploadType);

    return Card(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Container(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsFeedDetailScreen(newsFeedModel, _newsFeedReactModel[i].photoList)));
              },
              child: Container(
                child: Column(
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
                            errorWidget: (context, url, error)=> Image.asset('images/placeholder_newsfeed.jpg'),
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
                        if(_newsFeedReactModel[i].reactType == null){
                          newsFeedModel.likeCount++;
                          _newsFeedReactModel[i].reactType = 'like';
                        }else{
                          _newsFeedReactModel[i].reactType = null;
                          if(newsFeedModel.likeCount >= 0){
                            newsFeedModel.likeCount--;
                          }
                        }
                        _callLikeWebService(newsFeedModel.uniqueKey);
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Container(margin: EdgeInsets.only(right: 5.0),
                            child: Image.asset(_newsFeedReactModel[i].reactType!=null?'images/like_fill.png':'images/like.png',
                              width: 20.0,height: 20.0,)),
                        Text('${MyString.txt_like}',
                          style: TextStyle(color: MyColor.colorPrimary, fontSize: FontSize.textSizeSmall),)
                      ],
                    ),
                  ),
                  //save newsfeed button
                  Expanded(child: GestureDetector(onTap: (){
                    _saveNewsFeed(newsFeedModel);

                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 5),
                            child: Image.asset('images/save.png', width: 20.0,height: 20.0,)),
                        Text('${MyString.txt_save}',
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

  Widget _headerNewsFeed(){
    return Column(
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
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));

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

  Widget _emptyNewsFeed(){
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
                    Text('သတင်းများ', style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeExtraNormal),),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: CircleAvatar(backgroundImage: _userModel!=null?
                _profilePhoto:AssetImage('images/profile_placeholder.png'),
                  backgroundColor: MyColor.colorGrey, radius: 25.0,),
              )
            ],
          ),
          Expanded(
            child: Center(child: Image.asset('images/empty_box.png', width: 80, height: 80,)),
          )
        ],
      ),
    );
  }

  Widget _listView(){
    return ListView.builder(
        itemCount: _newsFeedReactModel.length,
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
              _newsFeedList(i)
            ],
          );
        }
    );
  }

  Widget getNoConnectionWidget(){
    return Container(
      margin: EdgeInsets.only(top: 24.0, bottom: 20.0, left: 15.0, right: 15.0),
      child: Column(
        children: <Widget>[
          _headerNewsFeed(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('No Internet Connection'),
                  FlatButton(onPressed: (){

                    asyncLoaderState.currentState.reloadState();
                    _checkCon();

                    }
                    , child: Text('Retry', style: TextStyle(color: Colors.white),),color: MyColor.colorPrimary,)
                ],
              ),
            ),
          )
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


  @override
  Widget build(BuildContext context) {
    super.build(context);
    var _asyncLoader = new AsyncLoader(
      key: asyncLoaderState,
      initState: () async => await _getUser(),
      renderLoad: () => _renderLoad(),
      renderError: ([error]) => getNoConnectionWidget(),
      renderSuccess: ({data}) => Container(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: LoadMore(
            isFinish: _isEnd,
            onLoadMore: _loadMore,
            delegate: DefaultLoadMoreDelegate(),
            textBuilder: DefaultLoadMoreTextBuilder.english,
            child: _isRefresh?_renderLoad():_newsFeedReactModel.isNotEmpty?_listView():_emptyNewsFeed()
          ),
        ),
      )
    );
    return Scaffold(
      body: SafeArea(child: _asyncLoader),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
}
