import 'NewsFeedModel.dart';

class NewsFeedReactModel{
  NewsFeedModel _newsFeedModel;
  String _reactType;
  List<dynamic> _photoList;

  NewsFeedModel get newsFeedModel => _newsFeedModel;

  set newsFeedModel(NewsFeedModel value) {
    _newsFeedModel = value;
  }

  String get reactType => _reactType;

  set reactType(String value) {
    _reactType = value;
  }


  List<dynamic> get photoList => _photoList;

  set photoList(List<dynamic> value) {
    _photoList = value;
  }

  NewsFeedReactModel.fromJson(Map<String, dynamic> json):
      _newsFeedModel = NewsFeedModel.fromJson(json['Article']),
      _reactType = json['reacttype'],
      _photoList = List<dynamic>.from(json['PhotoLink']!=null?json['PhotoLink'] : []);
}