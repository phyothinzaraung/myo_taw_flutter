
class DaoPhotoModel{
  int _id;
  int _daoId;
  String _photoUrl;
  String _accesstime;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int get daoId => _daoId;

  String get accesstime => _accesstime;

  set accesstime(String value) {
    _accesstime = value;
  }

  String get photoUrl => _photoUrl;

  set photoUrl(String value) {
    _photoUrl = value;
  }

  set daoId(int value) {
    _daoId = value;
  }

  DaoPhotoModel.fromJson(Map<String, dynamic> json):
      _id = json['ID'],
      _daoId = json['DAOID'],
      _photoUrl = json['PhotoUrl'],
      _accesstime = json['Accesstime'];


}