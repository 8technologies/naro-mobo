import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class ProductModel {
  static String end_point = "products";
  static String tableName = "products";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String administrator_id = "";
  String administrator_text = "";
  String name = "";
  String type = "";
  String photo = "";
  String details = "";
  String price = "";
  String offer_type = "";
  String state = "";
  String category = "";
  String subcounty_id = "";
  String subcounty_text = "";
  String district_id = "";
  String district_text = "";

  static fromJson(dynamic m) {
    ProductModel obj = new ProductModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.administrator_id = Utils.to_str(m['administrator_id'], '');
    obj.administrator_text = Utils.to_str(m['administrator_text'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.type = Utils.to_str(m['type'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.details = Utils.to_str(m['details'], '');
    obj.price = Utils.to_str(m['price'], '');
    obj.offer_type = Utils.to_str(m['offer_type'], '');
    obj.state = Utils.to_str(m['state'], '');
    obj.category = Utils.to_str(m['category'], '');
    obj.subcounty_id = Utils.to_str(m['subcounty_id'], '');
    obj.subcounty_text = Utils.to_str(m['subcounty_text'], '');
    obj.district_id = Utils.to_str(m['district_id'], '');
    obj.district_text = Utils.to_str(m['district_text'], '');

    if (!obj.photo.contains("images")) {
      obj.photo = "images/" + obj.photo;
    }

    return obj;
  }

  static Future<List<ProductModel>> getLocalData({String where = "1"}) async {
    List<ProductModel> data = [];
    if (!(await ProductModel.initTable())) {
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
      data.add(ProductModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<ProductModel>> get_items({String where = '1'}) async {
    List<ProductModel> data = await getLocalData(where: where);
    if (data.isEmpty && where.length < 2) {
      await ProductModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      ProductModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<ProductModel>> getOnlineItems() async {
    List<ProductModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get('${ProductModel.end_point}', {}));

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
        await ProductModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          ProductModel sub = ProductModel.fromJson(x);
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
          print("faied to save to commit BRECASE ==> ${e.toString()}");
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
      'administrator_id': administrator_id,
      'administrator_text': administrator_text,
      'name': name,
      'type': type,
      'photo': photo,
      'details': details,
      'price': price,
      'offer_type': offer_type,
      'state': state,
      'category': category,
      'subcounty_id': subcounty_id,
      'subcounty_text': subcounty_text,
      'district_id': district_id,
      'district_text': district_text,
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
        ",administrator_id TEXT"
        ",administrator_text TEXT"
        ",name TEXT"
        ",type TEXT"
        ",photo TEXT"
        ",details TEXT"
        ",price TEXT"
        ",offer_type TEXT"
        ",state TEXT"
        ",category TEXT"
        ",subcounty_id TEXT"
        ",subcounty_text TEXT"
        ",district_id TEXT"
        ",district_text TEXT"
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
    if (!(await ProductModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(ProductModel.tableName);
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
