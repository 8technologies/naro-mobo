import 'package:dio/dio.dart';
import 'package:marcci/models/UserModel.dart';
import 'package:marcci/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/AppConfig.dart';
import 'RespondModel.dart';

class LocalImageToUploadModel {
  static String table_name = "local_images_to_upload";

  int id = 0;
  String name = "";
  String path = "";
  String parent_type = "";
  String parent_id_online = "";
  String parent_id_local = "";

  Future<bool> upload() async {
    Map<String, dynamic> formDataMap = {};
    try {
      formDataMap['file'] =
          await MultipartFile.fromFile(path, filename: name);
      formDataMap['name'] = name;
      formDataMap['path'] = path;
      formDataMap['parent_id_online'] = parent_id_online;
      formDataMap['parent_id_local'] = id;
      formDataMap['parent_type'] = parent_type;

      RespondModel r = RespondModel(
          await Utils.http_post('post-media-upload', formDataMap));
      if (r.code != 1) {
        return false;
      }

      if ('user-photo' == parent_type) {
        if (r.data != null) {
          UserModel u = UserModel.fromJson(r.data);
          await u.save();
        }
      }

      this.delete();
      return true;
    } on DioError {
      return false;
    }

    return false;
  }

  Future<void> delete() async {
    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    try {
      await db.rawDelete(
          'DELETE FROM ${LocalImageToUploadModel.table_name} WHERE id = ?',
          [id]);
      print("success to delete!");
    } catch (e) {
      print(e.toString());
      print("failed to delete!");
    }
  }

  Future<void> save() async {
    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.insert(
        LocalImageToUploadModel.table_name,
        toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print("SUCCESS SAVE");
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'parent_type': parent_type,
      'parent_id_online': parent_id_online,
      'parent_id_local': parent_id_local,
    };
  }

  static Future<List<LocalImageToUploadModel>> getItems() async {
    List<LocalImageToUploadModel> items = [];

    var db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return items;
    }
    List<Map> maps = await db.query(table_name);

    for (var element in maps) {
      LocalImageToUploadModel m = LocalImageToUploadModel.fromJson(element);
      items.add(m);
    }

    return items;
  }

  static Future<bool> initTable() async {
    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return false;
    }

    String sql =
        "CREATE TABLE IF NOT EXISTS ${LocalImageToUploadModel.table_name} (id TEXT PRIMARY KEY,name TEXT, path TEXT, parent_type TEXT,parent_id_online TEXT, parent_id_local TEXT )";
    try {
      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  static LocalImageToUploadModel fromJson(dynamic d) {
    LocalImageToUploadModel obj = new LocalImageToUploadModel();
    if (d == null) {
      return obj;
    }

    obj.id = Utils.int_parse(d['id']);
    obj.name = Utils.to_str(d['name'], '');
    obj.path = Utils.to_str(d['path'], '');
    obj.parent_type = Utils.to_str(d['parent_type'], '');
    obj.parent_id_online = Utils.to_str(d['parent_id_online'], '');
    obj.parent_id_local = Utils.to_str(d['parent_id_local'], '');

    return obj;
  }
}
