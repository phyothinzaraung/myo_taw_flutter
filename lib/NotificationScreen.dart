import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/helper/ServiceHelper.dart';
import 'package:myotaw/helper/ShowDateTimeHelper.dart';
import 'package:myotaw/model/NotificationModel.dart';
import 'package:myotaw/myWidget/CustomProgressIndicator.dart';
import 'helper/FireBaseAnalyticsHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'model/UserModel.dart';
import 'helper/SharePreferencesHelper.dart';
import 'Database/UserDb.dart';
import 'package:async_loader/async_loader.dart';
import 'package:myotaw/myWidget/NoConnectionWidget.dart';
import 'package:myotaw/myWidget/EmptyViewWidget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/NotificationDetailScreen.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with AutomaticKeepAliveClientMixin<NotificationScreen> {
  UserModel _userModel;
  UserDb _userDb = UserDb();

  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();

  String _regionCode;
  String _city;
  bool _isLoading = false;

  var response;

  List<NotificationModel> _notificationList = new List<NotificationModel>();
  List _notificationModelList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FireBaseAnalyticsHelper.TrackCurrentScreen(ScreenName.NOTIFICATION_SCREEN);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _getUser()async{
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    _userDb.closeUserDb();
    setState(() {
      _userModel = model;
    });
    _initHeaderTitle();
    await _getNotifications();
  }

  _initHeaderTitle(){
    switch(_userModel.currentRegionCode){
      case MyString.TGY_REGIONCODE:
        _city = MyString.TGY_CITY;
        break;
      case MyString.MLM_REGIONCODE:
        _city = MyString.MLM_CITY;
        break;
      case MyString.LKW_REGIONCODE:
        _city = MyString.LKW_CITY;
        break;
    }
  }

  _getNotifications() async{
    await _sharepreferenceshelper.initSharePref();
    _regionCode = _sharepreferenceshelper.getRegionCode();
    try{
      response = await ServiceHelper().getNotification(_regionCode);
      if(response.data != null) {
        _notificationModelList = response.data;
        for(var i in _notificationModelList){
          _notificationList.add(NotificationModel.fromJson(i));
        }
      }

    }catch(e){
      print(e);
    }

  }

  Widget _headerNotification(){
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
                  Text(MyString.txt_title_notification, style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeExtraNormal),),
                ],
              ),
            )
          ],
        )
      ],
    ));
  }

  Widget _notificationListWidget(int i){
    String datetime = _notificationList[i].postedDate;
    String date = ShowDateTimeHelper.showDateTimeDifference(datetime);
    
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(top: i == _notificationList.length? 0 : 1, left: 0, right: 0, bottom: 0),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        leading: Image.asset("images/noti.png", width: 30.0, height: 30.0,),
        title: Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(_notificationList[i].message, style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorBlackSemiTransparent), maxLines: 2,)),
        subtitle: Text(date, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextGrey),),
        onTap: (){
          NavigatorHelper.MyNavigatorPush(context, NotificationDetailScreen(_notificationList[i]), ScreenName.NOTIFICATION_DETAIL_SCREEN);
        },
      ),
    );
  }

  _listView(){
    return ListView.builder(
      itemCount: _notificationList.length,
      itemBuilder: (BuildContext context, int i){
        return Column(
          children: <Widget>[
            i==0? _headerNotification():Container(),
            _notificationListWidget(i)
          ],
        );
      },
    );
  }

  Future<Null> _handleRefresh() async {
    _notificationList.clear();
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print(_notificationList);
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => _getUser(),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => noConnectionWidget(asyncLoaderState),
        renderSuccess: ({data}) => RefreshIndicator(
            child: _notificationList.isNotEmpty?_listView() :
            Column(
              children: <Widget>[
                _headerNotification(),
                Expanded(child: emptyView(asyncLoaderState, MyString.txt_no_notification))
              ],
            ),
            onRefresh: _handleRefresh
        )
    );
    return Scaffold(
      body: ModalProgressHUD(inAsyncCall: _isLoading,progressIndicator: CustomProgressIndicatorWidget(),child: _asyncLoader)
    );
  }

  Widget _renderLoad(){
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _headerNotification(),
            Container(margin: EdgeInsets.only(top: 10.0),child: CircularProgressIndicator())
          ],
        )
    );
  }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
