import 'MyoTawConstant.dart';
import 'NumConvertHelper.dart';

class FloodLevelFtInHelper{
  static String getFtInFromWaterLevel(double value){
    String _feet = '';
    String _inch = '';

    if(value != null){
      String _feetStr = (value/12).toString();
      String _inchStr = (value%12.toInt()).toString();
      List _listFeet = _feetStr.split('.');
      List _listInch = _inchStr.split('.');
      _feet = _listFeet[0]!='0'?_listFeet[0]+' '+'${MyString.txt_feet}':'';
      _inch = _listInch[0]!='0'?_listInch[0]+' '+'${MyString.txt_inch}':'';
    }

    return '${NumConvertHelper.getMyanNumString(_feet)} ${NumConvertHelper.getMyanNumString(_inch)}';
  }
}