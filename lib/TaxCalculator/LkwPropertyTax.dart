
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/helper/NumConvertHelper.dart';

class LkwPropertyTax{

  static String _taxRange = '';

  static void clearValue(){
    _taxRange = '';
  }
  
  static String getTax({buildingType, story, grade}){
    switch(buildingType){
      case 'RC':
        switch(story){
          case '(၁) ထပ်':
            switch(grade){
              case MyString.txt_first_grade:
                _taxRange = '240,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '192,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '144,000';
                break;
            }
            break;
          case '(၂) ထပ်':
            switch(grade){
              case MyString.txt_first_grade:
                _taxRange = '360,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '288,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '240,000';
                break;
            }
            break;
          case '(၃) ထပ်':
            switch(grade){
              case MyString.txt_first_grade:
                _taxRange = '528,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '432,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '360,000';
                break;
            }
            break;
        }
        break;
      case 'အုတ်တိုက်':
        switch (story){
          case '(၁) ထပ်':
            switch(grade){
              case MyString.txt_first_grade:
                _taxRange = '120,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '96,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '72,000';
                break;
            }
            break;
          case '(၂) ထပ်':
            switch(grade){
              case MyString.txt_first_grade:
                _taxRange = '144,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '132,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '120,000';
                break;
            }
            break;
        }
        break;
      case 'အုတ်ညှပ်':
        switch (story){
          case '(၁) ထပ်':
            switch(grade){
              case MyString.txt_first_grade:
                _taxRange = '60,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '55,200';
                break;
              case MyString.txt_third_grade:
                _taxRange = '48,000';
                break;
            }
            break;
          case '(၂) ထပ်':
            switch(grade){
              case MyString.txt_first_grade:
                _taxRange = '72,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '67,200';
                break;
              case MyString.txt_third_grade:
                _taxRange = '60,000';
                break;
            }
            break;
        }
        break;
      case 'တိုက်ခံ':
        switch(grade){
          case MyString.txt_first_grade:
            _taxRange = '48,000';
            break;
          case MyString.txt_second_grade:
            _taxRange = '43,200';
            break;
          case MyString.txt_third_grade:
            _taxRange = '36,000';
            break;
        }
        break;
      case 'ပျဉ်ထောင်':
        switch (story){
          case '(၁) ထပ်':
            switch(grade){
              case MyString.txt_first_grade:
                _taxRange = '19,200';
                break;
              case MyString.txt_second_grade:
                _taxRange = '12,000';
                break;
              case MyString.txt_third_grade:
                _taxRange = '9,600';
                break;
            }
            break;
          case '(၂) ထပ်':
            switch(grade){
              case MyString.txt_first_grade:
                _taxRange = '36,000';
                break;
              case MyString.txt_second_grade:
                _taxRange = '28,800';
                break;
              case MyString.txt_third_grade:
                _taxRange = '21,600';
                break;
            }
            break;
        }
        break;
      case 'တဲအိမ်':
        _taxRange = '4,800';
        break;

    }
    return '${NumConvertHelper.getMyanNumString(_taxRange)}';
  }
}