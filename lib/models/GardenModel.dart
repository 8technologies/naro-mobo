import 'package:sqflite/sqflite.dart';

import '../utils/AppConfig.dart';
import '../utils/Utils.dart';
import 'RespondModel.dart';

class GardenModel {
  static String end_point = "gardens";
  static String tableName = "gardens_1";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String name = "";
  String crop_name = "";
  String status = "";
  String production_scale = "";
  String planting_date = "";
  String land_occupied = "";
  String crop_id = "";
  String crop_text = "";
  String details = "";
  String user_id = "";
  String user_text = "";
  String photo = "";
  String gps_lati = "";
  String gps_longi = "";
  String harvest_date = "";
  String is_harvested = "";
  String harvest_quality = "";
  String quantity_harvested = "";
  String quantity_planted = "";
  String harvest_notes = "";
  String district_id = "";
  String district_text = "";
  String subcounty_id = "";
  String subcounty_text = "";
  String parish_id = "";
  String parish_text = "";

  getPhoto() {
    if (photo.contains("images")) {
      return AppConfig.STORAGE_URL + photo.toString();
    }
    return AppConfig.STORAGE_URL + "images/" + photo.toString();
  }

  static fromJson(dynamic m) {
    GardenModel obj = new GardenModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.crop_name = Utils.to_str(m['crop_name'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.production_scale = Utils.to_str(m['production_scale'], '');
    obj.planting_date = Utils.to_str(m['planting_date'], '');
    obj.land_occupied = Utils.to_str(m['land_occupied'], '');
    obj.crop_id = Utils.to_str(m['crop_id'], '');
    obj.crop_text = Utils.to_str(m['crop_text'], '');
    obj.details = Utils.to_str(m['details'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.user_text = Utils.to_str(m['user_text'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.gps_lati = Utils.to_str(m['gps_lati'], '');
    obj.gps_longi = Utils.to_str(m['gps_longi'], '');
    obj.harvest_date = Utils.to_str(m['harvest_date'], '');
    obj.is_harvested = Utils.to_str(m['is_harvested'], '');
    obj.harvest_quality = Utils.to_str(m['harvest_quality'], '');
    obj.quantity_harvested = Utils.to_str(m['quantity_harvested'], '');
    obj.quantity_planted = Utils.to_str(m['quantity_planted'], '');
    obj.harvest_notes = Utils.to_str(m['harvest_notes'], '');
    obj.district_id = Utils.to_str(m['district_id'], '');
    obj.district_text = Utils.to_str(m['district_text'], '');
    obj.subcounty_id = Utils.to_str(m['subcounty_id'], '');
    obj.subcounty_text = Utils.to_str(m['subcounty_text'], '');
    obj.parish_id = Utils.to_str(m['parish_id'], '');
    obj.parish_text = Utils.to_str(m['parish_text'], '');

    return obj;
  }

  static Future<List<GardenModel>> getLocalData({String where = "1"}) async {
    List<GardenModel> data = [];
    if (!(await GardenModel.initTable())) {
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
      data.add(GardenModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<GardenModel>> get_items({String where = '1'}) async {
    List<GardenModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await GardenModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      GardenModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<GardenModel>> getOnlineItems() async {
    List<GardenModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get('${GardenModel.end_point}', {}));

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
        await GardenModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          GardenModel sub = GardenModel.fromJson(x);
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
      'name': name,
      'crop_name': crop_name,
      'status': status,
      'production_scale': production_scale,
      'planting_date': planting_date,
      'land_occupied': land_occupied,
      'crop_id': crop_id,
      'crop_text': crop_text,
      'details': details,
      'user_id': user_id,
      'user_text': user_text,
      'photo': photo,
      'gps_lati': gps_lati,
      'gps_longi': gps_longi,
      'harvest_date': harvest_date,
      'is_harvested': is_harvested,
      'harvest_quality': harvest_quality,
      'quantity_harvested': quantity_harvested,
      'quantity_planted': quantity_planted,
      'harvest_notes': harvest_notes,
      'district_id': district_id,
      'district_text': district_text,
      'subcounty_id': subcounty_id,
      'subcounty_text': subcounty_text,
      'parish_id': parish_id,
      'parish_text': parish_text,
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
        ",name TEXT"
        ",crop_name TEXT"
        ",status TEXT"
        ",production_scale TEXT"
        ",planting_date TEXT"
        ",land_occupied TEXT"
        ",crop_id TEXT"
        ",crop_text TEXT"
        ",details TEXT"
        ",user_id TEXT"
        ",user_text TEXT"
        ",photo TEXT"
        ",gps_lati TEXT"
        ",gps_longi TEXT"
        ",harvest_date TEXT"
        ",is_harvested TEXT"
        ",harvest_quality TEXT"
        ",quantity_harvested TEXT"
        ",quantity_planted TEXT"
        ",harvest_notes TEXT"
        ",district_id TEXT"
        ",district_text TEXT"
        ",subcounty_id TEXT"
        ",subcounty_text TEXT"
        ",parish_id TEXT"
        ",parish_text TEXT"
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
    if (!(await GardenModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(GardenModel.tableName);
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