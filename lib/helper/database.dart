import 'dart:async';
import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sipasi_rth_mobile/model/setting.dart';

class DB {
  static const String databaseName = "sipasi.db";
  static const int databaseVersion = 1;

  DB._privateConstructor();
  static final DB instance = DB._privateConstructor();

  // This method opens the database connection
  Future<Database> get database async {
    final databasePath = await getDatabasesPath();

    return await openDatabase(
      join(databasePath, databaseName),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE Setting(code TEXT PRIMARY KEY, desc TEXT, value TEXT, createDate DATETIME)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          db.execute("ALTER TABLE Setting ADD COLUMN createDate DATETIME");
        }
      },
      version: 3,
    );
  }

  Future<int> insertSetting(Setting setting) async {
    final db = await database;

    String? sett = await getSetting(setting.getCode());
    if(sett != ''){
      return await db.update(
        'Setting',
        setting.toMap(),
        where: 'code = ?',
        whereArgs: [setting.getCode()],
      );
    }
    else {
      return await db.insert('Setting', setting.toMap());
    }
  }

  Future<String?> getSetting(String code) async {
    try{
      final db = await database;
      log('get setting $code');
      final List<Map<String?, Object?>> SettingMap = await db.query(
          'Setting',
          where: 'code = ?',
          whereArgs: [code],
          limit: 1
      );
      String value = '';
      if(SettingMap.isNotEmpty) {
        value = SettingMap[0]['value'].toString();
      }
      return value;
    }
    catch(e){
      print(e);
    }
    return null;
  }

  Future<Map<String?, Object?>> getFullSetting(String code) async {
    //default value
    Map<String?, Object?> value = {
      'code': null,
      'desc': null,
      'value': null,
      'createDate' : null
    };

    try{
      final db = await database;
      log('get setting $code');
      final List<Map<String?, Object?>> SettingMap = await db.query(
          'Setting',
          where: 'code = ?',
          whereArgs: [code],
          limit: 1
      );
      value = SettingMap[0];
    }
    catch(e){
      print(e);
    }
    return value;
  }

  Future<bool> deleteSetting(String code) async {
    final db = await database;
    log('message');
    final int count = await db.delete(
      'Setting',
      where: 'code = ?',
      whereArgs: [code],
    );
    print(count);
    bool result = false;
    if(count > 0) {
      result = true;
    }
    return result;
  }
}