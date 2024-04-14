import 'dart:convert';

class FarmerGroup {
  int id = 0;
  String name = "";

  static List<FarmerGroup> fromJsonToList(String jsonBody) {
    if (jsonBody.isEmpty) {
      return [];
    }
    List<FarmerGroup> items = [];

    json.decode(jsonBody).map((data) {
      FarmerGroup item = new FarmerGroup();
      if (data['id'] != null) {
        try {
          item.id = int.parse(data['id'].toString());
        } catch (_) {
          item.id = 0;
        }
      }
      item.name = data['name'].toString();
      items.add(item);
    }).toList();

    return items;
  }
}
