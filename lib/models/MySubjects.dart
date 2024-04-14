import 'package:marcci/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/AppConfig.dart';
import 'RespondModel.dart';

class MySubjects {
  static String endPoint = "my-subjects";
  static String tableName = "mySubjects";

  int id = 0;
  String created_at = "";
  String enterprise_id = "";
  String academic_class_id = "";
  String subject_teacher = "";
  String code = "";
  String details = "";
  String course_id = "";
  String subject_name = "";
  String academic_year_id = "";
  String class_teahcer_id = "";
  String name = "";
  String short_name = "";
  String academic_class_level_id = "";
  String subject_teacher_name = "";

  static MySubjects fromJson(dynamic d) {
    MySubjects obj = new MySubjects();
    if (d == null) {
      return obj;
    }
    obj.id = Utils.int_parse(d['id']);
    obj.created_at = Utils.to_str(d['created_at'], '');
    obj.enterprise_id = Utils.to_str(d['enterprise_id'], '');
    obj.academic_year_id = Utils.to_str(d['academic_year_id'], '');
    obj.class_teahcer_id = Utils.to_str(d['class_teahcer_id'], '');
    obj.name = Utils.to_str(d['name'], '');
    obj.short_name = Utils.to_str(d['short_name'], '');
    obj.details = Utils.to_str(d['details'], '');
    obj.academic_class_id = Utils.to_str(d['academic_class_id'], '');
    obj.subject_teacher = Utils.to_str(d['subject_teacher'], '');
    obj.code = Utils.to_str(d['code'], '');
    obj.course_id = Utils.to_str(d['course_id'], '');
    obj.subject_name = Utils.to_str(d['subject_name'], '');
    obj.academic_year_id = Utils.to_str(d['academic_year_id'], '');
    obj.class_teahcer_id = Utils.to_str(d['class_teahcer_id'], '');
    obj.subject_teacher_name = Utils.to_str(d['subject_teacher_name'], '');
    obj.academic_class_level_id =
        Utils.to_str(d['academic_class_level_id'], '');

    return obj;
  }

  static Future<List<MySubjects>> getItems() async {
    List<MySubjects> data = await getLocalData();
    if (data.isEmpty) {
      await MySubjects.getOnlineItems();
      data = await getLocalData();
    } else {
      data = await getLocalData();
      MySubjects.getOnlineItems();
    }

    return data;
  }

  static Future<List<MySubjects>> getLocalData() async {
    List<MySubjects> data = [];
    if (!(await MySubjects.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(MySubjects.tableName);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(MySubjects.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<MySubjects>> getOnlineItems() async {
    List<MySubjects> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get('${MySubjects.endPoint}', {}));

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
        await MySubjects.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          MySubjects sub = new MySubjects();
          try {
            sub.id = Utils.int_parse(x['id']);
          } catch (xs) {
            sub.id = 0;
          }
          if (sub.id < 1) {
            continue;
          }

          sub.created_at = Utils.to_str(x['created_at'], '');
          sub.academic_class_id = Utils.to_str(x['academic_class_id'], '');
          sub.subject_teacher = Utils.to_str(x['subject_teacher'], '');
          sub.code = Utils.to_str(x['code'], '');
          sub.details = Utils.to_str(x['details'], '');
          sub.course_id = Utils.to_str(x['course_id'], '');
          sub.subject_name = Utils.to_str(x['subject_name'], '');
          sub.academic_year_id = Utils.to_str(x['academic_year_id'], '');
          sub.class_teahcer_id = Utils.to_str(x['class_teahcer_id'], '');
          sub.name = Utils.to_str(x['name'], '');
          sub.short_name = Utils.to_str(x['short_name'], '');
          sub.academic_class_level_id =
              Utils.to_str(x['academic_class_level_id'], '');
          sub.subject_teacher_name = Utils.to_str(x['subject_teacher_name'], '');

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
      'code': code,
      'class_teahcer_id': class_teahcer_id,
      'details': details,
      'academic_year_id': academic_year_id,
      'created_at': created_at,
      'course_id': course_id,
      'subject_teacher_name': subject_teacher_name,
      'academic_class_level_id': academic_class_level_id,
      'subject_name': subject_name,
      'short_name': short_name,
      'subject_teacher': subject_teacher,
      'academic_class_id': academic_class_id,
      'name': name,
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
        "code TEXT,"
        "class_teahcer_id TEXT,"
        "details TEXT,"
        "academic_year_id TEXT,"
        "course_id TEXT,"
        "created_at TEXT,"
        "subject_teacher_name TEXT,"
        "academic_class_level_id TEXT,"
        "short_name TEXT,"
        "name TEXT,"
        "subject_name TEXT,"
        "subject_teacher TEXT,"
        "academic_class_id TEXT)";

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
    if (!(await MySubjects.initTable())) {
      return;
    }
    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }
}
