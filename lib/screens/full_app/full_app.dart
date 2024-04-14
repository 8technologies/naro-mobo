import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/controllers/MainController.dart';
import 'package:marcci/models/LoggedInUserModel.dart';
import 'package:marcci/screens/full_app/section/AccountSection.dart';
import 'package:marcci/screens/gardens/GardenActivityCreateScreen.dart';
import 'package:marcci/screens/gardens/GardenCreateScreen.dart';
import 'package:marcci/screens/gardens/MyActivitiesCalender.dart';
import 'package:marcci/screens/gardens/MyActivitiesList.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../controllers/full_app_controller.dart';
import '../../models/FarmerOfflineModel.dart';
import '../../models/FinancialRecordModel.dart';
import '../../models/GardenActivity.dart';
import '../../models/GardenModel.dart';
import '../../models/MenuItem.dart';
import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';
import '../ai/AIHomeScreen.dart';
import '../finance/TransactionCreateScreen.dart';
import '../forms/FarmerProfilingStep1Screen.dart';
import '../gardens/GardenActivitySubmitScreen.dart';
import '../gardens/ProductionGuide.dart';
import '../products/ProductCreateScreen.dart';
import 'MainMenuScreen.dart';
import 'WeatherForeCastScreen.dart';

class FullApp extends StatefulWidget {
  const FullApp({Key? key}) : super(key: key);

  @override
  _FullAppState createState() => _FullAppState();
}

class _FullAppState extends State<FullApp> with SingleTickerProviderStateMixin {
  late FullAppController controller;
  final MainController mainController = Get.put(MainController());

  String tab = 'activities';

