import 'package:myotaw/helper/DbHelper.dart';

class UserModel{
  String _uniqueKey;
  String _name;
  String _phoneNo;
  String _photoUrl;
  String _state;
  String _township;
  String _address;
  String _registeredDate;
  String _accesstime;
  bool _isDeleted;
  String _resource;
  String _androidToken;
  String _currentRegionCode;
  int _pinCode;
  int _amount;
  int _isDeletedDb;
  bool _isWardAdmin;
  String _wardName;
  String _meterNo;

  UserModel();

  String get meterNo => _meterNo;

  set meterNo(String value) {
    _meterNo = value;
  }

  bool get isWardAdmin => _isWardAdmin;

  set isWardAdmin(bool value) {
    _isWardAdmin = value;
  }

  int get isDeletedDb => _isDeletedDb;

  set isDeletedDb(int value) {
    _isDeletedDb = value;
  }

  String get uniqueKey => _uniqueKey;

  set uniqueKey(String value) {
    _uniqueKey = value;
  }

  String get name => _name;

  String get currentRegionCode => _currentRegionCode;

  set currentRegionCode(String value) {
    _currentRegionCode = value;
  }

  String get androidToken => _androidToken;

  set androidToken(String value) {
    _androidToken = value;
  }

  String get resource => _resource;

  set resource(String value) {
    _resource = value;
  }

  bool get isDeleted => _isDeleted;

  set isDeleted(bool value) {
    _isDeleted = value;
  }

  String get accesstime => _accesstime;

  set accesstime(String value) {
    _accesstime = value;
  }

  String get registeredDate => _registeredDate;

  set registeredDate(String value) {
    _registeredDate = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get township => _township;

  set township(String value) {
    _township = value;
  }

  String get state => _state;

  set state(String value) {
    _state = value;
  }

  String get photoUrl => _photoUrl;

  set photoUrl(String value) {
    _photoUrl = value;
  }

  String get phoneNo => _phoneNo;

  set phoneNo(String value) {
    _phoneNo = value;
  }

  set name(String value) {
    _name = value;
  }


  int get pinCode => _pinCode;

  set pinCode(int value) {
    _pinCode = value;
  }

  int get amount => _amount;

  set amount(int value) {
    _amount = value;
  }

  String get wardName => _wardName;

  set wardName(String value) {
    _wardName = value;
  }

  UserModel.fromJson(Map<String, dynamic> json):
        _uniqueKey = json['UniqueKey'],
        _name = json['Name'],
        _phoneNo = json['PhoneNo'],
        _photoUrl = json['PhotoUrl'],
        _state = json['State'],
        _township = json['Township'],
        _address = json['Address'],
        _registeredDate = json['RegisteredDate'],
        _accesstime = json['Accesstime'],
        _isDeleted = json['IsDeleted'],
        _resource = json['Resource'],
        _androidToken = json['AndroidToken'],
        _currentRegionCode = json['CurrentRegionCode'],
        _pinCode = json['PinCode'],
        _amount = json['Amount'],
        _isWardAdmin = json['IsWardAdmin']??false,
        _wardName = json['WardName'],
        _meterNo = json['MeterNo'];

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json =new Map<String, dynamic>();
      json['UniqueKey'] = _uniqueKey;
      json['Name'] = _name;
      json['PhoneNo'] = _phoneNo;
      json['PhotoUrl'] = _photoUrl;
      json['State'] = _state;
      json['Township'] = _township;
      json['Address'] = _address;
      json['RegisteredDate'] = _registeredDate;
      json['Accesstime'] = _accesstime;
      json['IsDeleted'] = _isDeleted;
      json['Resource'] = _resource;
      json['AndroidToken'] = _androidToken;
      json['CurrentRegionCode'] = _currentRegionCode;
      json['PinCode'] = _pinCode;
      json['Amount'] = _amount;
      json['IsWardAdmin'] = _isWardAdmin;
      json['WardName'] = _wardName;
      json['MeterNo'] = _meterNo;

     return json;
  }

  UserModel.fromDb(Map<String, dynamic> map):
        _uniqueKey = map[DbHelper.COLUMN_USER_UNIQUE],
        _name = map[DbHelper.COLUMN_USER_NAME],
        _phoneNo = map[DbHelper.COLUMN_USER_PHONE_NO],
        _photoUrl = map[DbHelper.COLUMN_USER_PHOTO_URL],
        _state = map[DbHelper.COLUMN_USER_STATE],
        _township = map[DbHelper.COLUMN_USER_TOWNSHIP],
        _address = map[DbHelper.COLUMN_USER_ADDRESS],
        _registeredDate = map[DbHelper.COLUMN_USER_REGISTERED_DATE],
        _isDeletedDb = map[DbHelper.COLUMN_USER_ISDELETED],
        _accesstime = map[DbHelper.COLUMN_USER_ACCESSTIME],
        _resource = map[DbHelper.COLUMN_USER_RESOURCE],
        _androidToken = map[DbHelper.COLUMN_USER_ANDROID_TOKEN],
        _currentRegionCode = map[DbHelper.COLUMN_USER_CURRENT_REGION_CODE],
        _pinCode = map[DbHelper.COLUMN_USER_PIN_CODE],
        _amount = map[DbHelper.COLUMN_USER_AMOUNT],
        _isWardAdmin = map[DbHelper.COLUMN_USER_IS_WARD_ADMIN] ==1 ? true : false,
        _wardName = map[DbHelper.COLUMN_USER_WARD_NAME],
        _meterNo = map[DbHelper.COLUMN_USER_METER_NO];
}