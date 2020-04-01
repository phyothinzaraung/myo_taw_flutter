class ApplyBizLicensePhotoModel {
  List<Photo> _photo;
  bool _isValid;

  ApplyBizLicensePhotoModel({List<Photo> photo, bool isValid}) {
    this._photo = photo;
    this._isValid = isValid;
  }

  List<Photo> get photo => _photo;
  set photo(List<Photo> photo) => _photo = photo;
  bool get isValid => _isValid;
  set isValid(bool isValid) => _isValid = isValid;

  ApplyBizLicensePhotoModel.fromJson(Map<String, dynamic> json) {
    if (json['Photo'] != null) {
      _photo = new List<Photo>();
      json['Photo'].forEach((v) {
        _photo.add(new Photo.fromJson(v));
      });
    }
    _isValid = json['IsValid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._photo != null) {
      data['Photo'] = this._photo.map((v) => v.toJson()).toList();
    }
    data['IsValid'] = this._isValid;
    return data;
  }
}

class Photo {
  int _iD;
  int _apBizID;
  String _title;
  String _photoUrl;
  String _accesstime;
  Null _isDeleted;

  Photo(
      {int iD,
        int apBizID,
        String title,
        String photoUrl,
        String accesstime,
        Null isDeleted}) {
    this._iD = iD;
    this._apBizID = apBizID;
    this._title = title;
    this._photoUrl = photoUrl;
    this._accesstime = accesstime;
    this._isDeleted = isDeleted;
  }

  int get iD => _iD;
  set iD(int iD) => _iD = iD;
  int get apBizID => _apBizID;
  set apBizID(int apBizID) => _apBizID = apBizID;
  String get title => _title;
  set title(String title) => _title = title;
  String get photoUrl => _photoUrl;
  set photoUrl(String photoUrl) => _photoUrl = photoUrl;
  String get accesstime => _accesstime;
  set accesstime(String accesstime) => _accesstime = accesstime;
  Null get isDeleted => _isDeleted;
  set isDeleted(Null isDeleted) => _isDeleted = isDeleted;

  Photo.fromJson(Map<String, dynamic> json) {
    _iD = json['ID'];
    _apBizID = json['ApBizID'];
    _title = json['Title'];
    _photoUrl = json['PhotoUrl'];
    _accesstime = json['Accesstime'];
    _isDeleted = json['IsDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this._iD;
    data['ApBizID'] = this._apBizID;
    data['Title'] = this._title;
    data['PhotoUrl'] = this._photoUrl;
    data['Accesstime'] = this._accesstime;
    data['IsDeleted'] = this._isDeleted;
    return data;
  }
}
