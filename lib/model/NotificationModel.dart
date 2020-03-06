import 'package:myotaw/helper/DbHelper.dart';

class NotificationModel {
    int _adminID;
    bool _isDeleted = false;
    String _message;
    String _uniqueKey;
    String _adminName;
    String _postedDate;
    int _iD;
    String _accesstime;
    bool _isSeen = false;

    bool _isCheck = false;

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


    bool get isSeen => _isSeen;

    set isSeen(bool value) {
        _isSeen = value;
    }


    bool get isCheck => _isCheck;

    set isCheck(bool value) {
        _isCheck = value;
    }

    NotificationModel.fromJson(Map<String, dynamic> json) {
        _adminID = json['AdminID'];
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
        data['Message'] = this._message;
        data['UniqueKey'] = this._uniqueKey;
        data['AdminName'] = this._adminName;
        data['PostedDate'] = this._postedDate;
        data['ID'] = this._iD;
        data['Accesstime'] = this._accesstime;
        return data;
    }

    NotificationModel.fromDb(Map<String, dynamic> map):
            _iD = map[DbHelper.COLUMN_NOTIFICATION_ID],
            _message = map[DbHelper.COLUMN_NOTIFICATION_MESSAGE],
            _postedDate = map[DbHelper.COLUMN_NOTIFICATION_DATE],
            _isDeleted = map[DbHelper.COLUMN_NOTIFICATION_IS_DELETED]==1?true:false,
            _isSeen = map[DbHelper.COLUMN_NOTIFICATION_IS_SEEN]==1?true:false;

    Map<String, dynamic> toDb(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data[DbHelper.COLUMN_NOTIFICATION_ID] = this.iD;
        data[DbHelper.COLUMN_NOTIFICATION_MESSAGE] = this._message;
        data[DbHelper.COLUMN_NOTIFICATION_DATE] = this._postedDate;
        data[DbHelper.COLUMN_NOTIFICATION_IS_DELETED] = this._isDeleted?1:0;
        data[DbHelper.COLUMN_NOTIFICATION_IS_SEEN] = this._isSeen?1:0;
        return data;
    }

}
