import 'package:myotaw/model/DaoModel.dart';
import 'DaoModel.dart';
class DaoViewModel{

  List<dynamic>_photoList;
  DaoModel _daoModel;

  List<dynamic> get photoList => _photoList;

  set photoList(List<dynamic> value) {
    _photoList = value;
  }

  DaoModel get daoModel => _daoModel;

  set daoModel(DaoModel value) {
    _daoModel = value;
  }

  DaoViewModel.fromJson(Map<String, dynamic> json):
    _photoList = List<dynamic>.from(json['Photo']!=null?json['Photo'] : []),
    _daoModel = DaoModel.formJson(json['DAO']);
        
}