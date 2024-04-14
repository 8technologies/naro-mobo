import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/sections/widgets.dart';
import 'package:marcci/theme/app_theme.dart';
import 'package:marcci/utils/Utils.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/GardenActivity.dart';
import '../../utils/SizeConfig.dart';
import 'GardenActivityCreateScreen.dart';
import 'GardenActivitySubmitScreen.dart';
import 'MyActivitiesList.dart';

class MyActivitiesCalednderScreen extends StatefulWidget {
  const MyActivitiesCalednderScreen({Key? key}) : super(key: key);

  @override
  _MyActivitiesCalednderScreenState createState() =>
      _MyActivitiesCalednderScreenState();
}

class _MyActivitiesCalednderScreenState
    extends State<MyActivitiesCalednderScreen>
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
              Get.off(() => const MyActivitiesList());
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.list,
                size: 40,
                color: Colors.white,
              ),
            ),
          )
        ],
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          "My Activities Calender",
          color: Colors.white,
          maxLines: 2,
        ),
      ),
      body: mainWidget(),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: CustomTheme.primary,
          elevation: 10,
          onPressed: () {
            Get.off(() => GardenActivityCreateScreen());
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
    );
  }

  DateTime _focusedDay = DateTime.now();

  Widget mainWidget() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: doRefresh,
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return _focusedDay.year == day.year &&
                    _focusedDay.month == day.month &&
                    _focusedDay.day == day.day;
              },
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                ),
              ),
              calendarStyle: CalendarStyle(
                weekendTextStyle: TextStyle(
                  color: CustomTheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                selectedTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                selectedDecoration: BoxDecoration(
                  color: CustomTheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                outsideTextStyle: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                outsideDaysVisible: true,
                outsideDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                cellMargin: EdgeInsets.all(0),
                cellPadding: EdgeInsets.all(0),
                cellAlignment: Alignment.center,
                defaultTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                weekdayStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay =
                      selectedDay; // update `_focusedDay` here as well
                });
                _items.clear();
                for (var element in items) {
                  if (element.activity_date_to_be_done_date.year ==
                          selectedDay.year &&
                      element.activity_date_to_be_done_date.month ==
                          selectedDay.month &&
                      element.activity_date_to_be_done_date.day ==
                          selectedDay.day) {
                    _items.add(element);
                  }
                }
                setState(() {});
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                // _focusedDay = focusedDay;
              },
              eventLoader: (day) {
                List<String> events = [];
                items.forEach((obj) {
                  if (obj.activity_date_to_be_done_date.year == day.year &&
                      obj.activity_date_to_be_done_date.month == day.month &&
                      obj.activity_date_to_be_done_date.day == day.day) {
                    events.add(obj.id.toString());
                  }
                });
                return events;
              },
            ),
            Expanded(
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
                        GardenActivity m = _items[index];
                        return gardenActvityWidget(m);
                      },
                      childCount: _items.length, // 1000 list items
                    ),
                  ),
                ],
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
  List<GardenActivity> _items = [];

  Future<dynamic> myInit() async {
    items = await GardenActivity.get_items();

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
                  color: Colors.grey.shade800,
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
                                  Get.to(() =>
                                      GardenActivitySubmitScreen(activity));
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
