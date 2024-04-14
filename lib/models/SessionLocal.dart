import 'dart:convert';

import 'package:marcci/models/RespondModel.dart';
import 'package:marcci/models/TemporaryModel.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/AppConfig.dart';
import '../utils/Utils.dart';

class SessionLocal {
  static String table_name = "SessionLocal";

  List<TemporaryModel> expectedMembers = [];
  List<int> presentMembers = [];
  List<int> absentMembers = [];

  getPresentMembers() {
    var temp = jsonDecode(present);

    if (temp.runtimeType.toString() != 'List<dynamic>') {
      return [];
    }

    presentMembers.clear();
    for (var x in temp) {
      presentMembers.add(Utils.int_parse(x));
    }
  }

  getAbsentMembers() {
    var temp = jsonDecode(absent);

    if (temp.runtimeType.toString() != 'List<dynamic>') {
      return [];
    }

    absentMembers.clear();
    for (var x in temp) {
      absentMembers.add(Utils.int_parse(x));
    }
  }

  getExpectedMembers() {
    var temp = jsonDecode(expected);
    if (temp.runtimeType.toString() != 'List<dynamic>') {
      return [];
    }
    expectedMembers.clear();

    for (var x in temp) {
      expectedMembers.add(TemporaryModel.fromJson(x));
    }

    expectedMembers.sort((a, b) => a.title.compareTo(b.title));
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
        SessionLocal.table_name,
        toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  submitSelf() async {
    if (closed != 'yes') {
      return;
    }

    Map<String, dynamic> params = {
      'id': id,
      'due_date': due_date,
      'type': type,
      'title': title,
      'present': present,
      'academic_class_id': academic_class_id,
      'subject_id': subject_id,
      'service_id': service_id,
    };
    RespondModel resp =
        RespondModel(await Utils.http_post('session-create', params));

    if (resp.code == 1) {
      await deleteSelf();
      print('success');
    } else {
      print("faoiled/");
    }
  }

  toJson() {
    return {
      'id': id,
      'due_date': due_date,
      'type': type,
      'closed': closed,
      'title': title,
      'present': present,
      'absent': absent,
      'expected': expected,
      'academic_class_id': academic_class_id,
      'subject_id': subject_id,
      'service_id': service_id,
    };
  }

  static Future<List<SessionLocal>> getItems({String where = '1'}) async {
    List<SessionLocal> data = [];
    if (!(await SessionLocal.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(SessionLocal.table_name, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(SessionLocal.fromJson(maps[i]));
    });

    return data;
  }

  int id = 0;
  String due_date = "";
  String type = "";
  String title = "";
  String present = "";
  String absent = "";
  String closed = "no";
  String expected = "";
  String academic_class_id = '';
  String subject_id = '';
  String service_id = '';

  static SessionLocal fromJson(dynamic data) {
    SessionLocal item = new SessionLocal();
    if (data == null) {
      return item;
    }

    item.id = Utils.int_parse(data['id']);
    item.due_date = Utils.to_str(data['due_date'], '');
    item.type = Utils.to_str(data['type'], '');
    item.title = Utils.to_str(data['title'], '');
    item.present = Utils.to_str(data['present'], '');
    item.absent = Utils.to_str(data['absent'], '');
    item.closed = Utils.to_str(data['closed'], '');
    item.expected = Utils.to_str(data['expected'], '');
    item.academic_class_id = Utils.to_str(data['academic_class_id'], '');
    item.subject_id = Utils.to_str(data['subject_id'], '');
    item.service_id = Utils.to_str(data['service_id'], '');

    return item;
  }

  static Future<bool> initTable() async {
    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "${SessionLocal.table_name} (id INTEGER PRIMARY KEY ,"
        "due_date TEXT,"
        "type TEXT,"
        "expected TEXT,"
        "title TEXT,"
        "absent TEXT,"
        "present TEXT,"
        "service_id TEXT,"
        "subject_id TEXT,"
        "closed TEXT,"
        "academic_class_id TEXT)";

    try {
      //await db.delete(SessionLocal.table_name);

      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  deleteSelf() async {
    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.delete(
        SessionLocal.table_name,
      );
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  static uploadPending() async {
    for (SessionLocal s in (await SessionLocal.getItems())) {
      if (s.closed == 'yes') {
        await s.submitSelf();
      } else {}
    }
  }
}
