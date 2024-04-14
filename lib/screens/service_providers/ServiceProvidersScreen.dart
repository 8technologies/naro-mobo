import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../models/ServiceProvider.dart';
import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import 'ServiceProviderScreen.dart';

class ServiceProvidersScreen extends StatefulWidget {
  const ServiceProvidersScreen({Key? key}) : super(key: key);

  @override
  _ServiceProvidersScreenState createState() => _ServiceProvidersScreenState();
}

class _ServiceProvidersScreenState extends State<ServiceProvidersScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();

    doRefresh();
  }

  bool search = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                search = !search;
              });
              //Get.to(() => SearchScreen());
            },
            icon: search
                ? Icon(
                    FeatherIcons.x,
                    color: Colors.white,
                  )
                : Icon(
                    FeatherIcons.search,
                    color: Colors.white,
                  ),
          ),
          //pop up menu filter by
          PopupMenuButton(
            icon: Icon(
              FeatherIcons.filter,
              color: Colors.white,
            ),
            onSelected: (value) {
              if (value == 1) {
                Utils.toast("Filter by District");
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 1,
                  child: FxText.titleLarge(
                    "Filter by District",
                    fontWeight: 800,
                  ),
                ),
              ];
            },
          ),
        ],
        title: search
            ? Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                child: FxTextField(
                  hintText: "Search",
                  filled: true,
                  onChanged: (String value) {
                    keyWord = value.toString();
                    myInit();
                  },
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    FeatherIcons.search,
                    size: 20,
                    color: CustomTheme.primary,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    hintText: "Search",
                    hintStyle: TextStyle(
                      color: CustomTheme.primary,
                    ),
                  ),
                ),
              )
            : FxText.titleLarge(
                "Service Providers",
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
                  ServiceProvider m = items[index];
                  return productWidget(m);
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

  List<ServiceProvider> items = [];

  String keyWord = "";
  Future<dynamic> myInit() async {
    if (keyWord.isNotEmpty) {
      items = await ServiceProvider.get_items(
          where:
              "business_name like '%$keyWord%' OR services_offered like '%$keyWord%' OR provider_name like '%$keyWord%'");
    } else {
      items = await ServiceProvider.get_items();
    }
    setState(() {});

    return "Done";
  }

  Widget productWidget(ServiceProvider u) {
    return InkWell(
      onTap: () {
        Get.to(() => ServiceProviderScreen(u));
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 5, right: 5),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            roundedImage(u.getPhoto().toString(), 4.5, 4.5),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.titleMedium(
                    u.business_name,
                    maxLines: 2,
                    fontWeight: 800,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  FxContainer(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    borderRadiusAll: 0,
                    color: CustomTheme.primary,
                    child: FxText.bodyLarge(
                      "${(u.phone_number_2).toString().toUpperCase()}",
                      fontWeight: 800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      FxText.bodySmall(
                        "SERVICES:",
                        color: CustomTheme.primary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      FxText.bodySmall(
                        u.services_offered,
                        color: Colors.grey,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
