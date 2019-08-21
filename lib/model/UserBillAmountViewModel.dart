
class UserBillAmountViewModel{
  String _name;
  int _totalAmount;
  List<dynamic> _paymentModelList;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get totalAmount => _totalAmount;

  List get paymentModelList => _paymentModelList;

  set paymentModelList(List value) {
    _paymentModelList = value;
  }

  set totalAmount(int value) {
    _totalAmount = value;
  }

  UserBillAmountViewModel.formJson(Map<String, dynamic> json) :
      _name = json['Name'],
      _totalAmount = json['TotalAmount'],
      _paymentModelList = List<dynamic>.from(json['Log']);
}