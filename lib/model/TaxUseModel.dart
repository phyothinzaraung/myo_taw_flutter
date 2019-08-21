class TaxUserModel{
  int _id;
  String _taxTitle;
  double _amount;
  String _budgetYear;
  String _photoUrl;
  String _regionCode;
  String _postedDate;
  int _adminId;
  String _adminName;
  String _accessTime;
  bool _isDelete;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get taxTitle => _taxTitle;

  bool get isDelete => _isDelete;

  set isDelete(bool value) {
    _isDelete = value;
  }

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

  String get postedDate => _postedDate;

  set postedDate(String value) {
    _postedDate = value;
  }

  String get regionCode => _regionCode;

  set regionCode(String value) {
    _regionCode = value;
  }

  String get photoUrl => _photoUrl;

  set photoUrl(String value) {
    _photoUrl = value;
  }

  String get budgetYear => _budgetYear;

  set budgetYear(String value) {
    _budgetYear = value;
  }

  double get amount => _amount;

  set amount(double value) {
    _amount = value;
  }

  set taxTitle(String value) {
    _taxTitle = value;
  }

  TaxUserModel.fromJson(Map<String, dynamic> json) :
      _id = json['ID'],
      _taxTitle = json['TaxTitle'],
      _amount = json['Amount'],
      _budgetYear = json['BudgetYear'],
      _photoUrl = json['PhotoUrl'],
      _regionCode = json['RegionCode'],
      _postedDate = json['PostedDate'],
      _adminId = json['AdminID'],
      _adminName = json['AdminName'],
      _accessTime = json['Accesstime'],
      _isDelete = json['IsDeleted'];


}