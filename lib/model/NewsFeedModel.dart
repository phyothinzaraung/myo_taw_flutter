class NewsFeedModel {
  String _uniqueKey;
  int _iD;
  String _facebookID;
  String _title;
  String _body;
  String _reference;
  String _uploadType;
  String _photoUrl;
  String _videoUrl;
  String _audioUrl;
  String _pdfUrl;
  String _organizationName;
  int _organizationID;
  String _accesstime;
  String _createdDate;
  bool _isDeleted;
  String _remark;
  bool _isActive;
  int _likeCount;
  String _thumbnail;
  String _subscription;
  List<String> _photoLink;
  String _nFType;
  String _block;
  //local field
  bool _isSaved;

  NewsFeedModel(
      {String uniqueKey,
        int iD,
        String facebookID,
        String title,
        String body,
        String reference,
        String uploadType,
        String photoUrl,
        String videoUrl,
        String audioUrl,
        String pdfUrl,
        String organizationName,
        int organizationID,
        String accesstime,
        String createdDate,
        bool isDeleted,
        String remark,
        bool isActive,
        int likeCount,
        String thumbnail,
        String subscription,
        List<String> photoLink,
        String nFType,
        String block,
        //local field
        bool isSaved
      }) {
    this._uniqueKey = uniqueKey;
    this._iD = iD;
    this._facebookID = facebookID;
    this._title = title;
    this._body = body;
    this._reference = reference;
    this._uploadType = uploadType;
    this._photoUrl = photoUrl;
    this._videoUrl = videoUrl;
    this._audioUrl = audioUrl;
    this._pdfUrl = pdfUrl;
    this._organizationName = organizationName;
    this._organizationID = organizationID;
    this._accesstime = accesstime;
    this._createdDate = createdDate;
    this._isDeleted = isDeleted;
    this._remark = remark;
    this._isActive = isActive;
    this._likeCount = likeCount;
    this._thumbnail = thumbnail;
    this._subscription = subscription;
    this._photoLink = photoLink;
    this._nFType = nFType;
    this._block = block;
    this._isSaved = isSaved;
  }


  bool get isSaved => _isSaved;

  set isSaved(bool value) {
    _isSaved = value;
  }

  String get uniqueKey => _uniqueKey;
  set uniqueKey(String uniqueKey) => _uniqueKey = uniqueKey;
  int get iD => _iD;
  set iD(int iD) => _iD = iD;
  String get facebookID => _facebookID;
  set facebookID(String facebookID) => _facebookID = facebookID;
  String get title => _title;
  set title(String title) => _title = title;
  String get body => _body;
  set body(String body) => _body = body;
  String get reference => _reference;
  set reference(String reference) => _reference = reference;
  String get uploadType => _uploadType;
  set uploadType(String uploadType) => _uploadType = uploadType;
  String get photoUrl => _photoUrl;
  set photoUrl(String photoUrl) => _photoUrl = photoUrl;
  String get videoUrl => _videoUrl;
  set videoUrl(String videoUrl) => _videoUrl = videoUrl;
  String get audioUrl => _audioUrl;
  set audioUrl(String audioUrl) => _audioUrl = audioUrl;
  String get pdfUrl => _pdfUrl;
  set pdfUrl(String pdfUrl) => _pdfUrl = pdfUrl;
  String get organizationName => _organizationName;
  set organizationName(String organizationName) =>
      _organizationName = organizationName;
  int get organizationID => _organizationID;
  set organizationID(int organizationID) => _organizationID = organizationID;
  String get accesstime => _accesstime;
  set accesstime(String accesstime) => _accesstime = accesstime;
  String get createdDate => _createdDate;
  set createdDate(String createdDate) => _createdDate = createdDate;
  bool get isDeleted => _isDeleted;
  set isDeleted(bool isDeleted) => _isDeleted = isDeleted;
  String get remark => _remark;
  set remark(String remark) => _remark = remark;
  bool get isActive => _isActive;
  set isActive(bool isActive) => _isActive = isActive;
  int get likeCount => _likeCount;
  set likeCount(int likeCount) => _likeCount = likeCount;
  String get thumbnail => _thumbnail;
  set thumbnail(String thumbnail) => _thumbnail = thumbnail;
  String get subscription => _subscription;
  set subscription(String subscription) => _subscription = subscription;
  List<String> get photoLink => _photoLink;
  set photoLink(List<String> photoLink) => _photoLink = photoLink;
  String get nFType => _nFType;
  set nFType(String nFType) => _nFType = nFType;
  String get block => _block;
  set block(String block) => _block = block;

  NewsFeedModel.fromJson(Map<String, dynamic> json) {
    _uniqueKey = json['UniqueKey'];
    _iD = json['ID'];
    _facebookID = json['FacebookID'];
    _title = json['Title'];
    _body = json['Body'];
    _reference = json['Reference'];
    _uploadType = json['UploadType'];
    _photoUrl = json['PhotoUrl'];
    _videoUrl = json['VideoUrl'];
    _audioUrl = json['AudioUrl'];
    _pdfUrl = json['PdfUrl'];
    _organizationName = json['OrganizationName'];
    _organizationID = json['OrganizationID'];
    _accesstime = json['Accesstime'];
    _createdDate = json['CreatedDate'];
    _isDeleted = json['IsDeleted'];
    _remark = json['Remark'];
    _isActive = json['IsActive'];
    _likeCount = json['LikeCount'];
    _thumbnail = json['Thumbnail'];
    _subscription = json['Subscription'];
    _photoLink = json['PhotoLink']??[];
    _nFType = json['NFType'];
    _block = json['Block'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UniqueKey'] = this._uniqueKey;
    data['ID'] = this._iD;
    data['FacebookID'] = this._facebookID;
    data['Title'] = this._title;
    data['Body'] = this._body;
    data['Reference'] = this._reference;
    data['UploadType'] = this._uploadType;
    data['PhotoUrl'] = this._photoUrl;
    data['VideoUrl'] = this._videoUrl;
    data['AudioUrl'] = this._audioUrl;
    data['PdfUrl'] = this._pdfUrl;
    data['OrganizationName'] = this._organizationName;
    data['OrganizationID'] = this._organizationID;
    data['Accesstime'] = this._accesstime;
    data['CreatedDate'] = this._createdDate;
    data['IsDeleted'] = this._isDeleted;
    data['Remark'] = this._remark;
    data['IsActive'] = this._isActive;
    data['LikeCount'] = this._likeCount;
    data['Thumbnail'] = this._thumbnail;
    data['Subscription'] = this._subscription;
    data['PhotoLink'] = this._photoLink;
    data['NFType'] = this._nFType;
    data['Block'] = this._block;
    return data;
  }
}