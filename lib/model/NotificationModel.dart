class NotificationModel {
    int _iD;
    String _message;
    String _uniqueKey;
    String _postedDate;
    int _adminID;
    String _adminName;
    String _accesstime;
    bool _isDeleted;
    int _bizID;
    bool _isRead;

    NotificationModel(
        {int iD,
            String message,
            String uniqueKey,
            String postedDate,
            int adminID,
            String adminName,
            String accesstime,
            bool isDeleted,
            int bizID,
            bool isRead}) {
        this._iD = iD;
        this._message = message;
        this._uniqueKey = uniqueKey;
        this._postedDate = postedDate;
        this._adminID = adminID;
        this._adminName = adminName;
        this._accesstime = accesstime;
        this._isDeleted = isDeleted;
        this._bizID = bizID;
        this._isRead = isRead;
    }

    int get iD => _iD;
    set iD(int iD) => _iD = iD;
    String get message => _message;
    set message(String message) => _message = message;
    String get uniqueKey => _uniqueKey;
    set uniqueKey(String uniqueKey) => _uniqueKey = uniqueKey;
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
    int get bizID => _bizID;
    set bizID(int bizID) => _bizID = bizID;
    bool get isRead => _isRead;
    set isRead(bool isRead) => _isRead = isRead;

    NotificationModel.fromJson(Map<String, dynamic> json) {
        _iD = json['ID'];
        _message = json['Message'];
        _uniqueKey = json['UniqueKey'];
        _postedDate = json['PostedDate'];
        _adminID = json['AdminID'];
        _adminName = json['AdminName'];
        _accesstime = json['Accesstime'];
        _isDeleted = json['IsDeleted']??false;
        _bizID = json['BizID'];
        _isRead = json['IsRead']??false;
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['ID'] = this._iD;
        data['Message'] = this._message;
        data['UniqueKey'] = this._uniqueKey;
        data['PostedDate'] = this._postedDate;
        data['AdminID'] = this._adminID;
        data['AdminName'] = this._adminName;
        data['Accesstime'] = this._accesstime;
        data['IsDeleted'] = this._isDeleted;
        data['BizID'] = this._bizID;
        data['IsRead'] = this._isRead;
        return data;
    }
}
