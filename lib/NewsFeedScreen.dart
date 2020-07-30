import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';
import 'package:html/parser.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/helper/MyoTawCitySetUpHelper.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/model/NewsFeedModel.dart';
import 'package:myotaw/model/NewsFeedViewModel.dart';
import 'package:myotaw/myWidget/NativeProgressIndicator.dart';
import 'package:myotaw/myWidget/NativePullRefresh.dart';
import 'package:notifier/main_notifier.dart';
import 'ProfileFormScreen.dart';
import 'helper/PlatformHelper.dart';
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
import 'myWidget/CustomButtonWidget.dart';
import 'myWidget/CustomDialogWidget.dart';
import 'myWidget/DropDownWidget.dart';
import 'myWidget/EmptyViewWidget.dart';
import 'myWidget/IosPickerWidget.dart';
import 'myWidget/NoConnectionWidget.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

class NewsFeedScreen extends StatefulWidget {
  String channelType;
  NewsFeedScreen({this.channelType});
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> with AutomaticKeepAliveClientMixin<NewsFeedScreen> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  var response;
  List<NewsFeedViewModel> _newsFeedViewModelList = new List<NewsFeedViewModel>();
  ScrollController _scrollController = new ScrollController();
  bool _isEnd = false, _isCon= false;
  int page = 1;
  int pageCount = 10;
  UserModel _userModel;
  String _city, _userUniqueKey;
  SaveNewsFeedDb _saveNewsFeedDb = SaveNewsFeedDb();
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  SaveNewsFeedModel _saveNewsFeedModel = SaveNewsFeedModel();
  ImageProvider _profilePhoto;
  UserDb _userDb = UserDb();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  TextEditingController _searchEditingController  = TextEditingController();
  bool _isSearchTextFieldEnable = true, _isSearchTextSelect = true, _isSearchContentTypeSelect = false, _isSearchDateSelect = false;
  String _dropDownContentType = MyString.txt_to_choose, _keyWord = '';
  List<String> _contentTypeList = List();
  int _searchContentTypePickerIndex = 0;
  var _fromDate ='', _toDate ='', _memeberTypeTitle = '';

  final Map<int, Widget> _cupertinoSliderChildren = const <int, Widget>{
    0: Text(MyString.txt_search_text, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),
    1: Text(MyString.txt_search_content_type, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),
    2: Text(MyString.txt_search_date, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)
  };

