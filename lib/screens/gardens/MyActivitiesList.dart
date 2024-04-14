import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/sections/widgets.dart';
import 'package:marcci/theme/app_theme.dart';
import 'package:marcci/utils/Utils.dart';

import '../../models/GardenActivity.dart';
import '../../utils/SizeConfig.dart';
import 'GardenActivityCreateScreen.dart';
import 'GardenActivitySubmitScreen.dart';
import 'MyActivitiesCalender.dart';

class MyActivitiesList extends StatefulWidget {
  const MyActivitiesList({Key? key}) : super(key: key);

  @override
  _MyActivitiesListState createState() => _MyActivitiesListState();
}

class _MyActivitiesListState extends State<MyActivitiesList>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();

    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              Get.off(() => MyActivitiesCalednderScreen());
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.calendar_month,
                size: 40,
                color: Colors.white,
              ),
            ),
          )
        ],
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          "My Activities",
          color: Colors.white,
          maxLines: 2,
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Scaffold(
            floatingActionButton: FloatingActionButton.extended(
                backgroundColor: CustomTheme.primary,
                elevation: 10,
                onPressed: () {
                  Get.to(() => GardenActivityCreateScreen());
                },
                label: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      size: 18,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: FxText(
                        "SCHEDULE ACTIVITY",
                        fontWeight: 800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              toolbarHeight: 40,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*-------------- Build Tabs here ------------------*/
                  TabBar(
                    padding: EdgeInsets.only(bottom: 0),
                    labelPadding: EdgeInsets.only(bottom: 2, left: 8, right: 8),
                    indicatorPadding: EdgeInsets.all(0),
                    labelColor: Colors.white,
                    isScrollable: false,
                    enableFeedback: true,
                    indicator: UnderlineTabIndicator(
                        borderSide:
                            BorderSide(color: CustomTheme.primary, width: 4)),
                    tabs: [
                      Tab(
                          height: 30,
                          child: FxText.titleMedium(
                            "UPCOMING (${upcoming.length})".toUpperCase(),
                            fontWeight: 800,
                            color: CustomTheme.primary,
                          )),
                      Tab(
                          height: 30,
                          child: FxText.titleMedium(
                              "SUBMITTED (${submitted.length})".toUpperCase(),
                              fontWeight: 800,
                              color: CustomTheme.primary)),
                    ],
                  )
                ],
              ),
              iconTheme: IconThemeData(color: Colors.white),
              titleSpacing: 0,
            ),
            body: TabBarView(
              children: [
                mainWidget(),
                submittedWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mainWidget() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: doRefresh,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                },
                childCount: 1, // 1000 list items
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  GardenActivity m = upcoming[index];
                  return gardenActvityWidget(m);
                },
                childCount: upcoming.length, // 1000 list items
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget submittedWidget() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: doRefresh,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                },
                childCount: 1, // 1000 list items
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  GardenActivity m = submitted[index];
                  return gardenActvityWidget(m);
                },
                childCount: submitted.length, // 1000 list items
              ),
            ),
          ],
        ),
      ),
    );
  }

  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();
    setState(() {});
  }

  List<GardenActivity> items = [];
  List<GardenActivity> upcoming = [];
  List<GardenActivity> submitted = [];

  Future<dynamic> myInit() async {
    items = await GardenActivity.get_items();
    upcoming.clear();
    submitted.clear();
    items.forEach((element) {
      element.getStatus();
      if (element.temp_status == "Submitted") {
        submitted.add(element);
      } else {
        upcoming.add(element);
      }
    });
    setState(() {});
    return "Done";
  }

  menuItemWidget(String title, String subTitle, Function screen) {
    return InkWell(
      onTap: () => {screen()},
      child: Container(
        padding: const EdgeInsets.only(left: 0, bottom: 5, top: 20),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: CustomTheme.primary, width: 2),
        )),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.titleLarge(
                    title,
                    color: Colors.black,
                    fontWeight: 900,
                  ),
                  FxText.bodyLarge(
                    subTitle,
                    height: 1,
                    fontWeight: 600,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 35,
            )
          ],
        ),
      ),
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

  void _showMyBottomSheetGardenActivityDetails(
      context, GardenActivity activity) {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              'DATE TO BE DONE',
                              Utils.to_date_1(
                                  activity.activity_date_to_be_done),
                              vertical: 4,
                              horizontal: 20),
                          titleValueWidget2('DEADLINE',
                              Utils.to_date_1(activity.activity_due_date),
                              vertical: 4, horizontal: 20),
                          titleValueWidget2(
                              'STATUS', activity.farmer_activity_status,
                              vertical: 4, horizontal: 20),
                          titleValueWidget2(
                              'IS SUBMITTED', activity.farmer_has_submitted,
                              vertical: 4, horizontal: 20),
                          titleValueWidget2('DATE SUBMITTED',
                              Utils.to_date_1(activity.farmer_submission_date),
                              vertical: 4, horizontal: 20),
                          titleValueWidget2('DATE DONE',
                              Utils.to_date_1(activity.activity_date_done),
                              vertical: 4, horizontal: 20),
                          titleValueWidget2('DATE CREATED',
                              Utils.to_date_1(activity.created_at),
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
                                    activity.activity_description),
                              ],
                            ),
                          ),
                        ],
                      )),
                      activity.temp_status == 'Submitted'
                          ? const SizedBox()
                          : Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 0),
                              child: FxButton.block(
                                onPressed: () {
                                  if (activity.temp_status == 'Submitted') {
                                    Utils.toast(
                                        '${activity.activity_name} is already submitted.');
                                    return;
                                  }
                                  Navigator.pop(context);
                            Get.to(() => GardenActivitySubmitScreen(activity));
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
}
