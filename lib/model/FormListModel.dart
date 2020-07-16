class FormListModel{
  int _ID;
  String _FormName;
  String _FormUrl;

  int get ID => _ID;

  set ID(int value) {
    _ID = value;
  }

  String get FormName => _FormName;

  set FormName(String value) {
    _FormName = value;
  }

  String get FormUrl => _FormUrl;

  set FormUrl(String value) {
    _FormUrl = value;
  }

  FormListModel.fromJson(Map<String, dynamic> json) :
        _ID = json['ID'],
        _FormName = json['FormName'],
        _FormUrl = json['FormUrl'];
}