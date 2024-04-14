import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx/flutx.dart';

import '../../models/ServiceProvider.dart';
import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';

class ServiceProviderScreen extends StatefulWidget {
  ServiceProvider item;

  ServiceProviderScreen(this.item, {Key? key}) : super(key: key);

  @override
  _ServiceProviderScreenState createState() =>
      _ServiceProviderScreenState(this.item);
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;
  ServiceProvider item;

  _ServiceProviderScreenState(this.item);

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
          "Service provider details",
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
                      item.business_name,
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
                      height: 15,
                    ),
                    singleWidget('SERVICES OFFERED', item.services_offered),
                    singleWidget('DISTRICT', item.phone_number_2),
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
                  Utils.launchPhone(widget.item.phone_number.length < 5
                      ? '+256783204665'
                      : widget.item.phone_number.toString());
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
