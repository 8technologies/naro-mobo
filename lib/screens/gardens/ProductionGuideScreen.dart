import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:marcci/models/CropModel.dart';
import 'package:marcci/screens/gardens/GardenCreateScreen.dart';
import 'package:marcci/utils/AppConfig.dart';

import '../../marcci_models/ProtocolModel.dart';
import '../../models/GardenModel.dart';
import '../../sections/widgets.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/my_widgets.dart';

class ProductionGuideScreen extends StatefulWidget {
  final CropModel crop;

  const ProductionGuideScreen(this.crop);

  @override
  _CourseTasksScreenState createState() => _CourseTasksScreenState();
}

class _CourseTasksScreenState extends State<ProductionGuideScreen> {
  late ThemeData themeData;

  _CourseTasksScreenState();

  late Future<dynamic> futureInit;

  Future<dynamic> _my_init() async {
    futureInit = my_init();
    setState(() {});
    return "done";
  }

  CropModel item = CropModel();

  Future<dynamic> my_init() async {
    item = widget.crop;

    setState(() {});
    return "Done";
  }

  @override
  void initState() {
    _my_init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        titleSpacing: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        actions: [
          InkWell(
            onTap: () {
              PopupMenuButton<int>(
                  onSelected: (x) {
                    switch (x.toString()) {
                      case '1':
                        break;
                      case '2':
                        break;

                      case '3':
                        break;
                    }
                  },
                  icon: const Icon(
                    FeatherIcons.moreVertical,
                    size: 25,
                    color: Colors.white,
                  ),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Icon(
                                FeatherIcons.user,
                                color: CustomTheme.primary,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  child: FxText.bodyLarge('Edit bio data')),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Row(
                            children: [
                              Icon(
                                FeatherIcons.camera,
                                color: CustomTheme.primary,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              FxText.bodyLarge('Update photo'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 3,
                          child: Row(
                            children: [
                              Icon(
                                FeatherIcons.edit3,
                                color: CustomTheme.primary,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              FxText.bodyLarge('Edit guardian'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 4,
                          child: Row(
                            children: [
                              Icon(
                                FeatherIcons.smile,
                                color: Colors.green.shade700,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              FxText.bodyLarge('Add good record'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 9,
                          child: Row(
                            children: [
                              Icon(
                                FeatherIcons.frown,
                                color: Colors.red.shade700,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              FxText.bodyLarge('Report indiscipline'),
                            ],
                          ),
                        ),
                      ]);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 25),
              child: InkWell(
                onTap: () {
                  _showBottomSheet(context);
                },
                child: const Icon(
                  FeatherIcons.plus,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
        // remove back button in appbar.

        title: FxText.titleLarge(
          "${item.name}",
          color: Colors.white,
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            toolbarHeight: 48,
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*-------------- Build Tabs here ------------------*/
                TabBar(
                  padding: EdgeInsets.only(bottom: 0),
                  labelPadding: EdgeInsets.only(bottom: 2, left: 8, right: 8),
                  indicatorPadding: EdgeInsets.all(0),
                  labelColor: CustomTheme.primary,
                  isScrollable: true,
                  enableFeedback: true,
                  indicator: UnderlineTabIndicator(
                      borderSide:
                          BorderSide(color: CustomTheme.primary, width: 4)),
                  tabs: [
                    Tab(
                        height: 30,
                        child: FxText.titleMedium(
                          "SUMMARY".toUpperCase(),
                          fontWeight: 800,
                          color: CustomTheme.primary,
                        )),
                    Tab(
                        height: 30,
                        child: FxText.titleMedium(
                            "Production Guide".toUpperCase(),
                            fontWeight: 800,
                            color: CustomTheme.primary)),
                  ],
                )
              ],
            ),
          ),

          /*--------------- Build Tab body here -------------------*/
          body: TabBarView(
            children: <Widget>[
              FutureBuilder(
                  future: futureInit,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return myListLoaderWidget(context);
                      default:
                        return mainFragment();
                    }
                  }),
              RefreshIndicator(
                color: CustomTheme.primary,
                backgroundColor: Colors.white,
                onRefresh: () async {
                  //item.getProtocols();
                  setState(() {});
                },
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          //ProtocolModel pro = item.protocols_list[index];
                          ProtocolModel pro = ProtocolModel();
                          return Container(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flex(
                                  direction: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FxText.titleLarge(
                                      pro.step + '. ',
                                      fontWeight: 900,
                                      color: CustomTheme.primary,
                                      fontSize: 30,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          FxText.titleLarge(
                                            pro.activity_name,
                                            fontWeight: 800,
                                            color: Colors.black,
                                          ),
                                          Divider(
                                            color: CustomTheme.primary,
                                          ),
                                          !pro.days_before_planting.contains('null') ?titleValueWidget2(
                                              "DAYS BEFORE PLANTING",
                                              pro.days_before_planting):
                                          titleValueWidget2(
                                              "DAYS AFTER PLANTING",
                                              pro.days_after_planting),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          FxText(pro.description)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: [2, 2].length,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  mainFragment() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: AppConfig.STORAGE_URL + item.photo,
                  errorWidget: (context, url, error) => Image(
                    image: AssetImage(AppConfig.NO_IMAGE),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              FxText(item.details),
            ],
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GardenCreateScreen(GardenModel())));
                      },
                      leading: Icon(
                        FeatherIcons.plus,
                        color: CustomTheme.primary,
                        size: 26,
                      ),
                      title: FxText.titleMedium(
                        "Create ${item.name} Garden",
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
}
