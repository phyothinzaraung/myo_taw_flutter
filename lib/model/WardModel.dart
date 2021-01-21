class WardModel{
  int _id;
  String _wardName;
  String _township;
  String _stateDivision;

  WardModel();

  int get id => _id;

  set id(int value){
    _id = value;
  }

  String get wardName => _wardName;

  set wardName(String value){
    _wardName = value;
  }

  String get township => _township;

  set township(String value){
    _township = value;
  }

  String get stateDivision => _stateDivision;

  set stateDivision(String value){
    _stateDivision = value;
  }

  WardModel.fromJson(dynamic json){
      this._id = json["ID"];
      this._wardName = json["WardName"];
      this._township = json["Township"];
      this._stateDivision = json["StateDivision"];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = Map<String, dynamic>();

    json["ID"] = _id;
    json["WardName"] = _wardName;
    json["Township"] = _township;
    json["StateDivision"] = _stateDivision;

    return json;
  }
}