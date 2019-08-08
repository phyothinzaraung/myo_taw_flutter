
class FaqModel{
  int _id;
  String _question;
  String _answer;
  String _reference;
  String _postedDate;
  String _regionCode;
  int _adminId;
  String _adminName;
  String _accessTime;
  bool _isVisible = false;


  bool get isVisible => _isVisible;

  set isVisible(bool value) {
    _isVisible = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get question => _question;

  String get accessTime => _accessTime;

  set accessTime(String value) {
    _accessTime = value;
  }

  String get adminName => _adminName;

  set adminName(String value) {
    _adminName = value;
  }

  int get adminId => _adminId;

  set adminId(int value) {
    _adminId = value;
  }

  String get regionCode => _regionCode;

  set regionCode(String value) {
    _regionCode = value;
  }

  String get postedDate => _postedDate;

  set postedDate(String value) {
    _postedDate = value;
  }

  String get reference => _reference;

  set reference(String value) {
    _reference = value;
  }

  String get answer => _answer;

  set answer(String value) {
    _answer = value;
  }

  set question(String value) {
    _question = value;
  }

  FaqModel.fromJson(Map<String, dynamic> json) :
      _id = json['ID'],
      _question = json['Question'],
      _answer = json['Answer'],
      _reference = json['Reference'],
      _postedDate = json['PostedDate'],
      _regionCode = json['RegionCode'],
      _adminId = json['AdminID'],
      _adminName = json['AdminName'],
      _accessTime = json['Accesstime'];


}