import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dioPackage;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutx/flutx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marcci/models/ParishModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/CropModel.dart';
import '../models/GardenModel.dart';
import '../models/LoggedInUserModel.dart';
import '../theme/app_theme.dart';
import 'AppConfig.dart';

class Utils {
  static String to_date_4(String updatedAt) {
    String dateText = "__/__/___";
    if (updatedAt.toString().length < 5) {
      return "__/__/____";
    }
    try {
      DateTime date = DateTime.parse(updatedAt).toLocal();

      // dateText = DateFormat("jm").format(date);
      dateText = DateFormat("EEEE - dd MMM, y").format(date);
    } catch (e) {
      print("failed to convert date");
      print(e);
    }
    return dateText;
  }

/*
  static Future<MapLocationModel> searchWord(String keyword) async {
    MapLocationModel obj = MapLocationModel();
    if (keyword.isEmpty) {
      return obj;
    }

    var dio = Dio();
    var resp = await dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$keyword,Uganda&key=${AppConfig.GOOGLE_MAP_API}');
    for (var x in resp.data['results']) {
      obj.name = x['formatted_address'];
      obj.latitude = x['geometry']['location']['lat'];
      obj.longitude = x['geometry']['location']['lng'];
      break;
    }
    return obj;
  }
*/

  static String time_from_datetime(String updatedAt) {
    String dateText = "__/__/___";
    if (updatedAt.toString().length < 5) {
      return "__/__/____";
    }
    try {
      DateTime date = DateTime.parse(updatedAt).toLocal();

      // dateText = DateFormat("jm").format(date);
      dateText = DateFormat("jm").format(date);
    } catch (e) {
      print("failed to convert date");
      print(e);
    }
    return dateText;
  }

  static Future<void> systemBoot() async {
    await GardenModel.get_items();
    await CropModel.get_items();
    await ParishModel.get_items();
  }

  static Future<Database> getDb() async {
    return await openDatabase(AppConfig.DATABASE_PATH,
        version: Utils.int_parse(AppConfig.APP_VERSION));
  }

  static String prepare_phone_number(String phoneNumber) {
    if (phoneNumber.length > 12) {
      phoneNumber = phoneNumber.replaceFirst('+', "");
      phoneNumber = phoneNumber.replaceFirst('256', "");
    } else {
      phoneNumber = phoneNumber.replaceFirst('0', "");
    }
    if (phoneNumber.length != 9) {
      return "";
    }
    phoneNumber = "+256" + phoneNumber;
    return phoneNumber;
  }

  static bool phone_number_is_valid(String phoneNumber) {
    phoneNumber = Utils.prepare_phone_number(phoneNumber);
    if (phoneNumber.length != 13) {
      return false;
    }

    if (phoneNumber.substring(0, 4) != "+256") {
      return false;
    }

    return true;
  }

  static bool contains(List<dynamic> items, dynamic item) {
    bool yes = false;
    for (var e in items) {
      if (e.id == item.id) {
        yes = true;
        break;
      }
    }
    return yes;
  }

