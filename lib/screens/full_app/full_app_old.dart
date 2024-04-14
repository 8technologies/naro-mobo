import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/controllers/MainController.dart';
import 'package:marcci/models/LoggedInUserModel.dart';
import 'package:marcci/screens/full_app/section/AccountSection.dart';
import 'package:marcci/screens/gardens/GardenCreateScreen.dart';
import 'package:marcci/screens/gardens/MyActivitiesCalender.dart';
import 'package:marcci/theme/app_theme.dart';

import '../../controllers/full_app_controller.dart';
import '../../models/GardenActivity.dart';
import '../../models/GardenModel.dart';
import '../../models/MenuItem.dart';
import '../../utils/Utils.dart';
import '../gardens/GardenList.dart';
import '../gardens/MyActivitiesList.dart';
import '../gardens/ProductionGuide.dart';
import '../products/ProductCreateScreen.dart';
import '../products/ProductsScreen.dart';
import 'WeatherForeCastScreen.dart';

class FullAppOld extends StatefulWidget {
  const FullAppOld({Key? key}) : super(key: key);

  @override
  _FullAppOldState createState() => _FullAppOldState();
}

class _FullAppOldState extends State<FullAppOld> with SingleTickerProviderStateMixin {
  late ThemeData theme;

  late FullAppController controller;
  final MainController mainController = Get.put(MainController());

  @override
  void initState() {
    super.initState();


    theme = AppTheme.shoppingTheme;
    controller = FxControllerStore.putOrFind(FullAppController(this));
    mainController.initialized;
    mainController.init();
    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    menuItems = [
      MenuItem('Production Guides', 'T 1', null, '5.jpg', () {
        Get.to(() => GardenList(false));
      }),
      MenuItem('My Gardens', 'T 1', null, '4.jpg', () {
        Get.to(() => ProductionGuidesScreen({}));
      }),
      MenuItem('Weather Forecast', 'T 1', null, 'rain.png', () {
        Get.to(() => const WeatherForeCastScreen());
      }),
      MenuItem('Market Place', 'T 1', null, '2.jpg', () {
        Get.to(() => const ProductsScreen());
      }),
      MenuItem('Farmers Forum', 'T 1', null, '1.jpg', () {
        Utils.toast("Coming soon...");
        //Get.to(() => const PWDList());
      }),
    ];

    return Scaffold(
      backgroundColor: Color.fromRGBO(233, 243, 233, 1.0),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: CustomTheme.primary,
          elevation: 10,
          onPressed: () {
            Get.to(() => AccountSection());
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
                  "MORE",
                  fontWeight: 800,
                  color: Colors.white,
                ),
              ),
            ],
          )),
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

  Widget mainWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: 15,
          ),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        FxText.titleLarge(
                          'Hello ',
                          fontWeight: 300,
                          textAlign: TextAlign.left,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: FxText.titleLarge(
                            '${loggedInUserModel.name} '.toUpperCase(),
                            fontWeight: 900,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            color: CustomTheme.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        FxCard(
          margin: EdgeInsets.symmetric(horizontal: 10),
          color: missing.isNotEmpty
              ? Colors.red.shade700
              : upcoming.isNotEmpty
              ? Colors.orange.shade700
              : CustomTheme.primary,
          width: double.infinity,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.titleLarge(
                    'My Activities',
                    fontWeight: 800,
                    color: Colors.white,
                  ),
                  FxCard(
                      onTap: () {
                        Get.to(() => const MyActivitiesCalednderScreen());
                      },
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Row(
                        children: [
                          FxText.bodySmall(
                            'Do Action',
                            fontWeight: 800,
                            color: Colors.black,
                          ),
                          const Icon(
                            FeatherIcons.chevronRight,
                            size: 18,
                            color: Colors.black,
                          )
                        ],
                      ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              FxText.bodyMedium(
                missing.isNotEmpty
                    ? 'You have ${missing.length} activities missing for submission. Please submit your activities. 😢'
                    : upcoming.isNotEmpty
                    ? 'You have ${upcoming.length} upcoming activities. Please remember to submit your activities in time. ⏰'
                    : 'You have no any missing or pending activities. Keep it up! 👍',
                color: Colors.white,
                fontWeight: 700,
              )
            ],
          ),
        ),
        FxCard(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          color: Colors.white,
          width: double.infinity,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  actionButton('Create Garden', FeatherIcons.plus,
                      () => {Get.to(() => GardenCreateScreen(GardenModel()))}),
                  actionButton('My Activities', FeatherIcons.calendar,
                      () => {Get.to(() => MyActivitiesList())}),
                  actionButton(
                      'Sell Seed',
                      FeatherIcons.tag,
                      () => {
                            Get.to(() => ProductCreateScreen()),
                          }),
                  actionButton('Ask Expert', Icons.question_mark,
                      () => {Utils.toast('Coming Soon...')}),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: RefreshIndicator(
              onRefresh: doRefresh,
              color: CustomTheme.primary,
              backgroundColor: Colors.white,
              child: CustomScrollView(
                slivers: [
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        MenuItem item = menuItems[index];
                        return FxContainer(
                          width: (Get.width / 6),
                          height: (Get.width / 6),
                          borderRadiusAll: 10,
                          borderColor: CustomTheme.primary,
                          bordered: true,
                          onTap: () {
                            item.f();
                          },
                          color: Colors.white,
                          paddingAll: 0,
                          alignment: Alignment.bottomLeft,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Positioned(
                                top: 5,
                                child: Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/${item.img}',
                                    ),
                                    fit: BoxFit.cover,
                                    width: (MediaQuery.of(context).size.width /
                                        4.5),
                                  ),
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  width: (Get.width / 2.5),
                                  alignment: Alignment.center,
                                  child: FxText.titleLarge(
                                    item.title,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    maxLines: 2,
                                    height: 1,
                                    color: Colors.black,
                                    fontWeight: 900,
                                  ),
                                ),
                                bottom: 10,
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: menuItems.length,
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

  List<GardenActivity> items = [];
  List<GardenActivity> upcoming = [];
  List<GardenActivity> missing = [];
  List<GardenActivity> submitted = [];

  List<MenuItem> menuItems = [];
  LoggedInUserModel loggedInUserModel = LoggedInUserModel();

  Future<dynamic> myInit() async {
    loggedInUserModel = await LoggedInUserModel.getLoggedInUser();
    items = await GardenActivity.get_items();
    upcoming.clear();
    submitted.clear();
    missing.clear();
    items.forEach((element) {
      element.getStatus();
      if (element.temp_status == "Submitted") {
        submitted.add(element);
      } else if (element.temp_status == "Missing") {
        missing.add(element);
      } else {
        upcoming.add(element);
      }
    });
    setState(() {});

    return "Done";
  }

  menuItemWidget(String title, String subTitle, String icon, Function f) {
    return InkWell(
      onTap: () {
        f();
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          border: Border.all(color: CustomTheme.primary),
          borderRadius: BorderRadius.all(Radius.circular(10)),
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
          SizedBox(
            height: 5,
          ),
          Icon(
            icon,
            size: 35,
            color: CustomTheme.primary,
          ),
          SizedBox(
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
}
