
class BizLicenseModel{
  int _id;
  String _licenseType;
  String _requirements;
  int _serial;
  int _adminId;
  String _adminName;
  String _regionCode;
  String _reference;
  String _postedDate;
  String _accessTime;
  bool _isApplyAllow;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get licenseType => _licenseType;

  bool get isApplyAllow => _isApplyAllow;

  set isApplyAllow(bool value) {
    _isApplyAllow = value;
  }

  String get accessTime => _accessTime;

  set accessTime(String value) {
    _accessTime = value;
  }

  String get postedDate => _postedDate;

  set postedDate(String value) {
    _postedDate = value;
  }

  String get reference => _reference;

  set reference(String value) {
    _reference = value;
  }

  String get regionCode => _regionCode;

  set regionCode(String value) {
    _regionCode = value;
  }

  String get adminName => _adminName;

  set adminName(String value) {
    _adminName = value;
  }

  int get adminId => _adminId;

  set adminId(int value) {
    _adminId = value;
  }

  int get serial => _serial;

  set serial(int value) {
    _serial = value;
  }

  String get requirements => _requirements;

  set requirements(String value) {
    _requirements = value;
  }

  set licenseType(String value) {
    _licenseType = value;
  }

  BizLicenseModel.fromJson(Map<String, dynamic> json) :
      _id = json['ID'],
      _licenseType = json['LicenseType'],
      _requirements = json['Requirements'],
      _serial = json['Serial'],
      _adminId = json['AdminID'],
      _adminName = json['AdminName'],
      _regionCode = json['RegionCode'],
      _reference = json['Reference'],
      _postedDate = json['PostedDate'],
      _accessTime = json['Accesstime'],
      _isApplyAllow = json['IsApplyAllow'];

}
