import 'package:myotaw/helper/DbHelper.dart';
class NotificationModel{
  String _title;
  String _body;

  NotificationModel();


  String get title => _title;

  set title(String value) {
    _title = value;
  }

  NotificationModel.fromMap(Map<String, dynamic> map):
        _title = map[DbHelper.COLUMN_SAVE_NF_TITLE],
        _body = map[DbHelper.COLUMN_SAVE_NF_BODY];

  String get body => _body;

  set body(String value) {
    _body = value;
  }
}