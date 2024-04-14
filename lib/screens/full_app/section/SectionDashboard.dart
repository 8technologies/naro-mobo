import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/controllers/MainController.dart';

import '../../../controllers/SectionDashboardController.dart';
import '../../../sections/widgets.dart';
import '../../../theme/app_theme.dart';
import '../../subjects/SubjectsScreen.dart';

class SectionDashboard extends StatefulWidget {
  MainController mainController;

  SectionDashboard(this.mainController, {Key? key}) : super(key: key);

  @override
  _SectionDashboardState createState() => _SectionDashboardState();
}

class _SectionDashboardState extends State<SectionDashboard> {
  late ThemeData theme;
  late SectionDashboardController controller;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.shoppingManagerTheme;
    controller = FxControllerStore.putOrFind(SectionDashboardController());
    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: CustomTheme.primary,
        onPressed: () {
          UserModel.getItems();
          //widget.mainController.getMyClasses();
          //MyClasses.getItems();
        },
        child: const Icon(
          FeatherIcons.plus,
          size: 25,
        ),
      ),*/
      body: FutureBuilder(
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
    );
  }

  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();

    setState(() {});
  }

  Future<dynamic> myInit() async {

    return "Done";
  }

  Widget mainWidget() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 18,
            bottom: 15,
          ),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: [
              const Icon(FeatherIcons.settings),
              FxText.titleLarge(
                'NUDIPU'.toUpperCase(),
                maxLines: 1,
                fontWeight: 800,
                color: CustomTheme.primaryDark,
              ),
              Icon(FeatherIcons.user),
            ],
          ),
        ),
        const Divider(
          height: 0,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: RefreshIndicator(
              onRefresh: doRefresh,
              color: CustomTheme.primary,
              backgroundColor: Colors.white,
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return titleWidget('My Top Subjects', () {
                            Get.to(() => SubjectsScreen());
                          });
                        },
                        childCount: 1, // 1000 list items
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
