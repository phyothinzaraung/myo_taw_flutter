
import 'package:myotaw/helper/NumConvertHelper.dart';
import 'package:myotaw/helper/NumberFormatterHelper.dart';

class MlmBizTax{

  static String _taxRange = '';
  static String getTax({bizLicenseType, bizType}){
    switch(bizLicenseType){
      case 'စားသောက်ဆိုင်လုပ်ငန်းလိုင်စင်':
        switch (bizType){
          case "လက်ဘက်ရည်":
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "အချိုရည်":
            _taxRange = "10000 - 60000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "စားသောက်":
            _taxRange = "20000 - 150000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "ထမင်း":
            _taxRange = "10000 - 30000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "မုန့်ဟင်းခါး":
            _taxRange = "10000 - 25000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "ကြေးအိုး/ဆီချက်":
            _taxRange = "10000 - 60000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "ကွမ်းယာ":
            _taxRange = "10000 - 15000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "မုန့်ဆိုင်/သစ်သီး":
            _taxRange = "10000 - 60000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
        }
        break;
      case 'ဘေးအန္တရာယ်လုပ်ငန်းလိုင်စင်':
        switch(bizType){
          case "ပရိဘောဂ":
            _taxRange = "25000 - 50000 ";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "ကွန်ပျူတာ":
            _taxRange = "10000 - 40000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "ဆေးရွက်ကြီး":
            _taxRange = "20000 - 50000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "ဝါး":
            _taxRange = "10000 - 30000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "စက်ပြင်":
            _taxRange = "10000 - 60000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "ထင်း/မီးသွေး":
            _taxRange = "10000 - 250000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "ရာဘာ":
            _taxRange = "20000 - 400000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "ကွမ်းသီး":
            _taxRange = "15000 - 60000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "အိုး":
            _taxRange = "10000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')}";
            break;
          case "ဆေးလိပ်ခုံ":
            _taxRange = "15000 - 20000";
            _taxRange = "${NumberFormatterHelper.numberFormat('15000')} - ${NumberFormatterHelper.numberFormat('20000')}";
            break;
          case "စက်သုံးဆီ":
            _taxRange = "10000 - 300000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('300000')}";
            break;
          case "ပဲဆီ":
            _taxRange = "20000 - 30000";
            _taxRange = "${NumberFormatterHelper.numberFormat('20000')} - ${NumberFormatterHelper.numberFormat('30000')}";
            break;
          case "ဓာတ်မြေဩဇာ":
            _taxRange = "10000 - 50000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('50000')}";
            break;
          case "ဘတ္ထရီ":
            _taxRange = "40000";
            _taxRange = "${NumberFormatterHelper.numberFormat('40000')}";
            break;
          case "ဆေးဆိုင်":
            _taxRange = "10000 - 60000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('60000')}";
            break;
          case "ကားအရောင်းပြခန်း":
            _taxRange = "100000 - 300000";
            _taxRange = "${NumberFormatterHelper.numberFormat('100000')} - ${NumberFormatterHelper.numberFormat('300000')}";
            break;
          case "သစ်စက်ဆိုင်":
            _taxRange = "15000 - 50000";
            _taxRange = "${NumberFormatterHelper.numberFormat('15000')} - ${NumberFormatterHelper.numberFormat('50000')}";
            break;
          case "ရေခဲစက်":
            _taxRange = "30000 - 80000";
            _taxRange = "${NumberFormatterHelper.numberFormat('30000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "ရေသန့်":
            _taxRange = "35000 - 100000";
            _taxRange = "${NumberFormatterHelper.numberFormat('35000')} - ${NumberFormatterHelper.numberFormat('100000')}";
            break;
          case "အကြော်ဖို/မုန့်တီဖို":
            _taxRange = "10000 - 40000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('40000')}";
            break;
          case "သံပုံးပုလင်း":
            _taxRange = "15000 - 80000";
            _taxRange = "${NumberFormatterHelper.numberFormat('15000')} - ${NumberFormatterHelper.numberFormat('80000')}";
            break;
          case "ဗီဒီယိုခွေဌား":
            _taxRange = "10000 - 15000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('15000')}";
            break;
          case "ဆားစက်/ရောင်း":
            _taxRange = "10000 - 35000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('35000')}";
            break;
          case "ပလပ်စတစ်":
            _taxRange = "30000";
            _taxRange = "${NumberFormatterHelper.numberFormat('30000')}";
            break;
          case "ဆေးခန်း၊ ဓာတ်ခွဲခန်း":
            _taxRange = "15000 - 300000";
            _taxRange = "${NumberFormatterHelper.numberFormat('15000')} - ${NumberFormatterHelper.numberFormat('300000')}";
            break;
          case "အရက်ချက်စက်ရုံ":
            _taxRange = "200000";
            _taxRange = "${NumberFormatterHelper.numberFormat('200000')}";
            break;
          case "အခြား":
            _taxRange = "10000 - 100000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('100000')}";
            break;
        }
        break;
      case 'ပုဂ္ဂလိကအိမ်ဆိုင်လုပ်ငန်းလိုင်စင်':
        switch (bizType){
          case "ကုန်မာ":
            _taxRange = "15000 - 1500000";
            _taxRange = "${NumberFormatterHelper.numberFormat('15000')} - ${NumberFormatterHelper.numberFormat('1500000')}";
            break;
          case "သံမူလီ/သံဟောင်း":
            _taxRange = "10000 - 25000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('25000')}";
            break;
          case "ရွှေပန်းထိမ်":
            _taxRange = "60000 - 100000";
            _taxRange = "${NumberFormatterHelper.numberFormat('60000')} - ${NumberFormatterHelper.numberFormat('100000')}";
            break;
          case "ရွှေဆိုင်":
            _taxRange = "15000 - 40000";
            _taxRange = "${NumberFormatterHelper.numberFormat('15000')} - ${NumberFormatterHelper.numberFormat('40000')}";
            break;
          case "အပ်ချုပ်":
            _taxRange = "10000 - 40000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('40000')}";
            break;
          case "တီဗီရောင်း":
            _taxRange = "30000 - 50000";
            _taxRange = "${NumberFormatterHelper.numberFormat('30000')} - ${NumberFormatterHelper.numberFormat('50000')}";
            break;
          case "ပလပ်စတစ်":
            _taxRange = "10000 - 20000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('20000')}";
            break;
          case "တီဗီပြင်":
            _taxRange = "10000 - 20000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('20000')}";
            break;
          case "မျက်မှန်/မှန်":
            _taxRange = "10000 - 12000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('12000')}";
            break;
          case "နာရီ":
            _taxRange = "10000 - 20000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('20000')}";
            break;
          case "စာအုပ်ဌား":
            _taxRange = "10000 - 15000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('15000')}";
            break;
          case "စတိုး":
            _taxRange = "15000 - 50000";
            _taxRange = "${NumberFormatterHelper.numberFormat('15000')} - ${NumberFormatterHelper.numberFormat('50000')}";
            break;
          case "ဖိနပ်":
            _taxRange = "10000 - 40000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('40000')}";
            break;
          case "အလှကုန်":
            _taxRange = "10000 - 50000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('50000')}";
            break;
          case "စာအုပ်နှင့် စာရေးကိရိယာ":
            _taxRange = "15000 - 50000";
            _taxRange = "${NumberFormatterHelper.numberFormat('15000')} - ${NumberFormatterHelper.numberFormat('50000')}";
            break;
          case "အလှပြင်":
            _taxRange = "20000 - 50000";
            _taxRange = "${NumberFormatterHelper.numberFormat('20000')} - ${NumberFormatterHelper.numberFormat('50000')}";
            break;
          case "ဆံသဆိုင်":
            _taxRange = "10000 - 30000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('30000')}";
            break;
          case "ပွဲရုံ":
            _taxRange = "30000 - 60000";
            _taxRange = "${NumberFormatterHelper.numberFormat('30000')} - ${NumberFormatterHelper.numberFormat('60000')}";
            break;
          case "ဆန်":
            _taxRange = "10000 - 60000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('60000')}";
            break;
          case "ကုန်စုံ":
            _taxRange = "10000 - 30000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('30000')}";
            break;
          case "လျှပ်စစ်":
            _taxRange = "10000 - 50000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('50000')}";
            break;
          case "လယ်ယာသုံး":
            _taxRange = "30000 - 50000";
            _taxRange = "${NumberFormatterHelper.numberFormat('30000')} - ${NumberFormatterHelper.numberFormat('50000')}";
            break;
          case "စက်ပစ္စည်း":
            _taxRange = "10000 - 40000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('40000')}";
            break;
          case "အခြား":
            _taxRange = "10000 - 100000";
            _taxRange = "${NumberFormatterHelper.numberFormat('10000')} - ${NumberFormatterHelper.numberFormat('100000')}";
            break;
        }
        break;
    }
    return '${NumConvertHelper.getMyanNumString(_taxRange)}';
  }
}