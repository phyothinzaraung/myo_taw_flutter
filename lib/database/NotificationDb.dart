import 'dart:io';
import 'package:myotaw/model/NotificationModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myotaw/model/SaveNewsFeedModel.dart';
import 'package:myotaw/helper/DbHelper.dart';

class NotificationDb{

  static Database _database;

  openNotificationDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DbHelper.NOTIFICATION_DATABASE_NAME);
    _database = await openDatabase(path,
      version: DbHelper.NOTIFICATION_DATABASE_VERSION,
      onCreate: _onCreate,
    );
  }

  closeSaveNotificationDb(){
    _database.close();
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${DbHelper.TABLE_NAME_NOTIFICATION} (
            ${DbHelper.COLUMN_NOTIFICATION_ID} INTEGER PRIMARY KEY,
            ${DbHelper.COLUMN_NOTIFICATION_MESSAGE} TEXT,
            ${DbHelper.COLUMN_NOTIFICATION_DATE} TEXT,
            ${DbHelper.COLUMN_NOTIFICATION_IS_DELETED} INTEGER,
            ${DbHelper.COLUMN_NOTIFICATION_IS_SEEN} INTEGER,
            ${DbHelper.COLUMN_NOTIFICATION_BIZ_ID} INTEGER)
          ''');
  }

  Future<int> insert(NotificationModel model) async {
    Map<String, dynamic> row = {
      DbHelper.COLUMN_NOTIFICATION_ID : model.iD,
      DbHelper.COLUMN_NOTIFICATION_MESSAGE : model.message,
      DbHelper.COLUMN_NOTIFICATION_DATE : model.postedDate,
      DbHelper.COLUMN_NOTIFICATION_IS_DELETED : model.isDeleted?1:0,
      DbHelper.COLUMN_NOTIFICATION_IS_SEEN : model.isSeen?1:0,
      DbHelper.COLUMN_NOTIFICATION_BIZ_ID : model.bizId
    };
    print('sqlInsert: ${row}');
    return await _database.insert(DbHelper.TABLE_NAME_NOTIFICATION, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _database.query(DbHelper.TABLE_NAME_NOTIFICATION);
  }

  Future<int> updateNotification(NotificationModel model) async {
    return await _database.update(DbHelper.TABLE_NAME_NOTIFICATION, model.toDb(), where: '${DbHelper.COLUMN_SAVE_NF_ID} = ?', whereArgs: [model.iD]);
  }

  Future<int> updateNotificationForApplyBiz(NotificationModel model) async {
    return await _database.update(DbHelper.TABLE_NAME_NOTIFICATION, model.toDb(), where: '${DbHelper.COLUMN_NOTIFICATION_MESSAGE} = ?', whereArgs: [model.message]);
  }

  Future deleteBizId0()async{
    await _database.delete(DbHelper.TABLE_NAME_NOTIFICATION, where: '${DbHelper.COLUMN_NOTIFICATION_ID} = ?', whereArgs: [0]);
  }

  Future<List<NotificationModel>> getNotification() async {
    var result = await _database.query(DbHelper.TABLE_NAME_NOTIFICATION, where: '${DbHelper.COLUMN_NOTIFICATION_IS_DELETED} =?',whereArgs: [0],
        orderBy: '${DbHelper.COLUMN_NOTIFICATION_DATE} DESC');
    if (result.length == 0) return [];

    List<NotificationModel> list = result.map((item) {
      return NotificationModel.fromDb(item);
    }).toList();

    print(result);
    return list;
  }

  Future<int> getLastID() async {
    var result = await _database.query(DbHelper.TABLE_NAME_NOTIFICATION, where: '${DbHelper.COLUMN_NOTIFICATION_IS_DELETED} =?',whereArgs: [0],
        orderBy: '${DbHelper.COLUMN_NOTIFICATION_DATE} ASC',);
    if (result.length == 0) return 0;

    List<NotificationModel> list = result.map((item) {
      return NotificationModel.fromDb(item);
    }).toList();

    print(result);
    return list.last.iD;
  }

  Future<int> getUnReadNotificationCount() async {
    var list = await _database.rawQuery('SELECT * FROM ${DbHelper.TABLE_NAME_NOTIFICATION} '
        'WHERE ${DbHelper.COLUMN_NOTIFICATION_IS_SEEN} =? AND  ${DbHelper.COLUMN_NOTIFICATION_IS_DELETED} = ?',[0,0]);
    if(list.isNotEmpty){
      return list.length;
    }else{
      return 0;
    }
  }


  Future<int> queryRowCount() async {
    return Sqflite.firstIntValue(await _database.rawQuery('SELECT COUNT(*) FROM ${DbHelper.TABLE_NAME_NOTIFICATION}'));
  }


  Future<void> deleteNotificationById(String id) async {
    await _database.delete(DbHelper.TABLE_NAME_NOTIFICATION, where: '${DbHelper.COLUMN_NOTIFICATION_ID} = ?', whereArgs: [id]);
  }

  Future<bool> isSeen()async{
    bool _isSeen;
    var list = await _database.query(DbHelper.TABLE_NAME_NOTIFICATION,where:'${DbHelper.COLUMN_NOTIFICATION_IS_SEEN} = ?', whereArgs: [0]);
    if(list.isNotEmpty){
      _isSeen = true;
    }else{
      _isSeen = false;
    }
    return _isSeen;
  }

  Future<bool> isSeenById(NotificationModel model)async{
    bool _isSeen;
    var list = await _database.query(DbHelper.TABLE_NAME_NOTIFICATION,where:'${DbHelper.COLUMN_NOTIFICATION_IS_SEEN} = ? AND ${DbHelper.COLUMN_NOTIFICATION_ID} = ?',
        whereArgs: [1, model.iD]);
    if(list.isNotEmpty){
      _isSeen = true;
    }else{
      _isSeen = false;
    }
    return _isSeen;
  }

  Future deleteNotification()async{
    await _database.delete(DbHelper.TABLE_NAME_NOTIFICATION);
  }

  Future<bool> isNotificationSaved(int id) async {
    bool isSaved;
    var result = await _database.query(DbHelper.TABLE_NAME_NOTIFICATION,
        where: '${DbHelper.COLUMN_NOTIFICATION_ID} = ?', whereArgs: ['$id']);
    if(result.isNotEmpty){
      isSaved = true;
    }else{
      isSaved = false;
    }
    return isSaved;
  }

  Future<bool> isNotificationDelete(String id) async {
    bool isDelete;
    var result = await _database.query(DbHelper.TABLE_NAME_NOTIFICATION,
        where: '${DbHelper.COLUMN_NOTIFICATION_ID} = ?', whereArgs: ['$id']);
    for(var i in result){
      if(NotificationModel.fromDb(i).isDeleted){
        isDelete = true;
      }else{
      isDelete = true;
      }
    }
    return isDelete;
  }

/* _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if (oldVersion < newVersion) {
       await db.execute('ALTER TABLE $TABLE_NAME_USER ADD COLUMN $columnAddress TEXT');
    }
  }*/

}