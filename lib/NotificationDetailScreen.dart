import 'package:async_loader/async_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/helper/ShowDateTimeHelper.dart';
import 'package:myotaw/model/ApplyBizLicenseModel.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ApplyBizLicensePhotoListScreen.dart';
import 'helper/ServiceHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'model/NotificationModel.dart';
import 'myWidget/CustomButtonWidget.dart';
import 'myWidget/NativeProgressIndicator.dart';
import 'myWidget/NoConnectionWidget.dart';

class NotificationDetailScreen extends StatefulWidget{
  int id;
  NotificationDetailScreen(this.id);

  @override
  _NotificationDetailScreenState createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen>{

  String _message, _date;
  List _list;
  NotificationModel _notificationModel;
  Notifier _notifier;
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_readNotification(_notificationModel);
  }

  _getNotiDetail()async{
    await _sharepreferenceshelper.initSharePref();
    var response = await ServiceHelper().getNotificationDetail(_sharepreferenceshelper.getUserUniqueKey(), widget.id.toString());
    if(response.data != null) {
      _notificationModel = NotificationModel.fromJson(response.data);
      _message = _notificationModel.message;
      _list = _message.split('-');
      _date = ShowDateTimeHelper.showDateTimeDifference(_notificationModel.postedDate);
    }
  }

  Widget _body(){
    return Container(
      //padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
      color: Colors.white,
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
            //padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
            child: Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Image.asset('images/calendar.png', width: 18.0, height: 18.0,)),
                Text(_date, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextGrey),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30, right: 30, bottom: 50),
            child: Linkify(text: _message.contains(MyString.txt_noti_biz_license)? _list[1] : _message,onOpen: (link)async{
              if(await canLaunch(link.url)){
                await launch(link.url);
              }
            },linkStyle: TextStyle(color: Colors.red),),
          ),
          _message.contains(MyString.txt_noti_biz_license)?Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(left: 30, right: 30,),
            child: CustomButtonWidget(
              onPress: ()async{
                ApplyBizLicenseModel model = ApplyBizLicenseModel();
                model.id = _notificationModel.bizID;
                print('apply biz id : ${model.id}');
                NavigatorHelper.myNavigatorPush(context, ApplyBizLicensePhotoListScreen(model), ScreenName.APPLY_BIZ_LICENSE_PHOTO_LIST_SCREEN);

              }, child: Text(MyString.txt_upload_need_apply_biz_file, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
              color: MyColor.colorPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              borderRadius: BorderRadius.circular(10),
            ),
          ) : Container()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _notifier = NotifierProvider.of(context);
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await _getNotiDetail(),
        renderLoad: () => Container(
          margin: EdgeInsets.only(top: 10),
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              NativeProgressIndicator()
            ],
          ),
        ),
        renderError: ([error]) => noConnectionWidget(asyncLoaderState),
        renderSuccess: ({data}) => _body()
    );
    return CustomScaffoldWidget(
      title: Text(MyString.txt_title_notification,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal),),
      body: _asyncLoader,
    );
  }

}