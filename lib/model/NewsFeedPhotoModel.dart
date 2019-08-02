class NewsFeedPhotoModel{
  int _id;
  String _uniqueKey;
  int _organizationId;
  String _newsFeedId;
  String _photoUrl;
  String _accesstime;
  bool _isDeleted;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get uniqueKey => _uniqueKey;

  bool get isDeleted => _isDeleted;

  set isDeleted(bool value) {
    _isDeleted = value;
  }

  String get accesstime => _accesstime;

  set accesstime(String value) {
    _accesstime = value;
  }

  String get photoUrl => _photoUrl;

  set photoUrl(String value) {
    _photoUrl = value;
  }

  String get newsFeedId => _newsFeedId;

  set newsFeedId(String value) {
    _newsFeedId = value;
  }

  int get organizationId => _organizationId;

  set organizationId(int value) {
    _organizationId = value;
  }

  set uniqueKey(String value) {
    _uniqueKey = value;
  }

  NewsFeedPhotoModel.fromJson(Map<String, dynamic> json):
        _id = json['ID'],
        _uniqueKey = json['UniqueKey'],
        _organizationId = json['OrganizationID'],
        _newsFeedId = json['NewsFeedID'],
        _photoUrl = json['PhotoUrl'],
        _accesstime = json['Accesstime'],
        _isDeleted = json['IsDeleted'];
}