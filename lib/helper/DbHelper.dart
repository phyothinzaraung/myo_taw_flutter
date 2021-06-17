
class DbHelper{

  //UserTable

  static const TABLE_NAME_USER = 'UserTable';

  static const USER_DATABASE_NAME = "User.db";
  static const USER_DATABASE_VERSION = 3;

  static const COLUMN_USER_UNIQUE = 'uniqueKey';
  static const COLUMN_USER_NAME = 'name';
  static const COLUMN_USER_PHONE_NO = 'phoneNo';
  static const COLUMN_USER_PHOTO_URL = 'photoUrl';
  static const COLUMN_USER_STATE = 'state';
  static const COLUMN_USER_TOWNSHIP = 'township';
  static const COLUMN_USER_ADDRESS = 'address';
  static const COLUMN_USER_REGISTERED_DATE = 'registeredDate';
  static const COLUMN_USER_ISDELETED = 'isDeleted';
  static const COLUMN_USER_ACCESSTIME = 'accesstime';
  static const COLUMN_USER_RESOURCE = 'resource';
  static const COLUMN_USER_ANDROID_TOKEN = 'androidToken';
  static const COLUMN_USER_CURRENT_REGION_CODE = 'currentRegionCode';
  static const COLUMN_USER_PIN_CODE = 'pinCode';
  static const COLUMN_USER_AMOUNT = 'amount';
  static const COLUMN_USER_IS_WARD_ADMIN = 'isWardAdmin';
  static const COLUMN_USER_WARD_NAME = 'wardName';
  static const COLUMN_USER_METER_NO = 'meterNo';
  static const COLUMN_USER_MEMBER_TYPE = 'memberType';
  static const COLUMN_USER_IS_ACTIVE = 'isActive';
  //---------------------------------------------------------------------------------------------------------------------//

  //SaveNewsFeedTable

  static const TABLE_NAME_SAVE_NEWS_FEED = 'SaveNewsFeedTable';

  static const SAVE_NEWS_FEED_DATABASE_NAME = 'SaveNewsFeed.db';
  static const SAVE_NEWS_FEED_DATABASE_VERSION = 1;

  static const COLUMN_SAVE_NF_ID = 'id';
  static const COLUMN_SAVE_NF_TITLE = 'title';
  static const COLUMN_SAVE_NF_BODY = 'body';
  static const COLUMN_SAVE_NF_PHOTO_URL = 'photoUrl';
  static const COLUMN_SAVE_NF_VIDEO_URL = 'videoUrl';
  static const COLUMN_SAVE_NF_THUMBNAIL = 'thumbnail';
  static const COLUMN_SAVE_NF_ACCESSTIME = 'accesstime';
  static const COLUMN_SAVE_NF_CONTENT_TYPE = 'contentType';
  //--------------------------------------------------------------------------------------------------------------------------//

  //LocationTable

  static const TABLE_NAME_LOCATION = 'LocationTable';

  static const LOCATION_DATABASE_NAME = 'Location.db';
  static const LOCATION_DATABASE_VERSION = 1;

  static const COLUMN_LOCATION_ID = 'id';
  static const COLUMN_STATE_DIVISION = 'state_division';
  static const COLUMN_STATE_DIVISION_UNICODE = 'state_division_unicode';
  static const COLUMN_STATE_DIVISION_CODE = 'state_devision_code';
  static const COLUMN_TOWNHIP = 'township';
  static const COLUMN_TOWNSHIP_UNICODE = 'township_unicode';
  static const COLUMN_TOWNSHIP_CODE = 'township_code';

  //--------------------------------------------------------------------------------------------------------------------------//

  //NotificationTable
  static const TABLE_NAME_NOTIFICATION = 'NotificationTable';

  static const NOTIFICATION_DATABASE_NAME = 'Notification.db';
  static const NOTIFICATION_DATABASE_VERSION = 1;

  static const COLUMN_NOTIFICATION_ID = 'id';
  static const COLUMN_NOTIFICATION_MESSAGE = 'message';
  static const COLUMN_NOTIFICATION_DATE = 'date';
  static const COLUMN_NOTIFICATION_IS_DELETED = 'is_deleted';
  static const COLUMN_NOTIFICATION_IS_SEEN = 'is_seen';
  static const COLUMN_NOTIFICATION_BIZ_ID = 'biz_id';

}

