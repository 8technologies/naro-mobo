import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/models/ProductModel.dart';
import 'package:marcci/screens/products/ProductCreateScreen.dart';
import 'package:marcci/utils/AppConfig.dart';

import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import 'ProductScreen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();

    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => ProductCreateScreen());
        },
        label: Row(
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(
              width: 5,
            ),
            FxText.titleLarge(
              "Sell",
              color: Colors.white,
              fontWeight: 800,
            ),
          ],
        ),
        backgroundColor: CustomTheme.primary,
      ),
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          "Products & Services",
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 15),
                        child: FxText.bodyLarge(
                          "Recently posted ${items.length} products",
                          height: 1,
                          fontWeight: 800,
                        ),
                      ),
                      Divider(),
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
                  ProductModel m = items[index];
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

  List<ProductModel> items = [];

  Future<dynamic> myInit() async {
    items = await ProductModel.get_items();
    return "Done";
  }


  Widget productWidget(ProductModel u) {
    return InkWell(
      onTap: () {
        Get.to(() => ProductScreen(u));
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 5, right: 5),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            roundedImage(AppConfig.STORAGE_URL + u.photo.toString(), 4.5, 4.5),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.titleMedium(
                    u.name,
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
                      "UGX ${Utils.moneyFormat(u.price).toString().toUpperCase()}",
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
                      Icon(
                        Icons.shield,
                        size: 12,
                        color: CustomTheme.primaryDark,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      FxText.bodySmall(
                        u.state.toUpperCase(),
                        color: Colors.grey,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      Icon(
                        FeatherIcons.clock,
                        size: 12,
                        color: CustomTheme.primaryDark,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      FxText.bodySmall(
                        Utils.to_date_1(u.created_at),
                        maxLines: 1,
                        color: Colors.grey,
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
