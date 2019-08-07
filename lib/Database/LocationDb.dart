import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myotaw/model/LocationModel.dart';
import 'package:myotaw/helper/DbHelper.dart';

class LocationDb{

  static Database _database;

  openLocationDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DbHelper.LOCATION_DATABASE_NAME);
    _database = await openDatabase(path,
      version: DbHelper.LOCATION_DATABASE_VERSION,
      onCreate: _onCreate,
    );
  }

  closeLocationDb(){
    _database.close();
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${DbHelper.TABLE_NAME_LOCATION} (
            ${DbHelper.COLUMN_LOCATION_ID} INTEGER PRIMARY KEY,
            ${DbHelper.COLUMN_STATE_DIVISION} TEXT,
            ${DbHelper.COLUMN_STATE_DIVISION_UNICODE} TEXT,
            ${DbHelper.COLUMN_STATE_DIVISION_CODE} TEXT,
            ${DbHelper.COLUMN_TOWNHIP} TEXT,
            ${DbHelper.COLUMN_TOWNSHIP_UNICODE} TEXT,
            ${DbHelper.COLUMN_TOWNSHIP_CODE} TEXT)
          ''');
  }

  Future<int> insert(LocationModel model) async {
    Map<String, dynamic> row = {
      DbHelper.COLUMN_LOCATION_ID : model.locationId,
      DbHelper.COLUMN_STATE_DIVISION : model.stateDivision,
      DbHelper.COLUMN_STATE_DIVISION_UNICODE : model.stateDivision_Unicode,
      DbHelper.COLUMN_STATE_DIVISION_CODE : model.stateDivisionCode,
      DbHelper.COLUMN_TOWNHIP : model.township,
      DbHelper.COLUMN_TOWNSHIP_UNICODE : model.township_Unicode,
      DbHelper.COLUMN_TOWNSHIP_CODE : model.townshipCode,
    };
    print('sqlInsert: ${row}');
    return await _database.insert(DbHelper.TABLE_NAME_LOCATION, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _database.query(DbHelper.TABLE_NAME_LOCATION);
  }

  Future<List<LocationModel>> getLocation() async {
    var result = await _database.query(DbHelper.TABLE_NAME_LOCATION);
    if (result.length == 0) return [];

    List<LocationModel> list = result.map((item) {
      return LocationModel.fromMap(item);
    }).toList();

    print(result);
    return list;
  }


  Future<int> queryRowCount() async {
    return Sqflite.firstIntValue(await _database.rawQuery('SELECT COUNT(*) FROM ${DbHelper.TABLE_NAME_LOCATION}'));
  }

  Future<bool> isLocationDbSetup()async{
    int count = await queryRowCount();
    if(count != 0){
      return true;
    }else{
      return false;
    }
  }


  /*Future<int> update(Map<String, dynamic> row) async {
    int id = row[DbHelper.COLUMN_SAVE_NF_ID];
    return await _database.update(DbHelper.TABLE_NAME_SAVE_NEWS_FEED, row, where: '${DbHelper.COLUMN_SAVE_NF_ID} = ?', whereArgs: [id]);
  }*/


  /*Future<int> deleteSavedNewsFeedById(String uniqueKey) async {
    await _database.delete(DbHelper.TABLE_NAME_SAVE_NEWS_FEED, where: '${DbHelper.COLUMN_SAVE_NF_ID} = ?', whereArgs: [uniqueKey]);
  }

  Future deleteSavedNewsFeed()async{
    await _database.delete(DbHelper.TABLE_NAME_SAVE_NEWS_FEED);
  }*/

  Future<List<LocationModel>> getState() async {
    var result = await _database.query(DbHelper.TABLE_NAME_LOCATION, distinct: true,
        columns: [DbHelper.COLUMN_STATE_DIVISION_UNICODE]);
    if (result.length == 0) return null;
    List<LocationModel> list = new List<LocationModel>();
    for(var i in result){
      list.add(LocationModel.fromMap(i));
    }

    return list;
  }

/* _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if (oldVersion < newVersion) {
       await db.execute('ALTER TABLE $TABLE_NAME_USER ADD COLUMN $columnAddress TEXT');
    }
  }*/

}