  int _currentSegment = 0;
  List<Widget> _searchContentTypeWidgetList = List();
  String _fromDateToDate = MyString.txt_to_choose_date;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FireBaseAnalyticsHelper.trackCurrentScreen(ScreenName.NEWS_FEED_SCREEN);
    _contentTypeList.add(MyString.txt_to_choose);
    _contentTypeList.addAll(MyStringList.content_type_list);
    if (!PlatformHelper.isAndroid()) {
      _initSearchContentIosPickerWidgetList();
    }
  }

  _initSearchContentIosPickerWidgetList(){
    for(var i in _contentTypeList){
      _searchContentTypeWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
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
      _saveNewsFeedModel.thumbNail = model.thumbnail;
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
    Future.delayed(Duration(milliseconds: 100)).whenComplete((){
      if(_userModel.name == null){
        CustomDialogWidget().customSuccessDialog(
            context: context,
            content: MyString.txt_profile_set_up_need,
            img: 'logout_icon.png',
            buttonText: MyString.txt_profile_set_up,
            onPress: (){
              _navigateToProfileFormScreen();
            }
        );
      }
    });
    await _getNewsFeed(page);
  }

  _navigateToProfileFormScreen()async{
    Map result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileFormScreen(_userModel.isWardAdmin)));
    if(result != null && result.containsKey('isNeedRefresh') == true){
      Navigator.of(context).pop();
    }
  }

  _getNewsFeed(int p) async{
    if(_userModel.isWardAdmin){
      var _blockName =  widget.channelType != MyString.NEWS_FEED_CHANNEL_TYPE_BLOCK? '' : _userModel.wardName;
      response = await ServiceHelper().getNewsFeedForWardAdmin(MyoTawCitySetUpHelper.getNewsFeedCityId(_sharepreferenceshelper.getRegionCode()),p,pageCount,_userUniqueKey,
          _keyWord, widget.channelType, _blockName);
      print('UserKey : ${_userUniqueKey} - keyword : ${_keyWord} - channelType : ${widget.channelType} - blockName : ${_blockName}');
    }else{
      response = await ServiceHelper().getNewsFeed(MyoTawCitySetUpHelper.getNewsFeedCityId(_sharepreferenceshelper.getRegionCode()),p,pageCount,_userUniqueKey);
    }



    var result = response.data['Results'];
    //var result = [];
    print('loadmore: ${p}');
    if(result != null && result.length > 0){
      for(var i in result){
        NewsFeedViewModel _newsFeedViewModel = NewsFeedViewModel.fromJson(i);
        //print(_newsFeedViewModel.toJson());
        await _saveNewsFeedDb.openSaveNfDb();
        bool isSaved = await _saveNewsFeedDb.isNewsFeedSaved(_newsFeedViewModel.article.uniqueKey);
        _saveNewsFeedDb.closeSaveNfDb();
        _newsFeedViewModel.article.isSaved = isSaved;
        _newsFeedViewModelList.add(_newsFeedViewModel);
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
      _newsFeedViewModelList.clear();
    });
    asyncLoaderState.currentState.reloadState();
    return null;
  }


  _initHeaderTitle(){
    _profilePhoto = _userModel.photoUrl!=null?
    new CachedNetworkImageProvider(BaseUrl.USER_PHOTO_URL+_userModel.photoUrl) :
    AssetImage('images/profile_placeholder.png');
    _city = MyoTawCitySetUpHelper.getCity(_userModel.currentRegionCode);
    _memeberTypeTitle = _memberType().isNotEmpty? '(${_memberType()})' : '';
  }

  String _memberType(){
    var _title = '';
    switch(_userModel.memberType){
      case MyString.MEMBER_TYPE_WARD_ADMIN:
        _title = MyString.MEMBER_TYPE_WARD_ADMIN_TITLE;
        break;
      case MyString.MEMBER_TYPE_WARD_MP:
        _title = MyString.MEMBER_TYPE_WARD_MP_TITLE;
        break;
      case MyString.MEMBER_TYPE_WARD_MUNICIPAL:
        _title = MyString.MEMBER_TYPE_WARD_MUNICIPAL_TITLE;
        break;
    }
    return _title;
  }

  String _newsfeedContentTypeIcon(String type){
    var icon = '';
    switch (type){
      case MyString.NEWS_FEED_CONTENT_TYPE_PHOTO:
        icon = 'image';
        break;
      case MyString.NEWS_FEED_CONTENT_TYPE_VIDEO:
        icon = 'video';
        break;
      case MyString.NEWS_FEED_CONTENT_TYPE_AUDIO:
        icon = 'audio';
        break;
      case MyString.NEWS_FEED_CONTENT_TYPE_PDF:
        icon = 'pdf';
        break;
    }

    return icon;

  }

  String _newsfeedContentType(String type){
    var contentType = '';
    switch (type){
      case MyString.txt_content_type_photo:
        contentType = MyString.NEWS_FEED_UPLOAD_TYPE_PHOTO;
        break;
      case MyString.txt_content_type_video:
        contentType = MyString.NEWS_FEED_UPLOAD_TYPE_VIDEO;
        break;
      case MyString.txt_content_type_audio:
        contentType = MyString.NEWS_FEED_UPLOAD_TYPE_AUDIO;
        break;
      case MyString.txt_content_type_pdf:
        contentType = MyString.NEWS_FEED_UPLOAD_TYPE_PDF;
        break;
    }

    return contentType;

  }

  bool _isPhotoOrVideo(String type){
    if(type == MyString.NEWS_FEED_CONTENT_TYPE_PHOTO || type == MyString.NEWS_FEED_CONTENT_TYPE_VIDEO){
      return true;
    }else{
      return false;
    }
  }


  Widget _newsFeedListWidget(int i){
    NewsFeedModel newsFeedModel = _newsFeedViewModelList[i].article;
    String newsFeedPhoto = newsFeedModel.photoUrl;
    String newsFeedThumbNail = newsFeedModel.thumbnail;
    String title = newsFeedModel.title;
    String body = newsFeedModel.body;
    String date = ShowDateTimeHelper.showDateTimeDifference(newsFeedModel.accesstime);
    bool isPhoto = _isPhoto(newsFeedModel.uploadType);
    String contentType = newsFeedModel.uploadType;
    return Card(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Container(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: (){

                NavigatorHelper.myNavigatorPush(context, NewsFeedDetailScreen(newsFeedModel, _newsFeedViewModelList[i].photoLink), ScreenName.NEWS_FEED_DETAIL_SCREEN);
              },
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //image calendar
                          Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Image.asset("images/calendar.png", width: 15, height: 15,)),
                          //calendar date
                          Text(date, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextGrey),),
                          //Image.asset('images/${_newsfeedContentTypeIcon(contentType)}.png', width: 20, height: 20,)
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(bottom: 5.0),
                      //title
                      child: Text(title!=null?title:'---',
                        style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorTextBlack), maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ),
                    Container(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: <Widget>[
                          //newsfeed image
                          _isPhotoOrVideo(contentType)?CachedNetworkImage(
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
                              child: Center(child: NativeProgressIndicator()), width: double.maxFinite, height: 150.0,)),
                            errorWidget: (context, url, error)=> Image.asset('images/placeholder_newsfeed.jpg', width: double.maxFinite,
                              height: 180, fit: BoxFit.cover,
                            ),
                          ) : Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                width: double.maxFinite,
                                height: 180,
                                color: MyColor.colorGrey,
                              ),
                              Image.asset('images/${_newsfeedContentTypeIcon(contentType)}.png', width: 50,
                                  height: 50
                              ),
                            ],
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
                        if(_newsFeedViewModelList[i].reacttype == null){
                          newsFeedModel.likeCount++;
                          _newsFeedViewModelList[i].reacttype = 'like';
                        }else{
                          _newsFeedViewModelList[i].reacttype = null;
                          if(newsFeedModel.likeCount >= 0){
                            newsFeedModel.likeCount--;
                          }
                        }
                        FireBaseAnalyticsHelper.trackClickEvent(ScreenName.NEWS_FEED_SCREEN, ClickEvent.NEWS_FEED_LIKE_CLICK_EVENT, _userUniqueKey);
                        _callLikeWebService(newsFeedModel.uniqueKey);
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Container(margin: EdgeInsets.only(right: 5.0),
                            child: Image.asset(_newsFeedViewModelList[i].reacttype!=null?'images/like_fill.png':'images/like.png',
                              width: 20.0,height: 20.0,)),
                        Text('${MyString.txt_like}',
                          style: TextStyle(color: MyColor.colorPrimary, fontSize: FontSize.textSizeSmall),)
                      ],
                    ),
                  ),
                  //save newsfeed button
                  Expanded(child: GestureDetector(onTap: (){
                    FireBaseAnalyticsHelper.trackClickEvent(ScreenName.NEWS_FEED_SCREEN, ClickEvent.NEWS_FEED_SAVE_CLICK_EVENT, _userUniqueKey);
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _userModel!=null?_userModel.isWardAdmin?GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Icon(PlatformHelper.isAndroid()?Icons.arrow_back: CupertinoIcons.back,color: Colors.black,size: 30,),
                    ),
                  ) : Container() : Container(),
                 // Text(_city??'', style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeExtraNormal)),
                  /*Row(
                    children: <Widget>[
                      Text(_city, style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeLarge),),
                      Text(_memeberTypeTitle, style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeExtraSmall),)
                    ],
                  ),*/
                  RichText(text: TextSpan(
                    text: _city,
                    style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeLarge),
                    children: [
                      TextSpan(
                        text: _memeberTypeTitle,
                        style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeExtraSmall),
                      ),
                    ]
                  )),
                  Text(MyString.txt_newsfeed, style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeExtraNormal),),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
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
        _userModel != null?_userModel.isWardAdmin?_searchBarForAdmin() : Container() : Container()
      ],
    );
  }

  Widget _searchBarForAdmin(){
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          child: PlatformHelper.isAndroid()?SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        _isSearchTextSelect = true;
                        _isSearchContentTypeSelect = false;
                        _isSearchDateSelect = false;
                        _isSearchTextFieldEnable = true;
                        _fromDateToDate = MyString.txt_to_choose_date;
                      });
                      _searchEditingController.clear();
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _isSearchTextSelect?MyColor.colorPrimary : Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10,),
                        child: Row(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(Icons.text_fields, size: 17,color: _isSearchTextSelect?Colors.white : Colors.black,)
                            ),
                            Text(MyString.txt_search_text, style: TextStyle(color: _isSearchTextSelect?Colors.white : Colors.black, fontSize: FontSize.textSizeSmall),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        _isSearchTextSelect = false;
                        _isSearchContentTypeSelect = true;
                        _isSearchDateSelect = false;
                        _isSearchTextFieldEnable = false;
                        _fromDateToDate = MyString.txt_to_choose_date;
                      });
                      _searchEditingController.clear();
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _isSearchContentTypeSelect?MyColor.colorPrimary : Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10,),
                        child: Row(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(Icons.perm_media, size: 17,color: _isSearchContentTypeSelect?Colors.white : Colors.black,)),
                            Text(MyString.txt_search_content_type, style: TextStyle(color: _isSearchContentTypeSelect?Colors.white : Colors.black,fontSize: FontSize.textSizeSmall),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()async{
                      setState(() {
                        _isSearchTextSelect = false;
                        _isSearchContentTypeSelect = false;
                        _isSearchDateSelect = true;
                        _isSearchTextFieldEnable = false;
                        _fromDateToDate = MyString.txt_to_choose_date;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _isSearchDateSelect?MyColor.colorPrimary : Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10,),
                        child: Row(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(Icons.date_range, size: 17,color: _isSearchDateSelect?Colors.white : Colors.black,)),
                            Text(MyString.txt_search_date, style: TextStyle(color: _isSearchDateSelect?Colors.white : Colors.black,fontSize: FontSize.textSizeSmall),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ) : _cupertinoSliderControl(),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: _isSearchContentTypeSelect? _contentTypeDropdown()
              : Container(
            height: 55,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 0.5),
                      blurRadius: 3
                  )
                ]
            ),
            child: _isSearchDateSelect? GestureDetector(
              onTap: ()async{
                if(PlatformHelper.isAndroid()){
                  List dateTime = await DateRangePicker.showDatePicker(
                  context: context,
                  initialFirstDate: DateTime.now(),
                  initialLastDate: DateTime.now().add(Duration(days: 7)),
                  firstDate: DateTime(2019),
                  lastDate: DateTime(2025),
                );
                  if(dateTime != null){
                    if (dateTime.length == 2) {
                      _fromDate = ShowDateTimeHelper.formatDateTimeForSearch(dateTime[0].toString());
                      _toDate = ShowDateTimeHelper.formatDateTimeForSearch(dateTime[1].toString());
                      setState(() {
                        _fromDateToDate = '${_fromDate}  မှ  ${_toDate}  အထိ';
                        _keyWord = _fromDate+','+_toDate;
                      });
                      _handleRefresh();
                      print('dateformat: $_keyWord');
                    }
                  }
                }else{
                  _fromDateCupertinoCalendarPicker();
                }
              },
              child: Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 11, bottom: 11),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: Text(_fromDateToDate,style: TextStyle(fontSize: FontSize.textSizeExtraSmall),)),
                      GestureDetector(
                          onTap: (){
                            setState(() {
                              _fromDateToDate = MyString.txt_to_choose_date;
                              _keyWord = '';
                              _fromDate = '';
                              _toDate = '';
                              _searchEditingController.clear();
                            });
                            //FocusScope.of(context).requestFocus(FocusNode());
                            _handleRefresh();
                          },
                          child: Icon(PlatformHelper.isAndroid()? Icons.refresh : CupertinoIcons.refresh, color: Colors.black,size: PlatformHelper.isAndroid()? 23 : 25,)
                      )
                    ],
                  )),
            ) : Stack(
              alignment: Alignment.center,
              children: <Widget>[
                TextField(
                  enabled: _isSearchTextFieldEnable,
                  controller: _searchEditingController,
                  style: TextStyle(fontSize: FontSize.textSizeNormal,),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hoverColor: Colors.red,
                      filled: true,
                      fillColor: Colors.transparent,
                      hintText: MyString.txt_to_search,
                      hintStyle: TextStyle(fontSize: FontSize.textSizeSmall,),
                      //prefixIcon: Icon(Icons.search, color: Colors.black,size: 20,),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  _keyWord = _searchEditingController.text;
                                });
                                _handleRefresh();
                                FireBaseAnalyticsHelper.trackClickEvent(ScreenName.NEWS_FEED_SCREEN, ClickEvent.NEWS_FEED_TEXT_SEARCH_CLICK_EVENT, _userUniqueKey);

                              },
                              child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Icon(PlatformHelper.isAndroid()? Icons.search : CupertinoIcons.search, color: Colors.black,size: PlatformHelper.isAndroid()? 23 : 25,)
                              )
                          ),
                          GestureDetector(
                              onTap: (){
                                _searchEditingController.clear();
                                setState(() {
                                  _keyWord = '';
                                });
                                //FocusScope.of(context).requestFocus(FocusNode());
                                _handleRefresh();
                              },
                              child: Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: Icon(PlatformHelper.isAndroid()? Icons.refresh : CupertinoIcons.refresh, color: Colors.black,size: PlatformHelper.isAndroid()? 23 : 25,)
                              )
                          ),
                        ],
                      )
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (str){
                    print('keyword : ${str}');
                    //_searchEditingController.clear();
                    setState(() {
                      _keyWord = _searchEditingController.text;
                    });
                    _handleRefresh();
                    FireBaseAnalyticsHelper.trackClickEvent(ScreenName.NEWS_FEED_SCREEN, ClickEvent.NEWS_FEED_TEXT_SEARCH_CLICK_EVENT, _userUniqueKey);
                  },
                  cursorColor: MyColor.colorPrimary,
                ),
              ],
            ),
          )
        ),
      ],
    );
  }

  Future _fromDateCupertinoCalendarPicker(){
    return showCupertinoModalPopup(
        context: context,
        builder: (context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomButtonWidget(onPress: (){
                      Navigator.pop(context);
                      setState(() {
                        _fromDate = '';
                        _toDate = '';
                        _keyWord = '';
                        _fromDateToDate = MyString.txt_to_choose_date;
                      });
                    }, child: Text(MyString.txt_close, style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: Colors.red),),
                      color: Colors.white,
                      isFlatButton: true,
                    ),
                    Text(MyString.txt_need_from_date,
                      style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                    ),
                    CustomButtonWidget(onPress: (){
                      setState(() {
                        _fromDate = _fromDate.isNotEmpty? _fromDate : ShowDateTimeHelper.formatDateTimeForSearch(DateTime.now().toString());
                      });
                      print('fromDate : $_fromDate');
                      Navigator.pop(context);
                      Future.delayed(Duration(milliseconds: 250),(){
                        _toDateCupertinoCalendarPicker();
                      });
                    },
                      child: Text(MyString.txt_confirm,style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: Colors.blue)),
                      color: Colors.white,
                      isFlatButton: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  onDateTimeChanged: (dateTime){
                    _fromDate = ShowDateTimeHelper.formatDateTimeForSearch(dateTime.toString());
                  },
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.now(),
                  minimumDate: DateTime(2019),
                  maximumDate: DateTime(2025),
                  minimumYear: 2019,
                  maximumYear: 2025,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          );
        }
    );
  }
  Future _toDateCupertinoCalendarPicker(){
    return showCupertinoModalPopup(
        context: context,
        builder: (context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomButtonWidget(onPress: (){
                      Navigator.pop(context);
                      setState(() {
                        _fromDate = '';
                        _toDate = '';
                        _keyWord = '';
                        _fromDateToDate = MyString.txt_to_choose_date;
                      });
                    }, child: Text(MyString.txt_close, style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: Colors.red),),
                      color: Colors.white,
                      isFlatButton: true,
                    ),
                    Text(MyString.txt_need_to_date,
                      style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                    ),
                    CustomButtonWidget(onPress: (){
                      print('fromDate : $_fromDate / todate: $_toDate');
                      if(_fromDate.isNotEmpty && _toDate.isNotEmpty){
                        setState(() {
                          _fromDateToDate = '${_fromDate}  မှ  ${_toDate}  အထိ';
                          _keyWord = _fromDate+','+_toDate;
                        });
                        Navigator.pop(context);
                        //print('ios date picker : $_keyWord');
                        _handleRefresh();
                        FireBaseAnalyticsHelper.trackClickEvent(ScreenName.NEWS_FEED_SCREEN, ClickEvent.NEWS_FEED_DATE_SEARCH_CLICK_EVENT, _userUniqueKey);
                      }
                    },
                      child: Text(MyString.txt_confirm,style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: Colors.blue)),
                      color: Colors.white,
                      isFlatButton: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  onDateTimeChanged: (dateTime){
                    if(_fromDate.isEmpty){
                      _fromDate = ShowDateTimeHelper.formatDateTimeForSearch(dateTime.toString());
                    }else{
                      _toDate =ShowDateTimeHelper.formatDateTimeForSearch(dateTime.toString());
                    }

                  },
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.now(),
                  minimumDate: DateTime(2019),
                  maximumDate: DateTime(2025),
                  minimumYear: 2019,
                  maximumYear: 2025,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          );
        }
    );
  }

  Widget _contentTypeDropdown(){
    return Container(
      height: 55,
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 0.5),
                blurRadius: 3
            )
          ],
          color: Colors.white
      ),
      child: PlatformHelper.isAndroid()?

      Row(
        children: <Widget>[
          Expanded(
            child: DropDownWidget(
              value: _dropDownContentType,
              fontSize: FontSize.textSizeExtraSmall,
              onChange: (value){
                setState(() {
                  _dropDownContentType = value;
                  if(_dropDownContentType != MyString.txt_to_choose){
                    _keyWord = _newsfeedContentType(value);
                  }
                });
                _handleRefresh();
                FireBaseAnalyticsHelper.trackClickEvent(ScreenName.NEWS_FEED_SCREEN, ClickEvent.NEWS_FEED_CONTENT_TYPE_SEARCH_CLICK_EVENT, _userUniqueKey);
              },
              list: _contentTypeList,
            ),
          ),
          GestureDetector(
              onTap: (){
                _searchEditingController.clear();
                _keyWord = '';
                //FocusScope.of(context).requestFocus(FocusNode());
                _handleRefresh();
                setState(() {
                  _dropDownContentType = MyString.txt_to_choose;
                });
              },
              child: Icon(Icons.refresh, color: Colors.black,size: 23,)
          ),

        ],
      ) :
      Row(
        children: <Widget>[
          Expanded(
            child: IosPickerWidget(
              onPress: (){
                setState(() {
                  _dropDownContentType = _contentTypeList[_searchContentTypePickerIndex];
                  if(_dropDownContentType != MyString.txt_to_choose){
                    _keyWord = _newsfeedContentType(_dropDownContentType);
                  }
                });
                if(_dropDownContentType != MyString.txt_to_choose){
                  Navigator.pop(context);
                  _handleRefresh();
                  FireBaseAnalyticsHelper.trackClickEvent(ScreenName.NEWS_FEED_SCREEN, ClickEvent.NEWS_FEED_CONTENT_TYPE_SEARCH_CLICK_EVENT, _userUniqueKey);
                }
              },
              onSelectedItemChanged: (index){
                _searchContentTypePickerIndex = index;
              },
              fixedExtentScrollController: FixedExtentScrollController(initialItem: _searchContentTypePickerIndex),
              text: _dropDownContentType,
              children: _searchContentTypeWidgetList,
            ),
          ),

          GestureDetector(
              onTap: (){
                _searchEditingController.clear();
                _keyWord = '';
                //FocusScope.of(context).requestFocus(FocusNode());
                _handleRefresh();
                setState(() {
                  _dropDownContentType = MyString.txt_to_choose;
                  _searchContentTypePickerIndex = 0;
                });
              },
              child: Icon(CupertinoIcons.refresh, color: Colors.black,size: 25,)
          ),
        ],
      )
    );
  }

  Widget _cupertinoSliderControl(){
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 10, right: 10),
      child: CupertinoSlidingSegmentedControl(
        children: _cupertinoSliderChildren,
        thumbColor: Colors.white,
        padding: EdgeInsets.all(3),
        onValueChanged: (i)async{
          setState(() {
            _currentSegment = i;
            if (i == 0) {
              _isSearchTextSelect = true;
              _isSearchContentTypeSelect = false;
              _isSearchDateSelect = false;
              _isSearchTextFieldEnable = true;
              _fromDateToDate = MyString.txt_to_choose_date;
            }else if(i == 1){
              _isSearchTextSelect = false;
              _isSearchContentTypeSelect = true;
              _isSearchDateSelect = false;
              _isSearchTextFieldEnable = false;
              _fromDateToDate = MyString.txt_to_choose_date;
            }else{
              _isSearchTextSelect = false;
              _isSearchContentTypeSelect = false;
              _isSearchDateSelect = true;
              _isSearchTextFieldEnable = false;
              _fromDateToDate = MyString.txt_to_choose_date;
            }
          });

          await _sharepreferenceshelper.initSharePref();
          FireBaseAnalyticsHelper.trackClickEvent(ScreenName.DEPARTMENT_LIST_SCREEN, ClickEvent.MANAGEMENT_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
        },
        groupValue: _currentSegment,
      ),
    );
  }

  Widget _listView(){
    return ListView.builder(
        itemCount: _newsFeedViewModelList.length,
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
              ):Container(),
              _newsFeedListWidget(i)
            ],
          );
        }
    );
  }

  Widget _emptyView(){
    return Container(
      margin: EdgeInsets.only(top: 24.0,left: 15.0, right: 15.0),
      child: ListView(
        children: <Widget>[
          _headerNewsFeed(),
          Container(
              margin: EdgeInsets.only(top: 70),
              child: emptyView(asyncLoaderState,MyString.txt_no_newsFeed_data))
        ],
      ),
    );
  }

  Widget _noConWidget(){
    return Container(
      margin: EdgeInsets.only(top: 24.0, left: 15.0, right: 15.0),
      child: ListView(
        children: <Widget>[
          _headerNewsFeed(),
          Container(
              margin: EdgeInsets.only(top: 70),
              child: noConnectionWidget(asyncLoaderState))
        ],
      ),
    );
  }

  Widget _renderLoad(){
    return Container(
      margin: EdgeInsets.only(top: 24.0, bottom: 20.0, left: 15.0, right: 15.0),
      child: ListView(
        children: <Widget>[
          _headerNewsFeed(),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: NativeProgressIndicator(),
            ),
          )
        ],
      ),
    );
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
          child: NativePullRefresh(
              onRefresh: _handleRefresh,
              child: Notifier.of(context).register<bool>('scroll_top', (value){
                if(value.data != null && value.data == true && _sharepreferenceshelper.isNewsFeedScrollTop()){
                  _topToScreen();
                }
                _sharepreferenceshelper.setNewsFeedScrollTop(false);
                return _newsFeedViewModelList.isNotEmpty?LoadMore(
                    isFinish: _isEnd,
                    onLoadMore: _loadMore,
                    delegate: DefaultLoadMoreDelegate(),
                    textBuilder: DefaultLoadMoreTextBuilder.english,
                    child: _listView()
                ) : _emptyView();
              })
          ),
        )
    );
    return SafeArea(
      top: true,
      child: Scaffold(
        key: _globalKey,
        body: _asyncLoader,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

}
