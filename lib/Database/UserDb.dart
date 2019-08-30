import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myotaw/model/UserModel.dart';
import 'package:myotaw/helper/DbHelper.dart';

class UserDb {
  static Database _database;

  openUserDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DbHelper.USER_DATABASE_NAME);
    _database = await openDatabase(path,
        version: DbHelper.USER_DATABASE_VERSION,
        onCreate: _onCreate,
      );
  }

  closeUserDb(){
    _database.close();
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${DbHelper.TABLE_NAME_USER} (
            ${DbHelper.COLUMN_USER_UNIQUE} TEXT PRIMARY KEY,
            ${DbHelper.COLUMN_USER_NAME} TEXT,
            ${DbHelper.COLUMN_USER_PHONE_NO} TEXT,
            ${DbHelper.COLUMN_USER_PHOTO_URL} TEXT,
            ${DbHelper.COLUMN_USER_STATE} TEXT,
            ${DbHelper.COLUMN_USER_TOWNSHIP} TEXT,
            ${DbHelper.COLUMN_USER_ADDRESS} TEXT,
            ${DbHelper.COLUMN_USER_REGISTERED_DATE} TEXT,
            ${DbHelper.COLUMN_USER_ISDELETED} INTEGER,
            ${DbHelper.COLUMN_USER_ACCESSTIME} TEXT,
            ${DbHelper.COLUMN_USER_RESOURCE} TEXT,
            ${DbHelper.COLUMN_USER_ANDROID_TOKEN} TEXT,
            ${DbHelper.COLUMN_USER_CURRENT_REGION_CODE} TEXT,
            ${DbHelper.COLUMN_USER_PIN_CODE} INTEGER,
            ${DbHelper.COLUMN_USER_AMOUNT} INTEGER)
          ''');
  }

  Future<int> insert(UserModel model) async {
    Map<String, dynamic> row = {
      DbHelper.COLUMN_USER_UNIQUE : model.uniqueKey,
      DbHelper.COLUMN_USER_NAME : model.name,
      DbHelper.COLUMN_USER_PHONE_NO : model.phoneNo,
      DbHelper.COLUMN_USER_PHOTO_URL : model.photoUrl,
      DbHelper.COLUMN_USER_STATE : model.state,
      DbHelper.COLUMN_USER_TOWNSHIP : model.township,
      DbHelper.COLUMN_USER_ADDRESS : model.address,
      DbHelper.COLUMN_USER_REGISTERED_DATE : model.registeredDate,
      DbHelper.COLUMN_USER_ISDELETED : model.isDeleted,
      DbHelper.COLUMN_USER_ACCESSTIME : model.accesstime,
      DbHelper.COLUMN_USER_RESOURCE : model.resource,
      DbHelper.COLUMN_USER_ANDROID_TOKEN : model.androidToken,
      DbHelper.COLUMN_USER_CURRENT_REGION_CODE : model.currentRegionCode,
      DbHelper.COLUMN_USER_PIN_CODE : model.pinCode,
      DbHelper.COLUMN_USER_AMOUNT : model.amount
    };
    print('sqlInsert: ${row}');
    return await _database.insert(DbHelper.TABLE_NAME_USER, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _database.query(DbHelper.TABLE_NAME_USER);
  }

  Future<List<UserModel>> getUser() async {
    String sql;
    sql = "SELECT * FROM ${DbHelper.TABLE_NAME_USER}";

    var result = await _database.rawQuery(sql);
    if (result.length == 0) return [];

    List<UserModel> list = result.map((item) {
      return UserModel.fromMap(item);
    }).toList();

    print(result);
    return list;
  }


  Future<int> queryRowCount() async {
    return Sqflite.firstIntValue(await _database.rawQuery('SELECT COUNT(*) FROM ${DbHelper.TABLE_NAME_USER}'));
  }


  Future<int> update(Map<String, dynamic> row) async {
    int id = row[DbHelper.COLUMN_USER_UNIQUE];
    return await _database.update(DbHelper.TABLE_NAME_USER, row, where: '${DbHelper.COLUMN_USER_UNIQUE} = ?', whereArgs: [id]);
  }


  Future<int> delete(String uniqueKey) async {
    await _database.delete(DbHelper.TABLE_NAME_USER, where: '${DbHelper.COLUMN_USER_UNIQUE} = ?', whereArgs: [uniqueKey]);
  }

  Future deleteUser()async{
    await _database.delete(DbHelper.TABLE_NAME_USER);
  }

  Future<UserModel> getUserById(String uniqueKey) async {
    UserModel userModel;
    var result = await _database.query(DbHelper.TABLE_NAME_USER,
        columns: [DbHelper.COLUMN_USER_UNIQUE,
          DbHelper.COLUMN_USER_NAME,
          DbHelper.COLUMN_USER_PHONE_NO,
          DbHelper.COLUMN_USER_PHOTO_URL,
          DbHelper.COLUMN_USER_STATE,
          DbHelper.COLUMN_USER_TOWNSHIP,
          DbHelper.COLUMN_USER_ADDRESS,
          DbHelper.COLUMN_USER_REGISTERED_DATE,
          DbHelper.COLUMN_USER_ISDELETED,
          DbHelper.COLUMN_USER_ACCESSTIME,
          DbHelper.COLUMN_USER_RESOURCE,
          DbHelper.COLUMN_USER_ANDROID_TOKEN,
          DbHelper.COLUMN_USER_CURRENT_REGION_CODE,
          DbHelper.COLUMN_USER_PIN_CODE,
          DbHelper.COLUMN_USER_AMOUNT],
        where: '${DbHelper.COLUMN_USER_UNIQUE} = ?', whereArgs: ['$uniqueKey']);
    if (result.length == 0) return null;
    for(var i in result){
      userModel = UserModel.fromMap(i);
    }
    //print('getuserid ${userModel.name}');
    return userModel;
  }

 /* _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if (oldVersion < newVersion) {
       await db.execute('ALTER TABLE $TABLE_NAME_USER ADD COLUMN $columnAddress TEXT');
    }
  }*/
}