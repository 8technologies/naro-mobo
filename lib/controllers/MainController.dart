// ignore: file_names
// ignore: file_names
import 'package:get/get.dart';
import 'package:marcci/models/LoggedInUserModel.dart';
import 'package:marcci/models/MyClasses.dart';

import '../models/WeatherForeCastModel.dart';
import '../utils/Utils.dart';

class MainController extends GetxController {
  var count = 0.obs;

  // ignore: non_constant_identifier_names
  RxList<dynamic> my_classes = <MyClasses>[].obs;
  RxList<dynamic> weatherItems = <WeatherItem>[].obs;
  RxList<dynamic> weatherItem = <WeatherItem>[].obs;
  LoggedInUserModel loggedInUserModel = LoggedInUserModel();

  init() async {
    loggedInUserModel = await LoggedInUserModel.getLoggedInUser();
    await getWeather();
  }

  var raw;

  getWeather() async {
    print("getWeather");

    raw ??= await Utils.http_get(
        'https://api.open-meteo.com/v1/forecast?latitude=0.302247&longitude=32.609226&hourly=temperature_2m',
        {},
        addBase: false);
    if (!raw.runtimeType.toString().toLowerCase().contains('map')) {
      return;
    }

    DateTime now = DateTime.now();
    weatherItems.clear();
    weatherItem.clear();
    int j = 0;
    if (raw['hourly'] != null) {
      if (raw['hourly']['time'] != null) {
        if (raw['hourly']['time']
            .runtimeType
            .toString()
            .toLowerCase()
            .contains('list')) {
          for (var x in raw['hourly']['time']) {
            WeatherItem item = WeatherItem();
            if (raw['hourly'] != null) {
              if (raw['hourly']['temperature_2m'] != null) {
                if (raw['hourly']['temperature_2m'][j] != null) {
                  //_item.weather = raw['hourly']['temperature_2m'][j].toString();
                  j++;
                }
              }
            }
            DateTime time = DateTime.parse(x.toString());
            item.time = x.toString();

            if (time.weekday == now.weekday &&
                time.day == now.day &&
                time.hour == now.hour) {
              weatherItem.add(item);
            }
            if (time.isBefore(now)) {
              continue;
            }
            weatherItems.add(item);
          }
        }
      }
    }

    update();
  }

  increment() => count++;

  decrement() => count--;
}

