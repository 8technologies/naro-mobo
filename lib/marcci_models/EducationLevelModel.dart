import 'dart:convert';

class EducationLevelModel {
  int id = 0;
  String name = "";

  static List<EducationLevelModel> fromJsonToList(String jsonBody) {
    if (jsonBody.isEmpty) {
      return [];
    }
    List<EducationLevelModel> items = [];

    json.decode(jsonBody).map((data) {
      EducationLevelModel item = new EducationLevelModel();
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
