import 'package:marcci/utils/Utils.dart';

class TemporaryModel {
  int id = 0;
  String title = '';
  String subtitle = '';
  String image = '';
  String details = '';

  toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'details': details,
    };
  }

  static TemporaryModel fromJson(dynamic data) {
    TemporaryModel x = new TemporaryModel();
    x.id = Utils.int_parse(data['id']);
    x.title = Utils.to_str(data['title'], '');
    x.subtitle = Utils.to_str(data['subtitle'], '');
    x.image = Utils.to_str(data['image'], '');
    x.details = Utils.to_str(data['details'], '');
    return x;
  }
}
