import 'package:flutter/material.dart';
import 'package:myotaw/helper/ShowDateTimeHelper.dart';
import 'package:myotaw/model/NotificationModel.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';

class NotificationDetailScreen extends StatefulWidget{
  NotificationModel notificationModel;
  NotificationDetailScreen(this.notificationModel);

  @override
  _NotificationDetailScreenState createState() => _NotificationDetailScreenState(this.notificationModel);
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen>{

  NotificationModel _notificationModel;

  String _message, _date;

  _NotificationDetailScreenState(this._notificationModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNotificationData();
  }

  initNotificationData(){
    setState(() {
      _message = _notificationModel.message;
      _date = ShowDateTimeHelper.showDateTimeDifference(_notificationModel.postedDate);

    });
  }

  Widget _body(BuildContext context){
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset('images/calendar.png', width: 18.0, height: 18.0,),
              Text(" " + _date, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextGrey),)
            ],
          ),
          Text(_message, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorBlackSemiTransparent)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomScaffoldWidget(
      title: Text(MyString.txt_title_notification,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal),),
      body: _body(context),
    );
  }

}