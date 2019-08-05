import 'package:shared_preferences/shared_preferences.dart';

class Sharepreferenceshelper{
  static String USER_PHONE_KEY = 'user_phone';
  static String USER_UNIQUE_KEY = 'user_unique_key';
  static String USER_REGION_CODE_KEY = 'user_region_code';
  SharedPreferences sharedPreferences;

  void initSharePref() async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void setLoginSharePreference(String uniqueKey, String phone, String regionCode){
    sharedPreferences
        ..setString(USER_UNIQUE_KEY, uniqueKey)
        ..setString(USER_PHONE_KEY, phone)
        ..setString(USER_REGION_CODE_KEY, regionCode);
  }

  String getRegionCode(){
    return sharedPreferences.get(USER_REGION_CODE_KEY);
  }

  String getUniqueKey(){
    return sharedPreferences.get(USER_UNIQUE_KEY);
  }

  String getUserPhoneNo(){
    return sharedPreferences.get(USER_PHONE_KEY);
  }

  void logOutSharePref(){
    sharedPreferences.clear();
  }
}