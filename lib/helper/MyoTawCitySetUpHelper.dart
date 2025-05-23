
import 'package:flutter/cupertino.dart';
import 'package:myotaw/OldTgyPropertyTaxCalculatorScreen.dart';

import '../LkwBizTaxCalculatorScreen.dart';
import '../LkwPropertyTaxCalculatorScreen.dart';
import '../MlmBizTaxCalculatorScreen.dart';
import '../MlmPropertyTaxCalculatorScreen.dart';
import '../TgyBizTaxCalculatorScreen.dart';
import '../TgyPropertyTaxCalculatorScreen.dart';
import 'MyoTawConstant.dart';
import 'NavigatorHelper.dart';

class MyoTawCitySetUpHelper{

  static String getCity(String regionCode){
    String _city = '';
    switch(regionCode){
      case MyString.TGY_REGION_CODE:
        _city = MyString.TGY_CITY;
        break;
      case MyString.MLM_REGION_CODE:
        _city = MyString.MLM_CITY;
        break;
      case MyString.LKW_REGION_CODE:
        _city = MyString.LKW_CITY;
        break;
      case MyString.MGY_REGION_CODE:
        _city = MyString.MGY_CITY;
        break;
      case MyString.HLY_REGION_CODE:
        _city = MyString.HLY_CITY;
        break;
      case MyString.HPA_REGION_CODE:
        _city = MyString.HPA_CITY;
        break;
    }
    return _city;
  }

  static String getState(String regionCode){
    String _state = '';
    switch(regionCode){
      case MyString.TGY_REGION_CODE:
        _state = MyString.TGY_STATE;
        break;
      case MyString.MLM_REGION_CODE:
        _state = MyString.MLM_STATE;
        break;
      case MyString.LKW_REGION_CODE:
        _state = MyString.LKW_STATE;
        break;
      case MyString.MGY_REGION_CODE:
        _state = MyString.MGY_STATE;
        break;
      case MyString.HLY_REGION_CODE:
        _state = MyString.HLY_STATE;
        break;
      case MyString.HPA_REGION_CODE:
        _state = MyString.HPA_STATE;
        break;
    }
    return _state;
  }

  static int getNewsFeedCityId(String regionCode){
    int _organizationId = 0;
    switch(regionCode){
      case MyString.TGY_REGION_CODE:
        _organizationId = OrganizationId.TGY_ORGANIZATION_ID;
        break;
      case MyString.MLM_REGION_CODE:
        _organizationId = OrganizationId.MLM_ORGANIZATION_ID;
        break;
      case MyString.LKW_REGION_CODE:
        _organizationId = OrganizationId.LKW_ORGANIZATION_ID;
        break;
      case MyString.MGY_REGION_CODE:
        _organizationId = OrganizationId.MGY_ORGANIZATION_ID;
        break;
      case MyString.HLY_REGION_CODE:
        _organizationId = OrganizationId.HLY_ORGANIZATION_ID;
        break;
      case MyString.HPA_REGION_CODE:
        _organizationId = OrganizationId.HPA_ORGANIZATION_ID;
        break;
    }
    return _organizationId;
  }

  static String getCityLogo(String regionCode){
    String _logo;
    switch(regionCode){
      case MyString.TGY_REGION_CODE:
        _logo = 'images/tgy_logo.png';
        break;
      case MyString.MLM_REGION_CODE:
        _logo = 'images/mlm_logo.png';
        break;
//      case MyString.HLY_REGIONCODE:
//        _logo = 'images/mlm_logo.png';
//        break;
    }
    return _logo;
  }

  static String getCityWelcomeTitle(String regionCode){
    String _title = '';
    switch(regionCode){
      case MyString.TGY_REGION_CODE:
        _title = MyString.txt_welcome_tgy;
        break;
      case MyString.MLM_REGION_CODE:
        _title = MyString.txt_welcome_mlm;
        break;
      case MyString.LKW_REGION_CODE:
        _title = MyString.txt_welcome_lkw;
        break;
      case MyString.MGY_REGION_CODE:
        _title = MyString.txt_welcome_mgy;
        break;
      case MyString.HLY_REGION_CODE:
        _title = MyString.txt_welcome_hty;
        break;
      case MyString.HPA_REGION_CODE:
        _title = MyString.txt_welcome_hpa;
        break;
    }
    return _title;
  }

  static List<String> getCityList(){
    return [ MyString.TGY_CITY,MyString.MLM_CITY, MyString.HLY_CITY];
  }

  static String getRegionCode(String city){
    String _regionCode = '';
    switch(city){
      case MyString.TGY_CITY:
        _regionCode = MyString.TGY_REGION_CODE;
        break;
      case MyString.MLM_CITY:
        _regionCode = MyString.MLM_REGION_CODE;
        break;
      case MyString.LKW_CITY:
        _regionCode = MyString.LKW_REGION_CODE;
        break;
      case MyString.MGY_CITY:
        _regionCode = MyString.MGY_REGION_CODE;
        break;
      case MyString.HLY_CITY:
        _regionCode = MyString.HLY_REGION_CODE;
        break;
      case MyString.HPA_CITY:
        _regionCode = MyString.HPA_REGION_CODE;
        break;
    }
    return _regionCode;
  }

  static Future propertyCalculatorScreen(String regionCode, BuildContext context){
    var _navigator;
    switch (regionCode){
      case MyString.TGY_REGION_CODE:
        _navigator = NavigatorHelper.myNavigatorPush(context, TgyPropertyTaxCalculatorScreen(), ScreenName.TGY_PROPERTY_TAX_CALCULATOR_SCREEN);
        break;
      case MyString.MLM_REGION_CODE:
        _navigator = NavigatorHelper.myNavigatorPush(context, MlmPropertyTaxCalculatorScreen(), ScreenName.MLM_PROPERTY_TAX_CALCULATOR_SCREEN);
        break;
      case MyString.LKW_REGION_CODE:
        _navigator = NavigatorHelper.myNavigatorPush(context, LkwPropertyTaxCalculatorScreen(), ScreenName.LKW_PROPERTY_TAX_CALCULATOR_SCREEN);
        break;
      case MyString.MGY_REGION_CODE:
        _navigator = NavigatorHelper.myNavigatorPush(context, LkwPropertyTaxCalculatorScreen(), ScreenName.LKW_PROPERTY_TAX_CALCULATOR_SCREEN);
        break;
    }
    return _navigator;
  }

  static Future bizTaxCalculatorScreen(String regionCode, BuildContext context){
    var _navigator;
    switch (regionCode){
      case MyString.TGY_REGION_CODE:
        _navigator = NavigatorHelper.myNavigatorPush(context, TgyBizTaxCalculatorScreen(), ScreenName.TGY_BIZ_TAX_CALCULATOR_SCREEN);
        break;
      case MyString.MLM_REGION_CODE:
        _navigator = NavigatorHelper.myNavigatorPush(context, MlmBizTaxCalculatorScreen(), ScreenName.MLM_BIZ_TAX_CALCULATOR_SCREEN);
        break;
      case MyString.LKW_REGION_CODE:
        _navigator = NavigatorHelper.myNavigatorPush(context, LkwBizTaxCalculatorScreen(), ScreenName.LKW_PROPERTY_TAX_CALCULATOR_SCREEN);
        break;
      case MyString.MGY_REGION_CODE:
        _navigator = NavigatorHelper.myNavigatorPush(context, LkwBizTaxCalculatorScreen(), ScreenName.LKW_PROPERTY_TAX_CALCULATOR_SCREEN);
        break;
    }
    return _navigator;
  }
}