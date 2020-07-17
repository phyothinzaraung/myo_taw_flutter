class NewsFeedPhotoModel {
  int _iD;
  String _uniqueKey;
  int _organizationID;
  String _newsFeedID;
  String _photoUrl;
  String _accesstime;
  bool _isDeleted;
  String _title;

  NewsFeedPhotoModel(
      {int iD,
        String uniqueKey,
        int organizationID,
        String newsFeedID,
        String photoUrl,
        String accesstime,
        bool isDeleted,
        String title}) {
    this._iD = iD;
    this._uniqueKey = uniqueKey;
    this._organizationID = organizationID;
    this._newsFeedID = newsFeedID;
    this._photoUrl = photoUrl;
    this._accesstime = accesstime;
    this._isDeleted = isDeleted;
    this._title = title;
  }

  int get iD => _iD;
  set iD(int iD) => _iD = iD;
  String get uniqueKey => _uniqueKey;
  set uniqueKey(String uniqueKey) => _uniqueKey = uniqueKey;
  int get organizationID => _organizationID;
  set organizationID(int organizationID) => _organizationID = organizationID;
  String get newsFeedID => _newsFeedID;
  set newsFeedID(String newsFeedID) => _newsFeedID = newsFeedID;
  String get photoUrl => _photoUrl;
  set photoUrl(String photoUrl) => _photoUrl = photoUrl;
  String get accesstime => _accesstime;
  set accesstime(String accesstime) => _accesstime = accesstime;
  bool get isDeleted => _isDeleted;
  set isDeleted(bool isDeleted) => _isDeleted = isDeleted;
  String get title => _title;
  set title(String title) => _title = title;

  NewsFeedPhotoModel.fromJson(Map<String, dynamic> json) {
    _iD = json['ID'];
    _uniqueKey = json['UniqueKey'];
    _organizationID = json['OrganizationID'];
    _newsFeedID = json['NewsFeedID'];
    _photoUrl = json['PhotoUrl'];
    _accesstime = json['Accesstime'];
    _isDeleted = json['IsDeleted'];
    _title = json['Title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this._iD;
    data['UniqueKey'] = this._uniqueKey;
    data['OrganizationID'] = this._organizationID;
    data['NewsFeedID'] = this._newsFeedID;
    data['PhotoUrl'] = this._photoUrl;
    data['Accesstime'] = this._accesstime;
    data['IsDeleted'] = this._isDeleted;
    data['Title'] = this._title;
    return data;
  }
}