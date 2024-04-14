import 'dart:convert';
import 'dart:core';

import 'package:dio/dio.dart';

class WeatherForeCastModel {
  String latitude = '';
  String longitude = '';
  String generationtime_ms = '';
  String timezone = '';
  List<WeatherItem> items = [];

  Future<WeatherForeCastModel> get_forecast() async {
    /*String url =
        'https://api.openweathermap.org/data/2.5/forecast/daily?lat=${this.latitude}&lon=${this.longitude}&appid=6e31fe628d75e869ff147ef200985f02';*/
    String url =
        'https://api.tomorrow.io/v4/weather/forecast?location=$latitude,$longitude&apikey=taI6t6lPLs5tZSZexaHJFbCPJycbNn79';

    Dio d = Dio();
    Response response = await d.get(url);

    var data = response.data;

    WeatherForeCastModel obj = WeatherForeCastModel.fromJson(data);
    return obj;
  }

  static WeatherForeCastModel fromJson(dynamic m) {
    WeatherForeCastModel obj = WeatherForeCastModel();
    if (m == null) {
      return obj;
    }

    if (m.runtimeType.toString().toLowerCase() == 'string') {
      m = json.decode(m);
    }

    if (!m.runtimeType.toString().toLowerCase().contains('map')) {
      return obj;
    }

    if (m['timelines'] != null) {
      var timelines = m['timelines'];
      if (timelines['daily']
          .runtimeType
          .toString()
          .toLowerCase()
          .contains('list')) {
        for (var x in timelines['daily']) {
          WeatherItem item = WeatherItem();
          var v = x['values'];
          /*_item.dt = x['dt'].toString();
          _item.sunrise = x['sunrise'].toString();
          _item.sunset = x['sunset'].toString();
          _item.temp.day = x['temp']['day'].toString();
          _item.temp.min = x['temp']['min'].toString();
          _item.temp.max = x['temp']['max'].toString();
          _item.temp.night = x['temp']['night'].toString();
          _item.temp.eve = x['temp']['eve'].toString();
          _item.temp.morn = x['temp']['morn'].toString();
          _item.weather.id = x['weather'][0]['id'].toString();
          _item.weather.main = x['weather'][0]['main'].toString();
          _item.weather.description = x['weather'][0]['description'].toString();
          _item.weather.icon = x['weather'][0]['icon'].toString();
          _item.speed = x['speed'].toString();
          _item.deg = x['deg'].toString();
          _item.clouds = x['clouds'].toString();
          _item.pop = x['pop'].toString();
          _item.gust = x['gust'].toString();
          _item.rain = x['rain'].toString();*/
          item.dt = x['time'];
          item.sunrise = v['sunriseTime'];
          item.sunset = v['sunsetTime'];
          item.temp.day = '';
          item.temp.min = v['temperatureMin'].toString();
          item.temp.max = v['temperatureMax'].toString();
          item.temp.ave = v['temperatureAvg'].toString();
          item.temp.night = '';
          item.temp.eve = '';
          item.temp.morn = '';
          item.weather.id = '';
          item.weather.main = v['weatherCodeMax'].toString();
          item.weather.description = v['weatherCodeMax'].toString();
          item.weather.icon = '';
          item.speed = v['windSpeedMax'].toString();
          item.deg = v['rainIntensityMax'].toString();
          item.clouds = v['cloudCoverMax'].toString();
          item.pop = '';
          item.gust = '';
          item.rain = v['rainIntensityMax'].toString();
          item.precipitation = v['precipitationProbabilityAvg'].toString();
          item.direction = v['windDirectionAvg'].toString();
          obj.items.add(item);
        }
      }
    } else {
      print("timelines is null");
    }

    return obj;
  }
}

class WeatherItem {
  String time = '';
  String humidity = '';

  String dt = '';
  String sunrise = '';
  String sunset = '';
  Temp temp = Temp();
  Weather weather = Weather();
  String speed = '';
  String deg = '';
  String clouds = '';
  String pop = '';
  String gust = '';
  String rain = '';
  String precipitation = '';
  String direction = '';
}

class Weather {
  String id = '';
  String main = '';
  String description = '';
  String icon = '';
}

class Temp {
  String day = '';
  String min = '';
  String max = '';
  String night = '';
  String eve = '';
  String morn = '';
  String ave = '';
}
