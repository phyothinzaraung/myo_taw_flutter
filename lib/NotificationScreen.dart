import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/database/NotificationDb.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/helper/ServiceHelper.dart';
import 'package:myotaw/helper/ShowDateTimeHelper.dart';
import 'package:myotaw/model/NotificationModel.dart';
import 'package:myotaw/myWidget/CustomProgressIndicator.dart';
import 'package:myotaw/myWidget/NativeProgressIndicator.dart';
import 'package:myotaw/myWidget/NativePullRefresh.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier.dart';
import 'helper/FireBaseAnalyticsHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/PlatformHelper.dart';
import 'model/UserModel.dart';
import 'helper/SharePreferencesHelper.dart';
import 'Database/UserDb.dart';
import 'package:async_loader/async_loader.dart';
import 'package:myotaw/myWidget/NoConnectionWidget.dart';
import 'package:myotaw/myWidget/EmptyViewWidget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/NotificationDetailScreen.dart';

import 'myWidget/CustomDialogWidget.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with AutomaticKeepAliveClientMixin<NotificationScreen> {
  UserModel _userModel;
  UserDb _userDb = UserDb();

  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  String _city, _regionCode;
  bool _isLoading = false;
  var response;
  List<NotificationModel> _notificationList = new List<NotificationModel>();
  List _notificationModelList = new List();
  GlobalKey<SliverAnimatedListState> _globalKey = GlobalKey();
  NotificationDb _notificationDb = NotificationDb();
  Notifier _notifier;
  bool _isClear = false, _isCheck = false;
  List<NotificationModel> _deleteList = List();


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
        await _notificationDb.openNotificationDb();
        //_notificationDb.deleteNotification();
        var l = await _notificationDb.getNotification();
        if(l.length == 0){
          for(var i in _notificationModelList){
            //_notificationList.add(NotificationModel.fromJson(i));
            bool isSave = await _notificationDb.isNotificationSaved(NotificationModel.fromJson(i).iD);
            NotificationModel model = NotificationModel.fromJson(i);
            model.isSeen = true;
            if(!isSave){
              _notificationDb.insert(model);
            }
          }
        }else{
          for(var i in _notificationModelList){
            //_notificationList.add(NotificationModel.fromJson(i));
            bool isSave = await _notificationDb.isNotificationSaved(NotificationModel.fromJson(i).iD);
            if(!isSave){
              _notificationDb.insert(NotificationModel.fromJson(i));
            }
          }
        }
        var list = await _notificationDb.getNotification();
        _notificationList.addAll(list);
        var count = await _notificationDb.getUnReadNotificationCount();
        _notificationDb.closeSaveNotificationDb();
        _notifier.notify('noti_count', count);
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
            ),
            _isClear?IconButton(icon: Icon(Icons.clear), onPressed: (){
              setState(() {
                _isClear = false;
                _isCheck = false;
              });
            }) : Container(),
            _isClear?_deleteList.isNotEmpty?IconButton(icon: Icon(Icons.delete), onPressed: ()async{
              setState(() {
                _isLoading = true;
              });
              for(var i in _deleteList){
                await _notificationDb.openNotificationDb();
                await _notificationDb.insert(i);
                _notificationDb.closeSaveNotificationDb();
                setState(() {
                  _isClear = false;
                  _isCheck = false;
                });
              }
              setState(() {
                _isLoading = false;
              });
            }) : Container() : Container(),

          ],
        )
      ],
    ));
  }

  Widget _notificationListWidget(NotificationModel model,Animation animation, [int i]){
    String datetime = model.postedDate;
    String date = ShowDateTimeHelper.showDateTimeDifference(datetime)??'';
    
    return ScaleTransition(
      scale: CurvedAnimation(parent: animation, curve: Interval(0.2, 1)),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Interval(0.2, 1)),
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.only(top: i == _notificationList.length? 0 : 1, left: 0, right: 0, bottom: 0),
          elevation: 0.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
            leading: Image.asset(model.isSeen?"images/noti_open.png" : 'images/noti_close.png', width: 30.0, height: 30.0,),
            trailing: !_isCheck?IconButton(
                icon: Icon(PlatformHelper.isAndroid()?Icons.delete :CupertinoIcons.delete_solid, color: Colors.red,),
                onPressed: (){
                  CustomDialogWidget().customConfirmDialog(
                      context: context,
                      content: MyString.txt_are_u_sure,
                      textYes: MyString.txt_delete,
                      textNo: MyString.txt_delete_cancel,
                      img: PlatformHelper.isAndroid()? 'bin.png' : 'iosbin.png',
                      onPress: ()async{
                        await _notificationDb.openNotificationDb();
                        NotificationModel notificationModel = _notificationList[i];
                        notificationModel.isDeleted = true;
                        await _notificationDb.updateNotification(notificationModel);
                        var count =await _notificationDb.getUnReadNotificationCount();
                        _notificationDb.closeSaveNotificationDb();
                        _notifier.notify('noti_count', count);
                        Navigator.of(context).pop();
                        Future.delayed(Duration(milliseconds: 200),(){
                          setState(() {
                            var noti = _notificationList.removeAt(i);
                            _globalKey.currentState.removeItem(i, (context, animation){
                              return _notificationListWidget(noti, animation);
                            },duration: Duration(milliseconds: 500));
                          });
                        });
                      }
                  );
                }
            ) : IconButton(icon: Icon(Icons.check_box, color: model.isCheck? MyColor.colorPrimary : MyColor.colorGreyDark,), onPressed: (){
              setState(() {
                model.isCheck = !model.isCheck;
                if(model.isCheck){
                  NotificationModel deleteModel = model;
                  deleteModel.isDeleted = true;
                  setState(() {
                    _deleteList.add(deleteModel);
                  });
                }else{
                  setState(() {
                    _deleteList.remove(model);
                  });
                }
              });
            }),
            title: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(model.message, style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorBlackSemiTransparent), maxLines: 2,overflow: TextOverflow.ellipsis,)),
            subtitle: Text(date, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextGrey),),
            onLongPress: (){
              print('longepress');
              setState(() {
                _isClear = true;
                _isCheck = true;
              });
            },
            onTap: ()async{
              await _notificationDb.openNotificationDb();
              NotificationModel notificationModel = model;
              notificationModel.isSeen = true;
              await _notificationDb.updateNotification(notificationModel);
              var count = await _notificationDb.getUnReadNotificationCount();
              _notifier.notify('noti_count', count);
              _notificationDb.closeSaveNotificationDb();
              setState(() {
                model.isSeen = true;
              });
              NavigatorHelper.MyNavigatorPush(context, NotificationDetailScreen(model), ScreenName.NOTIFICATION_DETAIL_SCREEN);
            },
          ),
        ),
      ),
    );
  }

  /*_listView(){
    return AnimatedList(
      key: _globalKey,
      initialItemCount: _notificationList.length,
      itemBuilder: (context, i, animation){
        return _notificationListWidget(_notificationList[i], animation, i);
        *//*return Column(
          children: <Widget>[
            i==0? _headerNotification():Container(),
            _notificationListWidget(_notificationList[i], animation, i)
          ],
        );*//*
      },
    );
    *//*return ListView.builder(
      itemCount: _notificationList.length,
      itemBuilder: (BuildContext context, int i){
        return Column(
          children: <Widget>[
            i==0? _headerNotification():Container(),
            _notificationListWidget(i)
          ],
        );
      },
    );*//*
  }*/

  Future<Null> _handleRefresh() async {
    _notificationList.clear();
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _notifier = NotifierProvider.of(context);
    print(_notificationList);
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => _getUser(),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => noConnectionWidget(asyncLoaderState),
        renderSuccess: ({data}) => NativePullRefresh(
            child: _notificationList.isNotEmpty?CustomScrollView(
              slivers: <Widget>[
                SliverList(delegate: SliverChildBuilderDelegate((context, i){
                  return _headerNotification();
                }, childCount: 1)),
                Notifier.of(context).register<Map<String, dynamic>>('noti_add', (value){
                  var data = value.data;
                  if(data != null){
                    _notificationList.insert(0, NotificationModel.fromJson(value.data));
                    //_globalKey.currentState.insertItem(0,duration: Duration(milliseconds: 500));
                  }
                  return SliverAnimatedList(itemBuilder: (context, i, animation){
                    return _notificationListWidget(_notificationList[i], animation, i);
                  }, initialItemCount: _notificationList.length,key: _globalKey,);
                })
              ],
            ) :
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
            Container(margin: EdgeInsets.only(top: 10.0),child: NativeProgressIndicator())
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
