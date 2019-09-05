
class ReferralModel{
  int _referId;
  String _referPhNo;
  String _userPhNo;
  double _balance;
  bool _paid;
  String _application;
  bool _validity;
  String _accessTime;
  bool _isDeleted;
  String _createDate;
  String _referDate;
  String _imei;

  ReferralModel();


  int get referId => _referId;

  set referId(int value) {
    _referId = value;
  }

  String get referPhNo => _referPhNo;

  set referPhNo(String value) {
    _referPhNo = value;
  }

  String get userPhNo => _userPhNo;

  set userPhNo(String value) {
    _userPhNo = value;
  }

  double get balance => _balance;

  set balance(double value) {
    _balance = value;
  }

  bool get paid => _paid;

  set paid(bool value) {
    _paid = value;
  }

  String get application => _application;

  set application(String value) {
    _application = value;
  }

  bool get validity => _validity;

  set validity(bool value) {
    _validity = value;
  }

  String get accessTime => _accessTime;

  set accessTime(String value) {
    _accessTime = value;
  }

  bool get isDeleted => _isDeleted;

  set isDeleted(bool value) {
    _isDeleted = value;
  }

  String get createDate => _createDate;

  set createDate(String value) {
    _createDate = value;
  }

  String get referDate => _referDate;

  set referDate(String value) {
    _referDate = value;
  }

  String get imei => _imei;

  set imei(String value) {
    _imei = value;
  }

  ReferralModel.fromJson(Map<String, dynamic> json) :
        _referId = json['ReferId'],
        _referPhNo = json['ReferralPhoneNumber'],
        _userPhNo = json['UserPhoneNumber'],
        _balance = json['Balance'],
        _paid = json['Paid'],
        _application = json['Application'],
        _validity = json['Validity'],
        _accessTime = json['Accesstime'],
        _isDeleted = json['IsDeleted'],
        _createDate = json['CreateDate'],
        _referDate = json['ReferDate'],
        _imei = json['IMEI'];
}