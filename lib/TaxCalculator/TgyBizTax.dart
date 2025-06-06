
import 'package:myotaw/helper/NumConvertHelper.dart';

class TgyBizTax{
  static String _taxRange = '';
  static String getTax({bizType, grade, squareFeet}){
    switch (bizType){
    //food biz
      case "ကုန်စုံဆိုင်/မုန့်ဆိုင်":
        _taxRange = "၁၅,၀၀၀ - ၁၀၀,၀၀၀";
        break;
      case "မုန့်ဖုတ်ခြင်း/ရောင်းချခြင်း":
        _taxRange = "၃၀,၀၀၀ - ၁၀၀,၀၀၀";
        break;
      case "အအေးနှင့်ဖျော်ရည်ပြုလုပ်ရောင်းချခြင်း":
        _taxRange = "၂၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "ရေခဲစက်/ဘိလပ်ရည်စက်နှင့်ရေခဲချောင်းလုပ်ငန်း":
        _taxRange = "၄၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "လ္ဘက်ရည်/ကော်ဖီစသည့်အလားတူပြင်ဆင်ရောင်းချခြင်း":
        _taxRange = "၃၀,၀၀၀ - ၂၀၀,၀၀၀";
        break;
      case "ထမင်း/ခေါက်ဆွဲ(အကြော်/အပြုတ်)":
        _taxRange = "၃၀,၀၀၀ - ၁၀၀,၀၀၀";
        break;
      case "ကြာဇံ/မုန့်ဟင်းခါး/တိုဖူးနွေး/ရှမ်းခေါက်ဆွဲစသည့် အလားတူလုပ်ငန်း":
        _taxRange = "၂၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "ဆီနှင့်ကြော်သော အကြော်မျိုးစုံ":
        _taxRange = "၃၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "စားသောက်ဆိုင်ကြီး/ပျော်ပွဲစားရုံ/ဟိုတယ်ဆိုင်ကြီးများ":
        _taxRange = "၈၀,၀၀၀ - ၃၀၀,၀၀၀";
        break;
      case "ကွမ်းယာရောင်းခြင်း":
        _taxRange = "၁၀,၀၀၀ - ၄၀,၀၀၀";
        break;
      case "နေကြာစေ့/ကွာစေ့/ယိုစုံ/ချိုချဉ် စသည့်အိမ်တွင်းမှုစားသောက်ကုန်လုပ်ငန်း":
        _taxRange = "၃၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "ချဉ်ဖတ်လုပ်ငန်း":
        _taxRange = "၄၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "မုန့်တီလုပ်ငန်း":
        _taxRange = "၅၀,၀၀၀";
        break;
    //danger biz
      case "အလုပ်ရုံများ(စက်မှု၊ လက်မှု)":
        _taxRange = "၂၀,၀၀၀ - ၁၀၀,၀၀၀";
        break;
      case "လေထိုး၊ တာယာ၊ ကျွတ်လုပ်ငန်း":
        _taxRange = "၂၀,၀၀၀ - ၄၀,၀၀၀";
        break;
      case "စက်ချုပ်ဆိုင်၊ မိုးကာ ကူရှင်ချုပ်လုပ်ငန်း":
        _taxRange = "၂၀,၀၀၀ - ၅၀,၀၀၀";
        break;
      case "လျှပ်စစ်ဘက်ထရီလုပ်ငန်း":
        _taxRange = "၂၀,၀၀၀ - ၅၀,၀၀၀";
        break;
      case "ထင်း၊ မီးသွေး၊ ဝါး၊ ကြိမ်၊ သစ်ခွဲသား၊ သက်ကယ် သိုလှောင်ခြင်း":
        _taxRange = "၂၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "လဲမှို့၊ ဝါဂွမ်း၊ ဆေးဆိုး၊ သိုးမွေးလုပ်ငန်း":
        _taxRange = "၄၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "ဆံသနှင့်အလှပြင်လုပ်ငန်းများ":
        _taxRange = "၂၀,၀၀၀ - ၆၀,၀၀၀";
        break;
      case "ပုံနှိပ်လုပ်ငန်း":
        _taxRange = "၅၀,၀၀၀ - ၇၀,၀၀၀";
        break;
      case "စက်ဘီးပြင်၊ ထီးပြင်၊ ဖိနပ်ပြင်လုပ်ငန်း":
        _taxRange = "၈,၀၀၀ - ၁၅,၀၀၀";
        break;
      case "ကျွဲကော်ပစ္စည်းသိုလှောင်ခြင်း(ပလပ်စတစ်လုပ်ငန်း)":
        _taxRange = "၅၀,၀၀၀ - ၇၀,၀၀၀";
        break;
      case "စက်ရုံများ(သစ်ခွဲစက်၊ အမှုန့်ကြိတ်စက်၊ ဆီစက်၊ ဆပ်ပြာစက်)":
        _taxRange = "၄၀,၀၀၀ - ၂၀၀,၀၀၀";
        break;
      case "သဲ၊ အုတ်သိုလှောင်ရေး(အုတ်လုပ်ငန်း)":
        _taxRange = "၅၀,၀၀၀ - ၁၀၀,၀၀၀";
        break;
      case "ဆေးခန်း(ရောဂါရှာဖွေရေး၊ ဓါတ်ခွဲခန်း၊ အရေပြားအလှပြုပြင်ရေးဆေးခန်းအပါအဝင်)အလားတူလုပ်ငန်းများ":
        _taxRange = "၃၀,၀၀၀ - ၁၀၀,၀၀၀";
        break;
      case "ပုဂ္ဂလိကဆေးရုံကြီးများ":
        _taxRange = "၂၀၀,၀၀၀ - ၅၀၀,၀၀၀";
        break;
      case "ဆေးနှင့်ဆေးပစ္စည်းအရောင်းဆိုင်များ":
        _taxRange = "၃၀,၀၀၀ - ၇၀,၀၀၀";
        break;
      case "ဗီဒီယို၊ ဓါတ်ပုံ၊ ရုပ်မြင်လုပ်ငန်းလိုင်စင်နှင့်အလားတူလုပ်ငန်းများ":
        _taxRange = "၂၀,၀၀၀ - ၃၀၀,၀၀၀";
        break;
      case "ဆန်၊ ဂျုံ၊ ပဲနှင့်အခြားကောက်ပဲသီးနှံ\u200Bရောင်းဝယ်ရေး":
        _taxRange = "၃၀,၀၀၀ - ၃၀၀,၀၀၀";
        break;
      case "ဆေးရွက်ကြီး၊ ဆေးရိုး၊ သနပ်ဖက်နှင့်အလားတူပစ္စည်းသိုလှောင်ခြင်း(ဆေးလိပ်ခုံ)":
        _taxRange = "၄၀,၀၀၀ - ၁၀၀,၀၀၀";
        break;
      case "စားသောက်ကုန်စည်ပစ္စည်းသိုလှောင်ခြင်း(ပွဲရုံ)":
        _taxRange = "၃၀,၀၀၀ - ၁၀၀,၀၀၀";
        break;
    //hotel biz
      case "တည်းခိုခန်း":
        switch (grade){
          case "(၁)ယောက်ခန်းတစ်ခန်းလျှင်":
            _taxRange = "၈,၀၀၀";
            break;
          case "(၂)ယောက်ခန်းတစ်ခန်းလျှင်":
            _taxRange = "၁၀,၀၀၀";
            break;
          case "မိသားစုတစ်ခန်းလျှင်":
            _taxRange = "၁၂,၀၀၀";
            break;
        }
        break;
      case "ဘော်ဒါဆောင်":
        _taxRange = "၄,၀၀၀";
        break;
    //water biz
      case "သောက်ရေသန့်လုပ်ငန်း":
        _taxRange = "၁၅၀,၀၀၀ - ၃၀၀,၀၀၀";
        break;
      case "ကိုယ်ပိုင်ဈေးစတိုး":
        _taxRange = "၁၅၀,၀၀၀ - ၃၀၀,၀၀၀";
        break;
      case "ကုန်တိုက်နှင့်အလားတူလုပ်ငန်းများ၊ အရောင်းဆိုင်ကြီးများ(၁ စတုန်ရန်းပေလျှင်)":
        switch (squareFeet){
          case "ပေ (၁၀၀၀၀) အထက်":
            _taxRange = "၁ စတုရန်းပေလျှင် ၅၀";
            break;
          case "ပေ (၁၀၀၀၀) အောက်":
            _taxRange = "၁ စတုရန်းပေလျှင် ၁၀၀";
            break;
        }
        break;
      case "အုပ်စုလိုက်/အတန်းလိုက်ရှိသောစတိုးဆိုင်များ/TV၊ ဖုန်း၊ အလှကုန်၊ လူသုံးကုန်၊ အိမ်ဆောက်ပစ္စည်း၊ ကား/ဆိုင်ကယ်အရောင်းဆိုင်၊ ပစ္စည်းအရောင်းဆိုင်နှင့်ဝန်ဆောင်မှုလုပ်ငန်းများ":
        _taxRange = "၃၀,၀၀၀ - ၃၀၀,၀၀၀";
        break;
      case "မင်္ဂလာခန်းမ":
        _taxRange = "၁၀၀,၀၀၀ - ၃၀၀,၀၀၀";
        break;
    }
    return '${NumConvertHelper.getMyanNumString(_taxRange)}';
  }
}