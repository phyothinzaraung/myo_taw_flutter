import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:myotaw/database/NotificationDb.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/helper/ShowDateTimeHelper.dart';
import 'package:myotaw/model/ApplyBizLicenseModel.dart';
import 'package:myotaw/model/NotificationModel.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ApplyBizLicensePhotoListScreen.dart';
import 'myWidget/CustomButtonWidget.dart';

class NotificationDetailScreen extends StatefulWidget{
  NotificationModel notificationModel;
  NotificationDetailScreen(this.notificationModel);

  @override
  _NotificationDetailScreenState createState() => _NotificationDetailScreenState(this.notificationModel);
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen>{

  NotificationModel _notificationModel;
  NotificationDb _notificationDb = NotificationDb();
  String _message, _date;
  List _list;
  Notifier _notifier;

  _NotificationDetailScreenState(this._notificationModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNotificationData();
    _readNotification(_notificationModel);
  }

  initNotificationData(){
    setState(() {
      _message = _notificationModel.message;
      _list = _message.split('-');
      _date = ShowDateTimeHelper.showDateTimeDifference(_notificationModel.postedDate);
    });
    print('bizid : ${_notificationModel.bizId}');
  }

  _readNotification(NotificationModel model)async{
    await _notificationDb.openNotificationDb();
    var isSeen = await _notificationDb.isSeenById(model);
    if(!isSeen){
      model.isSeen = true;
      await _notificationDb.updateNotification(model);
      var count = await _notificationDb.getUnReadNotificationCount();
      _notifier.notify('noti_count', count);
    }
    _notificationDb.closeSaveNotificationDb();
  }

  Widget _body(BuildContext context){
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Image.asset('images/calendar.png', width: 18.0, height: 18.0,)),
                Text(_date, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextGrey),)
              ],
            ),
          ),
          Expanded(
            //child: Text(_message, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorBlackSemiTransparent))
            child: Linkify(text: _message.contains(MyString.txt_noti_biz_license)? _list[1] : _message,onOpen: (link)async{
              if(await canLaunch(link.url)){
                await launch(link.url);
              }
            },linkStyle: TextStyle(color: Colors.red),),
          ),
          _message.contains(MyString.txt_noti_biz_license)?Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(bottom: 10.0),
            child: CustomButtonWidget(
              onPress: ()async{
                ApplyBizLicenseModel model = ApplyBizLicenseModel();
                model.id = _notificationModel.bizId;
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
    return CustomScaffoldWidget(
      title: Text(MyString.txt_title_notification,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal),),
      body: _body(context),
    );
  }

}