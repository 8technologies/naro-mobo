import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/screens/ai/AIHomeScreen.dart';
import 'package:marcci/screens/full_app/section/AccountSection.dart';
import 'package:marcci/screens/gardens/GardenList.dart';
import 'package:marcci/theme/app_theme.dart';

import '../account/About8TechScreen.dart';
import '../account/AboutNaroScreen.dart';
import '../crops/CropsScreen.dart';
import '../finance/TransactionCreateScreen.dart';
import '../finance/TransactionList.dart';
import '../forms/FarmersScreen.dart';
import '../gardens/MyActivitiesList.dart';
import '../petsts/PestReportsScreen.dart';
import '../petsts/PestsScreen.dart';
import '../products/ProductsScreen.dart';
import '../service_providers/ServiceProvidersScreen.dart';
import 'WeatherForeCastScreen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: CustomTheme.primary,
        title: Text(
          "Main Menu",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: true
          ? Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: menuItemWidget(
                              'My Gardens',
                              'Simple and easy to manage your gardens.',
                              'gardens.png',
                              () {
                                Get.to(() => GardenList(false));
                              },
                            )),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: menuItemWidget(
                              'My Activities',
                              'Digitalize your farm activities and records.',
                              'activity.png',
                              () {
                                Get.to(() => MyActivitiesList());
                              },
                            )),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: menuItemWidget(
                              'Fiance',
                              'Manage your income and expenses.',
                              'finance.png',
                              () {
                                Get.to(() => TransactionListScreen());
                              },
                            )),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: menuItemWidget(
                              'Pests & Disease Reports',
                              'Learn about pests and diseases, reports and management.',
                              'pests.png',
                              () {
                                Get.to(() => PestsScreen({}));
                              },
                            )),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: menuItemWidget(
                              'Marketplace',
                              'Buy and sell farm products and services.',
                              'market.png',
                              () {
                                Get.to(() => ProductsScreen());
                              },
                            )),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: menuItemWidget(
                              'Crops & Seeds',
                              'Discover the best crops and seeds for your farm.',
                              'seeds.png',
                              () {
                                Get.to(() => CropsScreen({}));
                              },
                            )),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: menuItemWidget(
                              'Service Providers',
                              'Simple and easy to manage your gardens.',
                              'farmers.png',
                              () {
                                Get.to(() => ServiceProvidersScreen());
                              },
                            )),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: menuItemWidget(
                              'Report Pests & Diseases',
                              'Digitalize your farm activities and records.',
                              'pests.png',
                              () {
                                Get.to(() => PestReportsScreen({}));
                              },
                            )),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: menuItemWidget(
                              'Weather Information',
                              'Get the latest weather information for your farm.',
                              'weather.png',
                              () {
                                Get.to(() => const WeatherForeCastScreen());
                              },
                            )),
                            SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: menuItemWidget(
                                'AI Assistance',
                                'Get AI assistance for your farm activities.',
                                'icon-ai.gif',
                                () {
                                  Get.to(() => AIHomeScreen());
                                },
                                hasBg: true,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: menuItemWidget(
                              'Farmers',
                              'Farmer profiling and networking.',
                              'farmers.png',
                              () {
                                Get.to(() => FarmersScreen());
                              },
                            )),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: menuItemWidget(
                              'My Account',
                              'Manage your account and profile.',
                              'user.png',
                              () {
                                Get.to(() => AccountSection());
                              },
                            )),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: menuItemWidget(
                              '8Technologies',
                              'Learn about 8Tech Consults and its services.',
                              '8tech.png',
                              () {
                                Get.to(() => About8TechScreen());
                              },
                            )),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: menuItemWidget(
                              'NARO',
                              'About NARO and its services.',
                              'logo.png',
                              () {
                                Get.to(() => AboutNaroScreen());
                              },
                            )),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 10,
                  color: CustomTheme.primary,
                ),
                Divider(
                  height: 0,
                  thickness: 5,
                  color: CustomTheme.accent,
                ),
                Container(
                  height: 25,
                  color: CustomTheme.primary,
                  child: Center(
                    child: FxText.bodySmall(
                      "Powered by NARO - (c) ${DateTime.now().year} ",
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: Text("Financial Record Create"),
                    trailing: Icon(Icons.add),
                    onTap: () {
                      Get.to(() => TransactionCreateScreen());
                    },
                  ),
                  ListTile(
                    title: Text("Pests & Disease Reports"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Get.to(() => PestReportsScreen({}));
                    },
                  ),
                  ListTile(
                    title: Text("Pests & Diseases"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Get.to(() => PestsScreen({}));
                    },
                  ),
                  ListTile(
                    title: Text("Gardens"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Get.to(() => GardenList(false));
                    },
                  ),
                  ListTile(
                    title: Text("Crops & Seeds"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Get.to(() => CropsScreen({}));
                    },
                  ),
                  ListTile(
                    title: Text("Market Place"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Get.to(() => ProductsScreen());
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

menuItemWidget(
  String t,
  String s,
  String i,
  Function onTap, {
  bool hasBg = false,
}) {
  return FxContainer(
    onTap: () {
      onTap();
    },
    height: Get.width / 5,
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 2,
    ),
    color: hasBg ? Colors.blue : Colors.white,
    child: Row(
      children: [
        Image(
          image: AssetImage("assets/images/$i"),
          fit: BoxFit.cover,
          width: Get.width / 9,
          height: Get.width / 9,
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.titleMedium(
              t,
              color: hasBg ? Colors.white : Colors.black,
              fontWeight: 900,
              maxLines: 1,
              letterSpacing: 0.001,
              overflow: TextOverflow.ellipsis,
            ),
            FxText.bodySmall(
              s,
              fontWeight: 400,
              height: 1,
              color: hasBg ? Colors.grey.shade50 : Colors.black,
              letterSpacing: 0.01,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ],
        )),
      ],
    ),
    bordered: true,
    border: Border.all(
      color: hasBg ? Colors.blue.shade700 : CustomTheme.primary,
      width: 2,
    ),
  );
}
