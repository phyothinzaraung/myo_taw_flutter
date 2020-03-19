import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/database/NotificationDb.dart';
import 'package:myotaw/helper/MyoTawCitySetUpHelper.dart';
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

class _NotificationScreenState extends State<NotificationScreen> with AutomaticKeepAliveClientMixin<NotificationScreen>, TickerProviderStateMixin {
  UserModel _userModel;
  UserDb _userDb = UserDb();

  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  String _city, _regionCode;
  bool _isLoading = false;
  var response;
  List<NotificationModel> _notificationList = new List<NotificationModel>();
  List<NotificationModel> _notificationDeleteList = new List<NotificationModel>();
  GlobalKey<SliverAnimatedListState> _globalKey = GlobalKey();
  NotificationDb _notificationDb = NotificationDb();
  Notifier _notifier;
  bool _isLongPress = false, _isSelectAll = false;
  AnimationController _animatinController;
  Tween<double> _tween = Tween(begin: 1, end: 1.3);


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
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    _userDb.closeUserDb();
    setState(() {
      _userModel = model;
    });
    _city = MyoTawCitySetUpHelper.getCity(_sharepreferenceshelper.getRegionCode());
    await _getNotifications();
  }


  _getNotifications() async{
    await _sharepreferenceshelper.initSharePref();
    _regionCode = _sharepreferenceshelper.getRegionCode();
    try{
      response = await ServiceHelper().getNotification(_regionCode);
      if(response.data != null) {
        var result  = response.data;
        await _notificationDb.openNotificationDb();
        var l = await _notificationDb.getNotification();
        for(var i in result){
          bool isSave = await _notificationDb.isNotificationSaved(NotificationModel.fromJson(i).iD);
          if(!isSave){
            _notificationDb.insert(NotificationModel.fromJson(i));
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

  Widget _notificationListWidget(NotificationModel model,Animation animation, [int i]){
    String datetime = model.postedDate;
    String date = ShowDateTimeHelper.showDateTimeDifference(datetime);

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
            leading: ScaleTransition(
                scale: _tween.animate(CurvedAnimation(parent: _animatinController, curve: Curves.linearToEaseOut)),
                child: Image.asset(model.isSeen?"images/noti_open.png" : 'images/noti_close.png', width: 30.0, height: 30.0,)),
            trailing: !_isLongPress?IconButton(
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
                        var count = await _notificationDb.getUnReadNotificationCount();
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
            ) : IconButton(icon: Icon(PlatformHelper.isAndroid()? Icons.check_circle : CupertinoIcons.check_mark_circled), onPressed: (){
              setState(() {
                model.isCheck = !model.isCheck;
                NotificationModel _model = model;
                _model.listIndex = i;
                model.isCheck? _notificationDeleteList.add(_model) : _notificationDeleteList.remove(_model);
                //model.isCheck? _animatinController.repeat(reverse: true) : _animatinController.animateTo(0);
              });
              print(_notificationDeleteList.length);
            },color: model.isCheck==true? MyColor.colorPrimary : MyColor.colorGreyDark),
            title: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(model.message, style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorBlackSemiTransparent), maxLines: 2,overflow: TextOverflow.ellipsis,)),
            subtitle: Text(date, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextGrey),),
            onTap: ()async{

              if(!_isLongPress){
                //await _readNotification(model);
                setState(() {
                  model.isSeen = true;
                });
                NavigatorHelper.myNavigatorPush(context, NotificationDetailScreen(model), ScreenName.NOTIFICATION_DETAIL_SCREEN);

              }else{
                _clearCheckNotification();
              }
            },
            onLongPress: (){
              _animatinController.repeat(reverse: true);
              setState(() {
                _isLongPress = true;
              });
            },
          ),
        ),
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
                _isLongPress?GestureDetector(
                  onTap: (){
                    _notificationDeleteList.clear();
                    _isSelectAll = !_isSelectAll;
                    if(_isSelectAll){
                      for(var i in _notificationList){
                        setState(() {
                          i.isCheck = true;
                          _notificationDeleteList.add(i);
                        });
                      }
                    }else{
                      for(var i in _notificationList){
                        setState(() {
                          i.isCheck = false;
                          _notificationDeleteList.remove(i);
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 10,right: 10,top: 3, bottom: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: MyColor.colorPrimary
                    ),
                    child: Text(MyString.txt_select_all, style: TextStyle(color: Colors.white,fontSize: FontSize.textSizeLessSmall)),
                  ),
                ) : Container(),
                _notificationDeleteList.isNotEmpty?
                Row(
                  children: <Widget>[
                    GestureDetector(
                        onTap: ()async{
                          setState(() {
                            _isLoading = true;
                          });
                          await _notificationDb.openNotificationDb();
                          for(var i in _notificationDeleteList){
                            NotificationModel notificationModel = i;
                            notificationModel.isSeen = true;
                            notificationModel.isCheck = false;
                            await _notificationDb.updateNotification(notificationModel);
                          }
                          var count = await _notificationDb.getUnReadNotificationCount();
                          _notificationDb.closeSaveNotificationDb();
                          _notifier.notify('noti_count', count);
                          setState(() {
                            _notificationDeleteList.clear();
                            _isLoading = false;
                            _isLongPress = false;
                          });
                          _animatinController.animateBack(0);
                        },
                        child: Container(
                            margin: EdgeInsets.only(left: 20,right: 5),
                            child: Image.asset('images/noti_open.png',width: 20, height: 20,))
                    ),
                    IconButton(icon: Icon(PlatformHelper.isAndroid()?Icons.delete : CupertinoIcons.delete_solid),
                      onPressed: ()async{

                        setState(() {
                          _isLoading = true;
                        });
                        await _notificationDb.openNotificationDb();
                        for(var i in _notificationDeleteList){
                          NotificationModel notificationModel = i;
                          notificationModel.isDeleted = true;
                          await _notificationDb.updateNotification(notificationModel);
                          /*var noti = _notificationList.removeAt(i.listIndex);
                        _globalKey.currentState.removeItem(i.listIndex, (context, animation){
                          return _notificationListWidget(noti, animation);
                        },);*/
                        }
                        var count = await _notificationDb.getUnReadNotificationCount();
                        _notificationDb.closeSaveNotificationDb();
                        _notifier.notify('noti_count', count);
                        setState(() {
                          _notificationDeleteList.clear();
                          _isLoading = false;
                          _isLongPress = false;
                        });
                        _notificationList.clear();
                        asyncLoaderState.currentState.reloadState();
                        _animatinController.animateBack(0);

                      },color: Colors.red,),
                  ],
                ) : Container(),
              ],
            ),

          ],
        ));
  }

  /*_listView(){
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
  }*/

  Future<Null> _handleRefresh() async {
    _notificationList.clear();
    asyncLoaderState.currentState.reloadState();
    return null;
  }


  _clearCheckNotification(){
    _animatinController.animateBack(0);
    for(var i in _notificationList){
      i.isCheck = false;
    }
    setState(() {
      _isLongPress = false;
      _notificationDeleteList.clear();
    });
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
            _headerNotification(),
            Expanded(child: noConnectionWidget(asyncLoaderState))
          ],
        ),
        renderSuccess: ({data}) => NativePullRefresh(
            child: _notificationList.isNotEmpty?
            GestureDetector(
              onTap: (){
                _clearCheckNotification();
              },
              child: Notifier.of(context).register('noti_add', (value){

                var data = value.data;

                if(data != null && _sharepreferenceshelper.isNotificationAdd() && NotificationModel.fromJson(data).message!='unCheckAll'){
                  _notificationList.insert(0, NotificationModel.fromJson(value.data));
                  _globalKey.currentState.insertItem(0, duration: Duration(milliseconds: 500));
                }
                if(data != null && NotificationModel.fromJson(data).message=='unCheckAll' && _sharepreferenceshelper.isNotificationUnCheck()){
                  for(var i in _notificationList){
                    i.isCheck = false;
                  }
                  _notificationDeleteList.clear();
                  _isLongPress = false;
                  _animatinController.animateBack(0);
                }
                _sharepreferenceshelper.setNotificationUnCheck(false);
                _sharepreferenceshelper.setNotificationAdd(false);

                return CustomScrollView(
                  slivers: <Widget>[
                    SliverList(delegate: SliverChildBuilderDelegate((context, i){
                      return _headerNotification();
                    }, childCount: 1)),
                    SliverAnimatedList(itemBuilder: (context, i, animation){
                      return _notificationListWidget(_notificationList[i], animation, i);
                    }, initialItemCount: _notificationList.length,key: _globalKey,)
                  ],
                );
              }),
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
    _animatinController.stop();
    _animatinController.dispose();
  }
}
