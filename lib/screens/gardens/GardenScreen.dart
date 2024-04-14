import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/models/CropModel.dart';
import 'package:marcci/models/GardenModel.dart';
import 'package:marcci/screens/gardens/GardenCreateScreen.dart';
import 'package:marcci/theme/app_theme.dart';

import '../../controllers/MainController.dart';
import '../../sections/widgets.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../finance/TransactionList.dart';

class GardenScreen extends StatefulWidget {
  GardenModel item;
  GardenScreen(this.item, {super.key});
  @override
  GardenScreenState createState() => GardenScreenState();
}

class GardenScreenState extends State<GardenScreen> {
  final MainController mainController = Get.find<MainController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool is_loading = false;
  bool search_mode = false;
  bool isPick = false;

  List<CropModel> allItems = [];
  List<CropModel> items = [];
  String search = "";

  @override
  Widget build(BuildContext context) {
    Utils.init_theme();
    return Scaffold(
        appBar: AppBar(
          actions: [
            /*create pop menu*/
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 35,
              ),
              onSelected: (String value) {
                if (value.toString() == "Update garden information") {
                  Get.to(() => GardenCreateScreen(widget.item));
                }
              },
              color: Colors.white,
              itemBuilder: (BuildContext context) {
                return [
                  'Create an activity',
                  'Report a pest or disease',
                  'Ask an expert',
                  'Update garden information',
                ].map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FxText.bodyLarge(
                          choice,
                          color: Colors.black,
                          fontWeight: 800,
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
            SizedBox(
              width: 10,
            ),
          ],
          backgroundColor: CustomTheme.primary,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxText.titleLarge(
                "Garden Details",
                fontWeight: 800,
                color: Colors.white,
                height: 1.0,
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
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText.titleLarge(
                          widget.item.name,
                          fontWeight: 800,
                          color: CustomTheme.primary,
                          height: 1.0,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        roundedImage(
                          "${AppConfig.STORAGE_URL}/${widget.item.photo}",
                          1,
                          1.7,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: FxText.titleMedium(
                            "Garden Activities",
                            fontWeight: 800,
                            color: CustomTheme.primary,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: CustomTheme.primary,
                          ),
                          subtitle: FxText.bodySmall(
                            'View and manage all activities for this garden',
                            fontWeight: 600,
                          ),
                          onTap: () {
                            Get.to(() => TransactionListScreen());
                          },
                        ),
                        Divider(
                          height: 0,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: FxText.titleMedium(
                            "Garden Financial Records",
                            fontWeight: 800,
                            color: CustomTheme.primary,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: CustomTheme.primary,
                          ),
                          subtitle: FxText.bodySmall(
                            'View and manage all financial records for this garden',
                            fontWeight: 600,
                          ),
                          onTap: () {
                            // Get.to(() => GardenActivityScreen(widget.item));
                          },
                        ),
                        Center(
                          child: FxText.titleLarge(
                            "Garden Details".toUpperCase(),
                            fontWeight: 800,
                            textAlign: TextAlign.center,
                            color: CustomTheme.primary,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        titleValueWidget('Garden name', widget.item.name),
                        titleValueWidget('Crop Planted', widget.item.crop_text),
                        titleValueWidget(
                            'Production Scale', widget.item.production_scale),
                        titleValueWidget('Garden Status', widget.item.status),
                        titleValueWidget('Date Created',
                            Utils.to_date(widget.item.created_at)),
                        titleValueWidget('Planting Date',
                            Utils.to_date(widget.item.planting_date)),
                        titleValueWidget(
                            'Land Size', widget.item.land_occupied),
                        titleValueWidget(
                            'Quantity Planted', widget.item.quantity_planted),
                        titleValueWidget('GARDEN GPS',
                            "${widget.item.gps_lati},${widget.item.gps_longi}"),
                        Divider(),
                        titleValueWidget('IS GARDEN HARVESTED?',
                            "${widget.item.is_harvested}"),
                        titleValueWidget('HARVEST DATE?',
                            "${Utils.to_date(widget.item.harvest_date)}"),
                        titleValueWidget('HARVEST QUALITY',
                            "${widget.item.harvest_quality}"),
                        titleValueWidget('HARVEST QUANTITY',
                            "${widget.item.quantity_harvested}"),
                        titleValueWidget(
                            'HARVEST NOTES', "${widget.item.harvest_notes}"),
                        SizedBox(
                          height: 0,
                        ),
                        Divider(),
                        FxText.titleLarge("Garden Details",
                            fontWeight: 800, color: CustomTheme.primary),
                        Container(
                          child: Html(
                            data: widget.item.details,
                            style: {
                              '*': Style(
                                color: Colors.grey.shade700,
                              ),
                              "strong": Style(
                                  color: CustomTheme.primary,
                                  fontSize: FontSize(18),
                                  fontWeight: FontWeight.normal),
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
