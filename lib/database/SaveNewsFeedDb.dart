import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myotaw/model/SaveNewsFeedModel.dart';
import 'package:myotaw/helper/DbHelper.dart';

class SaveNewsFeedDb{

  static Database _database;

  openSaveNfDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DbHelper.SAVE_NEWS_FEED_DATABASE_NAME);
    _database = await openDatabase(path,
      version: DbHelper.SAVE_NEWS_FEED_DATABASE_VERSION,
      onCreate: _onCreate,
    );
  }

  closeSaveNfDb(){
    _database.close();
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${DbHelper.TABLE_NAME_SAVE_NEWS_FEED} (
            ${DbHelper.COLUMN_SAVE_NF_ID} TEXT PRIMARY KEY,
            ${DbHelper.COLUMN_SAVE_NF_TITLE} TEXT,
            ${DbHelper.COLUMN_SAVE_NF_BODY} TEXT,
            ${DbHelper.COLUMN_SAVE_NF_PHOTO_URL} TEXT,
            ${DbHelper.COLUMN_SAVE_NF_VIDEO_URL} TEXT,
            ${DbHelper.COLUMN_SAVE_NF_THUMBNAIL} TEXT,
            ${DbHelper.COLUMN_SAVE_NF_ACCESSTIME} TEXT,
            ${DbHelper.COLUMN_SAVE_NF_CONTENT_TYPE} TEXT)
          ''');
  }

  Future<int> insert(SaveNewsFeedModel model) async {
    Map<String, dynamic> row = {
      DbHelper.COLUMN_SAVE_NF_ID : model.id,
      DbHelper.COLUMN_SAVE_NF_TITLE : model.title,
      DbHelper.COLUMN_SAVE_NF_BODY : model.body,
      DbHelper.COLUMN_SAVE_NF_PHOTO_URL : model.photoUrl,
      DbHelper.COLUMN_SAVE_NF_VIDEO_URL : model.videoUrl,
      DbHelper.COLUMN_SAVE_NF_THUMBNAIL : model.thumbNail,
      DbHelper.COLUMN_SAVE_NF_ACCESSTIME : model.accessTime,
      DbHelper.COLUMN_SAVE_NF_CONTENT_TYPE : model.contentType,
    };
    print('sqlInsert: ${row}');
    return await _database.insert(DbHelper.TABLE_NAME_SAVE_NEWS_FEED, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _database.query(DbHelper.TABLE_NAME_SAVE_NEWS_FEED);
  }

  Future<List<SaveNewsFeedModel>> getSaveNewsFeed() async {
    var result = await _database.query(DbHelper.TABLE_NAME_SAVE_NEWS_FEED, orderBy: '${DbHelper.COLUMN_SAVE_NF_ACCESSTIME} DESC');
    if (result.length == 0) return [];

    List<SaveNewsFeedModel> list = result.map((item) {
      return SaveNewsFeedModel.fromDb(item);
    }).toList();

    print(result);
    return list;
  }


  Future<int> queryRowCount() async {
    return Sqflite.firstIntValue(await _database.rawQuery('SELECT COUNT(*) FROM ${DbHelper.TABLE_NAME_SAVE_NEWS_FEED}'));
  }


  Future<int> update(Map<String, dynamic> row) async {
    int id = row[DbHelper.COLUMN_SAVE_NF_ID];
    return await _database.update(DbHelper.TABLE_NAME_SAVE_NEWS_FEED, row, where: '${DbHelper.COLUMN_SAVE_NF_ID} = ?', whereArgs: [id]);
  }


  Future<void> deleteSavedNewsFeedById(String uniqueKey) async {
    await _database.delete(DbHelper.TABLE_NAME_SAVE_NEWS_FEED, where: '${DbHelper.COLUMN_SAVE_NF_ID} = ?', whereArgs: [uniqueKey]);
  }

  Future deleteSavedNewsFeed()async{
    await _database.delete(DbHelper.TABLE_NAME_SAVE_NEWS_FEED);
  }

  Future<bool> isNewsFeedSaved(String id) async {
    bool isSaved;
    var result = await _database.query(DbHelper.TABLE_NAME_SAVE_NEWS_FEED,
        columns: [DbHelper.COLUMN_SAVE_NF_ID,
          DbHelper.COLUMN_SAVE_NF_TITLE,
          DbHelper.COLUMN_SAVE_NF_BODY,
          DbHelper.COLUMN_SAVE_NF_PHOTO_URL,
          DbHelper.COLUMN_SAVE_NF_VIDEO_URL,
          DbHelper.COLUMN_SAVE_NF_THUMBNAIL,
          DbHelper.COLUMN_SAVE_NF_ACCESSTIME,
          DbHelper.COLUMN_SAVE_NF_CONTENT_TYPE,],
        where: '${DbHelper.COLUMN_SAVE_NF_ID} = ?', whereArgs: ['$id']);
    if(result.isNotEmpty){
      isSaved = true;
    }else{
      isSaved = false;
    }
    return isSaved;
  }

/* _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if (oldVersion < newVersion) {
       await db.execute('ALTER TABLE $TABLE_NAME_USER ADD COLUMN $columnAddress TEXT');
    }
  }*/

}