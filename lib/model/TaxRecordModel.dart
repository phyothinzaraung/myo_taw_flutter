
class TaxRecordModel{
  int _id;
  String _photoUrl;
  String _subject;
  String _postedDate;
  String _uniqueKey;
  String _userName;
  String _regionCode;
  String _accessTime;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get photoUrl => _photoUrl;

  String get accessTime => _accessTime;

  set accessTime(String value) {
    _accessTime = value;
  }

  String get regionCode => _regionCode;

  set regionCode(String value) {
    _regionCode = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get uniqueKey => _uniqueKey;

  set uniqueKey(String value) {
    _uniqueKey = value;
  }

  String get postedDate => _postedDate;

  set postedDate(String value) {
    _postedDate = value;
  }

  String get subject => _subject;

  set subject(String value) {
    _subject = value;
  }

  set photoUrl(String value) {
    _photoUrl = value;
  }

  TaxRecordModel.fromJson(Map<String, dynamic> json) :
  _id = json['ID'],
  _photoUrl = json['PhotoUrl'],
  _subject = json['Subject'],
  _postedDate = json['PostedDate'],
  _uniqueKey = json['UniqueKey'],
  _userName = json['UserName'],
  _regionCode = json['RegionCode'],
  _accessTime = json['Accesstime'];
}