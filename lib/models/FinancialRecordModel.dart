import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class FinancialRecordModel {
  static String end_point = "financial-records";
  static String tableName = "financial_records_2";
  String created_at = "";
  String updated_at = "";
  int id = 0;
  String garden_id = "";
  String garden_text = "";
  String user_id = "";
  String user_text = "";
  String category = "";
  String amount = "";
  String payment_method = "";
  String recipient = "";
  String description = "";
  String receipt = "";
  String date = "";
  String quantity = "";

  bool isIncome() {
    return category.toLowerCase().contains("income");
  }

  static fromJson(dynamic m) {
    FinancialRecordModel obj = new FinancialRecordModel();
    if (m == null) {
      return obj;
    }

    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.id = Utils.int_parse(m['id']);
    obj.garden_id = Utils.to_str(m['garden_id'], '');
    obj.garden_text = Utils.to_str(m['garden_text'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.user_text = Utils.to_str(m['user_text'], '');
    obj.category = Utils.to_str(m['category'], '');
    obj.amount = Utils.to_str(m['amount'], '');
    obj.payment_method = Utils.to_str(m['payment_method'], '');
    obj.recipient = Utils.to_str(m['recipient'], '');
    obj.description = Utils.to_str(m['description'], '');
    obj.receipt = Utils.to_str(m['receipt'], '');
    obj.date = Utils.to_str(m['date'], '');
    obj.quantity = Utils.to_str(m['quantity'], '');

    return obj;
  }

  static Future<List<FinancialRecordModel>> getLocalData(
      {String where = "1"}) async {
    List<FinancialRecordModel> data = [];
    if (!(await FinancialRecordModel.initTable())) {
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
      data.add(FinancialRecordModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<FinancialRecordModel>> get_items(
      {String where = '1'}) async {
    List<FinancialRecordModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await FinancialRecordModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      FinancialRecordModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<FinancialRecordModel>> getOnlineItems() async {
    List<FinancialRecordModel> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get('${FinancialRecordModel.end_point}', {}));

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
        await FinancialRecordModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          FinancialRecordModel sub = FinancialRecordModel.fromJson(x);
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
      'created_at': created_at,
      'updated_at': updated_at,
      'id': id,
      'garden_id': garden_id,
      'garden_text': garden_text,
      'user_id': user_id,
      'user_text': user_text,
      'category': category,
      'amount': amount,
      'payment_method': payment_method,
      'recipient': recipient,
      'description': description,
      'receipt': receipt,
      'date': date,
      'quantity': quantity,
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
        ",garden_id TEXT"
        ",garden_text TEXT"
        ",user_id TEXT"
        ",user_text TEXT"
        ",category TEXT"
        ",amount TEXT"
        ",payment_method TEXT"
        ",recipient TEXT"
        ",description TEXT"
        ",receipt TEXT"
        ",date TEXT"
        ",quantity TEXT"
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
    if (!(await FinancialRecordModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(FinancialRecordModel.tableName);
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
