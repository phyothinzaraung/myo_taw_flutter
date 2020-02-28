class DaoViewModel {
  List<Photo> _photo;
  DAO _dAO;

  DaoViewModel({List<Photo> photo, DAO dAO}) {
    this._photo = photo;
    this._dAO = dAO;
  }

  List<Photo> get photo => _photo;
  set photo(List<Photo> photo) => _photo = photo;
  DAO get dAO => _dAO;
  set dAO(DAO dAO) => _dAO = dAO;

  DaoViewModel.fromJson(Map<String, dynamic> json) {
    if (json['Photo'] != null) {
      _photo = new List<Photo>();
      json['Photo'].forEach((v) {
        _photo.add(new Photo.fromJson(v));
      });
    }
    _dAO = json['DAO'] != null ? new DAO.fromJson(json['DAO']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._photo != null) {
      data['Photo'] = this._photo.map((v) => v.toJson()).toList();
    }
    if (this._dAO != null) {
      data['DAO'] = this._dAO.toJson();
    }
    return data;
  }
}

class Photo {
  int _iD;
  int _dAOID;
  String _photoUrl;
  String _accesstime;
  bool _isDeleted;

  Photo(
      {int iD, int dAOID, String photoUrl, String accesstime, bool isDeleted}) {
    this._iD = iD;
    this._dAOID = dAOID;
    this._photoUrl = photoUrl;
    this._accesstime = accesstime;
    this._isDeleted = isDeleted;
  }

  int get iD => _iD;
  set iD(int iD) => _iD = iD;
  int get dAOID => _dAOID;
  set dAOID(int dAOID) => _dAOID = dAOID;
  String get photoUrl => _photoUrl;
  set photoUrl(String photoUrl) => _photoUrl = photoUrl;
  String get accesstime => _accesstime;
  set accesstime(String accesstime) => _accesstime = accesstime;
  bool get isDeleted => _isDeleted;
  set isDeleted(bool isDeleted) => _isDeleted = isDeleted;

  Photo.fromJson(Map<String, dynamic> json) {
    _iD = json['ID'];
    _dAOID = json['DAOID'];
    _photoUrl = json['PhotoUrl'];
    _accesstime = json['Accesstime'];
    _isDeleted = json['IsDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this._iD;
    data['DAOID'] = this._dAOID;
    data['PhotoUrl'] = this._photoUrl;
    data['Accesstime'] = this._accesstime;
    data['IsDeleted'] = this._isDeleted;
    return data;
  }
}

class DAO {
  int _iD;
  String _title;
  String _description;
  String _display;
  int _serial;
  String _icon;
  String _regionCode;
  String _contact;
  String _remark;
  String _postedDate;
  int _adminID;
  String _adminName;
  String _accesstime;
  bool _isDeleted;
  String _deptType;

  DAO(
      {int iD,
        String title,
        String description,
        String display,
        int serial,
        String icon,
        String regionCode,
        String contact,
        String remark,
        String postedDate,
        int adminID,
        String adminName,
        String accesstime,
        bool isDeleted,
        String deptType}) {
    this._iD = iD;
    this._title = title;
    this._description = description;
    this._display = display;
    this._serial = serial;
    this._icon = icon;
    this._regionCode = regionCode;
    this._contact = contact;
    this._remark = remark;
    this._postedDate = postedDate;
    this._adminID = adminID;
    this._adminName = adminName;
    this._accesstime = accesstime;
    this._isDeleted = isDeleted;
    this._deptType = deptType;
  }

  int get iD => _iD;
  set iD(int iD) => _iD = iD;
  String get title => _title;
  set title(String title) => _title = title;
  String get description => _description;
  set description(String description) => _description = description;
  String get display => _display;
  set display(String display) => _display = display;
  int get serial => _serial;
  set serial(int serial) => _serial = serial;
  String get icon => _icon;
  set icon(String icon) => _icon = icon;
  String get regionCode => _regionCode;
  set regionCode(String regionCode) => _regionCode = regionCode;
  String get contact => _contact;
  set contact(String contact) => _contact = contact;
  String get remark => _remark;
  set remark(String remark) => _remark = remark;
  String get postedDate => _postedDate;
  set postedDate(String postedDate) => _postedDate = postedDate;
  int get adminID => _adminID;
  set adminID(int adminID) => _adminID = adminID;
  String get adminName => _adminName;
  set adminName(String adminName) => _adminName = adminName;
  String get accesstime => _accesstime;
  set accesstime(String accesstime) => _accesstime = accesstime;
  bool get isDeleted => _isDeleted;
  set isDeleted(bool isDeleted) => _isDeleted = isDeleted;
  String get deptType => _deptType;
  set deptType(String deptType) => _deptType = deptType;

  DAO.fromJson(Map<String, dynamic> json) {
    _iD = json['ID'];
    _title = json['Title'];
    _description = json['Description'];
    _display = json['Display'];
    _serial = json['Serial'];
    _icon = json['Icon'];
    _regionCode = json['RegionCode'];
    _contact = json['Contact'];
    _remark = json['Remark'];
    _postedDate = json['PostedDate'];
    _adminID = json['AdminID'];
    _adminName = json['AdminName'];
    _accesstime = json['Accesstime'];
    _isDeleted = json['IsDeleted'];
    _deptType = json['DeptType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this._iD;
    data['Title'] = this._title;
    data['Description'] = this._description;
    data['Display'] = this._display;
    data['Serial'] = this._serial;
    data['Icon'] = this._icon;
    data['RegionCode'] = this._regionCode;
    data['Contact'] = this._contact;
    data['Remark'] = this._remark;
    data['PostedDate'] = this._postedDate;
    data['AdminID'] = this._adminID;
    data['AdminName'] = this._adminName;
    data['Accesstime'] = this._accesstime;
    data['IsDeleted'] = this._isDeleted;
    data['DeptType'] = this._deptType;
    return data;
  }
}
