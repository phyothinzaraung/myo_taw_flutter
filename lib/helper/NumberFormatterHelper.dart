
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class NumberFormatterHelper{
  static String NumberFormat(String amount){
    FlutterMoneyFormatter flutterMoneyFormatter = FlutterMoneyFormatter(amount: double.parse(amount));
    return flutterMoneyFormatter.output.withoutFractionDigits;
  }
}