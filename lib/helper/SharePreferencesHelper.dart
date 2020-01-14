import 'package:shared_preferences/shared_preferences.dart';

class Sharepreferenceshelper{
  static String USER_PHONE_KEY = 'user_phone';
  static String USER_UNIQUE_KEY = 'user_unique_key';
  static String USER_REGION_CODE_KEY = 'user_region_code';
  static String USER_IS_WARD_ADMIN = 'user_is_ward_admin';
  static String USER_WARD_NAME = 'user_ward_name';
  SharedPreferences sharedPreferences;

  void initSharePref() async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void setLoginSharePreference(String uniqueKey, String phone, String regionCode, bool isWardAdmin, String wardName){
    sharedPreferences
        ..setString(USER_UNIQUE_KEY, uniqueKey)
        ..setString(USER_PHONE_KEY, phone)
        ..setString(USER_REGION_CODE_KEY, regionCode)
        ..setBool(USER_IS_WARD_ADMIN, isWardAdmin)
        ..setString(USER_WARD_NAME, wardName);
  }

  String getRegionCode(){
    return sharedPreferences.get(USER_REGION_CODE_KEY);
  }

  String getUserUniqueKey(){
    return sharedPreferences.get(USER_UNIQUE_KEY);
  }

  String getUserPhoneNo(){
    return sharedPreferences.get(USER_PHONE_KEY);
  }

  String getWardName(){
    return sharedPreferences.get(USER_WARD_NAME);
  }

  void logOutSharePref(){
    sharedPreferences.clear();
  }

  bool isWardAdmin(){
    if(sharedPreferences.getBool(USER_IS_WARD_ADMIN)){
      return true;
    }else{
      return false;
    }
  }

  bool isLogin(){
    if(sharedPreferences.containsKey(USER_PHONE_KEY)){
      return true;
    }else{
      return false;
    }
  }
}