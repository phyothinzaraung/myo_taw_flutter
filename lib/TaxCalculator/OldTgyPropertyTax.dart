

import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/helper/NumConvertHelper.dart';
import 'package:myotaw/helper/NumberFormatterHelper.dart';

class OLdTgyPropertyTax{
   static double rentalRate = 0, arv = 0, length = 0, width = 0;
   static int ARV;

   static String getArv({building,story,roadType, l, w})
  {

    switch (building){
      case "သက်ကယ်မိုးထရံကာ":
        switch (story){
          case "၁ ထပ်":
            switch (roadType){
              case "လမ်းကျယ်":
                rentalRate = 9.3;
                break;
              case "လမ်းကျဉ်း":
                rentalRate = 9.3;
                break;
            }
            break;
        }
        break;
      case "သွပ်မိုးထရံကာ":
        switch (story){
          case "၁ ထပ်":
            switch (roadType){
              case "လမ်းကျယ်":
                rentalRate = 12.4;
                break;
              case "လမ်းကျဉ်း":
                rentalRate = 12.4;
                break;
            }
            break;
          case "၂ ထပ်":
            switch (roadType){
              case "လမ်းကျယ်":
                rentalRate = 15.5;
                break;
              case "လမ်းကျဉ်း":
                rentalRate = 15.5;
                break;
            }
            break;
        }
        break;
      case "ပျဉ်":
        switch (story){
          case "၁ ထပ်":
            switch (roadType){
              case "လမ်းမကြီး":
                rentalRate = 46.5;
                break;
              case "လမ်းကျယ်":
                rentalRate = 24.8;
                break;
              case "လမ်းကျဉ်း":
                rentalRate = 15.5;
                break;
            }
            break;
          case "၂ ထပ်":
            switch (roadType){
              case "လမ်းမကြီး":
                rentalRate = 62;
                break;
              case "လမ်းကျယ်":
                rentalRate = 31;
                break;
              case "လမ်းကျဉ်း":
                rentalRate = 24.8;
                break;
            }
            break;
        }
        break;
      case "နံကပ်":
        switch (story){
          case "၁ ထပ်":
            switch (roadType){
              case "လမ်းမကြီး":
                rentalRate = 62;
                break;
              case "လမ်းကျယ်":
                rentalRate = 46.5;
                break;
              case "လမ်းကျဉ်း":
                rentalRate = 31;
                break;
            }
            break;
          case "၂ ထပ်":
            switch (roadType){
              case "လမ်းမကြီး":
                rentalRate = 93;
                break;
              case "လမ်းကျယ်":
                rentalRate = 62;
                break;
              case "လမ်းကျဉ်း":
                rentalRate = 46.5;
                break;
            }
            break;
        }
        break;
      case "တိုက်":
        switch (story){
          case "၁ ထပ်":
            switch (roadType){
              case "လမ်းမကြီး":
                rentalRate = 124;
                break;
              case "လမ်းကျယ်":
                rentalRate = 93;
                break;
              case "လမ်းကျဉ်း":
                rentalRate = 77.5;
                break;
            }
            break;
          case "၂ ထပ်":
            switch (roadType){
              case "လမ်းမကြီး":
                rentalRate = 170.5;
                break;
              case "လမ်းကျယ်":
                rentalRate = 155;
                break;
              case "လမ်းကျဉ်း":
                rentalRate = 93;
                break;
            }
            break;
          case "၃ ထပ်":
            switch (roadType){
              case "လမ်းမကြီး":
                rentalRate = 232.5;
                break;
              case "လမ်းကျယ်":
                rentalRate = 217;
                break;
              case "လမ်းကျဉ်း":
                rentalRate = 124;
                break;
            }
            break;
          case "၄ ထပ်":
            switch (roadType){
              case "လမ်းမကြီး":
                rentalRate = 310;
                break;
              case "လမ်းကျယ်":
                rentalRate = 279;
                break;
              case "လမ်းကျဉ်း":
                rentalRate = 186;
                break;
            }
            break;
          case "၅ ထပ်":
            switch (roadType){
              case "လမ်းမကြီး":
                rentalRate = 372;
                break;
              case "လမ်းကျယ်":
                rentalRate = 310;
                break;
              case "လမ်းကျဉ်း":
                rentalRate = 248;
                break;
            }
            break;
          case "၆ ထပ်":
            switch (roadType){
              case "လမ်းမကြီး":
                rentalRate = 465;
                break;
              case "လမ်းကျယ်":
                rentalRate = 327;
                break;
              case "လမ်းကျဉ်း":
                rentalRate = 310;
                break;
            }
            break;
        }
        break;
    }
    length = double.parse(l);
    width = double.parse(w);
    print('l&W : ${building} ${roadType} ${story} ${l} ${w}');
    arv = length * width * rentalRate;
    int arv_int = (arv * 0.08).toInt();
    int lastTwoInt = arv_int%100;

    if (lastTwoInt >= 50){
      ARV = arv_int + (100 - lastTwoInt);

    }else {
      ARV = arv_int - lastTwoInt;
    }

    print("rentalRate : ${arv} ${arv_int} ${rentalRate} ${ARV}");
    return NumConvertHelper.getMyanNumString(NumberFormatterHelper.numberFormat(ARV.toString()));
  }
}