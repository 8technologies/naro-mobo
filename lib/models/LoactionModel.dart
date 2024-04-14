// ignore: file_names
import 'dart:convert' show jsonDecode;
import 'package:marcci/utils/AppConfig.dart';

import '../utils/Utils.dart';

class LocarionModel {
  // ignore: non_constant_identifier_names
  static String end_point = "locations";
  int id = 0;
  int parent = 0;
  String name = "";

  // ignore: non_constant_identifier_names
  static Future<List<LocarionModel>> get_items(bool online) async {
    List<LocarionModel> items = [];
    List<LocarionModel> subs = [];

    jsonDecode(AppConfig.locations).map((e) {
      LocarionModel l = LocarionModel();
      l.name = Utils.to_str(e['name'], '');
      l.parent = Utils.int_parse(e['parent']);
      l.id = Utils.int_parse(e['id']);
      items.add(l);
    }).toList();

    for (var i in items) {
      if (i.parent > 0) {
        for (var j in items) {
          if (i.parent == j.id) {
            i.name = "${j.name}, ${i.name}"; 
            subs.add(i);
          }
        }
      }
    }

    return subs;
  }
}
