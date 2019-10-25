
class SmartWaterMeterUnitModel{

  String _meterNo;
  int _finalUnit;

  String get meterNo => _meterNo;

  set meterNo(String value) {
    _meterNo = value;
  }

  int get finalUnit => _finalUnit;

  set finalUnit(int value) {
    _finalUnit = value;
  }

  SmartWaterMeterUnitModel.fromJson(Map<String, dynamic> json) :

      _meterNo = json['MeterNo'],
      _finalUnit = json['FinalUnit'];

}