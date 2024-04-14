import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/models/FarmerOfflineModel.dart';
import 'package:marcci/theme/app_theme.dart';

import '../../models/FarmModel.dart';
import '../../utils/Utils.dart';
import 'FarmerDetailsScreen.dart';
import 'FarmerProfilingStep1Screen.dart';
import 'OfflineFarmersScreen.dart';

class FarmersScreen extends StatefulWidget {
  const FarmersScreen({super.key});

  @override
  State<FarmersScreen> createState() => _FarmersScreenState();
}

class _FarmersScreenState extends State<FarmersScreen> {
  var futureInit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureInit = doRefresh();
  }

  Future<void> doRefresh() async {
    farmers = await FarmModel.get_items();
    localFarmers = await FarmerOfflineModel.get_items();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FxText.titleLarge(
          "Enrolled Farmers",
          color: Colors.white,
        ),
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => FarmerProfilingStep1Screen(FarmerOfflineModel()));
            },
            icon: const Icon(
              Icons.add,
              size: 35,
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      backgroundColor: Colors.white,
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
          },
        ),
      ),
    );
  }

  List<FarmerOfflineModel> localFarmers = [];
  List<FarmModel> farmers = [];

  Widget mainWidget() {
    return Column(
      children: [
        Expanded(
          child: farmers.isEmpty
              ? emptyListWidget('No offline farmers found.', 'Refresh', () {
                  doRefresh();
                })
              : RefreshIndicator(
                  onRefresh: () {
                    return doRefresh();
                  },
                  backgroundColor: Colors.white,
                  child: ListView.builder(
                    itemCount: farmers.length,
                    itemBuilder: (context, index) {
                      FarmModel farmer = farmers[index];
                      return InkWell(
                        onTap: () {
                          Get.to(() => FarmerDetailsScreen(farmer));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 10,
                          ),
                          child: FxContainer.bordered(
                            paddingAll: 10,
                            borderRadiusAll: 10,
                            border: Border.all(
                              color: CustomTheme.primary,
                              width: 1,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 40,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FxText.titleLarge(
                                        "${farmer.getFullName()}",
                                        fontWeight: 800,
                                        color: Colors.black,
                                      ),
                                      FxText.bodySmall(
                                        "Phone: ${farmer.getPhone()}",
                                        fontWeight: 600,
                                      ),
                                      FxText.bodySmall(
                                        "PARISH: ${farmer.parish_text}",
                                        fontWeight: 600,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
        localFarmers.isEmpty
            ? SizedBox()
            : FxContainer(
                onTap: () {
                  Get.to(() => OfflineFarmersScreen());
                },
                color: Colors.red,
                borderRadiusAll: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FxText.bodyLarge(
                      "There are ${localFarmers.length} farmers pending for upload",
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
      ],
    );
  }

  void submit_all() async {
    Utils.showLoader(false);
    try {
      for (FarmerOfflineModel farmer in localFarmers) {
        farmer.ready_for_upload = 'Yes';
        String x = await farmer.submitSelf();
        if (x.isEmpty) {
          Utils.toast('Submitted successfully');
          farmer.delete();
        } else {
          Utils.toast(x, color: Colors.red);
        }
      }
    } catch (e) {
      Utils.toast('An error occurred', color: Colors.red);
    }
    Utils.hideLoader();
    doRefresh();
  }
}

emptyListWidget(String s, String t, Null Function() param2) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FxText.titleLarge(
          s,
          fontWeight: 600,
        ),
        const SizedBox(
          height: 10,
        ),
        FxContainer(
          onTap: param2,
          paddingAll: 10,
          borderRadiusAll: 5,
          color: CustomTheme.primary,
          child: FxText.bodyLarge(
            t,
            color: Colors.white,
          ),
        )
      ],
    ),
  );
}
