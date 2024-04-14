import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/models/CropModel.dart';
import 'package:marcci/models/PestsAndDiseaseModel.dart';
import 'package:marcci/theme/app_theme.dart';

import '../../controllers/MainController.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../utils/my_widgets.dart';

class PestScreen extends StatefulWidget {
  PestsAndDiseaseModel item;

  PestScreen(this.item, {super.key});

  @override
  PestScreenState createState() => PestScreenState();
}

class PestScreenState extends State<PestScreen> {
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
          backgroundColor: CustomTheme.primary,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxText.titleLarge(
                "Pest and Disease Details",
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
                          widget.item.description,
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
                        SizedBox(
                          height: 0,
                        ),
                        Container(
                          child: Html(
                            data: widget.item.description,
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
