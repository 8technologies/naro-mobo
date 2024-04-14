import 'package:hive_flutter/adapters.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

@HiveType(typeId: 11)
class GardenModelOld {
  static int file_id = 11;
  static String endPoint = "gardens";

  @HiveField(1)
  int id = 0;

  @HiveField(2)
  String created_at = "";

  @HiveField(3)
  String updated_at = "";

  @HiveField(4)
  String name = "";

  @HiveField(5)
  String crop_name = "";

  @HiveField(6)
  String status = "";

  @HiveField(7)
  String production_scale = "";

  @HiveField(8)
  String planting_date = "";

  @HiveField(9)
  String land_occupied = "";

  @HiveField(10)
  String crop_id = "";

  @HiveField(11)
  String crop_text = "";

  @HiveField(12)
  String details = "";

  @HiveField(13)
  String user_id = "";

  @HiveField(14)
  String user_text = "";

  @HiveField(15)
  String photo = "";

  static fromJson(dynamic m) {
    GardenModelOld obj = new GardenModelOld();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.crop_name = Utils.to_str(m['crop_name'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.production_scale = Utils.to_str(m['production_scale'], '');
    obj.planting_date = Utils.to_str(m['planting_date'], '');
    obj.land_occupied = Utils.to_str(m['land_occupied'], '');
    obj.crop_id = Utils.to_str(m['crop_id'], '');
    obj.details = Utils.to_str(m['details'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.photo = Utils.to_str(m['photo'], '');

    if (!obj.photo.contains("images")) {
      obj.photo = "images/" + obj.photo;
    }
    return obj;
  }

  static Future<List<GardenModelOld>> getLocalData({String where = "1"}) async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(file_id)) {

    }

    var box = await Hive.openBox<GardenModelOld>('GardenModelOld');

    return box.values.toList().cast<GardenModelOld>();
  }

  static Future<List<GardenModelOld>> getItems({String where = '1'}) async {
    List<GardenModelOld> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await GardenModelOld.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData(where: where);
      GardenModelOld.getOnlineItems();
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<GardenModelOld>> getOnlineItems() async {
    List<GardenModelOld> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(GardenModelOld.endPoint, {}));

    if (resp.code != 1) {
      return [];
    }

    List<GardenModelOld> items = [];
    for (var x in resp.data) {
      GardenModelOld m = GardenModelOld.fromJson(x);
      await m.save();
      items.add(m);
    }
    return items;
  }
  var box;
  save() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(file_id)) {

    }
    if(box == null){
      box = await Hive.openBox<GardenModelOld>('GardenModelOld');
    }

    await box.put(id, this);
  }

  toJson() {
    return {
      'id': id,
      'created_at': created_at,
      'updated_at': updated_at,
      'name': name,
      'crop_name': crop_name,
      'status': status,
      'production_scale': production_scale,
      'planting_date': planting_date,
      'land_occupied': land_occupied,
      'crop_id': crop_id,
      'details': details,
      'user_id': user_id,
      'photo': photo,
    };
  }
}
