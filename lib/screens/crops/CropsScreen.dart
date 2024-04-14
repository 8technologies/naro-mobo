import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/models/CropModel.dart';
import 'package:marcci/theme/app_theme.dart';
import 'package:marcci/utils/AppConfig.dart';

import '../../controllers/MainController.dart';
import '../../utils/Utils.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_widgets.dart';
import 'CropScreen.dart';

class CropsScreen extends StatefulWidget {
  Map<String, dynamic> params;

  CropsScreen(this.params, {super.key});

  @override
  CropsScreenState createState() => CropsScreenState();
}

class CropsScreenState extends State<CropsScreen> {
  final MainController mainController = Get.find<MainController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.params['isPicker'] != null) {
      isPick = widget.params['isPicker'];
    }
    my_init();
  }

  bool is_loading = false;
  bool search_mode = false;
  bool isPick = false;

  List<CropModel> allItems = [];
  List<CropModel> items = [];
  String search = "";

  Future<void> my_init() async {
    setState(() {
      is_loading = true;
    });

    items = await CropModel.get_items();
    print(items.length.toString());

    if (search.isEmpty) {
      items = await CropModel.get_items();
      if (items.isEmpty) {
        await CropModel.getOnlineItems();
        items = await CropModel.get_items();
      }
    } else {
      if (allItems.isEmpty) {
        allItems = await CropModel.get_items();
      }
      items.clear();
      //search in allItems as you add in items
      for (var item in allItems) {
        if (item.name.toLowerCase().contains(search.toLowerCase())) {
          items.add(item);
        }
      }
    }

    setState(() {
      is_loading = false;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    Utils.init_theme();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //logout();
            showModalBottomSheet(
                context: context,
                backgroundColor: CustomTheme.primary,
                isScrollControlled: true,
                builder: (BuildContext buildContext) {
                  return Container(
                    color: Colors.transparent,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              onTap: () async {
                                setState(() {});
                              },
                              leading: const Icon(
                                FeatherIcons.plus,
                                color: Colors.black,
                                size: 26,
                              ),
                              title: FxText.titleMedium(
                                "Register New Animal",
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
          },
          backgroundColor: CustomTheme.primary,
          clipBehavior: Clip.hardEdge,
          focusColor: CustomTheme.primary,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
          ),
        ),
        appBar: AppBar(
            backgroundColor: CustomTheme.primary,
            title: Column(
              children: [
                search_mode
                    ? TextField(
                        autofocus: true,
                        onChanged: (v) {
                          setState(() {
                            search = v.toString();
                          });
                          my_init();
                        },
                        decoration: const InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: InputBorder.none,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.titleLarge(
                            "Groundnut varieties",
                            fontWeight: 800,
                            color: Colors.white,
                            height: 1.0,
                          ),
                          FxText.bodySmall(
                            "${items.length} Groundnut varieties found.",
                            fontWeight: 600,
                            color: Colors.white,
                          )
                        ],
                      ),
              ],
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: search_mode
                    ? const Icon(
                        Icons.close,
                        size: 35,
                      )
                    : const Icon(
                        Icons.search,
                        size: 35,
                      ),
                onPressed: () {
                  setState(() {
                    search_mode = !search_mode;
                  });
                },
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              )
            ]),
        body: RefreshIndicator(
          onRefresh: my_init,
          color: CustomTheme.primary,
          backgroundColor: MyColors.accent,
          child: is_loading
              ? listLoader()
              : items.isEmpty
                  ? noItemWidget('No items found', () {
                      my_init();
                    })
                  : ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          height: 1,
                          color: Colors.grey[300],
                        );
                      },
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        CropModel item = items[index];
                        return InkWell(
                          onTap: () async {
                            if (isPick) {
                              Navigator.pop(context, item);
                              return;
                            }

                            Get.to(() => CropScreen(item));

                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 7,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxContainer(
                                  borderRadiusAll: 10,
                                  paddingAll: 2,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: true
                                        ? roundedImage(
                                            "${AppConfig.STORAGE_URL}/${item.photo}",
                                            4,
                                            5,
                                          )
                                        : Image(
                                            image:
                                                AssetImage(AppConfig.NO_IMAGE),
                                            width: 65,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FxText.titleLarge(
                                      item.name,
                                      fontWeight: 800,
                                      color: Colors.black,
                                      height: 1.0,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: FxText(item.name.toUpperCase(),
                                              fontWeight: 900,
                                              fontSize: 12,
                                              color: MyColors.accent),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ));
  }
}