  static Future<void> set_local(String key, String data) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key, data);
    return;
  }

  static Future<dynamic> http_post(
      String path, Map<String, dynamic> body) async {
    bool isOnline = await Utils.is_connected();

    if (!isOnline) {
      return {
        'code': 0,
        'message': 'You are not connected to internet.',
        'data': null
      };
    }

    dynamic response;
    var dio = Dio();
    LoggedInUserModel userModel = await LoggedInUserModel.getLoggedInUser();
    String token = userModel.remember_token;
    body['user_id'] = userModel.id;
    var da = dioPackage.FormData.fromMap(body); //.fromMap();
    try {
      response = await dio.post(
          (!path.contains('http')) ? AppConfig.API_BASE_URL + "/$path" : path,
          data: da,
          options: Options(
            headers: <String, String>{
              "Authorization": 'Bearer $token',
              "Content-Type": "application/json",
              "Accept": "application/json",
              "User-Id": "${userModel.id}",
            },
          ));
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
      if (e.response?.data != null) {
        if (e.response?.data.runtimeType.toString() ==
            '_Map<String, dynamic>') {
          return e.response?.data;
        }
      }
      Map<String, dynamic> map = {
        'status': 0,
        'message': "Failed because ${e.message.toString()}"
      };
      return jsonEncode(map);
    }
  }

  static Future<bool> is_logged_in() async {
    LoggedInUserModel u = await LoggedInUserModel.getLoggedInUser();
    if (u.id < 1) {
      return false;
    } else {
      //// await LoggedInUserModel.update_local_user();
      return true;
    }
  }

  static String get_file_url(String name) {
    String url = AppConfig.MAIN_SITE_URL + "/storage/uploads";
    if ((name.length < 2)) {
      url += '/default.png';
    } else {
      url += '/$name';
    }
    return url;
  }

  static Future<dynamic> http_get(String path, Map<String, dynamic> body,
      {bool addBase = true}) async {
    LoggedInUserModel u = await LoggedInUserModel.getLoggedInUser();
    body['user_id'] = u.id;
    bool isOnline = await Utils.is_connected();
    if (!isOnline) {
      return {
        'code': 0,
        'message': 'You are not connected to internet.',
        'data': null
      };
    }

    var response;
    var dio = Dio();

    try {
      response =
          await dio.get(addBase ? AppConfig.API_BASE_URL + "/$path" : path,
              queryParameters: body,
              options: Options(
                headers: {
                  "authorization": "Bearer <your token>",
                  "User-Id": '${u.id}',
                  'Content-Type': 'application/json; charset=UTF-8',
                  'accept': 'application/json',
                },
              ));

      return response.data;
    } on DioError catch (e) {
      if (e.response?.data != null) {
        if (e.response?.data.runtimeType.toString() ==
            '_Map<String, dynamic>') {
          return e.response?.data;
        }
      }
      return {
        'status': 0,
        'code': 0,
        'message': e.response?.data,
        'data': null,
      };
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await deleteDatabase(AppConfig.DATABASE_PATH);
    return;
  }

  static void launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  static Future<void> boot_system() async {}

  static SystemUiOverlayStyle init_theme() {
    AppTheme.resetFont();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: CustomTheme.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: CustomTheme.primary,
        statusBarBrightness: Brightness.light,
      ),
    );

    SystemUiOverlayStyle.light;

    return SystemUiOverlayStyle(
      statusBarColor: CustomTheme.primary,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: CustomTheme.primary,
      statusBarBrightness: Brightness.light,
      systemNavigationBarDividerColor: CustomTheme.primary,
    );
  }

  static Future<dynamic> init_databse() async {}

  static void init_dark_theme() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: CustomTheme.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: CustomTheme.primary));
  }

  static void launchPhone(String phoneNumber) async {
    if (!await launch('tel:$phoneNumber'))
      throw 'Could not launch $phoneNumber';
  }

  static String yes_no_parse(dynamic x) {
    if (x == null) {
      return 'No';
    }
    if (Utils.int_parse(x) == 1) {
      return 'Yes';
    } else {
      return 'No';
    }
  }

  static String to_str(dynamic x, String y) {
    if (x == null) {
      return y;
    }
    if (x.toString().toString() == 'null') {
      return y;
    }
    if (x.toString().isEmpty) {
      return y.toString();
    }
    return x.toString();
  }

  static int int_parse(dynamic x) {
    if (x == null) {
      return 0;
    }
    int temp = 0;
    try {
      temp = int.parse(x.toString());
    } catch (e) {
      temp = 0;
    }

    return temp;
  }

  static bool bool_parse(dynamic x) {
    int temp = 0;
    bool ans = false;
    try {
      temp = int.parse(x.toString());
    } catch (e) {
      temp = 0;
    }

    if (temp == 1) {
      ans = true;
    } else {
      ans = false;
    }
    return ans;
  }

  static double screen_width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screen_height(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static Future<bool> is_connected() async {
    return true;
    bool isConnected = false;
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      isConnected = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      isConnected = true;
    }

    return isConnected;
  }

  static log(String message) {
    debugPrint(message, wrapWidth: 1200);
  }

  static String getGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return "Good morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good evening";
    } else {
      return "Good night";
    }
  }

  static toast(String message,
      {Color color = Colors.green, bool isLong = false}) {
    if (Colors.green == color) {
      color = CustomTheme.primary;
    }

    Utils.toast2(message, is_long: isLong, background_color: color);
    return;

    Get.snackbar('Alert', message,
        dismissDirection: DismissDirection.down,
        colorText: Colors.white,
        backgroundColor: color,
        margin: EdgeInsets.zero,
        duration:
            isLong ? const Duration(seconds: 3) : const Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.GROUNDED);
  }

  static void toast2(String message,
      {Color background_color = CustomTheme.primary,
      color = Colors.white,
      bool is_long = false}) {
    if (Colors.green == color) {
      color = CustomTheme.primary;
    }

    Fluttertoast.showToast(
        msg: message,
        toastLength: is_long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: background_color,
        textColor: color,
        fontSize: 16.0);
  }

  static void go_to_home(context) {
    Navigator.pushNamedAndRemoveUntil(context, "/HomeScreen", (r) => false);
  }

  static Future<void> showConfirmDialog(
    BuildContext context,
    Function onPositiveClick,
    Function onNegativeClick, {
    String message = "Please confirm this action",
    String positive_text = "Confirm",
    String negative_text = "Cancel",
  }) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        int selectedRadio = 0;
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: FxSpacing.all(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FxText.bodySmall(
                      "$message\n",
                      fontWeight: 500,
                    ),
                    Container(
                        alignment: AlignmentDirectional.center,
                        child: Column(
                          children: [
                            FxButton.block(
                                onPressed: () {
                                  onPositiveClick();
                                  Navigator.pop(context);
                                },
                                borderRadiusAll: 4,
                                elevation: 0,
                                child: FxText.bodySmall(positive_text,
                                    letterSpacing: 0.3, color: Colors.white)),
                            SizedBox(
                              height: 10,
                            ),
                            FxButton.outlined(
                                onPressed: () {
                                  onNegativeClick();
                                  Navigator.pop(context);
                                },
                                borderRadiusAll: 4,
                                elevation: 0,
                                child: FxText.bodySmall(negative_text,
                                    letterSpacing: 0.3, color: Colors.red)),
                          ],
                        )),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  static SystemUiOverlayStyle overlay() {
    return SystemUiOverlayStyle(
      statusBarColor: CustomTheme.primary,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light, // For iOS (dark icons)
    );
  }

  static Future<Position> get_device_location() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void upload_image(String path) async {}

  static double mediaWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static bool isDesktop(BuildContext context) {
    return false;
    if (MediaQuery.of(context).size.width > 700) {
      return true;
    }
    return false;
  }

  static double mediaHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double sizeByWidth(BuildContext context, double w) {
    return MediaQuery.of(context).size.width / w;
  }

  static double fs1(BuildContext context) {
    return Utils.sizeByWidth(context, 5);
  }

  static double fs2(BuildContext context) {
    return Utils.sizeByWidth(context, 6);
  }

  static double fs3(BuildContext context) {
    return Utils.sizeByWidth(context, 6.5);
  }

  static double fs4(BuildContext context) {
    return Utils.sizeByWidth(context, 7);
  }

  static double fs5(BuildContext context) {
    return Utils.sizeByWidth(context, 7.5);
  }

  static double fs6(BuildContext context) {
    return Utils.sizeByWidth(context, 8);
  }

  static double fs7(BuildContext context) {
    return Utils.sizeByWidth(context, 8.5);
  }

  static double fs8(BuildContext context) {
    return Utils.sizeByWidth(context, 9);
  }

  static double fs9(BuildContext context) {
    return Utils.sizeByWidth(context, 9.5);
  }

  static double fs10(BuildContext context) {
    return Utils.sizeByWidth(context, 10);
  }

  static double fs11(BuildContext context) {
    return Utils.sizeByWidth(context, 10.6);
  }

  static double fs12(BuildContext context) {
    return Utils.sizeByWidth(context, 11);
  }

  static double fs13(BuildContext context) {
    return Utils.sizeByWidth(context, 11.5);
  }

  static double fs14(BuildContext context) {
    return Utils.sizeByWidth(context, 12);
  }

  static double fs15(BuildContext context) {
    return Utils.sizeByWidth(context, 15);
  }

  static double fs16(BuildContext context) {
    return Utils.sizeByWidth(context, 16);
  }

  static double fs17(BuildContext context) {
    return Utils.sizeByWidth(context, 17);
  }

  static double fs18(BuildContext context) {
    return Utils.sizeByWidth(context, 18);
  }

  static double fs19(BuildContext context) {
    return Utils.sizeByWidth(context, 19);
  }

  static double fs20(BuildContext context) {
    return Utils.sizeByWidth(context, 20);
  }

  static String to_date(dynamic updatedAt) {
    String dateText = "--:--";
    if (updatedAt == null) {
      return "--:--";
    }
    if (updatedAt.toString().length < 5) {
      return "--:--";
    }

    try {
      DateTime date = DateTime.parse(updatedAt.toString());

      dateText = DateFormat("d MMM, y - ").format(date);
      dateText += DateFormat("jm").format(date);
    } catch (e) {}

    return dateText;
  }

  static String getImageUrl(dynamic img) {
    String _img = "logo.png";
    if (img != null) {
      img = img.toString();
      if (img.toString().isNotEmpty) {
        _img = img;
      }
    }
    _img.replaceAll('/images', '');
    return "${AppConfig.MAIN_SITE_URL}/storage/images/$_img";
  }

  static String to_date_1(dynamic updatedAt) {
    String dateText = "__/__/___";
    if (updatedAt == null) {
      return "__/__/____";
    }
    if (updatedAt.toString().length < 5) {
      return "__/__/____";
    }

    try {
      DateTime date = DateTime.parse(updatedAt.toString());

      dateText = DateFormat("d MMM, y").format(date);
    } catch (e) {}

    return dateText;
  }

  static String replaceAfterDot(String originalString, String replacement) {
    List<String> parts = originalString.split('.');

    if (parts.length > 1) {
      parts[1] = replacement;
      return parts.join('.');
    } else {
      return originalString;
    }
  }

  static String to_date_2(dynamic updatedAt) {
    String dateText = "__/__/___";
    if (updatedAt == null) {
      return "__/__/____";
    }
    if (updatedAt.toString().length < 5) {
      return "__/__/____";
    }
    try {
      DateTime date = DateTime.parse(updatedAt.toString());

      dateText = DateFormat("EEEE - dd MMM, y").format(date);
    } catch (e) {}
    return dateText;
  }

  static String to_date_3(dynamic updatedAt) {
    String dateText = "__/__/___";
    if (updatedAt == null) {
      return "__/__/____";
    }
    if (updatedAt.toString().length < 5) {
      return "__/__/____";
    }
    try {
      DateTime date = DateTime.parse(updatedAt.toString());

      dateText = DateFormat("jm").format(date);
    } catch (e) {}
    return dateText;
  }

  static DateTime toDate(dynamic updatedAt) {
    DateTime date = DateTime.now();
    try {
      date = DateTime.parse(updatedAt.toString());
    } catch (e) {
      date = DateTime.now();
    }

    return date;
  }

  static String moneyFormat(String price) {
    int value0 = Utils.int_parse(price);
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      if (value0 < 0) {
        value = "-$value";
      }
      return value;
    }
    return price;
  }

  static Future<void> launchBrowser(String path) async {
    Uri uri = Uri.parse('${AppConfig.MAIN_SITE_URL}/$path');

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      Utils.toast('Could not launch ${uri.toString()}', color: CustomTheme.red);
    }
  }

  static Future<String> getPref(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(path) ?? "";
  }

  static Future<void> setPref(String path, String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(path, data);
    return;
  }

  static initValue(dynamic val, List<dynamic> list) {
    if (list.contains(val)) {
      return val;
    }
    return null;
  }

  static void showLoader(bool dismissable) {
    if (EasyLoading.isShow) {
      return;
    } else {
      EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: dismissable,
      );
    }
    return;
  }

  static void hideLoader() {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    return;
  }

  static String create_icon_string(String description) {
    String codeString = AppConfig.weatherCodes[description]!.toLowerCase();
    if (description == "1000") {
      codeString = "clear";
    }

    return '${description}0_${codeString.replaceAll(" ", "_")}_large.png';
  }

  static double double_parse(String lat) {
    if (lat.isEmpty) {
      return 0;
    }

    double temp = 0;
    try {
      temp = double.parse(lat);
    } catch (e) {
      temp = 0;
    }
    return temp;
  }
}
