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

  Future<void> dropNotificationTable()async{
    await _database.execute("DROP TABLE IF EXISTS ${DbHelper.TABLE_NAME_NOTIFICATION}");
  }

  Future<bool> isNotiTableExist()async{
    try{
      var result = await _database.rawQuery('SELECT COUNT(*) FROM ${DbHelper.TABLE_NAME_NOTIFICATION}');
      if(result != null){
        return true;
      }
    }catch (e){
      print(e);
      return false;
    }
  }

/* _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if (oldVersion < newVersion) {
       await db.execute('ALTER TABLE $TABLE_NAME_USER ADD COLUMN $columnAddress TEXT');
    }
  }*/

}