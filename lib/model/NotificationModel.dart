class NotificationModel {
    int _adminID;
    bool _isDeleted;
    String _message;
    String _uniqueKey;
    String _adminName;
    String _postedDate;
    int _iD;
    String _accesstime;

    NotificationModel(
        {int adminID,
            bool isDeleted,
            String message,
            String uniqueKey,
            String adminName,
            String postedDate,
            int iD,
            String accesstime}) {
        this._adminID = adminID;
        this._isDeleted = isDeleted;
        this._message = message;
        this._uniqueKey = uniqueKey;
        this._adminName = adminName;
        this._postedDate = postedDate;
        this._iD = iD;
        this._accesstime = accesstime;
    }

    int get adminID => _adminID;
    set adminID(int adminID) => _adminID = adminID;
    bool get isDeleted => _isDeleted;
    set isDeleted(bool isDeleted) => _isDeleted = isDeleted;
    String get message => _message;
    set message(String message) => _message = message;
    String get uniqueKey => _uniqueKey;
    set uniqueKey(String uniqueKey) => _uniqueKey = uniqueKey;
    String get adminName => _adminName;
    set adminName(String adminName) => _adminName = adminName;
    String get postedDate => _postedDate;
    set postedDate(String postedDate) => _postedDate = postedDate;
    int get iD => _iD;
    set iD(int iD) => _iD = iD;
    String get accesstime => _accesstime;
    set accesstime(String accesstime) => _accesstime = accesstime;

    NotificationModel.fromJson(Map<String, dynamic> json) {
        _adminID = json['AdminID'];
        _isDeleted = json['IsDeleted'];
        _message = json['Message'];
        _uniqueKey = json['UniqueKey'];
        _adminName = json['AdminName'];
        _postedDate = json['PostedDate'];
        _iD = json['ID'];
        _accesstime = json['Accesstime'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['AdminID'] = this._adminID;
        data['IsDeleted'] = this._isDeleted;
        data['Message'] = this._message;
        data['UniqueKey'] = this._uniqueKey;
        data['AdminName'] = this._adminName;
        data['PostedDate'] = this._postedDate;
        data['ID'] = this._iD;
        data['Accesstime'] = this._accesstime;
        return data;
    }
}
