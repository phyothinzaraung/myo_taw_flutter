
import 'package:myotaw/helper/NumConvertHelper.dart';
import 'package:myotaw/helper/NumberFormatterHelper.dart';

class MlmPropertyTax{

  static int _taxRange = 0 ,_taxRange1 = 0;
  static String getTax({buildingType, story}){
    switch(buildingType){
      case 'RC':
        switch(story){
          case '၆ ထပ် နှင့်အထက်':
            _taxRange = 2500000;
            _taxRange1 = 5000000;
            break;
          case "၄ ထပ် မှ ၆ ထပ်":
            _taxRange = 800000;
            _taxRange1 = 3000000;
            break;
          case "၃ ထပ်":
            _taxRange = 100000;
            _taxRange1 = 1200000;
            break;
          case "၂ ထပ်":
            _taxRange = 30000;
            _taxRange1 = 800000;
            break;
          case "၁ ထပ်":
            _taxRange = 20000;
            _taxRange1 = 100000;
            break;
        }
        break;
      case 'အုတ်ညှပ်':
        switch (story){
          case "၂ ထပ်":
            _taxRange = 25000;
            _taxRange1 = 50000;
            break;
          case "၁ ထပ်":
            _taxRange = 15000;
            _taxRange1 = 40000;
            break;
        }
        break;
      case 'တိုက်ခံသွပ်မိုး':
        _taxRange = 25000;
        _taxRange1 = 50000;
        break;
      case 'ပျဉ်ထောင်':
        _taxRange = 25000;
        _taxRange1 = 50000;
        break;
      case 'ပျဉ်ထောင်သွပ်မိုး':
        switch (story){
          case "၂ ထပ်":
            _taxRange = 25000;
            _taxRange1 = 50000;
            break;
          case "၁ ထပ်":
            _taxRange = 15000;
            _taxRange1 = 40000;
            break;
        }
        break;
      case 'တိုက်ခံပျဉ်ထောင်':
        _taxRange = 25000;
        _taxRange1 = 50000;
        break;
      case 'ပျဉ်ထောင်ဖက်မိုး':
        _taxRange = 2500;
        _taxRange1 = 10000;
        break;
      case "ထရံကာသွပ်မိုး":
        _taxRange = 2500;
        _taxRange1 = 10000;
        break;
      case "ထရံကာဖက်မိုး":
        _taxRange = 2500;
        _taxRange1 = 10000;
        break;
    }
    return '${NumConvertHelper.getMyanNumString(NumberFormatterHelper.numberFormat(_taxRange.toString()))} - '
        '${NumConvertHelper.getMyanNumString(NumberFormatterHelper.numberFormat(_taxRange1.toString()))}';
  }
}