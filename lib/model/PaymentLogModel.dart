
class PaymentLogModel{
  int _id;
  String _uniqueKey;
  String _msgId;
  String _prepaidCode;
  String _useTime;
  int _totalAmount;
  int _useAmount;
  int _remainAmount;
  String _accessTime;
  bool _isDeleted;
  String _taxType;
  String _invoiceNo;

  PaymentLogModel();

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get uniqueKey => _uniqueKey;

  String get invoiceNo => _invoiceNo;

  set invoiceNo(String value) {
    _invoiceNo = value;
  }

  String get taxType => _taxType;

  set taxType(String value) {
    _taxType = value;
  }

  bool get isDeleted => _isDeleted;

  set isDeleted(bool value) {
    _isDeleted = value;
  }

  String get accessTime => _accessTime;

  set accessTime(String value) {
    _accessTime = value;
  }

  int get remainAmount => _remainAmount;

  set remainAmount(int value) {
    _remainAmount = value;
  }

  int get useAmount => _useAmount;

  set useAmount(int value) {
    _useAmount = value;
  }

  int get totalAmount => _totalAmount;

  set totalAmount(int value) {
    _totalAmount = value;
  }

  String get useTime => _useTime;

  set useTime(String value) {
    _useTime = value;
  }

  String get prepaidCode => _prepaidCode;

  set prepaidCode(String value) {
    _prepaidCode = value;
  }

  String get msgId => _msgId;

  set msgId(String value) {
    _msgId = value;
  }

  set uniqueKey(String value) {
    _uniqueKey = value;
  }

  PaymentLogModel.fromJson(Map<String, dynamic> json) :
      _id = json['ID'],
      _uniqueKey = json['UniqueKey'],
      _msgId = json['MsgID'],
      _prepaidCode = json['PrepaidCode'],
      _useTime = json['UseTime'],
      _totalAmount = json['TotalAmount'],
      _useAmount = json['UseAmount'],
      _remainAmount = json['RemainAmount'],
      _accessTime = json['Accesstime'],
      _isDeleted = json['IsDeleted'],
      _taxType = json['TaxType'],
      _invoiceNo = json['InvoiceNo'];


}