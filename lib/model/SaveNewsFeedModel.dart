import 'package:myotaw/helper/DbHelper.dart';
class SaveNewsFeedModel{
  String _id;
  String _title;
  String _body;
  String _photoUrl;
  String _videoUrl;
  String _thumbNail;
  String _accessTime;

  SaveNewsFeedModel();

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get title => _title;

  String get accessTime => _accessTime;

  set accessTime(String value) {
    _accessTime = value;
  }

  String get thumbNail => _thumbNail;

  set thumbNail(String value) {
    _thumbNail = value;
  }

  String get videoUrl => _videoUrl;

  set videoUrl(String value) {
    _videoUrl = value;
  }

  String get photoUrl => _photoUrl;

  set photoUrl(String value) {
    _photoUrl = value;
  }

  String get body => _body;

  set body(String value) {
    _body = value;
  }

  set title(String value) {
    _title = value;
  }

  SaveNewsFeedModel.fromMap(Map<String, dynamic> map):
        _id = map[DbHelper.COLUMN_SAVE_NF_ID],
        _title = map[DbHelper.COLUMN_SAVE_NF_TITLE],
        _body = map[DbHelper.COLUMN_SAVE_NF_BODY],
        _photoUrl = map[DbHelper.COLUMN_SAVE_NF_PHOTO_URL],
        _videoUrl = map[DbHelper.COLUMN_SAVE_NF_VIDEO_URL],
        _thumbNail = map[DbHelper.COLUMN_SAVE_NF_THUMBNAIL],
        _accessTime = map[DbHelper.COLUMN_SAVE_NF_ACCESSTIME];
}