  @override
  void initState() {
    super.initState();

    controller = FxControllerStore.putOrFind(FullAppController(this));
    mainController.initialized;
    mainController.init();
    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    menuItems = [
      MenuItem('Sacco Registration', 'T 1', null, '5.jpg', () {
        //Get.to(() => SaccoSystemIntroduction());
      }),
      MenuItem('My Gardens', 'T 1', null, '4.jpg', () {}),
      MenuItem('Weather Forecast', 'T 1', null, 'rain.png', () {
        Get.to(() => const WeatherForeCastScreen());
      }),
      MenuItem('Market Place', 'T 1', null, '2.jpg', () {}),
      MenuItem('Farmers Forum', 'T 1', null, '1.jpg', () {
        Utils.toast("Coming soon...");
        //Get.to(() => const PWDList());
      }),
    ];

    return WillPopScope(
      onWillPop: () async {
        Get.defaultDialog(
            middleText: "Are you sure you want quit this App?",
            titleStyle: TextStyle(color: Colors.black),
            actions: <Widget>[
              FxButton.outlined(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: FxText(
                  'CANCEL',
                  color: Colors.grey.shade700,
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                borderColor: Colors.grey.shade700,
              ),
              FxButton.small(
                backgroundColor: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: FxText(
                  'QUIT',
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(vertical: 17, horizontal: 15),
              )
            ]);
        return false;
      },
      child: Scaffold(
        backgroundColor: CustomTheme.primary,
        floatingActionButton: Align(
          alignment: Alignment(-.6, 1),
          child: FloatingActionButton.extended(
              backgroundColor: Colors.yellow,
              elevation: 10,
              onPressed: () {
                Get.to(() => MainMenuScreen());
              },
              label: Row(
                children: [
                  const Icon(
                    FeatherIcons.grid,
                    size: 25,
                    color: CustomTheme.primary,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: FxText.titleLarge(
                      "MENU",
                      fontWeight: 900,
                      fontSize: 30,
                      color: CustomTheme.primary,
                    ),
                  ),
                ],
              )),
        ),
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
      ),
    );
  }

  Widget mainWidget() {
    //mainController.init();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 5,
            right: 5,
            top: 10,
            bottom: 0,
          ),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => AccountSection());
                          },
                          child: FxContainer(
                            paddingAll: 4,
                            borderRadiusAll: 600,
                            color: Color(0xFFFFEB3B),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(600),
                              child: Image(
                                image: const AssetImage(
                                  'assets/images/user.png',
                                ),
                                fit: BoxFit.cover,
                                width: (MediaQuery.of(context).size.width / 7),
                                height: (MediaQuery.of(context).size.width / 7),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).size.height / 20),
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FxText.titleLarge(
                                "${Utils.getGreeting()},",
                                fontWeight: 400,
                                fontSize: 20,
                                textAlign: TextAlign.left,
                                color: Colors.white,
                              ),
                              FxText.titleLarge(
                                "Muhindo Mubaraka",
                                fontWeight: 600,
                                fontSize: 35,
                                height: 1,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).size.height / 20),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              FxContainer(
                                  color: Colors.yellow,
                                  paddingAll: 15,
                                  borderRadiusAll: 100,
                                  child: const Icon(
                                    Icons.add,
                                    size: 35,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    _showBottomSheet(context);
                                  }),
                              SizedBox(
                                height: 5,
                              ),
                              FxText.bodySmall(
                                "Create New",
                                fontWeight: 800,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              FxContainer(
                                  color: Colors.yellow,
                                  paddingAll: 15,
                                  borderRadiusAll: 100,
                                  child: const Icon(
                                    Icons.yard,
                                    size: 35,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Get.to(() => ProductionGuidesScreen({}));
                                  }),
                              SizedBox(
                                height: 5,
                              ),
                              FxText.bodySmall(
                                "My Gardens",
                                fontWeight: 800,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              FxContainer(
                                  color: Colors.blue,
                                  paddingAll: 15,
                                  borderRadiusAll: 100,
                                  child: Icon(
                                    Icons.insights_outlined,
                                    size: 35,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Get.to(() => AIHomeScreen());
                                  }),
                              SizedBox(
                                height: 5,
                              ),
                              FxText.bodySmall(
                                "AI",
                                fontWeight: 800,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              FxContainer(
                                  color: Colors.yellow,
                                  paddingAll: 15,
                                  borderRadiusAll: 100,
                                  child: const Icon(
                                    FeatherIcons.grid,
                                    size: 35,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Get.to(() => MainMenuScreen());
                                  }),
                              SizedBox(
                                height: 5,
                              ),
                              FxText.bodySmall(
                                "MAIN MENU".toUpperCase(),
                                fontSize: 12,
                                fontWeight: 800,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).size.height / 20),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              tab = 'activities';
                              setState(() {});
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: tab == 'activities'
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          topRight: Radius.circular(25),
                                        ),
                                        color: Colors.white,
                                      )
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          topRight: Radius.circular(25),
                                        ),
                                        color: Colors.transparent,
                                      ),
                                padding: EdgeInsets.only(
                                  top: 15,
                                  bottom: 20,
                                ),
                                child: FxText.bodySmall(
                                  "Recent Activities",
                                  textAlign: TextAlign.left,
                                  height: 1,
                                  color: tab == 'activities'
                                      ? CustomTheme.primary
                                      : Colors.white,
                                  fontWeight: 800,
                                )),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              tab = 'finance';
                              setState(() {});
                            },
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(15),
                                decoration: tab == 'finance'
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          topRight: Radius.circular(25),
                                        ),
                                        color: Colors.white,
                                      )
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          topRight: Radius.circular(25),
                                        ),
                                        color: Colors.transparent,
                                      ),
                                child: FxText.bodySmall(
                                  "Financial Records",
                                  color: tab == 'finance'
                                      ? CustomTheme.primary
                                      : Colors.white,
                                  textAlign: TextAlign.left,
                                  fontWeight: 800,
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        missing.isEmpty
            ? const SizedBox()
            : FxContainer(
                padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                borderRadiusAll: 0,
                color: Colors.red.shade700,
                onTap: () async {
                  await Get.to(() => MyActivitiesList());
                  doRefresh();
                },
                width: double.infinity,
                margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                child: Row(
                  children: [
                    FxText(
                      "You have ${missing.length.toString()} missing activities.",
                      fontWeight: 700,
                      color: Colors.white,
                    ),
                    Spacer(),
                    FxText(
                      "View >",
                      fontWeight: 700,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              color: Colors.white,
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: RefreshIndicator(
              onRefresh: doRefresh,
              color: CustomTheme.primary,
              backgroundColor: Colors.white,
              child: tab == 'activities' ? activitiesWidget() : financeWidget(),
            ),
          ),
        ),
      ],
    );
  }

  Widget gardenActvityWidget(GardenActivity m) {
    return InkWell(
      onTap: () {
        _showMyBottomSheetGardenActivityDetails(context, m);
        //Get.to(()=>MyActivityDetailsScreen(m));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.bodyLarge(
                  m.temp_status == 'Submitted'
                      ? "DATE DONE: ${Utils.to_date_1(m.farmer_submission_date)}"
                      : "DUE DATE: ${Utils.to_date_1(m.activity_due_date)}",
                  fontWeight: 700,
                  color: Colors.black,
                  fontSize: 14,
                ),
                const SizedBox(
                  height: 2,
                ),
                FxText.bodyLarge(
                  m.activity_name,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(
                  height: 5,
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FxText.bodySmall(
                      "GARDEN: ${m.garden_text}",
                      color: Colors.grey.shade700,
                      fontWeight: 800,
                    ),
                    FxContainer(
                      margin: EdgeInsets.only(bottom: 5, top: 2),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      color: m.bgColor,
                      child: FxText.bodySmall(
                        m.temp_status.toUpperCase(),
                        color: Colors.white,
                        fontWeight: 900,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  void _showMyBottomSheetGardenActivityDetails(context, GardenActivity activity) {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
            return Container(
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                margin: EdgeInsets.only(left: 0, right: 0, bottom: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(MySize.size16),
                    topRight: Radius.circular(MySize.size16),
                    bottomLeft: Radius.circular(MySize.size16),
                    bottomRight: Radius.circular(MySize.size16),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Spacer(),
                                  FxText.titleLarge(
                                    "ACTIVITY DETAILS".toUpperCase(),
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: 700,
                                  ),
                                  Spacer(),
                                  InkWell(
                                    child: Icon(
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
                      Divider(),
                      Expanded(
                          child: ListView(
                        children: [
                          titleValueWidget2('ACTIVITY', activity.activity_name,
                              vertical: 4, horizontal: 20),
                          titleValueWidget2('GARDEN', activity.garden_text,
                              vertical: 4, horizontal: 20),
                          titleValueWidget2(
                              'DATE TO BE DONE', Utils.to_date_1(activity.activity_date_to_be_done),
                              vertical: 4, horizontal: 20),
                          titleValueWidget2('DEADLINE', Utils.to_date_1(activity.activity_due_date),
                              vertical: 4, horizontal: 20),
                          titleValueWidget2('STATUS', activity.farmer_activity_status,
                              vertical: 4, horizontal: 20),
                          titleValueWidget2('IS SUBMITTED', activity.farmer_has_submitted,
                              vertical: 4, horizontal: 20),
                          titleValueWidget2(
                              'DATE SUBMITTED', Utils.to_date_1(activity.farmer_submission_date),
                              vertical: 4, horizontal: 20),
                          titleValueWidget2(
                              'DATE DONE', Utils.to_date_1(activity.activity_date_done),
                              vertical: 4, horizontal: 20),
                          titleValueWidget2('DATE CREATED', Utils.to_date_1(activity.created_at),
                              vertical: 4, horizontal: 20),
                          titleValueWidget2('REMARKS', activity.farmer_comment,
                              vertical: 4, horizontal: 20),
                          Divider(endIndent: 20, indent: 20),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FxText.titleMedium(
                                  'ACTIVITY DESCRIPTION',
                                  fontWeight: 800,
                                  color: Colors.black,
                                ),
                                FxText.bodyMedium(
                                  activity.activity_description,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                      activity.temp_status == 'Submitted'
                          ? const SizedBox()
                          : Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
                              child: FxButton.block(
                                onPressed: () async {
                                  if (activity.temp_status == 'Submitted') {
                                    Utils.toast(
                                        '${activity.activity_name} is already submitted.');
                                    return;
                                  }
                                  Navigator.pop(context);
                                  await Get.to(() =>
                                      GardenActivitySubmitScreen(activity));
                                  doRefresh();
                                },
                                backgroundColor: CustomTheme.primary,
                                borderRadiusAll: 8,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                elevation: 0,
                                child: FxText(
                                  "SUBMIT ACTIVITY",
                                  color: Colors.white,
                                  fontWeight: 700,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();
    setState(() {});
  }

  List<GardenActivity> items = [];
  List<GardenActivity> upcoming = [];
  List<GardenActivity> missing = [];
  List<GardenActivity> submitted = [];

  List<MenuItem> menuItems = [];
  LoggedInUserModel loggedInUserModel = LoggedInUserModel();

  Future<dynamic> myInit() async {
    loggedInUserModel = await LoggedInUserModel.getLoggedInUser();
    items = await GardenActivity.get_items();
    items2 = await FinancialRecordModel.get_items();
    upcoming.clear();
    submitted.clear();
    missing.clear();
    items.forEach((element) {
      element.getStatus();
      if (element.temp_status == "Submitted") {
        submitted.add(element);
      } else {
        upcoming.add(element);
      }
      if (element.temp_status == 'Missing') {
        missing.add(element);
      }
    });
    setState(() {});

    return "Done";
  }

  void _showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  )),
              child: Container(
                padding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                  top: 20,
                  bottom: 10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: FxText.titleLarge("Quick Actions",
                          fontWeight: 800, color: CustomTheme.primary),
                    ),
                    Center(
                      child: Container(
                        height: 2,
                        width: 50,
                        margin: EdgeInsets.only(top: 10, bottom: 5),
                        color: CustomTheme.accent,
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        await Get.to(() => GardenCreateScreen(GardenModel()));
                        doRefresh();
                      },
                      leading: Icon(
                        FeatherIcons.plus,
                        color: CustomTheme.primary,
                        size: 26,
                      ),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: FxText.titleMedium(
                        "Register new garden",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        await Get.to(() => GardenActivityCreateScreen());
                        doRefresh();
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: Icon(
                        FeatherIcons.plusCircle,
                        color: CustomTheme.primary,
                        size: 26,
                      ),
                      title: FxText.titleMedium(
                        "Create garden activity",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        await Get.to(() => TransactionCreateScreen());
                        doRefresh();
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: Icon(
                        FeatherIcons.dollarSign,
                        color: CustomTheme.primary,
                        size: 26,
                      ),
                      title: FxText.titleMedium(
                        "Create financial record",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        await Get.to(() => ProductCreateScreen());
                        doRefresh();
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: Icon(
                        FeatherIcons.shoppingCart,
                        color: CustomTheme.primary,
                        size: 26,
                      ),
                      title: FxText.titleMedium(
                        "Sell your farm products",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        await Get.to(() =>
                            FarmerProfilingStep1Screen(FarmerOfflineModel()));
                        doRefresh();
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: Icon(
                        FeatherIcons.userPlus,
                        color: CustomTheme.primary,
                        size: 26,
                      ),
                      title: FxText.titleMedium(
                        "Profile a Farmer",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  activitiesWidget() {
    if (items.length < 1) {
      return Center(
        child: FxText.bodyMedium(
          "You have no activities yet.\nCreate one now.",
          fontWeight: 700,
          textAlign: TextAlign.center,
          color: Colors.grey.shade700,
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              GardenActivity m = items[index];
              return gardenActvityWidget(m);
            },
            childCount: items.length, // 1000 list items
          ),
        ),
      ],
    );
  }

  List<FinancialRecordModel> items2 = [];

  financeWidget() {
    if (items2.length < 1) {
      return Center(
        child: FxText.bodyMedium(
          "You have no financial records yet.\nCreate one now.",
          fontWeight: 700,
          textAlign: TextAlign.center,
          color: Colors.grey.shade700,
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return transactionWidget(items2[index]);
            },
            childCount: items2.length, // 1000 list items
          ),
        ),
      ],
    );
  }

  Widget transactionWidget(FinancialRecordModel m) {
    return InkWell(
      onTap: () {
        _showMyBottomSheetTransactionDetails(Get.context, m);
      },
      child: Column(
        children: [
          Divider(
            height: 7,
            color: Colors.white,
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              FxContainer(
                color: CustomTheme.primary.withAlpha(20),
                paddingAll: 11,
                margin: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 0, top: 0),
                child: Icon(
                  !m.isIncome() ? FeatherIcons.arrowUp : FeatherIcons.arrowDown,
                  color: !m.isIncome()
                      ? Colors.red.shade800
                      : Colors.green.shade800,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.bodySmall(
                      Utils.to_date(m.created_at),
                      fontWeight: 700,
                      fontSize: 10,
                    ),
                    FxText.bodySmall(
                      m.garden_text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.grey.shade800,
                      fontWeight: 400,
                    ),
                    FxText.bodySmall(
                      '${m.description}'.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: CustomTheme.primary,
                      fontWeight: 700,
                    ),
                  ],
                ),
              ),
              FxText.bodyLarge(
                "UGX " + Utils.moneyFormat(m.amount),
                fontWeight: 700,
                color:
                    !m.isIncome() ? Colors.red.shade700 : Colors.green.shade700,
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          Divider(
            height: 7,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  void _showMyBottomSheetTransactionDetails(
      context, FinancialRecordModel item) {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            child: Container(
              padding: EdgeInsets.only(bottom: 20),
              margin: EdgeInsets.only(left: 13, right: 13, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MySize.size16),
                  topRight: Radius.circular(MySize.size16),
                  bottomLeft: Radius.circular(MySize.size16),
                  bottomRight: Radius.circular(MySize.size16),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Icon(
                              (!item.isIncome())
                                  ? FeatherIcons.upload
                                  : FeatherIcons.download,
                              color: (!item.isIncome())
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FxText.titleLarge(
                              item.category,
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: 700,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      minVerticalPadding: 0,
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      leading: Icon(
                        Icons.monetization_on,
                        color: CustomTheme.primary,
                      ),
                      title: FxText.bodyMedium(
                        'Amount',
                      ),
                      subtitle: FxText.bodyLarge(
                        "UGX ${Utils.moneyFormat(item.amount)}",
                        color: Colors.black,
                        fontWeight: 700,
                      ),
                    ),
                    ListTile(
                      dense: true,
                      minVerticalPadding: 0,
                      leading: Icon(
                        Icons.date_range,
                        color: CustomTheme.primary,
                      ),
                      title: FxText.bodyMedium(
                        'Date',
                      ),
                      subtitle: FxText.bodyLarge(
                        Utils.to_date(item.created_at),
                        color: Colors.black,
                        fontWeight: 700,
                      ),
                    ),
                    ListTile(
                      dense: true,
                      minVerticalPadding: 0,
                      leading: Icon(
                        Icons.info_outline,
                        color: CustomTheme.primary,
                      ),
                      title: FxText.bodyMedium(
                        'Garden',
                      ),
                      subtitle: FxText.bodyMedium(
                        item.garden_text,
                        color: Colors.black,
                      ),
                    ),
                    ListTile(
                      dense: true,
                      minVerticalPadding: 0,
                      leading: Icon(
                        Icons.abc,
                        color: CustomTheme.primary,
                      ),
                      title: FxText.bodyMedium(
                        'Details',
                      ),
                      subtitle: FxText.bodyMedium(
                        item.description,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
