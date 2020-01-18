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
}

class BaseUrl{
  static const String WEB_SERVICE_ROOT_ADDRESS = "https://cityappapi.azurewebsites.net/api/";
  static const String WEB_SERVICE_ROOT_ADDRESS_NEWSFEED = "https://generalcontentproviderapi.azurewebsites.net/api/";
  static const String NEWS_FEED_CONTENT_URL = "https://portalvhdslvb28rs1c3tmc.blob.core.windows.net/city/NewsFeed/";
  static const String CONTRIBUTE_PHOTO_URL = "https://portalvhdslvb28rs1c3tmc.blob.core.windows.net/city/Contribute/";
  static const String USER_PHOTO_URL = "https://portalvhdslvb28rs1c3tmc.blob.core.windows.net/city/Member/";
  static const String DAO_PHOTO_URL = "https://portalvhdslvb28rs1c3tmc.blob.core.windows.net/city/AboutDAO/";
  static const String APPLY_BIZ_LICENSE_PHOTO_URL = "https://portalvhdslvb28rs1c3tmc.blob.core.windows.net/city/ApplyBiz/";
  static const String WEB_SERVICE_ROOT_ADDRESS_TAX_PAYMENT = "https://taxpaymentservice.azurewebsites.net/api/";
  static const String WEB_SERVICE_ROOT_ADDRESS_REFERRAL = "https://newmaymay.azurewebsites.net/api/";
  static const String WEB_SERVICE_ROOT_ADDRESS_DAO_INVOICE_NO = "https://daoapifinal.azurewebsites.net/api/";
  static const String REFERRAL_URL = "https://maymayadmin.azurewebsites.net/Referral/CityAppReferralDetail?referralpno=";
  static const String WEB_SERVICE_ROOT_ADDRESS_OTP = "https://kktsmsverification.azurewebsites.net/api/";
}

class MyString{
  static const String API_KEY = "B93979A51C8C46712DD2C8271587B262";

  static const String txt_like = "နှစ်သက်";
  static const String txt_save = "သိမ်းမည်";
  static const String txt_welcome_tgy ='တောင်ကြီးမြို့စည်ပင်သာယာရေး တရားဝင် မြို့တော် အပရီကေးရှင်းမှ ကြိုဆိုပါသည်။';
  static const String txt_welcome_mlm ='မော်လမြိုင်မြို့စည်ပင်သာယာရေး တရားဝင် မြို့တော် အပရီကေးရှင်းမှ ကြိုဆိုပါသည်။';
  static const String TGY_CITY = 'တောင်ကြီးမြို့';
  static const String MLM_CITY = 'မော်လမြိုင်မြို့';
  static const String MDY_CITY = 'မန္တလေးမြို့';
  static const String TGY_REGIONCODE = "TGY";
  static const String MLM_REGIONCODE = "MLM";
  static const String MDY_REGIONCODE = "MDY";
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
  static const String txt_apply_license_need_to_fill = 'ပြထားသည့်များဖြည့်ပေးရန်လိုအပ်သည်';
  static const String txt_need_paper_work = 'လိုအပ်သောစာရွက်စာတမ်းများတွဲရန်/ကြည့်ရန်';
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
  static const String txt_profile_set_up_need = 'ကိုယ်ရေးအချက်အလတ် ဖြည့်သွင်းရန်လိုပါသည်။';
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
  static const String title_property_tax_calculate = "ပစ္စည်းခွန် အခွန်ငွေတွက်ချက်ရန်အတွက်";
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
  static const String txt_thanks = "အခွန်ပေးဆောင်မှုအတွက် \n ကျေးဇူးတင်ပါသည်";
  static const String txt_choose_license_type = "လိုင်စင်အမျိုးအစားရွေးပါ";
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
  static const String txt_need_suggestion = "အကြံပြုစာရေးပေးပါ";
  static const String txt_need_subject = "အကြောင်းအရာရွေးပေးပါ";
  static const String txt_need_suggestion_photo = "ဓာတ်ပုံတင်ရန် လိုအပ်ပါသည်။";
  static const String txt_need_suggestion_location = "တည်နေရာ မရ ရှိပါ။";
  static const String txt_try_again = "နောက်တစ်ကြိမ်လုပ်ဆောင်ပါ။";
  static const String txt_fill_phno = "ဖုန်းနံပါတ်ရိုက်ထည့်ပါ။";
  static const String txt_choose_city = "မြို့ရွေးချယ်ပေးပါ။";
  static const String txt_wrong_phNo= "ဖုန်းနံပါတ် မှားယွင်းနေပါသည်။";
  static const String txt_save_newsFeed_success= "သိမ်းဆည်းပြီး။";
  static const String txt_check_internet= "ကွန်နက်ရှင်ကိုစစ်ဆေးပါ။";
  static const String txt_need_apply_biz_photo_name= "ဓာတ်ပုံအမည် ရေးပေးပါ။";
  static const String txt_choose_building_type= "အဆောက်အဦး အမျိုးအစားရွေးပေးပါ။";
  static const String txt_choose_story= "အထပ် အမျိုးအစားရွေးပေးပါ။";
  static const String txt_choose_blockNo= "ရပ်ကွက် အမျိုးအစားရွေးပေးပါ။";
  static const String txt_type_length= "အလျား လိုအပ်သည်။";
  static const String txt_type_width= "အနံ လိုအပ်သည်။";
  static const String txt_wrong_pin_code = "ပင်ကုဒ် မှားပါသည်။";
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
  static const String txt_admin_user = "Ward Admin ၏ ပူးပေါင်းပါဝင်မှုကဏ္ဍ";
  static const String txt_myotaw_user = "မြို့တော်အသုံးပြုသူကဏ္ဍ";
  static const String txt_choose_feature = "ကဏ္ဍရွေးချယ်ပေးပါ";
  static const String txt_title_dashboard = "ကဏ္ဍများ";
  static const String txt_title_notification = "အသိပေးနှိုးဆော်ချက်";


