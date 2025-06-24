import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/controllers/MainController.dart';
import 'package:marcci/models/LoggedInUserModel.dart';
import 'package:marcci/screens/ai/chatbot_e_extension/AiChatScreen.dart';
import 'package:marcci/screens/full_app/section/AccountSection.dart';
import 'package:marcci/screens/gardens/GardenActivityCreateScreen.dart';
import 'package:marcci/screens/gardens/GardenCreateScreen.dart';
import 'package:marcci/screens/gardens/MyActivitiesList.dart';

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
import 'dart:ui';

class FullApp extends StatefulWidget {
  const FullApp({Key? key}) : super(key: key);

  @override
  _FullAppState createState() => _FullAppState();
}

// FIX: Changed to TickerProviderStateMixin to support multiple AnimationControllers
// (one from TabController, another from FlutterEasyLoading).
class _FullAppState extends State<FullApp> with TickerProviderStateMixin {
  late FullAppController controller;
  final MainController mainController = Get.put(MainController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    controller = FxControllerStore.putOrFind(FullAppController(this));
    _tabController = TabController(length: 2, vsync: this);
    mainController.init();
    doRefresh();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xfff5f6fa), // Main light background
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.to(() => MainMenuScreen()),
          backgroundColor: CustomTheme.primary,
          elevation: 4,
          icon: Icon(FeatherIcons.grid, color: Colors.white),
          // The icon
          label: FxText(
              // The text label
              'Main Menu',
              color: Colors.white,
              fontWeight: 700),
          tooltip: 'Main Menu',
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(CustomTheme.primary),
                      ),
                      SizedBox(height: 16),
                      FxText.bodyLarge("Loading Dashboard...",
                          color: Colors.grey.shade700),
                    ],
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: FxText.bodyLarge("Error: ${snapshot.error}",
                      color: Colors.red.shade400),
                );
              }
              return _buildMainDashboard();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainDashboard() {
    return RefreshIndicator(
      onRefresh: doRefresh,
      color: CustomTheme.primary,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            _buildHeader(),
            _buildQuickActions(),
            if (missing.isNotEmpty) _buildMissingActivitiesWarning(),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: CustomTheme.primary,
                  indicatorWeight: 3.0,
                  labelColor: CustomTheme.primary,
                  unselectedLabelColor: Colors.grey.shade600,
                  tabs: [
                    Tab(child: FxText.bodyLarge("Activities", fontWeight: 700)),
                    Tab(child: FxText.bodyLarge("Finances", fontWeight: 700)),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            _buildActivitiesList(),
            _buildFinanceList(),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHeader() {
    return SliverToBoxAdapter(
      child: FxContainer(
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: EdgeInsets.all(20),
        borderRadiusAll: 16,
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.bodyLarge("${Utils.getGreeting()},",
                      color: Colors.grey.shade600),
                  FxText.headlineSmall(
                    mainController.loggedInUserModel.name,
                    fontWeight: 700,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  FxContainer(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: CustomTheme.primary.withOpacity(0.1),
                    borderRadiusAll: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FeatherIcons.mapPin,
                            color: CustomTheme.primary, size: 12),
                        SizedBox(width: 6),
                        FxText.bodySmall("Nansana, Uganda",
                            color: CustomTheme.primary, fontWeight: 600),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 16),
            GestureDetector(
              onTap: () => Get.to(() => AccountSection()),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: CustomTheme.primary.withOpacity(0.2),
                backgroundImage: AssetImage('assets/images/user.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 600 ? 4 : 2;

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: screenWidth > 600 ? 2.5 : 1.5,
          children: [
            _quickActionCard("Create New", FeatherIcons.plusCircle,
                CustomTheme.skyBlue, () => _showBottomSheet(context)),
            _quickActionCard(
                "My Gardens",
                FeatherIcons.archive,
                CustomTheme.peach,
                () => Get.to(() => ProductionGuidesScreen({}))),
            _quickActionCard("AI Assistant", FeatherIcons.cpu,
                CustomTheme.purple, () => Get.to(() => AiChatScreen())),
            _quickActionCard("Main Menu", FeatherIcons.grid,
                CustomTheme.darkGreen, () => Get.to(() => MainMenuScreen())),
          ],
        ),
      ),
    );
  }

  Widget _quickActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    bool isAid = 'AI Assistant' == title;
    return FxContainer(
      onTap: onTap,
      border: isAid ? Border.all(color: CustomTheme.purple) : null,
      bordered: isAid ? true : false,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      borderRadiusAll: 16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxContainer(
            paddingAll: 12,
            borderRadiusAll: 99,
            color: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 24),
          ),
          Spacer(),
          FxText.bodyLarge(title,
              height: .9, fontWeight: 700, color: Colors.grey.shade800),
        ],
      ),
    );
  }

  Widget _buildMissingActivitiesWarning() {
    return SliverToBoxAdapter(
      child: FxContainer(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: CustomTheme.red.withOpacity(0.1),
        bordered: true,
        border: Border.all(color: CustomTheme.red.withOpacity(0.2)),
        borderRadiusAll: 12,
        onTap: () async {
          await Get.to(() => MyActivitiesList());
          doRefresh();
        },
        child: Row(
          children: [
            Icon(FeatherIcons.alertTriangle, color: CustomTheme.red, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: FxText.bodyMedium(
                "You have ${missing.length} overdue activities.",
                fontWeight: 600,
              ),
            ),
            FxText.bodySmall("View", fontWeight: 700),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesList() {
    if (items.isEmpty) {
      return _buildEmptyState("You have no activities yet.",
          "Create a garden activity to get started.");
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildActivityCard(items[index]),
    );
  }

  Widget _buildFinanceList() {
    if (items2.isEmpty) {
      return _buildEmptyState(
          "No financial records yet.", "Add an income or expense record.");
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: items2.length,
      itemBuilder: (context, index) => _buildTransactionCard(items2[index]),
    );
  }

  Widget _buildActivityCard(GardenActivity activity) {
    return FxContainer(
      margin: EdgeInsets.only(bottom: 16),
      paddingAll: 16,
      borderRadiusAll: 12,
      color: Colors.white,
      onTap: () => _showMyBottomSheetGardenActivityDetails(context, activity),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FxText.bodySmall("GARDEN: ${activity.garden_text}",
                    color: Colors.grey.shade600, fontWeight: 600),
              ),
              FxContainer(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: activity.bgColor.withOpacity(0.1),
                borderRadiusAll: 6,
                child: FxText.bodySmall(activity.temp_status.toUpperCase(),
                    color: activity.bgColor, fontWeight: 800),
              ),
            ],
          ),
          SizedBox(height: 8),
          FxText.bodyLarge(activity.activity_name,
              fontWeight: 700, color: Colors.grey.shade900),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(FeatherIcons.calendar,
                  color: Colors.grey.shade500, size: 14),
              SizedBox(width: 8),
              FxText.bodyMedium(
                activity.temp_status == 'Submitted'
                    ? "Done: ${Utils.to_date_1(activity.farmer_submission_date)}"
                    : "Due: ${Utils.to_date_1(activity.activity_due_date)}",
                color: Colors.grey.shade700,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTransactionCard(FinancialRecordModel transaction) {
    bool isIncome = transaction.isIncome();
    Color transactionColor = isIncome ? CustomTheme.green : CustomTheme.red;

    return FxContainer(
      margin: EdgeInsets.only(bottom: 16),
      borderRadiusAll: 12,
      color: Colors.white,
      onTap: () => _showMyBottomSheetTransactionDetails(context, transaction),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
                width: 6,
                decoration: BoxDecoration(
                    color: transactionColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12)))),
            SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FxText.bodyLarge(transaction.description,
                        fontWeight: 700,
                        color: Colors.grey.shade800,
                        maxLines: 1),
                    SizedBox(height: 4),
                    FxText.bodySmall(transaction.garden_text,
                        color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FxText.bodyLarge(
                      "UGX ${Utils.moneyFormat(transaction.amount)}",
                      fontWeight: 700,
                      color: transactionColor),
                  SizedBox(height: 4),
                  FxText.bodySmall(Utils.to_date_1(transaction.created_at),
                      color: Colors.grey.shade600),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FeatherIcons.fileText, color: Colors.grey.shade300, size: 60),
          SizedBox(height: 24),
          FxText.titleMedium(title,
              color: Colors.grey.shade700, fontWeight: 600),
          SizedBox(height: 8),
          FxText.bodyMedium(subtitle,
              color: Colors.grey.shade500, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  late Future<dynamic> futureInit;
  List<GardenActivity> items = [];
  List<GardenActivity> upcoming = [];
  List<GardenActivity> missing = [];
  List<GardenActivity> submitted = [];
  List<FinancialRecordModel> items2 = [];
  LoggedInUserModel loggedInUserModel = LoggedInUserModel();

  Future<dynamic> doRefresh() async {
    futureInit = myInit();
    if (mounted) setState(() {});
    return futureInit;
  }

  Future<dynamic> myInit() async {
    loggedInUserModel = await LoggedInUserModel.getLoggedInUser();
    mainController.loggedInUserModel = loggedInUserModel;

    var activityItems = await GardenActivity.get_items();
    var financialItems = await FinancialRecordModel.get_items();

    items = activityItems;
    items2 = financialItems;

    upcoming.clear();
    submitted.clear();
    missing.clear();

    for (var element in items) {
      element.getStatus();
      if (element.temp_status == "Submitted")
        submitted.add(element);
      else
        upcoming.add(element);
      if (element.temp_status == 'Missing') missing.add(element);
    }

    if (mounted) setState(() {});
    return "Done";
  }

  Future<bool> _onWillPop() async {
    Get.defaultDialog(
        title: "Confirm Exit",
        titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        middleText: "Are you sure you want to quit this App?",
        middleTextStyle: TextStyle(color: Colors.grey.shade700),
        backgroundColor: Colors.white,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                FxText('CANCEL', color: Colors.grey.shade700, fontWeight: 700),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: CustomTheme.red),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: FxText('QUIT', color: Colors.white, fontWeight: 700),
          )
        ]);
    return false;
  }

  void _showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        // Use isScrollControlled to allow the bottom sheet to take up more screen height if needed.
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        builder: (BuildContext buildContext) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            // Using a FractionallySizedBox to control the max height of the bottom sheet.
            child: FractionallySizedBox(
              heightFactor: 0.6,
              // The sheet will take up to 60% of the screen height.
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: FxText.titleLarge("Quick Actions",
                        fontWeight: 800, color: CustomTheme.primary),
                  ),
                  SizedBox(height: 20),
                  // The Flexible widget allows the ListView to take up the available space and become scrollable.
                  Flexible(
                    child: ListView(
                      // These are the scrollable items.
                      children: [
                        _buildBottomSheetItem(
                            context, "Register new garden", FeatherIcons.plus,
                            () async {
                          await Get.to(() => GardenCreateScreen(GardenModel()));
                          doRefresh();
                        }),
                        _buildBottomSheetItem(context, "Create garden activity",
                            FeatherIcons.plusCircle, () async {
                          await Get.to(() => GardenActivityCreateScreen());
                          doRefresh();
                        }),
                        _buildBottomSheetItem(
                            context,
                            "Create financial record",
                            FeatherIcons.dollarSign, () async {
                          await Get.to(() => TransactionCreateScreen());
                          doRefresh();
                        }),
                        _buildBottomSheetItem(
                            context,
                            "Sell your farm products",
                            FeatherIcons.shoppingCart, () async {
                          await Get.to(() => ProductCreateScreen());
                          doRefresh();
                        }),
                        _buildBottomSheetItem(
                            context, "Profile a Farmer", FeatherIcons.userPlus,
                            () async {
                          await Get.to(() =>
                              FarmerProfilingStep1Screen(FarmerOfflineModel()));
                          doRefresh();
                        }),
                        // You can add more items here, and the list will scroll.
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildBottomSheetItem(
      BuildContext context, String title, IconData icon, Function onTap) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        child: Row(
          children: [
            Icon(icon, color: CustomTheme.primary, size: 22),
            SizedBox(width: 16),
            Expanded(
              child: FxText.bodyLarge(title, color: Colors.grey.shade800),
            ),
          ],
        ),
      ),
    );
  }

  void _showMyBottomSheetGardenActivityDetails(
      context, GardenActivity activity) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext buildContext) {
          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (_, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FxText.titleLarge("ACTIVITY DETAILS",
                              color: Colors.black, fontWeight: 700),
                          InkWell(
                            child: Icon(FeatherIcons.x,
                                color: Colors.grey.shade600),
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.shade200, height: 1),
                    Expanded(
                        child: ListView(
                      controller: controller,
                      padding: EdgeInsets.all(16),
                      children: [
                        titleValueWidget2('ACTIVITY', activity.activity_name),
                        titleValueWidget2('GARDEN', activity.garden_text),
                        titleValueWidget2('DUE DATE',
                            Utils.to_date_1(activity.activity_due_date)),
                        titleValueWidget2(
                            'STATUS', activity.farmer_activity_status),
                        if (activity.farmer_has_submitted.toLowerCase() ==
                            "yes")
                          titleValueWidget2('DATE SUBMITTED',
                              Utils.to_date_1(activity.farmer_submission_date)),
                        titleValueWidget2('REMARKS', activity.farmer_comment),
                        Divider(color: Colors.grey.shade200),
                        FxText.titleMedium('DESCRIPTION',
                            fontWeight: 800, color: Colors.black),
                        SizedBox(height: 8),
                        FxText.bodyMedium(activity.activity_description,
                            color: Colors.grey.shade700),
                      ],
                    )),
                    if (activity.temp_status != 'Submitted')
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FxButton.block(
                          onPressed: () async {
                            Navigator.pop(context);
                            await Get.to(
                                () => GardenActivitySubmitScreen(activity));
                            doRefresh();
                          },
                          backgroundColor: CustomTheme.primary,
                          borderRadiusAll: 8,
                          child: FxText("SUBMIT ACTIVITY",
                              color: Colors.white, fontWeight: 700),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showMyBottomSheetTransactionDetails(
      context, FinancialRecordModel item) {
    showModalBottomSheet(
      context: context,
      // Use isScrollControlled to allow the bottom sheet to adapt to content size.
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      builder: (BuildContext buildContext) {
        bool isIncome = item.isIncome();
        return Padding(
          // Add padding for the safe area, e.g., for notches and the system navigation bar.
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Takes up minimum vertical space
              children: [
                // This is the non-scrollable header part of the bottom sheet.
                Icon(
                    isIncome
                        ? FeatherIcons.arrowDownCircle
                        : FeatherIcons.arrowUpCircle,
                    color: isIncome ? CustomTheme.green : CustomTheme.red,
                    size: 36),
                SizedBox(height: 8),
                FxText.titleLarge(item.category,
                    color: Colors.black, fontWeight: 700),
                SizedBox(height: 16),
                Divider(color: Colors.grey.shade200),
                // This Flexible widget makes the content below it scrollable.
                Flexible(
                  child: ListView(
                    shrinkWrap: true, // Important for ListView inside a Column
                    children: [
                      // These are the scrollable items.
                      _buildTransactionDetailRow(FeatherIcons.dollarSign,
                          'Amount', "UGX ${Utils.moneyFormat(item.amount)}"),
                      _buildTransactionDetailRow(FeatherIcons.calendar, 'Date',
                          Utils.to_date(item.created_at)),
                      _buildTransactionDetailRow(
                          FeatherIcons.archive, 'Garden', item.garden_text),
                      _buildTransactionDetailRow(FeatherIcons.messageSquare,
                          'Details', item.description),
                      // If you add more detail rows, they will also be part of the scrollable list.
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: CustomTheme.primary, size: 18),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.bodyMedium(title, color: Colors.grey.shade600),
                FxText.bodyLarge(value, color: Colors.black, fontWeight: 600),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Color(0xfff5f6fa),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
