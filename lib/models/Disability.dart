import 'dart:convert';

import 'package:marcci/models/DynamicTable.dart';
import 'package:marcci/utils/Utils.dart';

class Disability {
  static String table_name = "api/Disability";

  int id = 0;
  String name = "";
  String photo = "";
  String description = "";

  static Future<List<Disability>> getItems() async {
    List<Disability> data = [];

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
        data.add(Disability.fromJson(d));
      }
    }

    return data;
  }

  static Disability fromJson(dynamic d) {
    Disability obj = Disability();
    if (d == null) {
      return obj;
    }
    obj.id = Utils.int_parse(d['id']);
    obj.name = Utils.to_str(d['name'], '');
    obj.photo = Utils.to_str(d['photo'], '');
    obj.description = Utils.to_str(d['description'], '');

    return obj;
  }
}
