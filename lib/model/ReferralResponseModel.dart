class ReferralResponseModel{
  String _code;
  String _message;

  String get code => _code;

  set code(String value) {
    _code = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  ReferralResponseModel.fromJson(Map<String, dynamic> json) :
      _code = json['code'],
      _message = json['message'];

}