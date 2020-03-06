import 'package:myotaw/helper/DbHelper.dart';

class LocationModel{
  int _locationId;
  String _stateDivision;
  String _stateDivision_Unicode;
  String _stateDivisionCode;
  String _township;
  String _township_Unicode;
  String _townshipCode;

  int get locationId => _locationId;

  set locationId(int value) {
    _locationId = value;
  }

  String get stateDivision => _stateDivision;

  String get townshipCode => _townshipCode;

  set townshipCode(String value) {
    _townshipCode = value;
  }

  String get township_Unicode => _township_Unicode;

  set township_Unicode(String value) {
    _township_Unicode = value;
  }

  String get township => _township;

  set township(String value) {
    _township = value;
  }

  String get stateDivisionCode => _stateDivisionCode;

  set stateDivisionCode(String value) {
    _stateDivisionCode = value;
  }

  String get stateDivision_Unicode => _stateDivision_Unicode;

  set stateDivision_Unicode(String value) {
    _stateDivision_Unicode = value;
  }

  set stateDivision(String value) {
    _stateDivision = value;
  }

  LocationModel.fromJson(Map<String, dynamic> json):
      _locationId = json['LocationID'],
      _stateDivision = json['StateDivision'],
      _stateDivision_Unicode = json['StateDivision_Unicode'],
      _stateDivisionCode = json['StateDivisionCode'],
      _township = json['Township'],
      _township_Unicode = json['Township_Unicode'],
      _townshipCode = json['TownshipCode'];

  LocationModel.fromDb(Map<String, dynamic> map):
      _locationId = map[DbHelper.COLUMN_LOCATION_ID],
      _stateDivision = map[DbHelper.COLUMN_STATE_DIVISION],
      _stateDivision_Unicode = map[DbHelper.COLUMN_STATE_DIVISION_UNICODE],
      _stateDivisionCode = map[DbHelper.COLUMN_STATE_DIVISION_CODE],
      _township = map[DbHelper.COLUMN_TOWNHIP],
      _township_Unicode = map[DbHelper.COLUMN_TOWNSHIP_UNICODE],
      _townshipCode = map[DbHelper.COLUMN_TOWNSHIP_CODE];


}