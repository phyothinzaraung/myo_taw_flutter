import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myotaw/model/UserModel.dart';
import 'DbHelper.dart';

class UserDb {

  // make this a singleton class
  UserDb._privateConstructor();
  static final UserDb instance = UserDb._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initUserDb();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initUserDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DbHelper.DATABASE_NAME);
    return await openDatabase(path,
        version: DbHelper.DATABASE_VERSION,
        onCreate: _onCreate,
      );
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
            ${DbHelper.COLUMN_USER_ACCESSTIME} TEXT,
            ${DbHelper.COLUMN_USER_IS_DELETED} INTEGER,
            ${DbHelper.COLUMN_USER_RESOURCE} TEXT,
            ${DbHelper.COLUMN_USER_ANDROID_TOKEN} TEXT,
            ${DbHelper.COLUMN_USER_CURRENT_REGION_CODE} TEXT,
            ${DbHelper.COLUMN_USER_PIN_CODE} INTEGER,
            ${DbHelper.COLUMN_USER_AMOUNT} INTEGER)
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(UserModel model) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {
      DbHelper.COLUMN_USER_UNIQUE : model.uniqueKey,
      DbHelper.COLUMN_USER_NAME : model.name,
      DbHelper.COLUMN_USER_PHONE_NO : model.phoneNo,
      DbHelper.COLUMN_USER_PHOTO_URL : model.photoUrl,
      DbHelper.COLUMN_USER_STATE : model.state,
      DbHelper.COLUMN_USER_TOWNSHIP : model.township,
      DbHelper.COLUMN_USER_ADDRESS : model.address,
      DbHelper.COLUMN_USER_REGISTERED_DATE : model.registeredDate,
      DbHelper.COLUMN_USER_ACCESSTIME : model.accesstime,
      DbHelper.COLUMN_USER_IS_DELETED : model.isDeleted,
      DbHelper.COLUMN_USER_RESOURCE : model.resource,
      DbHelper.COLUMN_USER_ANDROID_TOKEN : model.androidToken,
      DbHelper.COLUMN_USER_CURRENT_REGION_CODE : model.currentRegionCode,
      DbHelper.COLUMN_USER_PIN_CODE : model.pinCode,
      DbHelper.COLUMN_USER_AMOUNT : model.amount
    };
    print('sqlInsert: ${row}');
    return await db.insert(DbHelper.TABLE_NAME_USER, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(DbHelper.TABLE_NAME_USER);
  }

  Future<List<UserModel>> getUserModel() async {
    Database dbClient = await instance.database;
    String sql;
    sql = "SELECT * FROM ${DbHelper.TABLE_NAME_USER}";

    var result = await dbClient.rawQuery(sql);
    if (result.length == 0) return [];

    List<UserModel> list = result.map((item) {
      return UserModel.fromJson(item);
    }).toList();

    print(result);
    return list;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ${DbHelper.TABLE_NAME_USER}'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[DbHelper.COLUMN_USER_UNIQUE];
    return await db.update(DbHelper.TABLE_NAME_USER, row, where: '${DbHelper.COLUMN_USER_UNIQUE} = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(DbHelper.TABLE_NAME_USER, where: '${DbHelper.COLUMN_USER_UNIQUE} = ?', whereArgs: [id]);
  }

  Future<UserModel> getUserById(String uniqueKey) async {
    Database dbClient = await instance.database;
    UserModel userModel;
    var result = await dbClient.query(DbHelper.TABLE_NAME_USER,
        columns: [DbHelper.COLUMN_USER_UNIQUE,
          DbHelper.COLUMN_USER_NAME,
          DbHelper.COLUMN_USER_PHONE_NO,
          DbHelper.COLUMN_USER_PHOTO_URL,
          DbHelper.COLUMN_USER_STATE,
          DbHelper.COLUMN_USER_TOWNSHIP,
          DbHelper.COLUMN_USER_ADDRESS,
          DbHelper.COLUMN_USER_REGISTERED_DATE,
          DbHelper.COLUMN_USER_ACCESSTIME,
          DbHelper.COLUMN_USER_IS_DELETED,
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
    await dbClient.close();
    print('getuserid ${userModel.name}');
    return userModel;
  }

 /* _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if (oldVersion < newVersion) {
       await db.execute('ALTER TABLE $TABLE_NAME_USER ADD COLUMN $columnAddress TEXT');
    }
  }*/
}