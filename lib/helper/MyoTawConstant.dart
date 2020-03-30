import 'package:flutter/material.dart';

class MyColor{
  static const Color colorPrimary = Color(0xff08c299);
  static const Color colorPrimaryDark = Color(0xff06b48e);
  static const Color colorTextGrey = Color(0xff9ea3a8);
  static const Color colorTextBlack = Color(0xff444547);
  static const Color colorGreyDark = Color(0xffd9dadb);
  static const Color colorGrey = Color(0xfff2f3f4);
  static const Color colorBlackSemiTransparent = Color(0xffB2000000);
  static const Color colorAccent = Color(0xffc22d08);
}

class FontSize{
  static const double textSizeLarge = 20;
  static const double textSizeExtraNormal = 17;
  static const double textSizeNormal = 15;
  static const double textSizeExtraSmall = 13;
  static const double textSizeSmall = 12;
  static const double textSizeLessSmall = 10;
}

class BaseUrl{
  static const String WEB_SERVICE_ROOT_ADDRESS = "https://cityappapi.azurewebsites.net/api/";
  static const String WEB_SERVICE_ROOT_ADDRESS_NEWSFEED = "https://generalcontentproviderapi.azurewebsites.net/api/";
  static const String WEB_SERVICE_ROOT_ADDRESS_TAX_PAYMENT = "https://taxpaymentservice.azurewebsites.net/api/";
  static const String WEB_SERVICE_ROOT_ADDRESS_REFERRAL = "https://newmaymay.azurewebsites.net/api/";
  static const String WEB_SERVICE_ROOT_ADDRESS_DAO_INVOICE_NO = "https://daoapifinal.azurewebsites.net/api/";
  static const String REFERRAL_URL = "https://maymayadmin.azurewebsites.net/Referral/CityAppReferralDetail?referralpno=";
  static const String WEB_SERVICE_ROOT_ADDRESS_OTP = "https://kktsmsverification.azurewebsites.net/api/";
  static const String MYO_TAW_POLICY_URL = "https://myotawadmin.azurewebsites.net/Privacy/privacypolicy";

  //photo url
  static const String NEWS_FEED_CONTENT_URL = "https://portalvhdslvb28rs1c3tmc.blob.core.windows.net/city/NewsFeed/";
  static const String CONTRIBUTE_PHOTO_URL = "https://portalvhdslvb28rs1c3tmc.blob.core.windows.net/city/Contribute/";
  static const String USER_PHOTO_URL = "https://portalvhdslvb28rs1c3tmc.blob.core.windows.net/city/Member/";
  static const String DAO_PHOTO_URL = "https://portalvhdslvb28rs1c3tmc.blob.core.windows.net/city/AboutDAO/";
  static const String APPLY_BIZ_LICENSE_PHOTO_URL = "https://portalvhdslvb28rs1c3tmc.blob.core.windows.net/city/ApplyBiz/";
  static const String TAX_RECORD_PHOTO_URL = "https://portalvhdslvb28rs1c3tmc.blob.core.windows.net/city/TaxRecord/";
}

class OrganizationId{
  static const int TGY_ORGANIZATION_ID = 8;
  static const int MLM_ORGANIZATION_ID = 9;
  static const int LKW_ORGANIZATION_ID = 13;
  static const int MGY_ORGANIZATION_ID = 14;
}

class MyString{
  static const String API_KEY = "B93979A51C8C46712DD2C8271587B262";

  static const String txt_like = "နှစ်သက်";
  static const String txt_save = "သိမ်းမည်";

  static const String txt_welcome_tgy ='တောင်ကြီးမြို့စည်ပင်သာယာရေး တရားဝင် မြို့တော် အပ်ပလီကေးရှင်းမှ ကြိုဆိုပါသည်။';
  static const String txt_welcome_mlm ='မော်လမြိုင်မြို့စည်ပင်သာယာရေး တရားဝင် မြို့တော် အပ်ပလီကေးရှင်းမှ ကြိုဆိုပါသည်။';
  static const String txt_welcome_lkw ='လွိုင်ကော်မြို့စည်ပင်သာယာရေး တရားဝင် မြို့တော် အပ်ပလီကေးရှင်းမှ ကြိုဆိုပါသည်။';
  static const String txt_welcome_mgy ='မကွေးမြို့စည်ပင်သာယာရေး တရားဝင် မြို့တော် အပ်ပလီကေးရှင်းမှ ကြိုဆိုပါသည်။';

  static const String TGY_CITY = 'တောင်ကြီးမြို့';
  static const String MLM_CITY = 'မော်လမြိုင်မြို့';
  static const String LKW_CITY = 'လွိုင်ကော်မြို့';
  static const String MGY_CITY = 'မကွေးမြို့';

  static const String TGY_REGIONCODE = "TGY";
  static const String MLM_REGIONCODE = "MLM";
  static const String LKW_REGIONCODE = "LKW";
  static const String MGY_REGIONCODE = "MGY";

