
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