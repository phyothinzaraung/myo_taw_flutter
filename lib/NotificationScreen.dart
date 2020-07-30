import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/database/NotificationDb.dart';
import 'package:myotaw/helper/MyoTawCitySetUpHelper.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/helper/ServiceHelper.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/helper/ShowDateTimeHelper.dart';
import 'package:myotaw/model/UserModel.dart';
import 'package:myotaw/myWidget/CustomProgressIndicator.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/NativeProgressIndicator.dart';
import 'package:myotaw/myWidget/NativePullRefresh.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier.dart';
import 'helper/FireBaseAnalyticsHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'model/NotificationModel.dart';
import 'Database/UserDb.dart';
import 'package:async_loader/async_loader.dart';
import 'package:myotaw/myWidget/NoConnectionWidget.dart';
import 'package:myotaw/myWidget/EmptyViewWidget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:myotaw/NotificationDetailScreen.dart';

class NotificationScreen extends StatefulWidget {
  Sharepreferenceshelper _sharepreferenceshelper;
  NotificationScreen(this._sharepreferenceshelper);
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with AutomaticKeepAliveClientMixin<NotificationScreen>, TickerProviderStateMixin {
  UserDb _userDb = UserDb();
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  String _city, _regionCode;
  bool _isLoading = false;
  var response;
  List<NotificationModel> _notificationList = new List<NotificationModel>();
  Notifier _notifier;
  AnimationController _animatinController;
  UserModel _userModel;
  int _unreadCount = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animatinController = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    FireBaseAnalyticsHelper.trackCurrentScreen(ScreenName.NOTIFICATION_SCREEN);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _getUser()async{
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(widget._sharepreferenceshelper.getUserUniqueKey());
    _userDb.closeUserDb();
    setState(() {
      _userModel = model;
    });
    _city = MyoTawCitySetUpHelper.getCity(widget._sharepreferenceshelper.getRegionCode());
    await _getNotifications();
  }


  _getNotifications() async{
    await widget._sharepreferenceshelper.initSharePref();
    _regionCode = widget._sharepreferenceshelper.getRegionCode();
      response = await ServiceHelper().getNotification(_regionCode,widget._sharepreferenceshelper.getUserUniqueKey());
      if(response.data != null) {
        var resultList = response.data['ReadNotiVM'];
        _unreadCount = response.data['unReadCount'];
        if(resultList != null && resultList.length > 0){
          for(var i in resultList){
            _notificationList.add(NotificationModel.fromJson(i));
          }
          //await _notificationDb.openNotificationDb();
          //_notificationDb.deleteNotification();
          /*for(var i in resultList){
          bool isSave = await _notificationDb.isNotificationSaved(NotificationModel.fromJson(i).iD);
          if(!isSave){
            _notificationDb.insert(NotificationModel.fromJson(i));
          }
        }*/
          /*var list = await _notificationDb.getNotification();
        _notificationList.addAll(list);
        var count = await _notificationDb.getUnReadNotificationCount();
        _notificationDb.closeSaveNotificationDb();*/
          widget._sharepreferenceshelper.saveNotiUnreadCount(_unreadCount);
          _notifier.notify('noti_count', _unreadCount);
        }
      }

  }

  Widget _notificationListWidget(int i){
    NotificationModel model = _notificationList[i];
    String datetime = model.postedDate;
    String date = ShowDateTimeHelper.showDateTimeDifference(datetime);

    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(top: i == _notificationList.length? 0 : 1, left: 0, right: 0, bottom: 0),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: ListTile(
          contentPadding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
          leading: Image.asset(model.isRead?"images/noti_open.png" : 'images/noti_close.png', width: 30.0, height: 30.0,),
          title: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(model.message, style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorBlackSemiTransparent), maxLines: 2,overflow: TextOverflow.ellipsis,)),
          subtitle: Text(date, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextGrey),),
          onTap: ()async{

            if(!model.isRead){
              model.isRead = true;
              if(widget._sharepreferenceshelper.getUnreadCount() > 0){
                var _count = widget._sharepreferenceshelper.getUnreadCount() - 1;
                _notifier.notify('noti_count', _count);
                widget._sharepreferenceshelper.saveNotiUnreadCount(_count);
              }
            }
            NavigatorHelper.myNavigatorPush(context, NotificationDetailScreen(model.iD), ScreenName.NOTIFICATION_DETAIL_SCREEN);
          }
      ),
    );
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
                ),
              ],
            ),

          ],
        ));
  }

  _listView(){
    return ListView.builder(
      itemCount: _notificationList.length,
      itemBuilder: (BuildContext context, int i){
        return Column(
          children: <Widget>[
            i==0? widget._sharepreferenceshelper.isWardAdmin()? Container() : _headerNotification():Container(),
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
    _notifier = NotifierProvider.of(context);
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => _getUser(),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => Column(
          children: <Widget>[
            widget._sharepreferenceshelper.isWardAdmin()? Container() :_headerNotification(),
            Expanded(child: noConnectionWidget(asyncLoaderState))
          ],
        ),
        renderSuccess: ({data}) => NativePullRefresh(
            child: _notificationList.isNotEmpty?
            Notifier.of(context).register('noti_add', (value){
              if(widget._sharepreferenceshelper.isNotificationAdd() != null){
                if(value.data != null && widget._sharepreferenceshelper.isNotificationAdd()){
                  //_handleRefresh();
                  _notificationList.insert(0, NotificationModel.fromJson(value.data));
                }
              }
              widget._sharepreferenceshelper.setNotificationAdd(false);
              return _listView();
            }) :
            Column(
              children: <Widget>[
                widget._sharepreferenceshelper.isWardAdmin()? Container() :_headerNotification(),
                Expanded(child: emptyView(asyncLoaderState, MyString.txt_no_notification))
              ],
            ),
            onRefresh: _handleRefresh
        )
    );
    return widget._sharepreferenceshelper.isWardAdmin()?
        CustomScaffoldWidget(
          title: Text(MyString.txt_title_notification,maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
          body:  ModalProgressHUD(
              inAsyncCall: _isLoading,
              progressIndicator: CustomProgressIndicatorWidget(),
              child: _asyncLoader
          ),
        )
        :
    Scaffold(
      body: ModalProgressHUD(
          inAsyncCall: _isLoading,
          progressIndicator: CustomProgressIndicatorWidget(),
          child: _asyncLoader
      ),
    );
  }

  Widget _renderLoad(){
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            widget._sharepreferenceshelper.isWardAdmin()? Container() :_headerNotification(),
            Container(margin: EdgeInsets.only(top: 10.0),child: NativeProgressIndicator())
          ],
        )
    );
  }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animatinController.stop();
    _animatinController.dispose();
  }
}
