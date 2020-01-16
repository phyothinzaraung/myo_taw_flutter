
class DbHelper{

  //UserTable

  static final TABLE_NAME_USER = 'UserTable';

  static final USER_DATABASE_NAME = "User.db";
  static final USER_DATABASE_VERSION = 1;

  static final COLUMN_USER_UNIQUE = 'uniqueKey';
  static final COLUMN_USER_NAME = 'name';
  static final COLUMN_USER_PHONE_NO = 'phoneNo';
  static final COLUMN_USER_PHOTO_URL = 'photoUrl';
  static final COLUMN_USER_STATE = 'state';
  static final COLUMN_USER_TOWNSHIP = 'township';
  static final COLUMN_USER_ADDRESS = 'address';
  static final COLUMN_USER_REGISTERED_DATE = 'registeredDate';
  static final COLUMN_USER_ISDELETED = 'isDeleted';
  static final COLUMN_USER_ACCESSTIME = 'accesstime';
  static final COLUMN_USER_RESOURCE = 'resource';
  static final COLUMN_USER_ANDROID_TOKEN = 'androidToken';
  static final COLUMN_USER_CURRENT_REGION_CODE = 'currentRegionCode';
  static final COLUMN_USER_PIN_CODE = 'pinCode';
  static final COLUMN_USER_AMOUNT = 'amount';
  static final COLUMN_USER_IS_WARD_ADMIN = 'isWardAdmin';
  static final COLUMN_USER_WARD_NAME = 'wardName';
  static final COLUMN_USER_METER_NO = 'meterNo';
  //---------------------------------------------------------------------------------------------------------------------//

  //SaveNewsFeedTable

  static final TABLE_NAME_SAVE_NEWS_FEED = 'SaveNewsFeedTable';

  static final SAVE_NEWS_FEED_DATABASE_NAME = 'SaveNewsFeed.db';
  static final SAVE_NEWS_FEED_DATABASE_VERSION = 1;

  static final COLUMN_SAVE_NF_ID = 'id';
  static final COLUMN_SAVE_NF_TITLE = 'title';
  static final COLUMN_SAVE_NF_BODY = 'body';
  static final COLUMN_SAVE_NF_PHOTO_URL = 'photoUrl';
  static final COLUMN_SAVE_NF_VIDEO_URL = 'videoUrl';
  static final COLUMN_SAVE_NF_THUMBNAIL = 'thumbnail';
  static final COLUMN_SAVE_NF_ACCESSTIME = 'accesstime';
  static final COLUMN_SAVE_NF_CONTENT_TYPE = 'contentType';
  //--------------------------------------------------------------------------------------------------------------------------//

  //LocationTable

  static final TABLE_NAME_LOCATION = 'LocationTable';

  static final LOCATION_DATABASE_NAME = 'Location.db';
  static final LOCATION_DATABASE_VERSION = 1;

  static final COLUMN_LOCATION_ID = 'id';
  static final COLUMN_STATE_DIVISION = 'state_division';
  static final COLUMN_STATE_DIVISION_UNICODE = 'state_division_unicode';
  static final COLUMN_STATE_DIVISION_CODE = 'state_devision_code';
  static final COLUMN_TOWNHIP = 'township';
  static final COLUMN_TOWNSHIP_UNICODE = 'township_unicode';
  static final COLUMN_TOWNSHIP_CODE = 'township_code';
}

