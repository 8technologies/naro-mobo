import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:marcci/theme/app_theme.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

@HiveType(typeId: 52)
class GardenActivityOld {
  static int file_id = 52;
  static String endPoint = "garden-activities";

  @HiveField(1)
  int id = 0;

  @HiveField(2)
  String created_at = "";

  @HiveField(3)
  String updated_at = "";

  @HiveField(4)
  String garden_id = "";

  @HiveField(5)
  String garden_text = "";

  @HiveField(6)
  String user_id = "";

  @HiveField(7)
  String user_text = "";

  @HiveField(8)
  String crop_activity_id = "";

  @HiveField(9)
  String crop_activity_text = "";

  @HiveField(10)
  String activity_name = "";

  @HiveField(11)
  String activity_description = "";

  @HiveField(12)
  String activity_date_to_be_done = "";

  @HiveField(13)
  String activity_due_date = "";

  @HiveField(14)
  String activity_date_done = "";

  @HiveField(15)
  String farmer_has_submitted = "";

  @HiveField(16)
  String farmer_activity_status = "";

  @HiveField(17)
  String farmer_submission_date = "";

  @HiveField(18)
  String farmer_comment = "";

  @HiveField(19)
  String agent_id = "";

  @HiveField(20)
  String agent_text = "";

  @HiveField(21)
  String agent_names = "";

  @HiveField(22)
  String agent_has_submitted = "";

  @HiveField(23)
  String agent_activity_status = "";

  @HiveField(24)
  String agent_comment = "";

  @HiveField(25)
  String agent_submission_date = "";

  @HiveField(26)
  String photo = "";


  static fromJson(dynamic m) {
    GardenActivityOld obj = new GardenActivityOld();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.garden_id = Utils.to_str(m['garden_id'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.crop_activity_id = Utils.to_str(m['crop_activity_id'], '');
    obj.activity_name = Utils.to_str(m['activity_name'], '');
    obj.activity_description = Utils.to_str(m['activity_description'], '');
    obj.activity_date_to_be_done =
        Utils.to_str(m['activity_date_to_be_done'], '');
    obj.activity_due_date = Utils.to_str(m['activity_due_date'], '');
    obj.activity_date_done = Utils.to_str(m['activity_date_done'], '');
    obj.farmer_has_submitted = Utils.to_str(m['farmer_has_submitted'], '');
    obj.farmer_activity_status = Utils.to_str(m['farmer_activity_status'], '');
    obj.farmer_submission_date = Utils.to_str(m['farmer_submission_date'], '');
    obj.farmer_comment = Utils.to_str(m['farmer_comment'], '');
    obj.agent_id = Utils.to_str(m['agent_id'], '');
    obj.agent_names = Utils.to_str(m['agent_names'], '');
    obj.agent_has_submitted = Utils.to_str(m['agent_has_submitted'], '');
    obj.agent_activity_status = Utils.to_str(m['agent_activity_status'], '');
    obj.agent_comment = Utils.to_str(m['agent_comment'], '');
    obj.agent_submission_date = Utils.to_str(m['agent_submission_date'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.garden_text = Utils.to_str(m['garden_text'], '');
    obj.user_text = Utils.to_str(m['user_text'], '');
    obj.temp_due_date = Utils.toDate(obj.activity_due_date);
    obj.getStatus();
    obj.getStatus();

    return obj;
  }

  getStatus() {
    if (farmer_has_submitted.toLowerCase() == "yes") {
      temp_status = "Submitted";
      bgColor = Colors.green.shade700;
    } else if (temp_due_date.isBefore(temp_now)) {
      temp_status = "Missing";
      bgColor = Colors.red.shade700;
    } else {
      bgColor = Colors.grey.shade700;
      temp_status = "Pending";
    }
  }

  Color bgColor = CustomTheme.primary;
  String temp_status = "";
  DateTime temp_due_date = DateTime.now();
  DateTime temp_now = DateTime.now();

  static Future<List<GardenActivityOld>> getLocalData({String where = "1"}) async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(file_id)) {
    }

    var box = await Hive.openBox<GardenActivityOld>('GardenActivityOld');

    return box.values.toList().cast<GardenActivityOld>();
  }


  static Future<List<GardenActivityOld>> getItems({String where = '1'}) async {
    List<GardenActivityOld> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await GardenActivityOld.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData(where: where);
      GardenActivityOld.getOnlineItems();
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<GardenActivityOld>> getOnlineItems() async {
    List<GardenActivityOld> data = [];

    RespondModel resp =
    RespondModel(await Utils.http_get(GardenActivityOld.endPoint, {}));


    if (resp.code != 1) {
      return [];
    }
    List<GardenActivityOld> items = [];
    print(resp.data);
    for (var x in resp.data) {
      GardenActivityOld m = GardenActivityOld.fromJson(x);
      await m.save();
      print(x);
      continue;


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
      box = await Hive.openBox<GardenActivityOld>('GardenActivityOld');
    }
    await box.put(id, this);
  }

  toJson() {
    return {
      'id': id,
      'created_at': created_at,
      'updated_at': updated_at,
      'garden_id': garden_id,
      'user_id': user_id,
      'crop_activity_id': crop_activity_id,
      'activity_name': activity_name,
      'activity_description': activity_description,
      'activity_date_to_be_done': activity_date_to_be_done,
      'activity_due_date': activity_due_date,
      'activity_date_done': activity_date_done,
      'farmer_has_submitted': farmer_has_submitted,
      'farmer_activity_status': farmer_activity_status,
      'farmer_submission_date': farmer_submission_date,
      'farmer_comment': farmer_comment,
      'agent_id': agent_id,
      'agent_names': agent_names,
      'agent_has_submitted': agent_has_submitted,
      'agent_activity_status': agent_activity_status,
      'agent_comment': agent_comment,
      'agent_submission_date': agent_submission_date,
      'garden_text': garden_text,
      'photo': photo,
    };
  }



}