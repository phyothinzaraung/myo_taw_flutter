
class SmartWaterMeterLogModel{

    int _id;
    String _uniqueKey;
    String _msgId;
    String _phoneNo;
    String _userName;
    String _date;
    int _unit;
    int _amount;
    String _meterNo;
    String _accessstime;

    int get id => _id;

    set id(int value) {
      _id = value;
    }

    String get uniqueKey => _uniqueKey;

    String get accessstime => _accessstime;

    set accessstime(String value) {
      _accessstime = value;
    }

    String get meterNo => _meterNo;

    set meterNo(String value) {
      _meterNo = value;
    }

    int get amount => _amount;

    set amount(int value) {
      _amount = value;
    }

    int get unit => _unit;

    set unit(int value) {
      _unit = value;
    }

    String get date => _date;

    set date(String value) {
      _date = value;
    }

    String get userName => _userName;

    set userName(String value) {
      _userName = value;
    }

    String get phoneNo => _phoneNo;

    set phoneNo(String value) {
      _phoneNo = value;
    }

    String get msgId => _msgId;

    set msgId(String value) {
      _msgId = value;
    }

    set uniqueKey(String value) {
      _uniqueKey = value;
    }

    SmartWaterMeterLogModel.fromJson(Map<String, dynamic> json) :
        _id = json['ID'],
        _uniqueKey = json['UniqueKey'],
        _msgId = json['MsgID'],
        _phoneNo = json['PhoneNo'],
        _userName = json['UserName'],
        _date = json['Date'],
        _unit = json['Unit'],
        _amount = json['Amount'],
        _meterNo = json['MeterNo'],
        _accessstime = json['Accesstime'];

}