import 'dart:convert';

import 'package:marcci/models/DynamicTable.dart';
import 'package:marcci/utils/Utils.dart';

class GroupModel {
  static String table_name = "groups";

  int id = 0;
  String name = "";
  String group_name = "";

  static Future<List<GroupModel>> getItems() async {
    List<GroupModel> data = [];

    List<DynamicTable> dynamicData =
        await DynamicTable.getItems(table_name, params: {'is_not_private': 1});

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
        data.add(GroupModel.fromJson(d));
      }
    }

    return data;
  }

  static GroupModel fromJson(dynamic d) {
    GroupModel obj = GroupModel();
    if (d == null) {
      return obj;
    }
    obj.id = Utils.int_parse(d['id']);
    obj.name = Utils.to_str(d['name'], '');
    obj.group_name = Utils.to_str(d['group_name'], '');

    return obj;
  }
}
