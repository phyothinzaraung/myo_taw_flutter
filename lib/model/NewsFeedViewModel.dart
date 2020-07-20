

import 'package:myotaw/model/NewsFeedModel.dart';
import 'package:myotaw/model/NewsFeedPhotoModel.dart';

class NewsFeedViewModel {
  NewsFeedModel _newsFeedModel;
  String _reacttype;
  List<NewsFeedPhotoModel> _photoModelList;

  NewsFeedViewModel(
      {NewsFeedModel article, String reacttype, List<NewsFeedPhotoModel> photoLink}) {
    this._newsFeedModel = article;
    this._reacttype = reacttype;
    this._photoModelList = photoLink;
  }

  NewsFeedModel get article => _newsFeedModel;
  set article(NewsFeedModel article) => _newsFeedModel = article;
  String get reacttype => _reacttype;
  set reacttype(String reacttype) => _reacttype = reacttype;
  List<NewsFeedPhotoModel> get photoLink => _photoModelList;
  set photoLink(List<NewsFeedPhotoModel> photoLink) => _photoModelList = photoLink;

  NewsFeedViewModel.fromJson(Map<String, dynamic> json) {
    _newsFeedModel =
    json['Article'] != null ? new NewsFeedModel.fromJson(json['Article']) : null;
    _reacttype = json['reacttype'];
    if (json['PhotoLink'] != null) {
      _photoModelList = new List<NewsFeedPhotoModel>();
      json['PhotoLink'].forEach((v) {
        _photoModelList.add(new NewsFeedPhotoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._newsFeedModel != null) {
      data['Article'] = this._newsFeedModel.toJson();
    }
    data['reacttype'] = this._reacttype;
    if (this._photoModelList != null) {
      data['PhotoLink'] = this._photoModelList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