  static const String txt_welcome = "မြို့တော်မှ ကြိုဆိုပါ၏။";


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
  static const String txt_dept_manager = 'စီမံခန့်ခွဲမှုဌာနခွဲ';
  static const String txt_dept_engineer = 'အင်ဂျင်နီယာဌာနခွဲ';
  static const String txt_biz_license = 'လိုင်စင်နှင့်လျှောက်လွှာများသို့';
  static const String txt_gallery = 'Gallery မှပုံတင်မည်';
  static const String txt_camera = 'ဓာတ်ပုံရိုက်မည်';
  static const String txt_upload_photo = 'ပုံတင်မည်';
  static const String txt_choose_photo = 'ပုံပြန်ရွေးမည်';
  static const String txt_tax_record_name = 'မှတ်တမ်းအမည်';
  static const String txt_upload_photo_camera = 'ဓာတ်ပုံတင်ရန်';
  static const String txt_upload_photo_gallery = 'Gallery မှဓာတ်ပုံယူရန်';
  static const String title_suggestion = 'ပေးပို့လိုသော စာ';
  static const String title_suggestion_subject = 'အကြောင်းအရာ';
  static const String txt_choose_subject = 'အကြောင်းအရာရွေးချယ်ပါ';
  static const String title_suggestion_mess = 'အကြံပြုစာ';
  static const String txt_send_suggestion = 'စာပို့မည်';
  static const String txt_suggestion_finish = 'ပူးပေါင်းပါဝင်မှုအတွက် \n ကျေးဇူးတင်ပါသည်။';
  static const String txt_close = 'ပိတ်မည်';
  static const String txt_location_update = 'တည်နေရာရယူရန်';
  static const String txt_get_location_update = 'တည်နေရာယူမည်';
  static const String title_biz_license = 'လုပ်ငန်းလိုင်စင်နှင့်ခွင့်ပြုမိန့်လျှောက်ထားရန်';
  static const String txt_biz_license_information = 'လုပ်ငန်းဆိုင်ရာအချက်အလက်များ';
  static const String txt_biz_name = 'လုပ်ငန်းအမည်';
  static const String txt_biz_type = 'လုပ်ငန်းအမျိုးအစား';
  static const String txt_area = 'အကျယ်အဝန်း (အလျား × အနံ)';
  static const String txt_unit_feet = 'ပေ';
  static const String txt_biz_location = 'တည်နေရာ';
  static const String txt_biz_region_no = 'အမှတ်';
  static const String txt_biz_street_name = 'လမ်း';
  static const String txt_biz_block_no = 'ရပ်ကွက်';
  static const String txt_township = 'မြို့နယ်';
  static const String txt_state = 'တိုင်း/ဒေသကြီး';
  static const String txt_state_warning = 'တိုင်း/ဒေသကြီး ဖြည့်ပေးပါ';
  static const String txt_owner_information = 'ပိုင်ရှင်ဆိုင်ရာအချက်အလက်များ';
  static const String txt_owner_name = 'အမည်';
  static const String txt_owner_nrc_no = 'မှတ်ပုံတင်အမှတ်';
  static const String txt_owner_ph_no = 'ဆက်သွယ်ရန်ဖုန်းနံပါတ်';
  static const String txt_owner_region_no = 'အမှတ်';
  static const String txt_owner_street_name = 'လမ်း';
  static const String txt_owner_block_no = 'ရပ်ကွက်';
  static const String txt_owner_township = 'မြို့နယ်';
  static const String txt_owner_state = 'တိုင်း/ဒေသကြီး';
  static const String txt_owner_location = 'တည်နေရာ';
  static const String txt_remark = 'မှတ်ချက်';
  static const String txt_apply_license = 'လျှောက်ထားမည်';
  static const String txt_apply_license_need_to_fill = 'ပြထားသည့်များဖြည့်ပေးရန်လိုအပ်သည်။';
  static const String txt_need_paper_work = 'လိုအပ်သောစာရွက်စာတမ်းများတင်ရန်/ကြည့်ရန်';
  static const String txt_apply_biz_license_photo = 'လုပ်ငန်းလိုင်စင်ဓာတ်ပုံများ';
  static const String txt_tax_use_no_data = 'ဒေတာမရှိပါ';
  static const String txt_tax_type = 'အခွန်အမျိုးအစား';
  static const String txt_tax_bill_amount = 'အခွန်ငွေ';
  static const String txt_kyat = 'ကျပ်';
  static const String txt_user_money = 'မိမိ၏ငွေ';
  static const String txt_top_up = 'ငွေဖြည့်မည်';
  static const String txt_pay_tax = 'အခွန်ဆောင်မည်';
  static const String title_top_up = 'ငွေဖြည့်ရန်';
  static const String txt_prepaid_code = 'ငွေဖြည့်ကုဒ်';
  static const String txt_pin_code = 'ပင်ကုဒ်';
  static const String txt_top_up_cancel = 'ထွက်မည်';
  static const String txt_create_pin = 'ပင်ကုဒ်ပြုလုပ်မည်';
  static const String txt_profile_set_up = 'ဖြည့်သွင်းမည်';
  static const String txt_profile_set_up_need = 'ကိုယ်ရေးအချက်အလက် ဖြည့်သွင်းရန်လိုပါသည်။';
  static const String txt_online_payment_tax = 'အခွန်ဆောင်ရန်';
  static const String txt_invoice_no = 'ပြေစာနံပါတ်';
  static const String txt_choose_tax_type = 'အခွန်အမျိုးအစားရွေးပါ';
  static const String txt_tax_amount = 'အခွန်ဆောင်ရမည့်ငွေပမာဏ';
  static const String txt_get_tax_amount = 'အခွန်ဆောင်မည့်ပမာဏရယူမည့်';
  static const String txt_pay_tax_confirm = 'ပေးမည်';
  static const String txt_pay_tax_success = 'အခွန်ပေးဆောင်မှုအောင်မြင်သည်';
  static const String txt_scan_qr_code = 'ဤနေရာကို Scan ဖတ်ပါ';
  static const String txt_send = 'ပို့မည်';
  static const String txt_not_send = 'မပို့ပါ';
  static const String txt_pin_set_up_success = 'ပင်ကုဒ်ပြုလုပ်မှု အောင်မြင်သည်။';

  static const String PROPERTY_TAX = "PropertyTax";
  static const String BIZ_LICENSE = "BizLicense";
  static const String WATER_METER = "WaterMeter";
  static const String MARKET_TAX = "MarketTax";
  static const String WHEEL_TAX = "WheelTax";
  static const String SIGNBOARD_TAX = "SignboardTax";

  static const String MYAN_PROPERTY_TAX = "ပစ္စည်းခွန် (စံငှားခွန်)";
  static const String MYAN_BIZ_LICENSE = "လုပ်ငန်းလိုင်စင်";
  static const String MYAN_WATER_METER = "ရေမီတာခွန်";
  static const String MYAN_MARKET_TAX = "ဈေးဆိုင်ခန်းခွန်";
  static const String MYAN_WHEEL_TAX = "ဘီးခွန်";
  static const String MYAN_SIGNBOARD_TAX = "ကြော်ငြာဆိုင်းဘုတ်ခွန်";

