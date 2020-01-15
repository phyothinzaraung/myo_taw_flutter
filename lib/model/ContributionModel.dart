class ContributionModel {
  int _iD;
  String _subject;
  String _message;
  String _photoUrl;
  String _uniqueKey;
  String _userName;
  String _userPhoneNo;
  String _latitude;
  String _longitude;
  String _source;
  String _regionCode;
  bool _isRead;
  bool _fixed;
  String _accesstime;
  bool _isDeleted;
  bool _isWardAdmin;
  String _wardName;

  ContributionModel(
      {int iD,
        String subject,
        String message,
        String photoUrl,
        String uniqueKey,
        String userName,
        String userPhoneNo,
        String latitude,
        String longitude,
        String source,
        String regionCode,
        bool isRead,
        bool fixed,
        String accesstime,
        bool isDeleted,
        bool isWardAdmin,
        String wardName}) {
    this._iD = iD;
    this._subject = subject;
    this._message = message;
    this._photoUrl = photoUrl;
    this._uniqueKey = uniqueKey;
    this._userName = userName;
    this._userPhoneNo = userPhoneNo;
    this._latitude = latitude;
    this._longitude = longitude;
    this._source = source;
    this._regionCode = regionCode;
    this._isRead = isRead;
    this._fixed = fixed;
    this._accesstime = accesstime;
    this._isDeleted = isDeleted;
    this._isWardAdmin = isWardAdmin;
    this._wardName = wardName;
  }

  int get iD => _iD;
  set iD(int iD) => _iD = iD;
  String get subject => _subject;
  set subject(String subject) => _subject = subject;
  String get message => _message;
  set message(String message) => _message = message;
  String get photoUrl => _photoUrl;
  set photoUrl(String photoUrl) => _photoUrl = photoUrl;
  String get uniqueKey => _uniqueKey;
  set uniqueKey(String uniqueKey) => _uniqueKey = uniqueKey;
  String get userName => _userName;
  set userName(String userName) => _userName = userName;
  String get userPhoneNo => _userPhoneNo;
  set userPhoneNo(String userPhoneNo) => _userPhoneNo = userPhoneNo;
  String get latitude => _latitude;
  set latitude(String latitude) => _latitude = latitude;
  String get longitude => _longitude;
  set longitude(String longitude) => _longitude = longitude;
  String get source => _source;
  set source(String source) => _source = source;
  String get regionCode => _regionCode;
  set regionCode(String regionCode) => _regionCode = regionCode;
  bool get isRead => _isRead;
  set isRead(bool isRead) => _isRead = isRead;
  bool get fixed => _fixed;
  set fixed(bool fixed) => _fixed = fixed;
  String get accesstime => _accesstime;
  set accesstime(String accesstime) => _accesstime = accesstime;
  bool get isDeleted => _isDeleted;
  set isDeleted(bool isDeleted) => _isDeleted = isDeleted;
  bool get isWardAdmin => _isWardAdmin;
  set isWardAdmin(bool isWardAdmin) => _isWardAdmin = isWardAdmin;
  String get wardName => _wardName;
  set wardName(String wardName) => _wardName = wardName;

  ContributionModel.fromJson(Map<String, dynamic> json) {
    _iD = json['ID'];
    _subject = json['Subject'];
    _message = json['Message'];
    _photoUrl = json['PhotoUrl'];
    _uniqueKey = json['UniqueKey'];
    _userName = json['UserName'];
    _userPhoneNo = json['UserPhoneNo'];
    _latitude = json['Latitude'];
    _longitude = json['Longitude'];
    _source = json['Source'];
    _regionCode = json['RegionCode'];
    _isRead = json['IsRead'];
    _fixed = json['Fixed'];
    _accesstime = json['Accesstime'];
    _isDeleted = json['IsDeleted'];
    _isWardAdmin = json['IsWardAdmin'];
    _wardName = json['WardName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this._iD;
    data['Subject'] = this._subject;
    data['Message'] = this._message;
    data['PhotoUrl'] = this._photoUrl;
    data['UniqueKey'] = this._uniqueKey;
    data['UserName'] = this._userName;
    data['UserPhoneNo'] = this._userPhoneNo;
    data['Latitude'] = this._latitude;
    data['Longitude'] = this._longitude;
    data['Source'] = this._source;
    data['RegionCode'] = this._regionCode;
    data['IsRead'] = this._isRead;
    data['Fixed'] = this._fixed;
    data['Accesstime'] = this._accesstime;
    data['IsDeleted'] = this._isDeleted;
    data['IsWardAdmin'] = this._isWardAdmin;
    data['WardName'] = this._wardName;
    return data;
  }
}
