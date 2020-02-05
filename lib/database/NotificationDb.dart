//import 'dart:io';
//import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:myotaw/model/NotificationModel.dart';
//import 'package:myotaw/helper/DbHelper.dart';
//
//class NotificationDb{
//
//  static Database _database;
//
//  openNotiDb() async {
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    String path = join(documentsDirectory.path, DbHelper.NOTIFICATION_DATABASE_NAME);
//    _database = await openDatabase(path,
//      version: DbHelper.NOTIFICATION_DATABASE_VERSION,
//      onCreate: _onCreate,
//    );
//  }
//
//  closeNotiDb(){
//    _database.close();
//  }
//
//  // SQL code to create the database table
//  Future _onCreate(Database db, int version) async {
//    await db.execute('''
//          CREATE TABLE ${DbHelper.TABLE_NAME_NOTIFICATION} (
//            ${DbHelper.COLUMN_NOTIFICATION_TITLE} TEXT PRIMARY KEY,
//            ${DbHelper.COLUMN_NOTIFICATION_BODY} TEXT)
//          ''');
//  }
//
//  Future<int> insert(NotificationModel model) async {
//    Map<String, dynamic> row = {
//      DbHelper.COLUMN_NOTIFICATION_TITLE : model.title,
//      DbHelper.COLUMN_NOTIFICATION_BODY : model.body,
//    };
//    print('sqlInsert: ${row}');
//    return await _database.insert(DbHelper.TABLE_NAME_NOTIFICATION, row, conflictAlgorithm: ConflictAlgorithm.replace);
//  }
//
//
//  Future<List<Map<String, dynamic>>> queryAllRows() async {
//    return await _database.query(DbHelper.TABLE_NAME_NOTIFICATION);
//  }
//
//  Future<List<NotificationModel>> getNotification() async {
//    var result = await _database.query(DbHelper.TABLE_NAME_NOTIFICATION,);
//    if (result.length == 0) return [];
//
//    List<NotificationModel> list = result.map((item) {
//      return NotificationModel.fromMap(item);
//    }).toList();
//
//    print(result);
//    return list;
//  }
//
//
//  Future<int> queryRowCount() async {
//    return Sqflite.firstIntValue(await _database.rawQuery('SELECT COUNT(*) FROM ${DbHelper.TABLE_NAME_NOTIFICATION}'));
//  }
//
//
//  Future<int> update(Map<String, dynamic> row) async {
//    int id = row[DbHelper.COLUMN_NOTIFICATION_TITLE];
//    return await _database.update(DbHelper.TABLE_NAME_NOTIFICATION, row, where: '${DbHelper.COLUMN_NOTIFICATION_TITLE} = ?', whereArgs: [id]);
//  }
//
//
//  Future<void> deleteSavedNotiById(String title) async {
//    await _database.delete(DbHelper.TABLE_NAME_NOTIFICATION, where: '${DbHelper.COLUMN_NOTIFICATION_TITLE} = ?', whereArgs: [title]);
//  }
//
//  Future deleteSavedNoti()async{
//    await _database.delete(DbHelper.TABLE_NAME_NOTIFICATION);
//  }
//
//  Future<bool> isNewsFeedSaved(String id) async {
//    bool isSaved;
//    var result = await _database.query(DbHelper.TABLE_NAME_NOTIFICATION,
//        columns: [DbHelper.COLUMN_NOTIFICATION_TITLE,
//          DbHelper.COLUMN_NOTIFICATION_BODY,],
//        where: '${DbHelper.COLUMN_NOTIFICATION_TITLE} = ?', whereArgs: ['$id']);
//    if(result.isNotEmpty){
//      isSaved = true;
//    }else{
//      isSaved = false;
//    }
//    return isSaved;
//  }
//
// _onUpgrade(Database db, int oldVersion, int newVersion) async{
//    if (oldVersion < newVersion) {
//       await db.execute('ALTER TABLE $TABLE_NAME_USER ADD COLUMN $columnAddress TEXT');
//    }
//  }
//
//
//}
