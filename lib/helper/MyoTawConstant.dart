import 'package:flutter/material.dart';

class MyColor{
  static const Color colorPrimary = Color(0xff08c299);
  static const Color colorPrimaryDark = Color(0xff06b48e);
  static const Color colorTextGrey = Color(0xff9ea3a8);
  static const Color colorTextBlack = Color(0xff444547);
  static const Color colorGreyDark = Color(0xffd9dadb);
  static const Color colorGrey = Color(0xfff2f3f4);
  static const Color colorBlackSemiTransparent = Color(0xffB2000000);
}

class FontSize{
  static const double textSizeLarge = 20;
  static const double textSizeExtraNormal = 17;
  static const double textSizeNormal = 15;
  static const double textSizeSmall = 12;
}

class BaseUrl{
  static const String WEB_SERVICE_ROOT_ADDRESS = "https://cityappapi.azurewebsites.net/api/";
  static const String WEB_SERVICE_ROOT_ADDRESS_NEWSFEED = "https://generalcontentproviderapi.azurewebsites.net/api/";
  static const String NEWS_FEED_CONTENT_URL = "https://portalvhdslvb28rs1c3tmc.blob.core.windows.net/city/NewsFeed/";
  static const String USER_PHOTO_URL = "https://portalvhdslvb28rs1c3tmc.blob.core.windows.net/city/Member/";
}

class MyString{
  static const String txt_like = "နှစ်သက်";
  static const String txt_save = "သိမ်းမည်";
  static const String txt_welcome_tgy ='တောင်ကြီးမြို့စည်ပင်သာယာရေး တရားဝင် မြို့တော် အပရီကေးရှင်းမှ ကြိုဆိုပါသည်။';
  static const String txt_welcome_mlm ='မော်လမြိုင်မြို့စည်ပင်သာယာရေး တရားဝင် မြို့တော် အပရီကေးရှင်းမှ ကြိုဆိုပါသည်။';
  static const String TGY_CITY = 'တောင်ကြီးမြို့';
  static const String MLM_CITY = 'မော်လမြိုင်မြို့';
  static const String TGY_REGIONCODE = "TGY";
  static const String MLM_REGIONCODE = "MLM";

  //dashboard title
  static const String txt_municipal = 'စည်ပင်အကြောင်း';
  static const String txt_tax = 'စည်ပင်အခွန်';
  static const String txt_suggestion = 'အကြံပြုစာပို့မည်';
  static const String txt_business_tax = 'လိုင်စင်လျှောက်ထားခြင်း';
  static const String txt_online_tax = 'အွန်လိုင်းမှပေးဆောင်ခြင်း';
  static const String txt_tax_use = 'အခွန်ငွေသုံးစွဲမှု';
  static const String txt_calculate_tax = 'အခွန်တွက်ရန်';
  static const String txt_faq = 'အမေးများသောမေးခွန်းများ';
  static const String txt_save_newsFeed = 'ဖတ်ရန်သိမ်းထားသည်များ';
  static const String txt_profile = 'သင့်အကောင့်';
  static const String txt_referral = 'ညွှန်းသူ';
  static const String title_profile = 'ကိုယ်ရေးအချက်အလက်';
  static const String txt_setting = 'ပြင်ဆင်ရန်';
  static const String txt_edit_profile = 'ကို‌ယ်ရေးအချက်အလက်ပြင်ဆင်ရန်';
  static const String txt_apply_biz_license = 'လျှောက်ထားပြီးသော လုပ်ငန်းလိုင်စင်များ';
  static const String txt_log_out = 'ထွက်မည်';
  static const String txt_log_out_cancel = 'မထွက်ပါ';
  static const String txt_tax_record = 'အခွန်မှတ်တမ်း';
  static const String txt_tax_new_record = 'အခွန်မှတ်တမ်းအသစ် မှတ်ရန်';
  static const String txt_are_u_sure = 'သေချာပါသလား';
  static const String title_save_nf = 'သိမ်းဆည်းထားသည်များ';
  static const String txt_delete = 'ဖျက်မည်';
  static const String txt_delete_cancel = 'မဖျက်ပါ';
  static const String NEWS_FEED_CONTENT_TYPE_PHOTO = 'Photo';
  static const String NEWS_FEED_CONTENT_TYPE_VIDEO = 'Video';
  static const String txt_user_name = 'အမည်';
  static const String txt_user_address = 'လိပ်စာ';
  static const String txt_user_state = 'တိုင်း/ဒေသကြီး';
  static const String txt_user_township = 'မြို့နယ်';
  static const String txt_save_user_profile = 'သိမ်းဆည်းမည်';
  static const String title_faq = 'အမေးများသောမေးခွန်းများ';
}

class OrganizationId{
  static const int TGY_ORGANIZATION_ID = 8;
  static const int MLM_ORGANIZATION_ID = 9;
}