import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/theme/app_theme.dart';

import '../../models/GardenModel.dart';
import '../../sections/widgets.dart';
import 'GardenCreateScreen.dart';

class ProductionGuidesScreen extends StatefulWidget {
  Map<String, String> params = {};

  ProductionGuidesScreen(this.params, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductionGuidesScreenState createState() => _ProductionGuidesScreenState();
}

class _ProductionGuidesScreenState extends State<ProductionGuidesScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    if (widget.params.containsKey("isPick")) {
      isPick = true;
    }
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
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => GardenCreateScreen(GardenModel()));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.add,
                size: 40,
                color: Colors.white,
              ),
            ),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.titleLarge(
              isPick ? "Select Garden" : "My Gardens",
              color: Colors.white,
              maxLines: 1,
              height: 1.2,
            ),
            FxText.bodySmall(
              "${gardens.length} Gardens",
              color: Colors.white,
            ),
          ],
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
    if(gardens.length == 0){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FxText.titleLarge(
              "No Gardens",
              color: Colors.grey.shade600,
              fontWeight: 800,
            ),
            FxText.bodyLarge(
              "You have not created any gardens yet",
              color: Colors.grey.shade600,
              fontWeight: 600,
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
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
                    children: const [
                      SizedBox(
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
                  GardenModel m = gardens[index];
                  return InkWell(
                      onTap: () {
                        if (isPick) {
                          Navigator.pop(context, m);
                        } else {
                          //Get.to(() => GardenCreateScreen(m));
                        }
                      },
                      child: gardenWidget(m));
                },
                childCount: gardens.length, // 1000 list items
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

  List<GardenModel> gardens = [];

  Future<dynamic> myInit() async {
    gardens = await GardenModel.get_items();
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
