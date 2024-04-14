import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../utils/AppConfig.dart';
import '../utils/Utils.dart';
import 'RespondModel.dart';

class DynamicTable {
  static String table_name = "dynamic_table";

  static Future<List<DynamicTable>> getItems(String endPoint,
      {dynamic params}) async {
    params ??= {};
    DynamicTable.getOlineData(endPoint, params: params);

    List<DynamicTable> data = await getLocalData(endPoint);
    if (data.isEmpty) {
      await DynamicTable.getOlineData(endPoint);
      data = await getLocalData(endPoint);
    }

    return data;
  }

  static Future<void> getOlineData(String endPoint, {dynamic params}) async {
    if (!(await Utils.is_connected())) {
      return;
    }

    params ??= {};

    RespondModel resp = RespondModel(await Utils.http_get(endPoint, params));

    if (resp.code != 1) {
      return;
    }
    if (!(await DynamicTable.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return;
    }

    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return;
    }

    await db.rawDelete(
        'DELETE FROM ${DynamicTable.table_name} WHERE end_point = ?',
        [endPoint]);

    await db.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO ${DynamicTable.table_name}(end_point, data) VALUES(?, ?)',
          [endPoint, jsonEncode(resp.data)]);
    });
  }

  static Future<List<DynamicTable>> getLocalData(String endPoint) async {
    List<DynamicTable> data = [];
    if (!(await DynamicTable.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(DynamicTable.table_name,
        where : 'end_point = ?', whereArgs: [endPoint]);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(DynamicTable.fromJson(maps[i]));
    });

    return data;
  }

  String end_point = "";
  String data = "";

  static DynamicTable fromJson(dynamic data) {
    DynamicTable item = new DynamicTable();
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
        "CREATE TABLE IF NOT EXISTS ${DynamicTable.table_name} (end_point TEXT PRIMARY KEY,data TEXT)";
    try {
      //await db.delete(DynamicTable.table_name);

      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }
}
