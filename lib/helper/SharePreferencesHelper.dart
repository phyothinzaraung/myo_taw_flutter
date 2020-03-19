import 'package:shared_preferences/shared_preferences.dart';

class Sharepreferenceshelper{
  static String USER_PHONE_KEY = 'user_phone';
  static String USER_UNIQUE_KEY = 'user_unique_key';
  static String USER_REGION_CODE_KEY = 'user_region_code';
  static String USER_IS_WARD_ADMIN = 'user_is_ward_admin';
  static String USER_WARD_NAME = 'user_ward_name';
  static String USER_FCM_TOKEN = 'user_fcm_token';
  static String NOTIFICATION_ADD = 'notification_add';
  static String IS_NEWS_FEED_DELETE = 'is_news_feed_delete';
  static String IS_NOTIFICATION_UNCHECK = 'is_notification_uncheck';
  static String IS_NEWS_FEED_SCROLL_TOP = 'is_news_feed_scroll_top';
  SharedPreferences _sharedPreferences;

  Future initSharePref() async{
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void setLoginSharePreference(String uniqueKey, String phone, String regionCode, bool isWardAdmin, String wardName, String token){
    _sharedPreferences
        ..setString(USER_UNIQUE_KEY, uniqueKey)
        ..setString(USER_PHONE_KEY, phone)
        ..setString(USER_REGION_CODE_KEY, regionCode)
        ..setBool(USER_IS_WARD_ADMIN, isWardAdmin)
        ..setString(USER_FCM_TOKEN, token)
        ..setString(USER_WARD_NAME, wardName);
  }

  void setUserToken(String token){
    _sharedPreferences
      ..setString(USER_FCM_TOKEN, token);
  }

  void setIsWardAdmin(bool isWardAdmin){
    _sharedPreferences
      ..setBool(USER_IS_WARD_ADMIN, isWardAdmin);
  }

  String getRegionCode(){
    return _sharedPreferences.get(USER_REGION_CODE_KEY);
  }

  String getUserUniqueKey(){
    return _sharedPreferences.get(USER_UNIQUE_KEY);
  }

  String getUserPhoneNo(){
    return _sharedPreferences.get(USER_PHONE_KEY);
  }

  String getWardName(){
    return _sharedPreferences.get(USER_WARD_NAME);
  }

  String getToken(){
    return _sharedPreferences.get(USER_FCM_TOKEN);
  }

  void logOutSharePref(){
    _sharedPreferences.clear();
  }

  bool isWardAdmin(){
    if(_sharedPreferences.getBool(USER_IS_WARD_ADMIN)){
      return true;
    }else{
      return false;
    }
  }

  bool isLogin(){
    if(_sharedPreferences.containsKey(USER_PHONE_KEY)){
      return true;
    }else{
      return false;
    }
  }

  void setNotificationAdd(bool isAdd){
    _sharedPreferences.setBool(NOTIFICATION_ADD, isAdd);
  }

  bool isNotificationAdd(){
    return _sharedPreferences.getBool(NOTIFICATION_ADD);
  }

  void setNotificationUnCheck(bool isAdd){
    _sharedPreferences.setBool(IS_NOTIFICATION_UNCHECK, isAdd);
  }

  bool isNotificationUnCheck(){
    return _sharedPreferences.getBool(IS_NOTIFICATION_UNCHECK);
  }

  void setNewsFeedScrollTop(bool isScroll){
    _sharedPreferences.setBool(IS_NEWS_FEED_SCROLL_TOP, isScroll);
  }

  bool isNewsFeedScrollTop(){
    return _sharedPreferences.getBool(IS_NEWS_FEED_SCROLL_TOP);
  }
}