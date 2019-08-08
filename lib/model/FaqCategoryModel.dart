
class FaqCategoryModel{
  String _category;
  bool _isSelect = false;

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  bool get isSelect => _isSelect;

  set isSelect(bool value) {
    _isSelect = value;
  }

}