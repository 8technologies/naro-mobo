import 'package:sqflite/sqflite.dart';

import '../utils/AppConfig.dart';
import '../utils/Utils.dart';
import 'RespondModel.dart';

class ServiceProvider {
  static String end_point = "service-providers";
  static String tableName = "service_providers";
  int id = 0;
  String created_at = "";

  String updated_at = "";
  String provider_name = "";
  String business_name = "";
  String details = "";
  String services_offered = "";
  String gps_lat = "";
  String gps_long = "";
  String photo = "";
  String phone_number = "";
  String phone_number_2 = "";
  String email = "";

  String getPhoto() {
    return AppConfig.STORAGE_URL + photo;
  }

  static fromJson(dynamic m) {
    ServiceProvider obj = new ServiceProvider();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.provider_name = Utils.to_str(m['provider_name'], '');
    obj.business_name = Utils.to_str(m['business_name'], '');
    obj.details = Utils.to_str(m['details'], '');
    obj.services_offered = Utils.to_str(m['services_offered'], '');
    obj.gps_lat = Utils.to_str(m['gps_lat'], '');
    obj.gps_long = Utils.to_str(m['gps_long'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.phone_number = Utils.to_str(m['phone_number'], '');
    obj.phone_number_2 = Utils.to_str(m['phone_number_2'], '');
    obj.email = Utils.to_str(m['email'], '');

    return obj;
  }

  static Future<List<ServiceProvider>> getLocalData(
      {String where = "1"}) async {
    List<ServiceProvider> data = [];
    if (!(await ServiceProvider.initTable())) {
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
      data.add(ServiceProvider.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<ServiceProvider>> get_items({String where = '1'}) async {
    List<ServiceProvider> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await ServiceProvider.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      ServiceProvider.getOnlineItems();
    }
    return data;
  }

  static Future<List<ServiceProvider>> getOnlineItems() async {
    List<ServiceProvider> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get('${ServiceProvider.end_point}', {}));

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
        await ServiceProvider.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          ServiceProvider sub = ServiceProvider.fromJson(x);
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
      'provider_name': provider_name,
      'business_name': business_name,
      'details': details,
      'services_offered': services_offered,
      'gps_lat': gps_lat,
      'gps_long': gps_long,
      'photo': photo,
      'phone_number': phone_number,
      'phone_number_2': phone_number_2,
      'email': email,
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
        ",provider_name TEXT"
        ",business_name TEXT"
        ",details TEXT"
        ",services_offered TEXT"
        ",gps_lat TEXT"
        ",gps_long TEXT"
        ",photo TEXT"
        ",phone_number TEXT"
        ",phone_number_2 TEXT"
        ",email TEXT"
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
    if (!(await ServiceProvider.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(ServiceProvider.tableName);
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
