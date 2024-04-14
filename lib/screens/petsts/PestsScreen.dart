import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/models/PestsAndDiseaseModel.dart';
import 'package:marcci/theme/app_theme.dart';
import 'package:marcci/utils/AppConfig.dart';

import '../../controllers/MainController.dart';
import '../../utils/Utils.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_widgets.dart';
import 'PestScreen.dart';

class PestsScreen extends StatefulWidget {
  Map<String, dynamic> params;

  PestsScreen(this.params, {super.key});

  @override
  PestsScreenState createState() => PestsScreenState();
}

class PestsScreenState extends State<PestsScreen> {
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

  List<PestsAndDiseaseModel> allItems = [];
  List<PestsAndDiseaseModel> items = [];
  String search = "";

  Future<void> my_init() async {
    setState(() {
      is_loading = true;
    });

    items = await PestsAndDiseaseModel.get_items();
    print(items.length.toString());

    if (search.isEmpty) {
      items = await PestsAndDiseaseModel.get_items();
      if (items.isEmpty) {
        await PestsAndDiseaseModel.getOnlineItems();
        items = await PestsAndDiseaseModel.get_items();
      }
    } else {
      if (allItems.isEmpty) {
        allItems = await PestsAndDiseaseModel.get_items();
      }
      items.clear();
      //search in allItems as you add in items
      for (var item in allItems) {
        if (item.category.toLowerCase().contains(search.toLowerCase())) {
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
                            "Pests & Diseases",
                            fontWeight: 800,
                            color: Colors.white,
                            height: 1.0,
                          ),
                          FxText.bodySmall(
                            "${items.length} items found",
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
                        PestsAndDiseaseModel item = items[index];
                        return InkWell(
                          onTap: () async {
                            if (isPick) {
                              Navigator.pop(context, item);
                              return;
                            }
                            Get.to(() => PestScreen(item));
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
                                      item.category,
                                      fontWeight: 800,
                                      color: Colors.black,
                                      height: 1.0,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: FxText(
                                              item.category.toUpperCase(),
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
