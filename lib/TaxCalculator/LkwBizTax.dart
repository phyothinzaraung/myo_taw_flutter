import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/helper/NumConvertHelper.dart';

class LkwBizTax{
  static String _taxRange = '';
  static String getTaxValue({licenseType,bizType,grade}){
    switch(licenseType){
      case 'စားသောက်ဆိုင်လုပ်ငန်းလိုင်စင်':
        switch (bizType){
          case 'စားသောက်ဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '22,000';
                break;
            }
            break;
          case 'လက်ဖက်ရည်ဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '22,000';
                break;
            }
            break;
          case 'မုန့်စုံ/မုန့်လုပ်ငန်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '22,000';
                break;
            }
            break;
          case 'ဖျော်ရည်/ယမကာ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '22,000';
                break;
            }
            break;
          case 'မုန့်ဟင်းခါး/ဆန်ခေါက်ဆွဲ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '27,500';
                break;
              case MyString.txt_second_grade:
                _taxRange = '16,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '11,000';
                break;
            }
            break;
          case 'အကြော်/ဟင်းထုပ်/အသုပ်စုံ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '27,500';
                break;
              case MyString.txt_second_grade:
                _taxRange = '16,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '11,000';
                break;
            }
            break;
          case 'စားသောက်ဆိုင်(ကြီး)':
            switch (grade){
              case MyString.txt_special_grade:
                _taxRange = '120,000';
                break;
              case MyString.txt_first_grade:
                _taxRange = '65,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '45,000';
                break;
            }
            break;
          case 'ခေါင်ရည်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '27,500';
                break;
              case MyString.txt_second_grade:
                _taxRange = '16,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '13,200';
                break;
            }
            break;
          case 'အအေးဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
        }
        break;
      case 'အန္တရာယ်ရှိစေနိုင်သောလုပ်ငန်းလိုင်စင်':
        switch(bizType){
          case '‌ရွှေဆိုင်/ပန်းထိမ်လုပ်ငန်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '77,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case '‌စတိုး':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '100,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'ဟန်းဆက်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '100,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'အရုပ်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'နာရီဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '11,000';
                break;
            }
            break;
          case 'ပလတ်စတစ်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'မျက်မှန်ဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '22,000';
                break;
            }
            break;
          case 'ကုန်စုံဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'အထည်ဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'ယက္ကန်းစင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '100,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '22,000';
                break;
            }
            break;
          case 'ဖိနပ်ဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'ပန်းကန်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '100,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '44,000';
                break;
            }
            break;
          case 'ကွမ်းယာ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '11,000';
                break;
            }
            break;
          case 'ကွမ်းပစ္စည်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '11,000';
                break;
            }
            break;
          case 'ခွေငှားဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
          case 'မိတ္တူဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '22,000';
                break;
            }
            break;
          case 'ပုံနှိပ်လုပ်ငန်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '65,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '45,000';
                break;
            }
            break;
          case 'ဆံသ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '27,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '22,000';
                break;
            }
            break;
          case 'အလှပြင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '27,500';
                break;
            }
            break;
          case '‌ဆေးဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '100,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'ပရိဘောဂလုပ်ငန်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '27,500';
                break;
            }
            break;
          case 'စာရေးကိရိယာ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '11,000';
                break;
            }
            break;
          case 'ဆန်ဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '100,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'စက်သုံးဆီ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '200,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '150,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '110,000';
                break;
            }
            break;
          case 'စက်ချုပ်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
          case 'မြေအိုး/မြေခွက်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
          case 'အမှုန့်ကြိတ်စက်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '28,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '22,000';
                break;
            }
            break;
          case 'သံထည်/ဓါးဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
          case 'ဒါန်သတ္တုဟောင်းဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
          case 'သံသေတ္တာ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '42,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '32,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '22,000';
                break;
            }
            break;
          case 'ဆန်စက်/ကြိတ်ခွဲစက်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '100,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'ဖယောင်းတိုင်လုပ်ငန်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '11,000';
                break;
            }
            break;
          case 'သစ်လုပ်ငန်း/သစ်ရောင်းချခြင်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '100,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'ဘယဆေးဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
          case 'ဓါတ်ပုံ/ဆိုင်းဘုတ်/ဂျာနယ်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '27,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '22,000';
                break;
            }
            break;
          case 'စာအုပ်ငှား':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '16,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '11,000';
                break;
            }
            break;
          case 'သက်ကယ်/ဝါး/ထရံ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '16,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '11,000';
                break;
            }
            break;
          case 'ကားပစ္စည်းဟောင်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '27,500';
                break;
            }
            break;
          case 'ဆီစက်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '22,000';
                break;
            }
            break;
          case 'ရေဒီယိုကက်ဆက်ပြင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '16,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '11,000';
                break;
            }
            break;
          case 'စက်ဘီးပြင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '16,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '11,000';
                break;
            }
            break;
          case 'ဟန်းဆက်ပြင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '35,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '25,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '15,000';
                break;
            }
            break;
          case 'တီဗွီပြင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '11,000';
                break;
            }
            break;
          case 'တွင်ခုံ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'ဆိုင်ကယ်ပြင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '27,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
          case 'လေထိုးကျွတ်ဖာ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
          case 'သံပန်း/သံတံခါး':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,500';
                break;
            }
            break;
          case 'ကားဝပ်ရှော့/ပန့်နော်ဇယ်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '65,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '49,500';
                break;
            }
            break;
          case 'ကုန်မာ/အိမ်ဆောက်ပစ္စည်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '100,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '49,500';
                break;
            }
            break;
          case 'ထုံးလုပ်ငန်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '27,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
          case 'အုတ်လုပ်ငန်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '27,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
          case 'အုတ်လုပ်ငန်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '27,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
          case 'မုန့်ဟင်းခါးဖို/ဆန်ခေါက်ဆွဲစက်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '27,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
          case 'အိမ်တွင်းမှု/အကြော်အလှော်ဖို':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '16,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '11,000';
                break;
            }
            break;
          case 'ဆေးခန်း/ဓါတ်ခွဲခန်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '38,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'TV Game/Internet Cyber':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '80,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '50,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '38,500';
                break;
            }
            break;
          case 'ကာရာအိုကေလုပ်ငန်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '150,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '100,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '50,000';
                break;
            }
            break;
          case 'ကုန်ခြောက်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'ကုန်ခြောက်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'အလှကုန်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_fourth_grade:
                _taxRange = '27,500';
                break;
            }
            break;
          case 'ဘတ္ထရီ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '11,000';
                break;
            }
            break;
          case 'ဂတ်စ်ဖြည့်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '40,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '30,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '20,000';
                break;
            }
            break;
          case 'ချိန်းလိတ်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '50,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '40,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '30,000';
                break;
            }
            break;
          case 'ကုန်စိမ်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
          case 'ကြက်စာရောင်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '65,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '45,000';
                break;
            }
            break;
          case 'သစ်စက်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '100,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '44,000';
                break;
            }
            break;
          case 'ကားရေဆေးခုံ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '22,000';
                break;
            }
            break;
          case 'ကိုယ်ပိုင်သင်တန်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '100,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '75,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '55,000';
                break;
            }
            break;
          case 'ဘိလိယက်ခုံ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '38,500';
                break;
              case MyString.txt_second_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '27,500';
                break;
            }
            break;
          case 'စက်ရုံလုပ်ငန်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '100,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '75,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '55,000';
                break;
            }
            break;
          case 'ကြက်မွေးမြူရေး':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
          case 'စိုက်ပျိုးပစ္စည်း/ဓါတ်မြေသြဇာ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '22,000';
                break;
            }
            break;
          case 'စက်ဘီးပစ္စည်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '65,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'လျှပ်စစ်ပစ္စည်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '100,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'စက်/ကားပစ္စည်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '100,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'ကျောက်ခွဲစက်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '60,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '50,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '40,000';
                break;
            }
            break;
          case 'ဆိုင်ကယ်ပစ္စည်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '85,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'သောက်ရေသန့်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '150,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '110,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '82,500';
                break;
            }
            break;
          case 'သံရည်ကြို/ခဲမဖြူ/ခနောက်စိမ်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '150,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '110,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '82,500';
                break;
            }
            break;
          case 'ရေခဲစက်လုပ်ငန်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '110,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '82,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '50,000';
                break;
            }
            break;
          case 'ကားအရောင်းပြခန်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '300,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '200,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '100,000';
                break;
            }
            break;
          case 'ကုန်မျိုးစုံအိမ်ဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '33,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '22,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '16,500';
                break;
            }
            break;
          case 'ပွဲရုံ/သီးနှံရောင်းဝယ်ရေး':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '47,500';
                break;
              case MyString.txt_second_grade:
                _taxRange = '37,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '27,500';
                break;
            }
            break;
          case 'ပီနံအိတ်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '35,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '25,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '15,000';
                break;
            }
            break;
          case 'ပင်မင်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '35,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '25,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '15,000';
                break;
            }
            break;
          case 'ကလေးကစားကွင်း':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '44,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'ကျန်းမာရေးစင်တာ':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '38,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '33,000';
                break;
            }
            break;
          case 'ထီအရောင်းဆိုင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '20,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '15,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '10,000';
                break;
            }
            break;
          case 'ရေခဲသေတ္တာပြင်':
            switch (grade){
              case MyString.txt_first_grade:
                _taxRange = '55,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '33,500';
                break;
              case MyString.txt_third_grade:
                _taxRange = '27,500';
                break;
            }
            break;
        }
        break;
    }
    return '${NumConvertHelper.getMyanNumString(_taxRange)}';
  }
}