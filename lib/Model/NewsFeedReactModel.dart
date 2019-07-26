import 'NewsFeedModel.dart';

class NewsFeedReactModel{
  NewsFeedModel _newsFeedModel;
  String _reactType;

  NewsFeedModel get newsFeedModel => _newsFeedModel;

  set newsFeedModel(NewsFeedModel value) {
    _newsFeedModel = value;
  }

  String get reactType => _reactType;

  set reactType(String value) {
    _reactType = value;
  }

  NewsFeedReactModel.fromJson(Map<String, dynamic> json):
      _newsFeedModel = NewsFeedModel.fromJson(json['Article']),
      _reactType = json['reacttype'];
}