import 'dart:convert';

import 'package:marcci/models/DynamicTable.dart';
import 'package:marcci/utils/Utils.dart';

import 'UserModel.dart';

class MyClasses {
  static String table_name = "my-classes";

  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String academic_year_id = "";
  String class_teahcer_id = "";
  String class_teacher_name = "";
  String students_count = "";
  String name = "";
  String short_name = "";
  String details = "";
  String compulsory_subjects = "";
  String optional_subjects = "";
  String class_type = "";
  String academic_class_level_id = "";

  static Future<List<MyClasses>> getItems() async {
    List<MyClasses> data = [];

    List<DynamicTable> dynamicData = await DynamicTable.getItems(table_name);

    for (DynamicTable element in dynamicData) {
      dynamic mapList;
      try {
        mapList = jsonDecode(element.data);
      } catch (e) {
        mapList = null;
      }
      if (mapList == null) {
        return [];
      }

      for (var d in mapList) {
        data.add(MyClasses.fromJson(d));
      }
    }

    return data;
  }

  List<UserModel> students = [];
  Future<List<UserModel>> getStudents() async {
    students = await UserModel.getItems(where: " current_class_id = '$id' ");
    return students;
  }
  static MyClasses fromJson(dynamic d) {
    MyClasses obj = new MyClasses();
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
    obj.compulsory_subjects = Utils.to_str(d['compulsory_subjects'], '');
    obj.optional_subjects = Utils.to_str(d['optional_subjects'], '');
    obj.class_type = Utils.to_str(d['class_type'], '');
    obj.students_count = Utils.to_str(d['students_count'], '');
    obj.class_teacher_name = Utils.to_str(d['class_teacher_name'], '');
    obj.academic_class_level_id =
        Utils.to_str(d['academic_class_level_id'], '');

    return obj;
  }
}