  static const String txt_referral_wrong_app = "အပရီကေရှင်း မှားယွင်းနေပါသည်";
  static const String title_calculate_tax = "အခွန်အမျိုးအစား ရွေးပါ";
  static const String txt_property_tax = "ပစ္စည်းခွန်";
  static const String title_property_tax_calculate = "ပစ္စည်းခွန် တွက်ချက်ရန်အတွက်";
  static const String title_biz_tax_calculate = "လုပ်ငန်းလိုင်စင်ခွန် တွက်ချက်ရန်အတွက်";
  static const String txt_biz_tax = "လုပ်ငန်းလိုင်စင်ခွန်";
  static const String txt_building_type = "အဆောက်အဦးအမျိုးအစား";
  static const String txt_story = "အထပ်အရေအတွက်";
  static const String txt_road = "လမ်းဥပစာ";
  static const String txt_blockNo = "ရပ်ကွက်";
  static const String txt_no_selected = "သတ်မှတ်ထားခြင်းမရှိ";
  static const String txt_calculate = "တွက်မည်";
  static const String txt_biz_tax_range = "ပေးဆောင်ရမည့် အခွန်နှုန်းထားမှာ";
  static const String txt_biz_tax_property = "ပေးဆောင်ရမည့် အခွန်မှာ";
  static const String txt_thanks = "အခွန်ပေးဆောင်မှုအတွက် \n ကျေးဇူးတင်ပါသည်။";
  static const String txt_choose_biz_license_type = "လိုင်စင်အမျိုးအစားရွေးပါ";
  static const String txt_license_type = "လိုင်စင်အမျိုးအစား";
  static const String txt_site_area = "အဆောက်အဦး (အလျား × အနံ)";
  static const String txt_grade = "အတန်းအစား";
  static const String title_smart_water_meter = "Smart ရေမီတာမှ \n အခွန်ဆောင်ခြင်း";
  static const String txt_smart_water_meter = "Smart ရေမီတာမှ အခွန်ဆောင်ခြင်း";
  static const String title_online_tax_payment = "အွန်လိုင်းမှ \n အခွန်ဆောင်ခြင်း";
  static const String txt_water_meter_unit = "သုံးစွဲယူနစ်";
  static const String txt_water_meter_no = "ရေမီတာနံပါတ်";
  static const String txt_smart_wm_date = "ရက်စွဲ";
  static const String txt_smart_wm_unit = "ယူနစ်";
  static const String txt_smart_wm_amount = "ကျသင့်ငွေ";
  static const String txt_smart_wm_not_register = "သင်သည် Smart ရေမီတာအတွက် စာရင်းသွင်းထားခြင်းမရှိပါ။";
  static const String txt_fill_pin_code = "ပင်ကုဒ်ရိုက်ထည့်ပေးပါ";
  static const String txt_get_otp = "OTP ကုဒ်ရယူရန်";
  static const String txt_enter_otp = "OTP ကုဒ်ရိုက်ထည့်ပေးပါ။";
  static const String txt_fill_otp = "OTP ကုဒ်ကိုဖြည့်ပါ";
  static const String txt_otp_not_exceed_4 = "OTP ကုဒ် ၄ လုံးထက်ကျော်၍မရပါ။";
  static const String txt_no_internet = "ကွန်နက်ရှင်ကိုစစ်ဆေးပါ။";
  static const String txt_no_newsFeed_data = "သတင်းများမရှိသေးပါ။";
  static const String txt_no_data = "ဒေတာမရှိပါ။";
  static const String txt_coming_soon = "မကြာမီလာမည်။";
  static const String txt_need_suggestion = "အကြံပြုစာရေးပေးပါ။";
  static const String txt_need_subject = "အကြောင်းအရာရွေးပေးပါ။";
  static const String txt_need_suggestion_photo = "ဓာတ်ပုံတင်ရန် လိုအပ်ပါသည်။";
  static const String txt_need_suggestion_location = "တည်နေရာ မရ ရှိပါ။";
  static const String txt_try_again = "နောက်တစ်ကြိမ်လုပ်ဆောင်ပါ";
  static const String txt_fill_phno = "ဖုန်းနံပါတ်ရိုက်ထည့်ပါ။";
  static const String txt_choose_city = "မြို့ရွေးချယ်ပေးပါ။";
  static const String txt_wrong_phNo= "ဖုန်းနံပါတ် မှားယွင်းနေပါသည်။";
  static const String txt_save_newsFeed_success = "သိမ်းဆည်းပြီး။";
  static const String txt_check_internet= "ကွန်နက်ရှင်ကိုစစ်ဆေးပါ။";
  static const String txt_need_apply_biz_photo_name= "ဓာတ်ပုံအမည် ရေးပေးပါ။";
  static const String txt_choose_building_type= "အဆောက်အဦး အမျိုးအစားရွေးပေးပါ။";
  static const String txt_choose_story= "အထပ် အရေအတွက်ရွေးပေးပါ။";
  static const String txt_choose_blockNo= "ရပ်ကွက် အမျိုးအစားရွေးပေးပါ။";
  static const String txt_type_length= "အလျား လိုအပ်သည်။";
  static const String txt_type_width= "အနံ လိုအပ်သည်။";
  static const String txt_type_length_width= "အလျား အနံ လိုအပ်သည်။";
  static const String txt_wrong_pin_code = "ပင်ကုဒ် မှားနေပါသည်။";
  static const String txt_need_prepaid_code = "ငွေဖြည့်ကုဒ် ရိုက်ပေးပါ။";
  static const String txt_need_pin_code = "ပင်ကုဒ် ရိုက်ပေးပါ။";
  static const String txt_choose_grade = "အတန်းအစား ရွေး‌ပေးပါ။";
  static const String txt_choose_biz_license = "လုပ်ငန်းအမျိုးအစား ရွေး‌ပေးပါ။";
  static const String txt_need_tax_record_name = "မှတ်တမ်းအမည် ဖြည့်ရန်လိုအပ်သည်။";
  static const String txt_wrong_invoice_or_tax_type = "ပြေစာနံပါတ် သို့မဟုတ် အခွန်အမျိုးအစား မှားနေပါသည်။";
  static const String txt_need_invoice_no = "ပြေစာနံပါတ် ဖြည့်ရန်လိုအပ်သည်။";
  static const String txt_top_up_expired = "ငွေဖြည့်ကုဒ်သက်တမ်းကုန်သွားသည်။";
  static const String txt_top_up_already = "ငွေဖြည့်ကုဒ်မှာအသုံးပြုပြီပါပြီး။";
  static const String txt_no_photo = "ဓာတ်ပုံများမရှိပါ";
  static const String txt_newsfeed = "သတင်းများ";
  static const String txt_contributions = "အကြုံပြုစာများ";
  static const String txt_profile_complete = "ကိုယ်ရေးအချက်အလက်ဖြည့်သွင်းမှု အောင်မြင်သည်။";
  static const String txt_empty_contribution = "အကြံပြုစာများ မရှိသေးပါ။";
  static const String txt_to_contribute = "အကြုံပြုမည်";
  static const String txt_contribute_fact = "အကြုံပြုချက်";
  static const String txt_send_contribution = "အကြုံပြုစာပို့မည်";
  static const String txt_ward_admin_feature = "Ward Admin ၏ ပူးပေါင်းပါဝင်မှုကဏ္ဍ";
  static const String txt_myotaw_feature = "မြို့တော်အပ်ပလီကေးရှင်းကဏ္ဍ";
  static const String txt_choose_feature = "ကဏ္ဍရွေးချယ်ပေးပါ";
  static const String txt_title_dashboard = "ကဏ္ဍများ";
  static const String txt_title_notification = "အသိပေးနှိုးဆော်ချက်";
  static const String txt_login = "ဝင်မည်";
  static const String txt_top_up_record = 'ငွေဖြည့်မှတ်တမ်း';
  static const String txt_top_up_amount = 'ငွေဖြည့်ကဒ်တန်ဖိုး';
  static const String txt_top_up_amount_before = 'ငွေမဖြည့်ရသေးသည့်တန်ဖိုး';
  static const String txt_top_up_amount_after = 'ငွေဖြည့်ပြီးတန်ဖိုး';
  static const String txt_flood_level = 'ရေကြီးခြင်းမှတ်တမ်း';
  static const String txt_flood_level_inch = 'ရေကြီးခြင်း (အမြင့်)';
  static const String txt_add_flood_level_record = 'မှတ်တမ်းတင်မည်';
  static const String txt_flood_level_height = 'ရေကြီးခြင်းအတိုင်းအတာ';
  static const String txt_get_flood_level= 'အတိုင်းအတာယူမည်';
  static const String txt_inch = 'လက်မ';
  static const String txt_feet = 'ပေ';
  static const String txt_flood_report_finish = 'မှတ်တမ်းတင်မှုအောင်မြင်သည်။';
  static const String txt_need_flood_level = 'ရေကြီးခြင်းအတိုင်းအတာလိုအပ်သည်။';
  static const String txt_flood_level_no_record = 'မှတ်တမ်းမရှိပါ။';
  static const String txt_no_top_up_record = 'ငွေဖြည့်မှတ်တမ်းမရှိပါ။';
  static const String txt_tax_record_upload_success = 'အခွန်မှတ်တမ်းအသစ်တင်မှုအောင်မြင်သည်။';
  static const String txt_tax_record_upload = 'အခွန်မှတ်တမ်းတင်မည်';
  static const String txt_saved_news_feed = 'သိမ်းဆည်းထားပြီး';
  static const String txt_choose_state_township = 'နေရပ်ရွေးပါ';
  static const String txt_need_user_information = 'ကိုယ်ရေးအချက်အလက်ဖြည့်ပေးပါ။';
  static const String txt_confirm = 'ရွေးမည်';
  static const String txt_faq_category_all = 'အားလုံး';
  static const String txt_get_flood_level_photo = 'ဓာတ်ပုံနှင့် ရေအမြင့်ယူရန်';
  static const String txt_square_feet = 'စတုရန်းပေ';
  static const String txt_choose_square_feet = 'စတုရန်းပေရွေးပေးပါ';
  static const String txt_no_notification = 'အသိပေးနှိုးဆော်ချက် မရှိသေးပါ။';
  static const String txt_choose_road= "လမ်းဥပစာ အမျိုးအစားရွေးပေးပါ။";
  static const String txt_upload = 'ပုံတင်မည်';
  static const String txt_upload_file_name = 'ဖိုင်အမည်';
  static const String txt_no_apply_biz_form_warning = 'အချက်အလက်များဖြည့်စွက်ရန်ကျန်ရှိသည်။';
  static const String txt_special_grade = 'အထူးနှုန်း';
  static const String txt_upload_need_apply_biz_file = 'လိုအပ်သောစာရွက်စာတမ်းတင်မည်';
  static const String txt_select_all = 'အားလုံး';
  static const String txt_myotaw_app_policy = 'Login ဝင်ခြင်းသည် MyoTaw app ၏ Policy \n ကိုလက်ခံပြီးဖြစ်သည်။';

