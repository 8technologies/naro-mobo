import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/models/FarmerOfflineModel.dart';
import 'package:marcci/theme/app_theme.dart';

import '../../utils/Utils.dart';
import 'FarmerProfilingStep1Screen.dart';

class OfflineFarmersScreen extends StatefulWidget {
  const OfflineFarmersScreen({super.key});

  @override
  State<OfflineFarmersScreen> createState() => _OfflineFarmersScreenState();
}

class _OfflineFarmersScreenState extends State<OfflineFarmersScreen> {
  var futureInit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureInit = doRefresh();
  }

  Future<void> doRefresh() async {
    localFarmers = await FarmerOfflineModel.get_items();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FxText.titleLarge(
          "Offline Farmers",
          color: Colors.white,
        ),
        backgroundColor: CustomTheme.primary,
        elevation: 0,
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

  Widget mainWidget() {
    return Column(
      children: [
        Expanded(
          child: localFarmers.isEmpty
              ? emptyListWidget('No offline farmers found.', 'Refresh', () {
                  doRefresh();
                })
              : RefreshIndicator(
                  onRefresh: () {
                    return doRefresh();
                  },
                  backgroundColor: Colors.white,
                  child: ListView.builder(
                    itemCount: localFarmers.length,
                    itemBuilder: (context, index) {
                      FarmerOfflineModel farmer = localFarmers[index];
                      return InkWell(
                        onTap: () {
                          //show bottom sheet with options of edit or delete
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.edit),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        await Get.to(
                                            () => FarmerProfilingStep1Screen(
                                                  localFarmers[index],
                                                ));
                                        doRefresh();
                                        setState(() {});
                                      },
                                      title: FxText.titleLarge(
                                        "Edit",
                                        color: Colors.black,
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onTap: () {
                                        //delete
                                        farmer.delete();
                                        doRefresh();
                                        doRefresh();
                                        Navigator.pop(context);
                                      },
                                      title: FxText.titleLarge(
                                        "Delete",
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
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
                                        "STATUS: ${farmer.getStatus()}",
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
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: FxButton.block(
              padding: const EdgeInsets.all(16),
              borderRadiusAll: 12,
              onPressed: () {
                submit_all();
              },
              block: false,
              backgroundColor: CustomTheme.primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FxText.titleLarge(
                    'SUBMIT ALL NOW',
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    FeatherIcons.upload,
                    color: Colors.white,
                  )
                ],
              )),
        ),
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
