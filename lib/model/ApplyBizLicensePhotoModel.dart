
class ApplyBizLicensePhotoModel{
  int _id;
  int _appBizId;
  String _title;
  String _photoUrl;
  String _accessTime;
  bool _isDeleted;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get title => _title;

  bool get isDeleted => _isDeleted;

  set isDeleted(bool value) {
    _isDeleted = value;
  }

  String get accessTime => _accessTime;

  set accessTime(String value) {
    _accessTime = value;
  }

  String get photoUrl => _photoUrl;

  set photoUrl(String value) {
    _photoUrl = value;
  }

  set title(String value) {
    _title = value;
  }


  int get appBizId => _appBizId;

  set appBizId(int value) {
    _appBizId = value;
  }

  ApplyBizLicensePhotoModel.fromJson(Map<String, dynamic> json):
      _id = json['ID'],
      _appBizId = json['ApBizID'],
      _title = json['Title'],
      _photoUrl = json['PhotoUrl'],
      _accessTime = json['Accesstime'],
      _isDeleted = json['IsDeleted'];

}