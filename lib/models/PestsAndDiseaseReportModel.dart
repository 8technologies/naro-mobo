import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class PestsAndDiseaseReportModel {
  static String end_point = "pests-and-disease-reports";
  static String tableName = "pests_and_disease_reports";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String pests_and_disease_id = "";
  String pests_and_disease_text = "";
  String garden_id = "";
  String garden_text = "";
  String crop_id = "";
  String crop_text = "";
  String user_id = "";
  String user_text = "";
  String district_id = "";
  String district_text = "";
  String subcounty_id = "";
  String subcounty_text = "";
  String parish_id = "";
  String parish_text = "";
  String description = "";
  String photo = "";
  String video = "";
  String expert_answer = "";
  String expert_answer_photo = "";
  String expert_answer_video = "";
  String expert_answer_audio = "";
  String expert_answer_description = "";
  String gps_lati = "";
  String gps_longi = "";

  static fromJson(dynamic m) {
    PestsAndDiseaseReportModel obj = new PestsAndDiseaseReportModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.pests_and_disease_id = Utils.to_str(m['pests_and_disease_id'], '');
    obj.pests_and_disease_text = Utils.to_str(m['pests_and_disease_text'], '');
    obj.garden_id = Utils.to_str(m['garden_id'], '');
    obj.garden_text = Utils.to_str(m['garden_text'], '');
    obj.crop_id = Utils.to_str(m['crop_id'], '');
    obj.crop_text = Utils.to_str(m['crop_text'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.user_text = Utils.to_str(m['user_text'], '');
    obj.district_id = Utils.to_str(m['district_id'], '');
    obj.district_text = Utils.to_str(m['district_text'], '');
    obj.subcounty_id = Utils.to_str(m['subcounty_id'], '');
    obj.subcounty_text = Utils.to_str(m['subcounty_text'], '');
    obj.parish_id = Utils.to_str(m['parish_id'], '');
    obj.parish_text = Utils.to_str(m['parish_text'], '');
    obj.description = Utils.to_str(m['description'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.video = Utils.to_str(m['video'], '');
    obj.expert_answer = Utils.to_str(m['expert_answer'], '');
    obj.expert_answer_photo = Utils.to_str(m['expert_answer_photo'], '');
    obj.expert_answer_video = Utils.to_str(m['expert_answer_video'], '');
    obj.expert_answer_audio = Utils.to_str(m['expert_answer_audio'], '');
    obj.expert_answer_description =
        Utils.to_str(m['expert_answer_description'], '');
    obj.gps_lati = Utils.to_str(m['gps_lati'], '');
    obj.gps_longi = Utils.to_str(m['gps_longi'], '');

    return obj;
  }

  static Future<List<PestsAndDiseaseReportModel>> getLocalData(
      {String where = "1"}) async {
    List<PestsAndDiseaseReportModel> data = [];
    if (!(await PestsAndDiseaseReportModel.initTable())) {
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
      data.add(PestsAndDiseaseReportModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<PestsAndDiseaseReportModel>> get_items(
      {String where = '1'}) async {
    List<PestsAndDiseaseReportModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await PestsAndDiseaseReportModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      PestsAndDiseaseReportModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<PestsAndDiseaseReportModel>> getOnlineItems() async {
    List<PestsAndDiseaseReportModel> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get('${PestsAndDiseaseReportModel.end_point}', {}));

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
        await PestsAndDiseaseReportModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          PestsAndDiseaseReportModel sub =
              PestsAndDiseaseReportModel.fromJson(x);
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
      'created_at': created_at,
      'updated_at': updated_at,
      'pests_and_disease_id': pests_and_disease_id,
      'pests_and_disease_text': pests_and_disease_text,
      'garden_id': garden_id,
      'garden_text': garden_text,
      'crop_id': crop_id,
      'crop_text': crop_text,
      'user_id': user_id,
      'user_text': user_text,
      'district_id': district_id,
      'district_text': district_text,
      'subcounty_id': subcounty_id,
      'subcounty_text': subcounty_text,
      'parish_id': parish_id,
      'parish_text': parish_text,
      'description': description,
      'photo': photo,
      'video': video,
      'expert_answer': expert_answer,
      'expert_answer_photo': expert_answer_photo,
      'expert_answer_video': expert_answer_video,
      'expert_answer_audio': expert_answer_audio,
      'expert_answer_description': expert_answer_description,
      'gps_lati': gps_lati,
      'gps_longi': gps_longi,
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
        ",created_at TEXT"
        ",updated_at TEXT"
        ",pests_and_disease_id TEXT"
        ",pests_and_disease_text TEXT"
        ",garden_id TEXT"
        ",garden_text TEXT"
        ",crop_id TEXT"
        ",crop_text TEXT"
        ",user_id TEXT"
        ",user_text TEXT"
        ",district_id TEXT"
        ",district_text TEXT"
        ",subcounty_id TEXT"
        ",subcounty_text TEXT"
        ",parish_id TEXT"
        ",parish_text TEXT"
        ",description TEXT"
        ",photo TEXT"
        ",video TEXT"
        ",expert_answer TEXT"
        ",expert_answer_photo TEXT"
        ",expert_answer_video TEXT"
        ",expert_answer_audio TEXT"
        ",expert_answer_description TEXT"
        ",gps_lati TEXT"
        ",gps_longi TEXT"
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
    if (!(await PestsAndDiseaseReportModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(PestsAndDiseaseReportModel.tableName);
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