  static const String txt_first_grade = 'ပထမတန်းစား';
  static const String txt_second_grade = 'ဒုတိယတန်းစား';
  static const String txt_third_grade = 'တတိယတန်းစား';
  static const String txt_fourth_grade = 'စတုတ္ထတန်းစား';




  static const String BUILDING_GRADE_A = "building grade A";
  static const String BUILDING_GRADE_B = "building grade B";
  static const String BUILDING_GRADE_C = "building grade C";
  static const String GOV_BUILDING = "gov";

  //contribution
  static const String FIX_ROAD_CONTRIBUTE = "လမ်းပြင်၊ လမ်းပျက်";
  static const String GARBAGE_CONTRIBUTE = "အမှိုက်";
  static const String DRAINAGE_CONTRIBUTE = "ရေမြောင်း";
  static const String FLOOD_CONTRIBUTE = "ရေကြီး၊ ရေလျှံ";
  static const String ELECTRIC_CONTRIBUTE = "မီးကြိုး";
  static const String ANIMAL_CONTRIBUTE = "တိရိစ္ဆာန်အရေး";
  static const String WATER_DISTRIBUTION_CONTRIBUTE = "ရေပေးဝေရေး";
  static const String PUBLIC_PLACE_CONTRIBUTE = "အများပိုင်နေရာ";
  static const String TRAFFIC_CONTRIBUTE = "မော်တော်ယာဉ်ဆိုင်ရာ";
  static const String CRIME_CONTRIBUTE = "မှုခင်း";
  static const String OTHER_CONTRIBUTE = "အခြား";

  static const String FIX_ROAD_ICON = "fix_road_nocircle";
  static const String GARBAGE_ICON = "cleaning_nocircle";
  static const String DRAINAGE_ICON = "city_drain_nocircle";
  static const String FLOOD_ICON = "flood_nocircle";
  static const String ELECTRIC_ICON = "electric_nocircle";
  static const String ANIMAL_ICON = "animal_nocircle";
  static const String WATER_DISTRIBUTION_ICON = "water_nocircle";
  static const String PUBLIC_PLACE_ICON = "public_nocircle";
  static const String TRAFFIC_ICON = "traffic_nocircle";
  static const String CRIME_ICON = "criminal_nocircle";
  static const String OTHER_ICON= "other_nocircle";


