

import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/helper/NumConvertHelper.dart';
import 'package:myotaw/helper/NumberFormatterHelper.dart';

class TgyPropertyTax{
  static double buildingValue = 0, roadValue = 0, zoneValue = 0, rentalRate = 0, arv = 0;
  static const int base_value = 70;
  static double tax = 0;
  static String getArv({buildingGrade, roadType, zone, length, width,story, isGov}){
    switch (buildingGrade){
      case MyString.BUILDING_GRADE_A:
        buildingValue = 0;
        break;
      case MyString.BUILDING_GRADE_B:
        buildingValue = -0.2;
        break;
      case MyString.BUILDING_GRADE_C:
        buildingValue = -0.8;
        break;
      /*case MyString.GOV_BUILDING:
        buildingValue = -0.15;
        break;*/
    }

    switch (roadType){
      case 1:
        roadValue = 0.1;
        break;
      case 2:
        roadValue = 0.05;
        break;
      case 3:
        roadValue = 0;
        break;
    }

    switch (zone){
      case 1:
        zoneValue = 0.5;
        break;
      case 2:
        zoneValue = 0.25;
        break;
      case 3:
        zoneValue = 0;
        break;
    }

    rentalRate = base_value + buildingValue * base_value + roadValue * base_value + zoneValue *base_value + (isGov? base_value * -0.15 : 0);
    arv = double.parse(length) * double.parse(width) * rentalRate * story;
    int lastTwoDigit = arv.round() % 100;
    int finalArv;
    if (lastTwoDigit >= 50){
      finalArv = arv.round() + (100 - lastTwoDigit);

    }else {
      finalArv = arv.round() - lastTwoDigit;
    }
    //isGov? tax = 0.04 : tax = 0.02;
    tax = 0.04;
    var _finalValue = (finalArv * tax + finalArv * tax).round();
    if(_finalValue < 2000){
      _finalValue = 2000;
    }
    print('rentalRate : $rentalRate , tax : $tax, buildingValue : $buildingValue, finalvalue: $_finalValue');

    return NumConvertHelper.getMyanNumString(NumberFormatterHelper.numberFormat(_finalValue.toString()));
  }
}