import 'package:marcci/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/AppConfig.dart';
import 'RespondModel.dart';

class Transaction {
  static String endPoint = "transactions";
  static String tableName = "transactions";

  int id = 0;
  int amount_figure = 0;
  String created_at = "";
  String type = "";
  String payment_date = "";
  String account_id = "";
  String amount = "";
  String description = "";
  String account_name = "";
  String administrator_id = "";

  static Transaction fromJson(dynamic d) {
    Transaction obj = new Transaction();
    if (d == null) {
      return obj;
    }
    obj.id = Utils.int_parse(d['id']);
    obj.created_at = Utils.to_str(d['created_at'], '');
    obj.created_at = Utils.to_str(d['created_at'], '');
    obj.type = Utils.to_str(d['type'], '');
    obj.payment_date = Utils.to_str(d['payment_date'], '');
    obj.account_id = Utils.to_str(d['account_id'], '');
    obj.amount = Utils.to_str(d['amount'], '');
    obj.amount_figure = Utils.int_parse(obj.amount);
    obj.description = Utils.to_str(d['description'], '');
    obj.account_name = Utils.to_str(d['account_name'], '');
    obj.administrator_id = Utils.to_str(d['administrator_id'], '');

    return obj;
  }

  static Future<List<Transaction>> getItems({String where = '1'}) async {
    List<Transaction> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await Transaction.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData( where: where );
      Transaction.getOnlineItems();
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<Transaction>> getLocalData({String where = "1"}) async {
    List<Transaction> data = [];
    if (!(await Transaction.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return data;
    }

    print("===> where $where <==== ");

    List<Map> maps = await db.query(Transaction.tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(Transaction.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<Transaction>> getOnlineItems() async {
    List<Transaction> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get('${Transaction.endPoint}', {}));

    print(resp.message);
    if (resp.code != 1) {
      return [];
    }

    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return [];
    }

    if (resp.data.runtimeType.toString().contains('List')) {
      if (await Utils.is_connected()) {
        await Transaction.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          Transaction sub = Transaction.fromJson(x);
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

    return [];

    return data;
  }

  save() async {
    Database db = await openDatabase(AppConfig.DATABASE_PATH);
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
      'type': type,
      'payment_date': payment_date,
      'account_id': account_id,
      'description': description,
      'amount': amount,
      'account_name': account_name,
      'administrator_id': administrator_id,
    };
  }

  static Future<bool> initTable() async {
    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "$tableName ("
        "id INTEGER PRIMARY KEY,"
        "created_at TEXT,"
        "type TEXT,"
        "payment_date TEXT,"
        "account_id TEXT,"
        "amount TEXT,"
        "description TEXT,"
        "account_name TEXT,"
        "administrator_id TEXT"
        ")";

    try {
      //await db.delete(tableName);

      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  static deleteAll() async {
    if (!(await Transaction.initTable())) {
      return;
    }
    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }
}
