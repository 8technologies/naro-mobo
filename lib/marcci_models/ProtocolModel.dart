
import 'ProductionCalendarItemModel.dart';


class ProtocolModel {
  int id = 0;
  String activity_name = "";
  String days_before_planting = "";
  String days_after_planting = "";
  String acceptable_timeline = "";
  String description = "";
  String value = "";
  String step = "";
  String is_activity_required = "";
  ProductionCalendarItemModel productionCalendarItem =
      new ProductionCalendarItemModel();

  Future<void> prepare_data(
      List<ProductionCalendarItemModel> tempItems) async {
    for (int i = 0; i < tempItems.length; i++) {
      if(tempItems[i].activity.toString() == this.id.toString()){
        print("FOUND ===> ${tempItems[i].activity} ===> ");
      }
    }
  }

  static ProtocolModel fromJsonToObject(dynamic tempMap) {
    ProtocolModel temp = new ProtocolModel();
    if (tempMap['id'] != null) {
      try {
        temp.id = int.parse(tempMap['id'].toString());
      } catch (_) {
        temp.id = 0;
      }

        print(tempMap);
        temp.is_activity_required = tempMap['is_activity_required'].toString();
        temp.value = tempMap['value'].toString();
        temp.step = tempMap['step'].toString();
        temp.description = tempMap['details'].toString();
        temp.acceptable_timeline = tempMap['acceptable_timeline'].toString();
        temp.days_after_planting = tempMap['days_after_planting'].toString();
        temp.days_before_planting = tempMap['days_before_planting'].toString();
        temp.activity_name = tempMap['name'].toString();
      }

    return temp;
  }

  static List<ProtocolModel> fromJsonToList(dynamic jsonBody) {
    print(jsonBody);
    if (jsonBody == null || jsonBody.isEmpty) {
      return [];
    }

    List<ProtocolModel> items = [];
    jsonBody.map((data) {
      ProtocolModel item = fromJsonToObject(data);
      items.add(item);
    }).toList();

    return items;
  }
}
