import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:marcci/models/ParishModel.dart';

import '../../models/MapLocationModel.dart';
import '../../models/WeatherForeCastModel.dart';
import '../../theme/custom_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_widgets.dart';
import '../pickers/ParishPickerScreen.dart';

class WeatherForeCastScreen extends StatefulWidget {
  const WeatherForeCastScreen({Key? key}) : super(key: key);

  @override
  _WeatherForeCastScreenState createState() => _WeatherForeCastScreenState();
}

class _WeatherForeCastScreenState extends State<WeatherForeCastScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    doRefresh();
  }

  WeatherForeCastModel weatherForeCastModel = WeatherForeCastModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.primary,
      body: SafeArea(
        child: FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: Text("⌛ Loading..."),
                  );
                default:
                  return mainWidget();
              }
            }),
      ),
    );
  }

  MapLocationModel selected_location = MapLocationModel();
  bool pickerIsOpen = true;
  final _fKey = GlobalKey<FormBuilderState>();

  Widget mainWidget() {
    return pickerIsOpen
        ? FormBuilder(
            key: _fKey,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FxContainer(
                          onTap: () {
                            if (parishModel.name.isEmpty) {
                              Utils.toast(
                                  "Location not selected. Request cancelled.");
                              Navigator.pop(context);
                              return;
                            }
                            setState(() {
                              pickerIsOpen = false;
                            });
                          },
                          paddingAll: 15,
                          child: const Icon(
                            FeatherIcons.x,
                            size: 35,
                            color: Colors.red,
                          )),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15, top: 0, right: 15, bottom: 0),
                    child: Center(
                      child: FxText.titleLarge(
                        'WEATHER FORECAST',
                        fontWeight: 800,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: FxButton.outlined(
                        onPressed: () async {
                          Utils.toast("Please wait...");
                          Position p = await Utils.get_device_location();
                          if (p.latitude == 0 && p.longitude == 0) {
                            Utils.toast("Failed to get your location.");
                            return;
                          }

                          selected_location.latitude = p.latitude;
                          selected_location.longitude = p.longitude;
                          selected_location.name = "My Location";
                          selected_location.address = "My Location";
                          selected_location.isMyLocation = true;
                          setState(() {
                            pickerIsOpen = false;
                          });
                        },
                        borderRadiusAll: 12,
                        borderColor: CustomTheme.primary,
                        child: FxText.bodyLarge(
                          'PICK MY CURRENT LOCATION',
                          fontWeight: 800,
                          color: Colors.black,
                        )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 20,
                          color: CustomTheme.primary,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      FxText.titleLarge(
                        'OR',
                        fontWeight: 900,
                        color: CustomTheme.primary,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 20,
                          color: CustomTheme.primary,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: FxButton.outlined(
                        onPressed: () async {
                          ParishModel? p = await Get.to(() =>
                              ParishPickerScreen(parishModel.id.toString(),
                                  parishModel.name.toString()));

                          if (p == null) {
                            Utils.toast("No location selected");
                            return;
                          }
                          parishModel = p;
                          Utils.toast("Please wait...");

                          selected_location.latitude =
                              Utils.double_parse(parishModel.lat);
                          selected_location.longitude =
                              Utils.double_parse(parishModel.lng);

                          selected_location.name = parishModel.name;
                          selected_location.address = parishModel.name;
                          selected_location.isMyLocation = false;
                          setState(() {});
                        },
                        borderRadiusAll: 12,
                        borderColor: CustomTheme.primary,
                        child: FxText.bodyLarge(
                          'SELECT CUSTOM LOCATION',
                          fontWeight: 800,
                          color: Colors.black,
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15, top: 15, right: 15, bottom: 0),
                    child: FxText.bodyMedium(
                      parishModel.name.isEmpty
                          ? 'Select a location to get weather forecast.'
                          : 'Selected Location: ${parishModel.name} \nGPS: ${parishModel.lat}, ${parishModel.lng}',
                      color: CustomTheme.primary,
                    ),
                  ),
                  Spacer(),
                  const Divider(
                    height: 1,
                  ),
                  FxContainer(
                      color: Colors.white,
                      borderRadiusAll: 0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: FxButton.block(
                          padding: const EdgeInsets.all(20),
                          borderRadiusAll: 12,
                          onPressed: () {
                            if (selected_location.name.isEmpty) {
                              Utils.toast("Location not selected.");
                              return;
                            }

                            if (selected_location.latitude == 0 ||
                                selected_location.longitude == 0) {
                              Utils.toast("Invalid location.");
                              return;
                            }

                            selected_location.isMyLocation = false;
                            doRefresh();
                            setState(() {
                              pickerIsOpen = false;
                            });
                          },
                          backgroundColor: CustomTheme.primary,
                          child: FxText.titleLarge(
                            'REQUEST FORECAST',
                            color: Colors.white,
                          )))
                ],
              ),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*  ListTile(
                onTap: () {
                   myInit();
                },
                leading: Icon(
                  FeatherIcons.arrowLeft,
                  color: Colors.white,
                ),
                title: FxText.titleLarge(
                  'WEATHER FORECAST',
                  fontWeight: 800,
                  color: Colors.white,
                ),
              ),*/
              Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 15,
                ),
                child: InkWell(
                  onTap: () async {
                    parishModel = ParishModel();
                    selected_location = MapLocationModel();
                    pickerIsOpen = true;
                    setState(() {});
                    return;
                    /* // dynamic x = await Get.to(() => MapPickerScreen({}));
                    // if (x == null) {
                    //   return;
                    // }
                    //
                    // if (x.runtimeType.toString() != 'MapLocationModel') {
                    //   Utils.toast('Invalid location');
                    //   return;
                    // }
                    // selected_location = x;
                    // futureInit = myInit();
                    // setState(() {});*/
                  },
                  child: Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flex(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  child: FxText.titleLarge(
                                    selected_location.isMyLocation
                                        ? 'My Current Location'
                                        : parishModel.name.isNotEmpty
                                            ? '${parishModel.name}.'
                                            : 'Select Location',
/*                                    '${selected_location.address}',*/
                                    fontWeight: 900,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                Icon(
                                  FeatherIcons.chevronDown,
                                  color: Colors.grey.shade100,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: RefreshIndicator(
                    onRefresh: doRefresh,
                    color: CustomTheme.primary,
                    backgroundColor: Colors.white,
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              WeatherItem w = weatherForeCastModel.items[index];
                              return FxCard(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                color: Colors.white,
                                width: double.infinity,
                                borderRadiusAll: 25,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flex(
                                      direction: Axis.horizontal,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        /*CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          imageUrl:
                                              "https://openweathermap.org/img/wn/${w.weather.icon}@2x.png",
                                          placeholder: (context, url) =>
                                              ShimmerLoadingWidget(),
                                          errorWidget: (context, url, error) =>
                                              const Image(
                                            image: AssetImage(
                                                AppConfig.NO_IMAGE),
                                            fit: BoxFit.cover,
                                          // ),
                                        ),*/
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: Image.asset(
                                            'assets/images/tomorrow/${Utils.create_icon_string(w.weather.description)}',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Expanded(
                                          child: FxText.headlineLarge(
                                            weatherForeCastModel.items.isEmpty
                                                ? '--.-'
                                                : '${w.temp.max}°C',
                                            fontWeight: 800,
                                            textAlign: TextAlign.end,
                                            color: CustomTheme.primary,
                                            maxLines: 1,
                                            fontSize: 70,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    FxText.titleLarge(
                                      weatherForeCastModel.items.isEmpty
                                          ? '---/----/-----'
                                          : Utils.to_date_4(w.dt),
                                      fontWeight: 400,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    FxText.titleLarge(
                                      weatherForeCastModel.items.isEmpty
                                          ? '---:---'
                                          : (AppConfig.weatherCodes[
                                                  w.weather.description]!
                                              .toUpperCase()),
                                      fontWeight: 800,
                                      color: MyColors.accent,
                                      fontSize: 35,
                                    ),
                                    const Divider(),
                                    const SizedBox(
                                      height: 0,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    FxText.titleSmall("SUNRISE & SUNSET",
                                        fontWeight: 800, color: Colors.black),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    title_detail_widget2('sunrise',
                                        Utils.time_from_datetime(w.sunrise)),
                                    title_detail_widget2('sunset',
                                        Utils.time_from_datetime(w.sunset)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    FxText.titleSmall("TEMPERATURES",
                                        fontWeight: 800, color: Colors.black),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    title_detail_widget2(
                                        'Minimum', '${w.temp.min}°C'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    title_detail_widget2(
                                        'Maximum', '${w.temp.max}°C'),
                                    title_detail_widget2(
                                        'Average', '${w.temp.ave}°C'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    FxText.titleSmall("WEATHER",
                                        fontWeight: 800, color: Colors.black),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    title_detail_widget2('Main',
                                        '${AppConfig.weatherCodes[w.weather.main]}'),
                                    title_detail_widget2(
                                        'clouds', '${w.clouds}%'),
                                    title_detail_widget2(
                                        'rain chance', '${w.precipitation} %'),
                                    title_detail_widget2(
                                        'rain intensity', '${w.rain} mm'),
                                    title_detail_widget2(
                                        'wind', '${w.direction}°'),
                                    title_detail_widget2(
                                        'wind speed', '${w.speed} m/s'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              );
                            },
                            childCount: weatherForeCastModel
                                .items.length, // 1000 list items
                          ),
                        ),
                      ],
                    ) /*ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      FxText.bodyLarge(
                        "There are 12 items on this Main Menu. Press on item to select it.",
                        height: 1,
                        fontWeight: 800,
                      ),
                      menuItemWidget(
                          '1. My notifications',
                          'Press here to see your messages and important alerts.',
                          'bell.png',
                          () => {}),
                      menuItemWidget(
                          '2. My persons with disabilities',
                          'Register & Manage people with disabilities.',
                          'form.png',
                          () => {Get.to(() => const PWDList())}),
                      menuItemWidget(
                          '3. Jobs and Opportunities',
                          'Browse job opportunities in Uganda that are suitable for you.',
                          'jobs.png',
                          () => {}),
                      menuItemWidget(
                          '4. Shop',
                          'Buy products and services that can help you in your day-to-day life.',
                          'shop.png',
                          () => {}),
                      menuItemWidget(
                          '5. Counseling services',
                          'Browse, meet and talk counselors across different parts of Uganda.',
                          'counselors.png',
                          () => {}),
                      menuItemWidget(
                          '6. News',
                          'Stay updated with latest news based on persons with disabilities.',
                          'news.png',
                          () => {}),
                      menuItemWidget(
                          '7. Events',
                          'Browse and register for upcoming events that are about to take place.',
                          'events.png',
                          () => {}),
                      menuItemWidget(
                          '8. Institutions',
                          'Press here to see Institutions for person with disabilities near you.',
                          'school.png',
                          () => {}),
                      menuItemWidget(
                          '9. Associations',
                          'United we stand! browse and join  associations that can support you.',
                          'associations.png',
                          () => {}),
                      menuItemWidget(
                          '10. Innovations',
                          'Open here to see different technologies for persons with disabilities and how you can acquire them.',
                          'innovation.png',
                          () => {}),
                      menuItemWidget(
                          '11. Testimonials',
                          'Learn from videos, audios, pictures and articles of people\'s experience.',
                          'testimonial.png',
                          () => {}),
                      menuItemWidget(
                          '12. My Account',
                          'Open here to manage everything your account and content that you post on this platform.',
                          'bell.png',
                          () => {}),
                      FxContainer(
                        margin: EdgeInsets.only(left: 30, right: 30, top: 15),
                        color: Colors.grey.shade200,
                        bordered: true,
                        borderColor: Colors.black,
                        child: FxText.bodyLarge(
                          'End of the menu. Scroll back to top to go through it again.',
                          fontWeight: 800,
                          color: Colors.black,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ],
              )*/
                    ,
                  ),
                ),
              ),
            ],
          );
  }

  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();
    setState(() {});
  }

  Future<String> getLocationName(double lat, double long) async {
    var dio = Dio();
    String name = "-";
    var resp = await dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=${AppConfig.GOOGLE_MAP_API}');
    if (resp.data != null &&
        resp.data['results'] != null &&
        resp.data['results'].length > 0) {
      name = resp.data['results'][0]['formatted_address'];
    }
    return name;
  }

  bool isFirst = true;
  ParishModel parishModel = ParishModel();

  Future<dynamic> myInit() async {
    if (isFirst) {
      isFirst = false;
      return "Done";
    }

    Utils.toast('Getting weather forecast...');
    MapLocationModel loc = MapLocationModel();
    //await Utils.searchWord('Uganda, ${parishModel.name}');
    /* Utils.toast('==>${loc.name}<===');*/

    loc.latitude = Utils.double_parse(parishModel.lat);
    loc.longitude = Utils.double_parse(parishModel.lng);
    loc.name = parishModel.name;
    loc.address = parishModel.name;

    if (loc.latitude != 0) {
      selected_location.latitude = loc.latitude;
      selected_location.longitude = loc.longitude;
      // selected_location.latitude = 42.3478;
      // selected_location.longitude = -71.0466;

      selected_location.address = await getLocationName(
          selected_location.latitude, selected_location.longitude);
      selected_location.name = selected_location.address;
    }
    weatherForeCastModel.latitude = selected_location.latitude.toString();
    weatherForeCastModel.longitude = selected_location.longitude.toString();
    weatherForeCastModel = await weatherForeCastModel.get_forecast();

    setState(() {});
    return "Done";
  }

  menuItemWidget(String title, String subTitle, String icon, Function f) {
    return InkWell(
      onTap: () {
        f();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          border: Border.all(color: CustomTheme.primary),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(244, 250, 255, 1.0),
                Color.fromRGBO(86, 176, 248, 1.0)
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.8, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  FxText.titleLarge(
                    title,
                    color: Colors.black,
                    fontWeight: 900,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FxText.bodyLarge(
                    subTitle,
                    height: 1,
                    fontWeight: 800,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Image(
              image: AssetImage(
                'assets/images/$icon',
              ),
              fit: BoxFit.cover,
              width: (MediaQuery.of(context).size.width / 3.5),
            )
          ],
        ),
      ),
    );
  }

  actionButton(String s, IconData icon, Function() param2) {
    return InkWell(
      onTap: param2,
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Icon(
            icon,
            size: 35,
            color: CustomTheme.primary,
          ),
          const SizedBox(
            height: 5,
          ),
          FxText.bodySmall(
            s,
            fontWeight: 800,
            color: CustomTheme.primary,
          ),
        ],
      ),
    );
  }

  void districtPicker() {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                margin: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Spacer(),
                                  FxText.titleLarge(
                                    "SELECT DISTRICT".toUpperCase(),
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: 700,
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    child: const Icon(
                                      FeatherIcons.x,
                                      color: CustomTheme.primary,
                                      size: 25,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
