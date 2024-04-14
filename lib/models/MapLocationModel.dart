class MapLocationModel {
  String name = "";
  String address = "";
  double latitude = 1.003567;
  double longitude = 34.334366;
  bool isMyLocation = false;

  MapLocationModel();

  MapLocationModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
