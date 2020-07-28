class TopUpLogModel {
  int _iD;
  String _uniqueKey;
  String _msgID;
  String _meterNo;
  String _phoneNo;
  String _prepaidCode;
  String _date;
  int _amount;
  int _leftAmount;
  int _totalAmount;

  TopUpLogModel(
      {int iD,
        String uniqueKey,
        String msgID,
        String meterNo,
        String phoneNo,
        String prepaidCode,
        String date,
        int amount,
        int leftAmount,
        int totalAmount}) {
    this._iD = iD;
    this._uniqueKey = uniqueKey;
    this._msgID = msgID;
    this._meterNo = meterNo;
    this._phoneNo = phoneNo;
    this._prepaidCode = prepaidCode;
    this._date = date;
    this._amount = amount;
    this._leftAmount = leftAmount;
    this._totalAmount = totalAmount;
  }

  int get iD => _iD;
  set iD(int iD) => _iD = iD;
  String get uniqueKey => _uniqueKey;
  set uniqueKey(String uniqueKey) => _uniqueKey = uniqueKey;
  String get msgID => _msgID;
  set msgID(String msgID) => _msgID = msgID;
  String get meterNo => _meterNo;
  set meterNo(String meterNo) => _meterNo = meterNo;
  String get phoneNo => _phoneNo;
  set phoneNo(String phoneNo) => _phoneNo = phoneNo;
  String get prepaidCode => _prepaidCode;
  set prepaidCode(String prepaidCode) => _prepaidCode = prepaidCode;
  String get date => _date;
  set date(String date) => _date = date;
  int get amount => _amount;
  set amount(int amount) => _amount = amount;
  int get leftAmount => _leftAmount;
  set leftAmount(int leftAmount) => _leftAmount = leftAmount;
  int get totalAmount => _totalAmount;
  set totalAmount(int totalAmount) => _totalAmount = totalAmount;

  TopUpLogModel.fromJson(Map<String, dynamic> json) {
    _iD = json['ID'];
    _uniqueKey = json['UniqueKey'];
    _msgID = json['MsgID'];
    _meterNo = json['MeterNo'];
    _phoneNo = json['PhoneNo'];
    _prepaidCode = json['PrepaidCode'];
    _date = json['Date'];
    _amount = json['Amount']??0;
    _leftAmount = json['LeftAmount']??0;
    _totalAmount = json['TotalAmount']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this._iD;
    data['UniqueKey'] = this._uniqueKey;
    data['MsgID'] = this._msgID;
    data['MeterNo'] = this._meterNo;
    data['PhoneNo'] = this._phoneNo;
    data['PrepaidCode'] = this._prepaidCode;
    data['Date'] = this._date;
    data['Amount'] = this._amount;
    data['LeftAmount'] = this._leftAmount;
    data['TotalAmount'] = this._totalAmount;
    return data;
  }
}
