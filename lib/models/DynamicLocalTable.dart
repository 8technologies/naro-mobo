import 'package:sqflite/sqflite.dart';

import '../utils/AppConfig.dart';
import '../utils/Utils.dart';

class DynamicLocalTable {
  static String table_name = "dynamic_local_table";

  save() async {
    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.insert(
        DynamicLocalTable.table_name,
        toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print("SUCCESS SAVE");
    } catch (e) {
      print("FAILED SAVE");
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  toJson() {
    return {
      'id': id,
      'end_point': end_point,
      'data': data,
    };
  }

  static Future<List<DynamicLocalTable>> getItems(String endPoint) async {
    List<DynamicLocalTable> data = [];
    if (!(await DynamicLocalTable.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(DynamicLocalTable.table_name,
        where : 'end_point = ?', whereArgs: [endPoint]);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(DynamicLocalTable.fromJson(maps[i]));
    });

    return data;
  }

  String end_point = "";
  String data = "";
  int id = 0;

  static DynamicLocalTable fromJson(dynamic data) {
    DynamicLocalTable item = new DynamicLocalTable();
    if (data == null) {
      return item;
    }

    item.data = Utils.to_str(data['data'], '');
    item.end_point = Utils.to_str(data['end_point'], '');
    return item;
  }

  static Future<bool> initTable() async {
    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return false;
    }

    String sql =
        "CREATE TABLE IF NOT EXISTS ${DynamicLocalTable.table_name} (id INTEGER PRIMARY KEY,end_point TEXT,data TEXT)";
    try {
      //await db.delete(DynamicLocalTable.table_name);

      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }
}
