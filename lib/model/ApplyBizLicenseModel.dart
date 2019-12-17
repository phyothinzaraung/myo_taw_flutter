class ApplyBizLicenseModel{
  int _id;
  String _licenseType;
  int _licensetypeId;
  String _bizName;
  String _bizType;
  double _length;
  double _width;
  double _area;
  String _bizRegionNo;
  String _bizStreetName;
  String _bizBlockNo;
  String _bizTownship;
  String _bizState;
  String _ownerName;
  String _nrcNo;
  String _phoneNo;
  String _regionNo;
  String _streetName;
  String _blockNo;
  String _township;
  String _state;
  String _remark;
  String _requiredData;
  String _applyDate;
  String _uniqueKey;
  String _userName;
  String _regionCode;
  String _accessTime;
  bool _isDeleted;
  bool _isValid;

  ApplyBizLicenseModel();

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get licenseType => _licenseType;

  bool get isValid => _isValid;

  set isValid(bool value) {
    _isValid = value;
  }

  bool get isDeleted => _isDeleted;

  set isDeleted(bool value) {
    _isDeleted = value;
  }

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

  String get applyDate => _applyDate;

  set applyDate(String value) {
    _applyDate = value;
  }

  String get requiredData => _requiredData;

  set requiredData(String value) {
    _requiredData = value;
  }

  String get remark => _remark;

  set remark(String value) {
    _remark = value;
  }

  String get state => _state;

  set state(String value) {
    _state = value;
  }

  String get township => _township;

  set township(String value) {
    _township = value;
  }

  String get blockNo => _blockNo;

  set blockNo(String value) {
    _blockNo = value;
  }

  String get streetName => _streetName;

  set streetName(String value) {
    _streetName = value;
  }

  String get regionNo => _regionNo;

  set regionNo(String value) {
    _regionNo = value;
  }

  String get phoneNo => _phoneNo;

  set phoneNo(String value) {
    _phoneNo = value;
  }

  String get nrcNo => _nrcNo;

  set nrcNo(String value) {
    _nrcNo = value;
  }

  String get ownerName => _ownerName;

  set ownerName(String value) {
    _ownerName = value;
  }

  String get bizState => _bizState;

  set bizState(String value) {
    _bizState = value;
  }

  String get bizTownship => _bizTownship;

  set bizTownship(String value) {
    _bizTownship = value;
  }

  String get bizBlockNo => _bizBlockNo;

  set bizBlockNo(String value) {
    _bizBlockNo = value;
  }

  String get bizStreetName => _bizStreetName;

  set bizStreetName(String value) {
    _bizStreetName = value;
  }

  String get bizRegionNo => _bizRegionNo;

  set bizRegionNo(String value) {
    _bizRegionNo = value;
  }

  double get area => _area;

  set area(double value) {
    _area = value;
  }

  double get width => _width;

  set width(double value) {
    _width = value;
  }

  double get length => _length;

  set length(double value) {
    _length = value;
  }

  String get bizType => _bizType;

  set bizType(String value) {
    _bizType = value;
  }

  String get bizName => _bizName;

  set bizName(String value) {
    _bizName = value;
  }

  int get licensetypeId => _licensetypeId;

  set licensetypeId(int value) {
    _licensetypeId = value;
  }

  set licenseType(String value) {
    _licenseType = value;
  }

  ApplyBizLicenseModel.fromJson(Map<String, dynamic> json) :
      _id = json['ID'],
      _licenseType = json['LicenseType'],
      _licensetypeId = json['LicenseTypeID'],
      _bizName = json['BizName'],
      _bizType = json['BizType'],
      _length = json['Length'],
      _width = json['Width'],
      _area = json['Area'],
      _bizRegionNo = json['BizRegionNo'],
      _bizStreetName = json['BizStreetName'],
      _bizBlockNo = json['BizBlockNo'],
      _bizTownship = json['BizTownship'],
      _bizState = json['BizState'],
      _ownerName = json['OwnerName'],
      _nrcNo = json['NRCNo'],
      _phoneNo = json['PhoneNo'],
      _regionNo = json['RegionNo'],
      _streetName = json['StreetName'],
      _blockNo = json['BlockNo'],
      _township = json['Township'],
      _state = json['State'],
      _remark = json['Remark'],
      _requiredData = json['RequiredData'],
      _applyDate = json['ApplyDate'],
      _uniqueKey = json['UniqueKey'],
      _userName = json['UserName'],
      _regionCode = json['RegionCode'],
      _accessTime = json['Accesstime'],
      _isDeleted = json['IsDeleted'],
      _isValid = json['IsValid'];

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json =new Map<String, dynamic>();
     json['ID'] = _id;
     json['LicenseType'] = _licenseType;
     json['LicenseTypeID'] = _licensetypeId;
     json['BizName'] = _bizName;
     json['BizType'] = _bizType;
     json['Length'] = _length;
     json['Width'] = _width;
     json['Area'] = _area;
     json['BizRegionNo'] = _bizRegionNo;
     json['BizStreetName'] = _bizStreetName;
     json['BizBlockNo'] = _bizBlockNo;
     json['BizTownship'] = _bizTownship;
     json['BizState'] = _bizState;
     json['OwnerName'] = _ownerName;
     json['NRCNo'] = _nrcNo;
     json['PhoneNo'] = _phoneNo;
     json['RegionNo'] = _regionNo;
     json['StreetName'] = _streetName;
     json['BlockNo'] = _blockNo;
     json['Township'] = _township;
     json['State'] = _state;
     json['Remark'] = _remark;
     json['RequiredData'] = _requiredData;
     json['ApplyDate'] = _applyDate;
     json['UniqueKey'] = _uniqueKey;
     json['UserName'] = _userName;
     json['RegionCode'] = _regionCode;
     json['Accesstime'] = _accessTime;
     json['IsDeleted'] = _isDeleted;
     json['IsValid'] = _isValid;

    return json;
  }


}