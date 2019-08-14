import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';
import 'package:dio/dio.dart';
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
  bool _isEnd , _isCon= false;
  int page = 1;
  int pageCount = 10;
  UserModel _userModel;
  String _city;
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

  _getUser()async{
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUniqueKey());
    await _userDb.closeUserDb();
    setState(() {
      _userModel = model;
    });
    _initHeaderTitle();
    await _getNewsFeed(page);
  }

  _initHeaderTitle(){
    _profilePhoto = new CachedNetworkImageProvider(BaseUrl.USER_PHOTO_URL+_userModel.photoUrl);
    switch(_userModel.currentRegionCode){
      case MyString.TGY_REGIONCODE:
        _city = MyString.TGY_CITY;
        _organizationId = OrganizationId.TGY_ORGANIZATION_ID;
        break;
      case MyString.MLM_REGIONCODE:
        _city = MyString.MLM_CITY;
        _organizationId = OrganizationId.MLM_ORGANIZATION_ID;
        break;
      default:
    }
  }

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
    //print('isCon : ${_isCon}');
  }

  _getNewsFeed(int p) async{
    response = await ServiceHelper().getNewsFeed(_organizationId, p, pageCount, _userModel.uniqueKey);
    var result = response.data['Results'];
    print('loadmore: ${p}');
    //Fluttertoast.showToast(msg: 'page: ${p}', backgroundColor: Colors.black.withOpacity(0.6));
    if(response.statusCode == 200){
      if(result != null){
        if(result.length > 0){
          for(var model in result){
            _newsFeedReactModel.add(NewsFeedReactModel.fromJson(model));
          }
          //prevent set state is called after NewsFeedScreen is disposed
          if(this.mounted){
            setState(() {
              _isEnd = false;
            });
          }
        }else{
          if(this.mounted){
            setState(() {
              _isEnd = true;
            });
          }
        }
      }else{
        if(this.mounted){
          setState(() {
            _isEnd = true;
          });
        }
      }
    }else{
      Fluttertoast.showToast(msg: 'နောက်တစ်ကြိမ်လုပ်ဆောင်ပါ။', backgroundColor: Colors.black.withOpacity(0.7));
    }
    print('isEnd: ${_isEnd}');
  }

  bool _isLike(String reactType){
    if(reactType != null){
      return true;
    }else{
      return false;
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


  Widget _newsFeedList(int i){
    NewsFeedModel newsFeedModel = _newsFeedReactModel[i].newsFeedModel;
    String newsFeedPhoto = newsFeedModel.photoUrl;
    String newsFeedThumbNail = newsFeedModel.thumbNail;
    String title = newsFeedModel.title;
    String date = showDateTime(newsFeedModel.accesstime);
    bool isLike = _isLike(_newsFeedReactModel[i].reactType);
    bool isPhoto = _isPhoto(newsFeedModel.uploadType);

    return Card(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Container(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsFeedDetailScreen(newsFeedModel)));
              },
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(child: Text(title!=null?title:'---',style: TextStyle(fontSize: FontSize.textSizeNormal), maxLines: 1, overflow: TextOverflow.ellipsis,))
                        ],),
                    ),
                    Container(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: <Widget>[
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
                          Container(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(10.0)),
                                  color: Colors.black.withOpacity(0.6)
                              ),
                              child: Text(date, style: TextStyle(color: Colors.white),)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      print('like: ${isLike}');
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
                        Text('${newsFeedModel.likeCount} ${MyString.txt_like}',
                          style: TextStyle(color: MyColor.colorPrimary, fontSize: FontSize.textSizeSmall),)
                      ],
                    ),
                  ),
                  Expanded(child: GestureDetector(onTap: (){
                    _saveNewsFeed(newsFeedModel);

                  },
                    child: Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[Image.asset('images/save.png', width: 20.0,height: 20.0,),],),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _saveNewsFeed(NewsFeedModel model)async{
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

  void _callLikeWebService(String newsFeedId)async{
    response = await ServiceHelper().likeReact('0fc9d06a-a622-4288-975d-b5f414a9ad73', newsFeedId, 'like');
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

  Widget _headerNewsFeedRefresh(){
    return Container(
      margin: EdgeInsets.only(top: 48.0, bottom: 20.0, left: 15.0, right: 15.0),
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
      margin: EdgeInsets.only(top: 48.0, bottom: 20.0, left: 15.0, right: 15.0),
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
      margin: EdgeInsets.only(top: 48.0, bottom: 20.0, left: 15.0, right: 15.0),
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

  Future<bool> _loadMore() async {
    await _checkCon();
    if(_isCon){
      page++;
      await _getNewsFeed(page);
      //Fluttertoast.showToast(msg: 'call loadmore');
    }
    return _isCon;
  }

  Future<Null> _handleRefresh() async {
    await _checkCon();
   if(_isCon){
     _newsFeedReactModel.clear();
     page = 0;
     page++;
     await _getUser();
     //await _getNewsFeed(page);
   }else{
     Fluttertoast.showToast(msg: 'Check Connection', backgroundColor: Colors.black.withOpacity(0.7), fontSize: FontSize.textSizeSmall);
   }
    return null;
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
            child: _newsFeedReactModel.isNotEmpty?_listView():_headerNewsFeedRefresh()
          ),
        ),
      )
    );
    return Scaffold(
      body: _asyncLoader,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
}