  static const double PHOTO_MAX_WIDTH= 1024;
  static const double PHOTO_MAX_HEIGHT= 720;


  static const String NOTIFICATION_TAB = "Notification Tab";
}

class MyStringList{

  //Tgy
  static const List<String> biz_tgy_food = [
    'ကုန်စုံဆိုင်/မုန့်ဆိုင်',
    'မုန့်ဖုတ်ခြင်း/ရောင်းချခြင်း',
    'အအေးနှင့်ဖျော်ရည်ပြုလုပ်ရောင်းချခြင်း',
    'ရေခဲစက်/ဘိလပ်ရည်စက်နှင့်ရေခဲချောင်းလုပ်ငန်း',
    'လ္ဘက်ရည်/ကော်ဖီစသည့်အလားတူပြင်ဆင်ရောင်းချခြင်း',
    'ထမင်း/ခေါက်ဆွဲ(အကြော်/အပြုတ်)',
    'ကြာဇံ/မုန့်ဟင်းခါး/တိုဖူးနွေး/ရှမ်းခေါက်ဆွဲစသည့် အလားတူလုပ်ငန်း',
    'ဆီနှင့်ကြော်သော အကြော်မျိုးစုံ',
    'စားသောက်ဆိုင်ကြီး/ပျော်ပွဲစားရုံ/ဟိုတယ်ဆိုင်ကြီးများ',
    'ကွမ်းယာရောင်းခြင်း',
    'နေကြာစေ့/ကွာစေ့/ယိုစုံ/ချိုချဉ် စသည့်အိမ်တွင်းမှုစားသောက်ကုန်လုပ်ငန်း',
    'ချဉ်ဖတ်လုပ်ငန်း',
    'မုန့်တီလုပ်ငန်း'];

  static const List<String> biz_tgy_license = [
    'စားသောက်ဆိုင်လုပ်ငန်းလိုင်စင်',
    'ဘေးအန္တရာယ်လုပ်ငန်းလိုင်စင်',
    'တည်းခိုခန်းလုပ်ငန်းလိုင်စင်',
    'ကိုယ်ပိုင်စီးပွားဖြစ်(ရေပေးရေးလုပ်ငန်း) လိုင်စင်',
    'ကိုယ်ပိုင်ဈေး(စတိုးဆိုင်) လုပ်ငန်းလိုင်စင်',
    'မင်္ဂလာခန်းမလိုင်စင်'];

  static const List<String> biz_tgy_danger = [
    'အလုပ်ရုံများ(စက်မှု၊ လက်မှု)',
    'လေထိုး၊ တာယာ၊ ကျွတ်လုပ်ငန်း',
    'စက်ချုပ်ဆိုင်၊ မိုးကာ ကူရှင်ချုပ်လုပ်ငန်း',
    'လျှပ်စစ်ဘက်ထရီလုပ်ငန်း',
    'ထင်း၊ မီးသွေး၊ ဝါး၊ ကြိမ်၊ သစ်ခွဲသား၊ သက်ကယ် သိုလှောင်ခြင်း',
    'လဲမှို့၊ ဝါဂွမ်း၊ ဆေးဆိုး၊ သိုးမွေးလုပ်ငန်း',
    'ဆံသနှင့်အလှပြင်လုပ်ငန်းများ',
    'ပုံနှိပ်လုပ်ငန်း',
    'စက်ဘီးပြင်၊ ထီးပြင်၊ ဖိနပ်ပြင်လုပ်ငန်း',
    'ကျွဲကော်ပစ္စည်းသိုလှောင်ခြင်း(ပလပ်စတစ်လုပ်ငန်း)',
    'စက်ရုံများ(သစ်ခွဲစက်၊ အမှုန့်ကြိတ်စက်၊ ဆီစက်၊ ဆပ်ပြာစက်)',
    'သဲ၊ အုတ်သိုလှောင်ရေး(အုတ်လုပ်ငန်း)',
    'ဆေးခန်း(ရောဂါရှာဖွေရေး၊ ဓါတ်ခွဲခန်း၊ အရေပြားအလှပြုပြင်ရေးဆေးခန်းအပါအဝင်)အလားတူလုပ်ငန်းများ',
    'ပုဂ္ဂလိကဆေးရုံကြီးများ',
    'ဆေးနှင့်ဆေးပစ္စည်းအရောင်းဆိုင်များ',
    'ဗီဒီယို၊ ဓါတ်ပုံ၊ ရုပ်မြင်လုပ်ငန်းလိုင်စင်နှင့်အလားတူလုပ်ငန်းများ',
    'ဆန်၊ ဂျုံ၊ ပဲနှင့်အခြားကောက်ပဲသီးနှံ​ရောင်းဝယ်ရေး',
    'ဆေးရွက်ကြီး၊ ဆေးရိုး၊ သနပ်ဖက်နှင့်အလားတူပစ္စည်းသိုလှောင်ခြင်း(ဆေးလိပ်ခုံ)',
    'စားသောက်ကုန်စည်ပစ္စည်းသိုလှောင်ခြင်း(ပွဲရုံ)'];

  static const List<String> biz_tgy_store = [
    'ကုန်စုံဆိုင်/မုန့်ဆိုင်/အိမ်ဆိုင်',
    'ကိုယ်ပိုင်ဈေးများ(စတိုးဆိုင်)',
    'Super Center, Mini Mart'];

  static const List<String> biz_tgy_hotel = [
    'တည်းခိုခန်း',
    'ဘော်ဒါဆောင်'];

  static const List<String> biz_tgy_grade = [
    '(၁)ယောက်ခန်းတစ်ခန်းလျှင်',
    '(၂)ယောက်ခန်းတစ်ခန်းလျှင်',
    'မိသားစုတစ်ခန်းလျှင်'];

  static const List<String> property_tgy_building_type = [
    'သက်ကယ်မိုးထရံကာ',
    'သွပ်မိုးထရံကာ','ပျဉ်',
    'နံကပ်','တိုက်',
    'ထရံ/ဖက်','ပျဥ်/သွပ်',
    'ပျည်ထောင်',
    'ဝါး/ဓနိ',
    'အုတ်',
    'အုတ်ညှပ်',
    'RC',
    'Steel structure'];

