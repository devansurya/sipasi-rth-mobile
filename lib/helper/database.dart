import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sipasi_rth_mobile/model/setting.dart';

class DB {
  static final String databaseName = "sipasi.db";
  static final int databaseVersion = 1;

  DB._privateConstructor();
  static final DB instance = DB._privateConstructor();

  // This method opens the database connection
  Future<Database> get database async {
    final databasePath = await getDatabasesPath();

    return await openDatabase(
      join(databasePath, databaseName),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE Setting(code TEXT PRIMARY KEY, desc TEXT, value TEXT)",
        );
      },
      version: 1,
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