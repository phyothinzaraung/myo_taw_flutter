
class InvoiceModel{
  String _taxType;
  String _ownerName;
  String _invoiceNo;
  String _blockNo;
  int _totalAmt;

  String get taxType => _taxType;

  set taxType(String value) {
    _taxType = value;
  }

  String get ownerName => _ownerName;

  int get totalAmt => _totalAmt;

  set totalAmt(int value) {
    _totalAmt = value;
  }

  String get blockNo => _blockNo;

  set blockNo(String value) {
    _blockNo = value;
  }

  String get invoiceNo => _invoiceNo;

  set invoiceNo(String value) {
    _invoiceNo = value;
  }

  set ownerName(String value) {
    _ownerName = value;
  }

  InvoiceModel.fromJson(Map<String, dynamic> json) :
        _taxType = json['TaxType'],
        _ownerName = json['OwnerName'],
        _invoiceNo = json['InvoiceNo'],
        _blockNo = json['BlockNo'],
        _totalAmt = json['TotalAmt'];


}