  static const List<String> property_tgy_road = [
    'လမ်းမကြီး',
    'လမ်းကျယ်',
    'လမ်းကျဉ်း'];

  static const List<String> property_tgy_block_no = [
    'ကံကြီးရပ်ကွက်',
    'ကန်ရှေ့ရပ်ကွက်',
    'ကံသာရပ်ကွက်',
    'ကန်အောက်ရပ်ကွက်',
    'ကျောင်းကြီးစုရပ်ကွက်',
    'ချမ်းမြသာစည်ရပ်ကွက်',
    'ချမ်းသာရပ်ကွက်',
    'စဝ်စံထွန်းရပ်ကွက်',
    'စိန်ပန်းရပ်ကွက်',
    'ဈေးပိုင်းရပ်ကွက်',
    'ညောင်ဖြူစခန်းရပ်ကွက်',
    'ညောင်ရွှေဟော်ကုန်းရပ်ကွက်',
    'ပြည်တော်သာရပ်ကွက်',
    'ဘုရားဖြူရပ်ကွက်',
    'မင်္ဂလာဦးရပ်ကွက်',
    'မြို့မရပ်ကွက်',
    'ရတနာသီရိရပ်ကွက်',
    'ရွှေတောင်ရပ်ကွက်',
    'ရေအေးကွင်းရပ်ကွက်',
    'လမ်းမတော်ရပ်ကွက်',
    'သစ်တောရပ်ကွက်',
    'ဟော်ကုန်းရပ်ကွက်',
    'ရေအေးကွင်း ၁ ရပ်ကွက်',
    'ရေအေးကွင်း ၂ ရပ်ကွက်',
    'အစိုးရအဆောက်အဦးများ'];

  static const List<String> suggestion_subject = [
    'လမ်းပြင်၊ လမ်းပျက်',
    'အမှိုက်',
    'ရေမြောင်း',
    'ရေကြီး၊ ရေလျှံ',
    'မီးကြိုး',
    'တိရိစ္ဆာန်အရေး',
    'ရေပေးဝေရေး',
    'အများပိုင်နေရာ',
    'အခြား'];

  static const List<String> suggestion_subject_admin_ward = [
    'လမ်းပြင်၊ လမ်းပျက်',
    'အမှိုက်',
    'ရေမြောင်း',
    'ရေကြီး၊ ရေလျှံ',
    'မီးကြိုး',
    'တိရိစ္ဆာန်အရေး',
    'ရေပေးဝေရေး',
    'အများပိုင်နေရာ',
    'မော်တော်ယာဉ်ဆိုင်ရာ',
    'မှုခင်း',
    'အခြား'];

  //--------------------------------------------------------------------------------------------------------------------------------------------


  //Mlm
  static const List<String> biz_mlm_license = [
    'စားသောက်ဆိုင်လုပ်ငန်းလိုင်စင်',
    'ဘေးအန္တရာယ်လုပ်ငန်းလိုင်စင်',
    'ပုဂ္ဂလိကအိမ်ဆိုင်လုပ်ငန်းလိုင်စင်'];

  static const List<String> biz_mlm_food = [
    'လက်ဘက်ရည်',
    'အချိုရည်',
    'စားသောက်',
    'ထမင်း',
    'မုန့်ဟင်းခါး',
    'ကြေးအိုး/ဆီချက်',
    'ကွမ်းယာ',
    'မုန့်ဆိုင်/သစ်သီး'];

  static const List<String> biz_mlm_danger = [
    'ပရိဘောဂ',
    'ကွန်ပျူတာ',
    'ဆေးရွက်ကြီး',
    'ဝါး',
    'စက်ပြင်',
    'ထင်း/မီးသွေး',
    'ရာဘာ',
    'ကွမ်းသီး',
    'အိုး',
    'ဆေးလိပ်ခုံ',
    'စက်သုံးဆီ',
    'ပဲဆီ',
    'ဓာတ်မြေဩဇာ',
    'ဘတ္ထရီ',
    'ဆေးဆိုင်',
    'ကားအရောင်းပြခန်း',
    'သစ်စက်ဆိုင်',
    'ရေခဲစက်',
    'ရေသန့်',
    'အကြော်ဖို/မုန့်တီဖို',
    'သံပုံးပုလင်း',
    'ဗီဒီယိုခွေဌား',
    'ဆားစက်/ရောင်း',
    'ပလပ်စတစ်',
    'ဆေးခန်း၊ ဓာတ်ခွဲခန်း',
    'အရက်ချက်စက်ရုံ',
    'အခြား'];

  static const List<String> biz_mlm_store = [
    'ကုန်မာ',
    'သံမူလီ/သံဟောင်း',
    'ရွှေပန်းထိမ်',
    'ရွှေဆိုင်',
    'အပ်ချုပ်',
    'တီဗီရောင်း',
    'ပလပ်စတစ်',
    'တီဗီပြင်',
    'မျက်မှန်/မှန်',
    'နာရီ',
    'စာအုပ်ဌား',
    'စတိုး',
    'ဖိနပ်',
    'အလှကုန်',
    'စာအုပ်နှင့် စာရေးကိရိယာ',
    'အလှပြင်',
    'ဆံသဆိုင်',
    'ပွဲရုံ',
    'ဆန်',
    'ကုန်စုံ',
    'လျှပ်စစ်',
    'လယ်ယာသုံး',
    'စက်ပစ္စည်း',
    'အခြား'];

  static const List<String> property_mlm_building = [
    'RC',
    'အုတ်ညှပ်',
    'တိုက်ခံသွပ်မိုး',
    'ပျဉ်ထောင်',
    'ပျဉ်ထောင်သွပ်မိုး',
    'တိုက်ခံပျဉ်ထောင်',
    'ပျဉ်ထောင်ဖက်မိုး',
    'ထရံကာသွပ်မိုး',
    'ထရံကာဖက်မိုး'];

  static const List<String> property_lkw_building = [
    'RC',
    'အုတ်တိုက်',
    'အုတ်ညှပ်',
    'တိုက်ခံ',
    'ပျဉ်ထောင်',
    'တဲအိမ်'];

  //-----------------------------------------------------------------------------------------------------------------------------------------
  //LKW

  static const List<String> biz_lkw_license = [
    'စားသောက်ဆိုင်လုပ်ငန်းလိုင်စင်',
    'အန္တရာယ်ရှိစေနိုင်သောလုပ်ငန်းလိုင်စင်'];

