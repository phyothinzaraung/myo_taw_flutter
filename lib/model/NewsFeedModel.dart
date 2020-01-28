
class NewsFeedModel{
  String _uniqueKey;
  int _id;
  String _title;
  String _body;
  String _reference;
  String _uploadType;
  String _photoUrl;
  String _videoUrl;
  String _organizationName;
  int _organizationId;
  String _accesstime;
  bool _isDeleted;
  String _remark;
  bool _isActive;
  int _likeCount;
  String _thumbNail;
  String _subscription;

  //local field
  bool _isSaved;


  bool get isSaved => _isSaved;

  set isSaved(bool value) {
    _isSaved = value;
  }

  String get uniqueKey => _uniqueKey;

  set uniqueKey(String value) {
    _uniqueKey = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get subscription => _subscription;

  set subscription(String value) {
    _subscription = value;
  }

  String get thumbNail => _thumbNail;

  set thumbNail(String value) {
    _thumbNail = value;
  }

  int get likeCount => _likeCount;

  set likeCount(int value) {
    _likeCount = value;
  }

  bool get isActive => _isActive;

  set isActive(bool value) {
    _isActive = value;
  }

  String get remark => _remark;

  set remark(String value) {
    _remark = value;
  }

  bool get isDeleted => _isDeleted;

  set isDeleted(bool value) {
    _isDeleted = value;
  }

  String get accesstime => _accesstime;

  set accesstime(String value) {
    _accesstime = value;
  }

  int get organizationId => _organizationId;

  set organizationId(int value) {
    _organizationId = value;
  }

  String get organizationName => _organizationName;

  set organizationName(String value) {
    _organizationName = value;
  }

  String get videoUrl => _videoUrl;

  set videoUrl(String value) {
    _videoUrl = value;
  }

  String get photoUrl => _photoUrl;

  set photoUrl(String value) {
    _photoUrl = value;
  }

  String get uploadType => _uploadType;

  set uploadType(String value) {
    _uploadType = value;
  }

  String get reference => _reference;

  set reference(String value) {
    _reference = value;
  }

  String get body => _body;

  set body(String value) {
    _body = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  NewsFeedModel.fromJson(Map<String, dynamic> json):
      _uniqueKey = json['UniqueKey'],
      _id = json['ID'],
      _title = json['Title'],
      _body = json['Body'],
      _reference = json['Reference'],
      _uploadType = json['UploadType'],
      _photoUrl = json['PhotoUrl'],
      _videoUrl = json['VideoUrl'],
      _organizationName = json['OrganizationName'],
      _organizationId = json['OrganizationID'],
      _accesstime = json['Accesstime'],
      _isDeleted = json['IsDeleted'],
      _remark = json['Remark'],
      _isActive = json['IsActive'],
      _likeCount = json['LikeCount'],
      _thumbNail = json['Thumbnail'],
      _subscription = json['Subscription'];
}