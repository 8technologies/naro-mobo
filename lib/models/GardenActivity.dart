import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../theme/custom_theme.dart';
import '../utils/Utils.dart';
import 'RespondModel.dart';

class GardenActivity {
  static String end_point = "garden-activities";
  static String tableName = "garden_activities";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String garden_id = "";
  String garden_text = "";
  String user_id = "";
  String user_text = "";
  String crop_activity_id = "";
  String crop_activity_text = "";
  String activity_name = "";
  String activity_description = "";
  String activity_date_to_be_done = "";
  String activity_due_date = "";
  String activity_date_done = "";
  String farmer_has_submitted = "";
  String farmer_activity_status = "";
  String farmer_submission_date = "";
  String farmer_comment = "";
  String agent_id = "";
  String agent_text = "";
  String agent_names = "";
  String agent_has_submitted = "";
  String agent_activity_status = "";
  String agent_comment = "";
  String agent_submission_date = "";
  String photo = "";
  DateTime activity_date_to_be_done_date = DateTime.now();

  static fromJson(dynamic m) {
    GardenActivity obj = new GardenActivity();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.garden_id = Utils.to_str(m['garden_id'], '');
    obj.garden_text = Utils.to_str(m['garden_text'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.user_text = Utils.to_str(m['user_text'], '');
    obj.crop_activity_id = Utils.to_str(m['crop_activity_id'], '');
    obj.crop_activity_text = Utils.to_str(m['crop_activity_text'], '');
    obj.activity_name = Utils.to_str(m['activity_name'], '');
    obj.activity_description = Utils.to_str(m['activity_description'], '');
    obj.activity_date_to_be_done =
        Utils.to_str(m['activity_date_to_be_done'], '');
    obj.activity_due_date = Utils.to_str(m['activity_due_date'], '');
    obj.activity_date_done = Utils.to_str(m['activity_date_done'], '');
    obj.farmer_has_submitted = Utils.to_str(m['farmer_has_submitted'], '');
    obj.farmer_activity_status = Utils.to_str(m['farmer_activity_status'], '');
    obj.farmer_submission_date = Utils.to_str(m['farmer_submission_date'], '');
    obj.farmer_comment = Utils.to_str(m['farmer_comment'], '');
    obj.agent_id = Utils.to_str(m['agent_id'], '');
    obj.agent_text = Utils.to_str(m['agent_text'], '');
    obj.agent_names = Utils.to_str(m['agent_names'], '');
    obj.agent_has_submitted = Utils.to_str(m['agent_has_submitted'], '');
    obj.agent_activity_status = Utils.to_str(m['agent_activity_status'], '');
    obj.agent_comment = Utils.to_str(m['agent_comment'], '');
    obj.agent_submission_date = Utils.to_str(m['agent_submission_date'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.temp_due_date = Utils.toDate(obj.activity_due_date);
    obj.getStatus();

    if (obj.activity_date_to_be_done.isNotEmpty &&
        obj.activity_date_to_be_done != "null") {
      try {
        obj.activity_date_to_be_done_date =
            Utils.toDate(obj.activity_date_to_be_done);
      } catch (e) {}
    }

    return obj;
  }

  String temp_status = "";
  DateTime temp_due_date = DateTime.now();
  DateTime temp_now = DateTime.now();
  Color bgColor = CustomTheme.primary;

  getStatus() {
    temp_due_date = Utils.toDate(activity_due_date);
    if (farmer_has_submitted.toLowerCase() == "yes") {
      temp_status = "Submitted";
      bgColor = Colors.green.shade700;
    } else if (temp_due_date.isBefore(temp_now)) {
      temp_status = "Missing";
      bgColor = Colors.red.shade700;
    } else {
      bgColor = Colors.grey.shade700;
      temp_status = "Pending";
    }
  }

  static Future<List<GardenActivity>> getLocalData({String where = "1"}) async {
    List<GardenActivity> data = [];
    if (!(await GardenActivity.initTable())) {
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
      data.add(GardenActivity.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<GardenActivity>> get_items({String where = '1'}) async {
    List<GardenActivity> data = await getLocalData(where: where);
    if (data.isEmpty && where.length < 2) {
      await GardenActivity.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      GardenActivity.getOnlineItems();
    }
    return data;
  }

  static Future<List<GardenActivity>> getOnlineItems() async {
    List<GardenActivity> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get('${GardenActivity.end_point}', {}));

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
        await GardenActivity.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          GardenActivity sub = GardenActivity.fromJson(x);
          try {
            batch.insert(tableName, sub.toJson(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (e) {
            print("failed to save because ${e.toString()}");
          }
        }

        try {
          await batch.commit(continueOnError: true);
        } catch (e) {
          print("FAILED to save to commit BECAUSE ==> ${e.toString()}");
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
      'garden_id': garden_id,
      'garden_text': garden_text,
      'user_id': user_id,
      'user_text': user_text,
      'crop_activity_id': crop_activity_id,
      'crop_activity_text': crop_activity_text,
      'activity_name': activity_name,
      'activity_description': activity_description,
      'activity_date_to_be_done': activity_date_to_be_done,
      'activity_due_date': activity_due_date,
      'activity_date_done': activity_date_done,
      'farmer_has_submitted': farmer_has_submitted,
      'farmer_activity_status': farmer_activity_status,
      'farmer_submission_date': farmer_submission_date,
      'farmer_comment': farmer_comment,
      'agent_id': agent_id,
      'agent_text': agent_text,
      'agent_names': agent_names,
      'agent_has_submitted': agent_has_submitted,
      'agent_activity_status': agent_activity_status,
      'agent_comment': agent_comment,
      'agent_submission_date': agent_submission_date,
      'photo': photo,
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
        ",crop_activity_id TEXT"
        ",crop_activity_text TEXT"
        ",activity_name TEXT"
        ",activity_description TEXT"
        ",activity_date_to_be_done TEXT"
        ",activity_due_date TEXT"
        ",activity_date_done TEXT"
        ",farmer_has_submitted TEXT"
        ",farmer_activity_status TEXT"
        ",farmer_submission_date TEXT"
        ",farmer_comment TEXT"
        ",agent_id TEXT"
        ",agent_text TEXT"
        ",agent_names TEXT"
        ",agent_has_submitted TEXT"
        ",agent_activity_status TEXT"
        ",agent_comment TEXT"
        ",agent_submission_date TEXT"
        ",photo TEXT"
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
    if (!(await GardenActivity.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(GardenActivity.tableName);
  }

  delete() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.delete(tableName, where : 'id = $id');
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }
}