  static const List<String> biz_lkw_food = [
    'စားသောက်ဆိုင်',
    'လက်ဖက်ရည်ဆိုင်',
    'မုန့်စုံ/မုန့်လုပ်ငန်း',
    'ဖျော်ရည်/ယမကာ',
    'မုန့်ဟင်းခါး/ဆန်ခေါက်ဆွဲ',
    'အကြော်/ဟင်းထုပ်/အသုပ်စုံ',
    'စားသောက်ဆိုင်(ကြီး)',
    'ခေါင်ရည်',
    'အအေးဆိုင်'
  ];

  static const List<String> biz_lkw_danger = [
    '‌ရွှေဆိုင်/ပန်းထိမ်လုပ်ငန်း',
    'စတိုး',
    'ဟန်းဆက်',
    'အရုပ်',
    'နာရီဆိုင်',
    'ပလတ်စတစ်',
    'မျက်မှန်ဆိုင်',
    'ကုန်စုံဆိုင်',
    'အထည်ဆိုင်',
    'ယက္ကန်းစင်',
    'ဖိနပ်ဆိုင်',
    'ပန်းကန်',
    'ကွမ်းယာ',
    'ကွမ်းပစ္စည်း',
    'ခွေငှားဆိုင်',
    'မိတ္တူဆိုင်',
    'ပုံနှိပ်လုပ်ငန်း',
    'ဆံသ',
    'အလှပြင်',
    '‌ဆေးဆိုင်',
    'ပရိဘောဂလုပ်ငန်း',
    'စာရေးကိရိယာ',
    'ဆန်ဆိုင်',
    'စက်သုံးဆီ',
    'စက်ချုပ်',
    'မြေအိုး/မြေခွက်',
    'အမှုန့်ကြိတ်စက်',
    'သံထည်/ဓါးဆိုင်',
    'ဒါန်သတ္တုဟောင်းဆိုင်',
    'သံသေတ္တာ',
    'ဆန်စက်/ကြိတ်ခွဲစက်',
    'ဖယောင်းတိုင်လုပ်ငန်း',
    'သစ်လုပ်ငန်း/သစ်ရောင်းချခြင်း',
    'ဘယဆေးဆိုင်',
    'ဓါတ်ပုံ/ဆိုင်းဘုတ်/ဂျာနယ်',
    'စာအုပ်ငှား',
    'သက်ကယ်/ဝါး/ထရံ',
    'ကားပစ္စည်းဟောင်း',
    'ဆီစက်',
    'ရေဒီယိုကက်ဆက်ပြင်',
    'စက်ဘီးပြင်',
    'ဟန်းဆက်ပြင်',
    'တီဗွီပြင်',
    'တွင်ခုံ',
    'ဆိုင်ကယ်ပြင်',
    'လေထိုးကျွတ်ဖာ',
    'သံပန်း/သံတံခါး',
    'ကားဝပ်ရှော့/ပန့်နော်ဇယ်',
    'ကုန်မာ/အိမ်ဆောက်ပစ္စည်း',
    'အုတ်လုပ်ငန်း',
    'မုန့်ဟင်းခါးဖို/ဆန်ခေါက်ဆွဲစက်',
    'အိမ်တွင်းမှု/အကြော်အလှော်ဖို',
    'ဆေးခန်း/ဓါတ်ခွဲခန်း',
    'TV Game/Internet Cyber',
    'ကာရာအိုကေလုပ်ငန်း',
    'ကုန်ခြောက်',
    'အလှကုန်',
    'ဘတ္ထရီ',
    'ဂတ်စ်ဖြည့်',
    'ချိန်းလိတ်',
    'ကုန်စိမ်း',
    'ကြက်စာရောင်း',
    'သစ်စက်',
    'ကားရေဆေးခုံ',
    'ကိုယ်ပိုင်သင်တန်း',
    'ဘိလိယက်ခုံ',
    'စက်ရုံလုပ်ငန်း',
    'ကြက်မွေးမြူရေး',
    'စိုက်ပျိုးပစ္စည်း/ဓါတ်မြေသြဇာ',
    'စက်ဘီးပစ္စည်း',
    'လျှပ်စစ်ပစ္စည်း',
    'စက်/ကားပစ္စည်း',
    'ကျောက်ခွဲစက်',
    'ဆိုင်ကယ်ပစ္စည်း',
    'သောက်ရေသန့်',
    'သံရည်ကြို/ခဲမဖြူ/ခနောက်စိမ်း',
    'ရေခဲစက်လုပ်ငန်း',
    'ကားအရောင်းပြခန်း',
    'ကုန်မျိုးစုံအိမ်ဆိုင်',
    'ပွဲရုံ/သီးနှံရောင်းဝယ်ရေး',
    'ပီနံအိတ်',
    'ပင်မင်း',
    'ကလေးကစားကွင်း',
    'ကျန်းမာရေးစင်တာ',
    'ထီအရောင်းဆိုင်',
    'ရေခဲသေတ္တာပြင်'
  ];
}

class ScreenName{
  //static const String SCREEN = 'screen';

  static const String WARD_ADMIN_FEATURE_SCREEN = 'Ward admin choose feature screen';
  static const String LOGIN_SCREEN = 'Login screen';
  static const String OTP_SCREEN = 'Otp screen';

  //ward admin contribution list screen
  static const String WARD_ADMIN_CONTRIBUTION_LIST_SCREEN = 'Ward admin contribution list screen';
  static const String CONTRIBUTION_DETAIL_SCREEN = 'Contribution detail screen';
  static const String WARD_ADMIN_CONTRIBUTION_SCREEN = 'Ward admin contribution screen';
  static const String WARD_ADMIN_LOCATION_UPDATE_SCREEN = 'Ward admin location update screen';

  static const String FLOOD_REPORT_LIST_SCREEN = 'Flood report list screen';
  static const String NEWS_FLOOD_REPORT_SCREEN = 'New flood report screen';
  static const String GET_FLOOD_LEVEL_SCREEN = 'Get flood level screen';

  static const String NEWS_FEED_SCREEN = 'News feed screen';
  static const String NEWS_FEED_DETAIL_SCREEN = 'News feed detail screen';


