import 'NumConvertHelper.dart';

class TaxUseBudgetYearHelper{

    String getBudgetYear(int year){
     if(year == 2018)
     {
       return NumConvertHelper.getMyanNumInt(year) + " - " + NumConvertHelper.getMyanNumInt(year);
     }
     else if (year < 2018)
     {
       return NumConvertHelper.getMyanNumInt(year) + " - " + NumConvertHelper.getMyanNumInt(year+1);
     }else {

       return NumConvertHelper.getMyanNumInt(year-1) + " - " + NumConvertHelper.getMyanNumInt(year);
     }
  }
}