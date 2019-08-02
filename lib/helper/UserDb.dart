import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myotaw/model/UserModel.dart';

class UserDb {
  static final TABLE_NAME_USER = 'user.db';

  static final DATABASE_NAME = "UserDb";
  static final DATABASE_VERSION = 1;

  static final COLUMN_USER_UNIQUE = 'unique';
  static final COLUMN_USER_NAME = 'name';
  static final COLUMN_USER_PHONE_NO = 'phoneNo';
  static final COLUMN_USER_PHOTO_URL = 'photoUrl';
  static final COLUMN_USER_STATE = 'state';
  static final COLUMN_USER_TOWNSHIP = 'township';
  static final COLUMN_USER_ADDRESS = 'address';
  static final COLUMN_USER_REGISTERED_DATE = 'registeredDate';
  static final COLUMN_USER_ACCESSTIME = 'accesstime';
  static final COLUMN_USER_IS_DELETED = 'isDeleted';
  static final COLUMN_USER_RESOURCE = 'resource';
  static final COLUMN_USER_ANDROID_TOKEN = 'androidToken';
  static final COLUMN_USER_CURRENT_REGION_CODE = 'currentRegionCode';
  static final COLUMN_USER_PIN_CODE = 'pinCode';
  static final COLUMN_USER_AMOUNT = 'Amount';

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
    String path = join(documentsDirectory.path, DATABASE_NAME);
    return await openDatabase(path,
        version: DATABASE_VERSION,
        onCreate: _onCreate,
      );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $TABLE_NAME_USER (
            $COLUMN_USER_UNIQUE TEXT PRIMARY KEY,
            $COLUMN_USER_NAME TEXT NOT NULL,
            $COLUMN_USER_PHONE_NO TEXT NOT NULL,
            $COLUMN_USER_PHOTO_URL TEXT NOT NULL,
            $COLUMN_USER_STATE TEXT NOT NULL,
            $COLUMN_USER_TOWNSHIP TEXT NOT NULL,
            $COLUMN_USER_ADDRESS TEXT NOT NULL,
            $COLUMN_USER_REGISTERED_DATE TEXT NOT NULL,
            $COLUMN_USER_ACCESSTIME TEXT NOT NULL,
            $COLUMN_USER_IS_DELETED INTEGER NOT NULL,
            $COLUMN_USER_RESOURCE TEXT NOT NULL,
            $COLUMN_USER_ANDROID_TOKEN TEXT NOT NULL,
            $COLUMN_USER_CURRENT_REGION_CODE TEXT NOT NULL,
            $COLUMN_USER_PIN_CODE INTEGER NOT NULL,
            $COLUMN_USER_AMOUNT INTEGER NOT NULL,
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    print('sqlInsert: ${row}');
    return await db.insert(TABLE_NAME_USER, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(TABLE_NAME_USER);
  }

  Future<List<UserModel>> getUserModel() async {
    Database dbClient = await instance.database;
    String sql;
    sql = "SELECT * FROM $TABLE_NAME_USER";

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
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $TABLE_NAME_USER'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[COLUMN_USER_UNIQUE];
    return await db.update(TABLE_NAME_USER, row, where: '$COLUMN_USER_UNIQUE = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(TABLE_NAME_USER, where: '$COLUMN_USER_UNIQUE = ?', whereArgs: [id]);
  }

  Future<List<UserModel>> getUserById(String uniqueKey) async {
    //Database dbClient = await instance.database;

    var result = await _database.query(TABLE_NAME_USER,
        columns: [COLUMN_USER_NAME,COLUMN_USER_PHONE_NO],
        where: '$COLUMN_USER_UNIQUE = ?', whereArgs: ['$uniqueKey']);
    if (result.length == 0) return [];
    UserModel userModel;
    List<UserModel> list = result.map((item) {
      return UserModel.fromJson(item);
    }).toList();

    print(result);
    await _database.close();
    return list;
  }

 /* _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if (oldVersion < newVersion) {
       await db.execute('ALTER TABLE $TABLE_NAME_USER ADD COLUMN $columnAddress TEXT');
    }
  }*/
}