  static const String DASHBOARD_SCREEN = 'Dashboard screen';
  static const String ABOUT_DAO_SCREEN = 'About dao screen';
  static const String ABOUT_TAX_SCREEN = 'About tax screen';
  static const String CONTRIBUTION_SCREEN = 'Contribution screen';
  static const String BIZ_LICENSE_SCREEN = 'Biz license screen';
  static const String ONLINE_TAX_CHOOSE_SCREEN = 'Online tax choose screen';
  static const String TAX_USE_SCREEN = 'Tax use screen';
  static const String CALCULATE_TAX_SCREEN = 'Calculate tax screen';
  static const String FAQ_SCREEN = 'Faq screen';
  static const String SAVED_NEWS_FEED_SCREEN = 'Saved news feed screen';
  static const String PROFILE_SCREEN = 'Profile screen';
  static const String ABOUT_DAO_DETAIL_SCREEN = 'About dao detail screen';
  static const String ABOUT_TAX_DETAIL_SCREEN = 'About tax detail screen';
  static const String DEPARTMENT_LIST_SCREEN = 'Department list screen';
  static const String BIZ_LICENSE_DETAIL_SCREEN = 'Biz license detail screen';
  static const String APPLY_BIZ_LICENSE_FORM_SCREEN = 'Apply biz license form screen';
  static const String APPLY_BIZ_LICENSE_LIST_SCREEN = 'Apply biz license list screen';
  static const String APPLY_BIZ_LICENSE_DETAIL_SCREEN = 'Apply biz license detail screen';
  static const String APPLY_BIZ_LICENSE_PHOTO_LIST_SCREEN = 'Apply biz license photo list screen';
  static const String PIN_CODE_SET_UP_SCREEN = 'Pin code set up screen';
  static const String ONLINE_TAX_SCREEN = 'Online tax screen';
  static const String SMART_WATER_METER_SCREEN = 'Smart water meter screen';
  static const String TOP_UP_RECORD_LIST_SCREEN = 'Top up record list screen';
  static const String ONLINE_TAX_PAYMENT_SCREEN = 'Online tax payment screen';
  static const String TGY_PROPERTY_TAX_CALCULATOR_SCREEN = 'Tgy property tax calculator screen';
  static const String TGY_BIZ_TAX_CALCULATOR_SCREEN = 'Tgy biz tax calculator screen';
  static const String MLM_PROPERTY_TAX_CALCULATOR_SCREEN = 'Mlm property tax calculator screen';
  static const String MLM_BIZ_TAX_CALCULATOR_SCREEN = 'Mlm biz tax calculator screen';
  static const String LKW_PROPERTY_TAX_CALCULATOR_SCREEN = 'Lkw property tax calculator screen';
  static const String LKW_BIZ_TAX_CALCULATOR_SCREEN = 'Lkw biz tax calculator screen';
  static const String SAVED_NEWS_FEED_DETAIL_SCREEN = 'Saved news feed detail screen';
  static const String PROFILE_PHOTO_SCREEN = 'Profile photo screen';
  static const String PROFILE_FORM_SCREEN = 'Profile form screen';
  static const String NEW_TAX_RECORD_SCREEN = 'New tax record screen';


  static const String NOTIFICATION_SCREEN = 'Notification screen';
  static const String NOTIFICATION_DETAIL_SCREEN = 'Notification detail screen';

  static const String PHOTO_DETAIL_SCREEN = 'Photo detail screen';

  static const String MYO_TAW_POLICY_SCREEN = 'Myo taw policy screen';

}

class ClickEvent{
  //static const String _CLICK_EVENT = 'click event';
  static const String GALLERY_CLICK_EVENT = 'Gallery click event';
  static const String CAMERA_CLICK_EVENT = 'Camera click event';
  static const String SEND_WARD_ADMIN_CONTRIBUTION_CLICK_EVENT = 'Send ward admin contribution click event';
  static const String GET_LOCATION_FROM_GOOGLE_MAP = 'Get location from google map event';
  static const String SEND_CONTRIBUTION_SUCCESS_CLICK_EVENT = 'Send contribution success click event';
  static const String SEND_FLOOD_LEVEL_REPORT_SUCCESS_CLICK_EVENT = 'Send flood level report success click event';

  static const String SEND_FLOOD_LEVEL_REPORT_CLICK_EVENT = 'Send flood level report click event';
  static const String GET_FLOOD_LEVEL_CLICK_EVENT = 'Get flood level click event';


  static const String NEWS_FEED_LIKE_CLICK_EVENT = 'News feed like click event';
  static const String NEWS_FEED_SAVE_CLICK_EVENT = 'News feed save click event';
  static const String GO_TO_TOP_CLICK_EVENT = 'Go to top click event';


  static const String MANAGEMENT_CLICK_EVENT = 'Management click event';
  static const String ENGINEER_CLICK_EVENT = 'Engineer click event';
  static const String SEND_CONTRIBUTION_CLICK_EVENT = 'Send contribution click event';
  static const String BIZ_LICENSE_APPLIED_CLICK_EVENT = 'Biz license applied click event';
  static const String APPLY_BIZ_LICENSE_PHOTO_UPLOAD_CLICK_EVENT = 'Apply biz license photo upload click event';
  static const String PIN_CODE_SET_UP_CLICK_EVENT = 'Pin code set up click event';
  static const String GET_TAX_AMOUNT_CLICK_EVENT = 'Get tax amount click event';
  static const String PAY_TAX_CLICK_EVENT = 'Pay tax click event';
  static const String CALCULATE_PROPERTY_TAX_CLICK_EVENT = 'Calculate property tax click event';
  static const String CALCULATE_BIZ_TAX_CLICK_EVENT = 'Calculate biz tax click event';
  static const String FAQ_BY_CATEGORY_CLICK_EVENT = 'Faq by category click event';
  static const String FAQ_ANSWER_CLICK_EVENT = 'Faq answer click event';
  static const String DELETE_SAVED_NEWS_FEED_CLICK_EVENT = 'Delete saved news feed click event';
  static const String PROFILE_PHOTO_UPLOAD_CLICK_EVENT = 'Profile photo upload click event';
  static const String PROFILE_INFORMATION_UPLOAD_CLICK_EVENT = 'Profile information upload click event';
  static const String USER_LOG_OUT_CLICK_EVENT = 'User log out click event';
  static const String TAX_RECORD_DELETE_CLICK_EVENT = 'Tax record delete click event';
  static const String NEW_TAX_RECORD_UPLOAD_CLICK_EVENT = 'New tax record upload click event';





}