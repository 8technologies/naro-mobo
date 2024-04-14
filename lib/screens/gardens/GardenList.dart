import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/models/GardenModel.dart';
import 'package:marcci/theme/app_theme.dart';

import '../../sections/widgets.dart';
import 'GardenCreateScreen.dart';
import 'GardenScreen.dart';

class GardenList extends StatefulWidget {
  bool isPick;
  GardenList(this.isPick, {Key? key}) : super(key: key);
  @override
  _GardenListState createState() => _GardenListState();
}

class _GardenListState extends State<GardenList>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    doRefresh();
  }

  bool isPick = false;

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
              Get.to(() => GardenCreateScreen(GardenModel()));
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.add,
                size: 40,
                color: Colors.white,
              ),
            ),
          )
        ],
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          "My Gardens",
          color: Colors.white,
          maxLines: 2,
        ),
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
    );
  }

  Widget mainWidget() {
    if (items.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FxText.titleLarge(
              "No Gardens",
              color: Colors.black,
              fontWeight: 900,
            ),
            FxText.bodyLarge(
              "You have not created any gardens yet.",
              height: 1,
              fontWeight: 600,
              color: Colors.grey.shade700,
            ),
            const SizedBox(
              height: 25,
            ),
            FxButton(
              onPressed: () {
                doRefresh();
              },
              borderRadiusAll: 100,
              backgroundColor: CustomTheme.primary,
              borderRadius: BorderRadius.circular(50),
              child: Text(
                'Refresh',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
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
                  GardenModel m = items[index];
                  return InkWell(
                      onTap: () {
                        if (widget.isPick) {
                          Get.back(result: m);
                          return;
                        }
                        Get.to(() => GardenScreen(items[index]));
                      },
                      child: gardenWidget(m));
                },
                childCount: items.length, // 1000 list items
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

  List<GardenModel> items = [];

  Future<dynamic> myInit() async {
    items = await GardenModel.get_items();
    print("items.length: ${items.length}");
    if (items.isEmpty) {
      await GardenModel.getOnlineItems();
      items = await GardenModel.get_items();
    }
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
}
