
class DaoModel{
  int _id;
  String _title;
  String _description;
  String _display;
  String _icon;
  String _regionCode;
  String _contact;
  String _remark;
  String _postedDate;
  int _adminId;
  String _adminName;
  String _deptType;
  String _accessTime;
  int _serial;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get title => _title;

  int get serial => _serial;

  set serial(int value) {
    _serial = value;
  }

  String get accessTime => _accessTime;

  set accessTime(String value) {
    _accessTime = value;
  }

  String get deptType => _deptType;

  set deptType(String value) {
    _deptType = value;
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

  String get remark => _remark;

  set remark(String value) {
    _remark = value;
  }

  String get contact => _contact;

  set contact(String value) {
    _contact = value;
  }

  String get regionCode => _regionCode;

  set regionCode(String value) {
    _regionCode = value;
  }

  String get icon => _icon;

  set icon(String value) {
    _icon = value;
  }

  String get display => _display;

  set display(String value) {
    _display = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  set title(String value) {
    _title = value;
  }

  DaoModel.formJson(Map<String, dynamic> json):
      _id = json['ID'],
      _title = json['Title'],
      _description = json['Description'],
      _display = json['Display'],
      _icon = json['Icon'],
      _regionCode = json['RegionCode'],
      _contact = json['Contact'],
      _remark = json['Remark'],
      _postedDate = json['PostedDate'],
      _adminId = json['AdminID'],
      _adminName = json['AdminName'],
      _deptType = json['DeptType'],
      _accessTime = json['Accesstime'],
      _serial = json['Serial'];


}