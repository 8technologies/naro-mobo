import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx/flutx.dart';
import 'package:marcci/models/ProductModel.dart';

import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';

class ProductScreen extends StatefulWidget {
  ProductModel item;

  ProductScreen(this.item, {Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState(this.item);
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;
  ProductModel item;

  _ProductScreenState(this.item);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          "Product details",
          color: Colors.white,
          maxLines: 2,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    FxText.titleLarge(
                      item.name,
                      color: Colors.black,
                      fontWeight: 800,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FxContainer(
                      child: roundedImage(
                          AppConfig.STORAGE_URL + widget.item.photo.toString(),
                          1,
                          1),
                      color: CustomTheme.primary.withAlpha(60),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText(
                                  'PRICE',
                                  color: Colors.black,
                                  fontWeight: 800,
                                ),
                                SizedBox(height: 5),
                                FxContainer(
                                  child: FxText.bodyLarge(
                                    "UGX ${Utils.moneyFormat(item.price)} "
                                        .toUpperCase(),
                                    color: Colors.white,
                                    fontWeight: 800,
                                  ),
                                  color: CustomTheme.primary,
                                  borderRadiusAll: 0,
                                  paddingAll: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    singleWidget('OFFER TYPE', item.offer_type),
                    singleWidget('CONTACT', item.state),
                    singleWidget('DETAILS', ''),
                    Html(
                      data: item.details,
                      style: {
                        "strong": Style(
                            color: CustomTheme.primary,
                            fontSize: FontSize(18),
                            fontWeight: FontWeight.normal),
                      },
                    )
                  ],
                ),
              ),
            ),
            Divider(
              color: CustomTheme.primary,
              height: 0,
            ),
            Container(
              color: CustomTheme.primary.withAlpha(20),
              padding:
                  EdgeInsets.only(bottom: 10, right: 10, left: 10, top: 10),
              child: FxButton.block(
                child: FxText.titleLarge(
                  'CONTACT THE SELLER',
                  color: Colors.white,
                  fontWeight: 900,
                ),
                onPressed: () {
                  Utils.launchPhone(widget.item.type.length < 5
                      ? '+256783204665'
                      : widget.item.state.toString());
                },
                borderRadiusAll: 100,
              ),
            )
          ],
        ),
      ),
    );
  }
}
