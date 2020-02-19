import 'package:myotaw/helper/DbHelper.dart';
class NotificationModel{
//  String _title;
//  String _body;
//
//  NotificationModel();
//
//
//  String get title => _title;
//
//  set title(String value) {
//    _title = value;
//  }
//
//  NotificationModel.fromMap(Map<String, dynamic> map):
//        _title = map[DbHelper.COLUMN_SAVE_NF_TITLE],
//        _body = map[DbHelper.COLUMN_SAVE_NF_BODY];
//
//  String get body => _body;
//
//  set body(String value) {
//    _body = value;
//  }

    int _id;
    String _message;
    String _regionCode;
    String _postedDate;
    String _adminID;
    String _adminName;
    String _accessTime;
    bool _isDeleted;


    int get id => _id;

    set id(int value) {
      _id = value;
    }

    String get message => _message;

    set message(String value) {
      _message = value;
    }

    String get regionCode => _regionCode;

    set regionCode(String value) {
      _regionCode = value;
    }

    String get postedDate => _postedDate;

    set postedDate(String value) {
      _postedDate = value;
    }

    String get adminID => _adminID;

    set adminID(String value) {
      _adminID = value;
    }

    String get adminName => _adminName;

    set adminName(String value) {
      _adminName = value;
    }

    String get accessTime => _accessTime;

    set accessTime(String value) {
      _accessTime = value;
    }

    bool get isDeleted => _isDeleted;

    set isDeleted(bool value) {
      _isDeleted = value;
    }

    NotificationModel.fromJson(Map<String, dynamic> json) :
          _id = json['ID'],
          _message = json['Message'],
          _regionCode = json['RegionCode'],
          _postedDate = json['PostedDate'],
          _adminID = json['AdminID'],
          _adminName = json['AdminName'],
          _accessTime = json['Accesstime'],
          _isDeleted = json['IsDeleted'];

}