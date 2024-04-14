import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class PestsAndDiseaseModel {
  static String end_point2 = "api/PestsAndDisease";
  static String tableName = "pests_and_diseases";
  int id = 0;
  String garden_location = "";
  String user_id = "";
  String user_text = "";
  String variety_id = "";
  String variety_text = "";
  String category = "";
  String photo = "";
  String video = "";
  String audio = "";
  String description = "";
  String created_at = "";
  String updated_at = "";

  static fromJson(dynamic m) {
    PestsAndDiseaseModel obj = new PestsAndDiseaseModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.garden_location = Utils.to_str(m['garden_location'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.user_text = Utils.to_str(m['user_text'], '');
    obj.variety_id = Utils.to_str(m['variety_id'], '');
    obj.variety_text = Utils.to_str(m['variety_text'], '');
    obj.category = Utils.to_str(m['category'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.video = Utils.to_str(m['video'], '');
    obj.audio = Utils.to_str(m['audio'], '');
    obj.description = Utils.to_str(m['description'], '');
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');

    return obj;
  }

  static Future<List<PestsAndDiseaseModel>> getLocalData(
      {String where = "1"}) async {
    List<PestsAndDiseaseModel> data = [];
    if (!(await PestsAndDiseaseModel.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps =
        await db.query(tableName, where: where, orderBy: ' id DESC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(PestsAndDiseaseModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<PestsAndDiseaseModel>> get_items(
      {String where = '1'}) async {
    List<PestsAndDiseaseModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await PestsAndDiseaseModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      PestsAndDiseaseModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<PestsAndDiseaseModel>> getOnlineItems() async {
    List<PestsAndDiseaseModel> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get('${PestsAndDiseaseModel.end_point2}', {}));

    if (resp.code != 1) {
      return [];
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return [];
    }

    if (resp.data.runtimeType.toString().contains('List')) {
      if (await Utils.is_connected()) {
        await PestsAndDiseaseModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          PestsAndDiseaseModel sub = PestsAndDiseaseModel.fromJson(x);
          try {
            batch.insert(tableName, sub.toJson(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (e) {
            print("faied to save becaus ${e.toString()}");
          }
        }

        try {
          await batch.commit(continueOnError: true);
        } catch (e) {
          print("faied to save to commit BRECASE == ${e.toString()}");
        }
      });
    }

    return data;
  }

  save() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.insert(
        tableName,
        toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  toJson() {
    return {
      'id': id,
      'garden_location': garden_location,
      'user_id': user_id,
      'user_text': user_text,
      'variety_id': variety_id,
      'variety_text': variety_text,
      'category': category,
      'photo': photo,
      'video': video,
      'audio': audio,
      'description': description,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  static Future initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "$tableName ("
        "id INTEGER PRIMARY KEY"
        ",garden_location TEXT"
        ",user_id TEXT"
        ",user_text TEXT"
        ",variety_id TEXT"
        ",variety_text TEXT"
        ",category TEXT"
        ",photo TEXT"
        ",video TEXT"
        ",audio TEXT"
        ",description TEXT"
        ",created_at TEXT"
        ",updated_at TEXT"
        ")";

    try {
      //await db.execute("DROP TABLE ${tableName}");
      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  static deleteAll() async {
    if (!(await PestsAndDiseaseModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(PestsAndDiseaseModel.tableName);
  }

  delete() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.delete(tableName, where: 'id = $id');
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }
}