  static const String BUILDING_GRADE_A = "building grade A";
  static const String BUILDING_GRADE_B = "building grade B";
  static const String BUILDING_GRADE_C = "building grade C";
  static const String GOV_BUILDING = "gov";

  //admin ph no
  static final String ADMIN_PH_1 = "+959425317337";
  static final String ADMIN_PH_2 = "+959794797489";
  static final String ADMIN_PH_3 = "+959975526335";
  static final String ADMIN_PH_4 = "+959254900916";
}

class MyArray{

  //admin ward ph no
  static const List<String> adminPhno = ["+959425317337", "+959794797489", "+959975526335", "+959254900916"];

  //Tgy
  static const List<String> biz_tgy_food = [
    'မုန့်ဖုတ်ခြင်း/ရောင်းချခြင်း',
    'အအေး/ဖျော်ရည်ပြုလုပ်ရောင်းချခြင်း',
    'ရေခဲစက်/ဘိလပ်ရည်စက်နှင့်ရေခဲချောင်းလုပ်ငန်း',
    'လ္ဘက်ရည်/ကော်ဖီစသည့် အလားတူပြင်ဆင်ရောင်းချခြင်း',
    'ထမင်း/ခေါက်ဆွဲ (အကြော်/အပြုတ်)',
    'ကြာဇံ/မုန့်ဟင်းခါး/တိုဟူးနွေး ရှမ်းခေါက်ဆွဲစသည့်အလားတူလုပ်ငန်း',
    'စားသောက်ဆိုင်ကြီးများ ဟိုတယ်ဆိုင်ကြီးများ',
    'ကွမ်းယာရောင်းချခြင်း','ဆီနှင့်ကြော်သောအကြော်မျိုးစုံ',
    'နေကြာစေ့/ကွာစေ့/ယိုစုံ/ချိုချဉ် စသည့်အလားတူလုပ်ငန်း',
    'ချဉ်ဖတ်လုပ်ငန်း','နို့ဆီရောင်းချခြင်း/မလိုင်မုန့်လုပ်ငန်း'];

  static const List<String> biz_tgy_license = [
    'စားသောက်ဆိုင်လုပ်ငန်းလိုင်စင်',
    'ဘေးအန္တရာယ်လုပ်ငန်းလိုင်စင်',
    'ကိုယ်ပိုင်ဈေး၊ စတိုးဆိုင်လိုင်စင်',
    'တည်းခိုခန်း/ဘော်ဒါဆောင်/မင်္ဂလာခန်းမလုပ်ငန်းလိုင်စင်'];

  static const List<String> biz_tgy_danger = [
    'ဆန်၊ ဂျုံ၊ ပဲနှင့်အခြားကောက်ပဲသီးနှံရောင်းဝယ်ရေး',
    'ဆေးရွက်ကြီး၊ ဆေးရိုး၊ သနပ်ဖက်၊ ဆေးလိပ်ခုံ',
    'စားသောက်ကုန်စည်ပစ္စည်းသိုလှောင်ခြင်း(ပွဲရုံ)',
    'အလုပ်ရုံများ (စက်မှု)',
    'အလုပ်ရုံများ (လက်မှု)',
    'လေထိုး၊ တာယာ၊ ကျွတ်လုပ်ငန်း',
    'စက်ချုပ်ဆိုင်၊ မိုးကာကူရှင်ချုပ်လုပ်ငန်း',
    'လျှပ်စစ်၊ ဘတ္တရီလုပ်ငန်း',
    'ထင်း၊ မီးသွေး၊ ဝါး ကြိမ်၊ သစ်ခွဲသား၊ သက်ကယ်သိုလှောင်ခြင်း',
    'လဲမှို့၊ ဝါဂွမ်း၊ ဆေးဆိုး၊ သိုးမွေးလုပ်ငန်း',
    'ဆံသနှင့်အလှပြင်လုပ်ငန်း','ပုံနှိပ်လုပ်ငန်း',
    'စက်ဘီးပြင်၊ ထီးပြင်၊ ဘိနပ်ပြင်လုပ်ငန်း',
    'ကျွဲကော်ပစ္စည်းသိုလှောင်ခြင်း (ပလပ်စတစ်လုပ်ငန်း)',
    'စက်ရုံများ (သစ်ခွဲစက်၊ အမှုန့်ကြိတ်စက်၊ ဆီစက်၊ ဆန်စက်)',
    'သဲ၊ အုတ်သိုလှောင်ရေး (အုတ်လုပ်ငန်း)',
    'ဓါတ်ပုံ၊ ဗီဒီယို၊ တေးသံသွင်း၊ ဘလောက်လုပ်ငန်း'];

  static const List<String> biz_tgy_store = [
    'ကုန်စုံဆိုင်/မုန့်ဆိုင်/အိမ်ဆိုင်',
    'ကိုယ်ပိုင်ဈေးများ(စတိုးဆိုင်)',
    'Super Center, Mini Mart'];

  static const List<String> biz_tgy_hotel = [
    'တည်းခိုခန်း',
    'ဘော်ဒါဆောင်',
    'မင်္ဂလာခန်းမ'];

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
}

class OrganizationId{
  static const int MDY_ORGANIZATION_ID = 7;
  static const int TGY_ORGANIZATION_ID = 8;
  static const int MLM_ORGANIZATION_ID = 9;
}