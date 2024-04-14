import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:marcci/theme/app_theme.dart';

import '../../models/GardenActivity.dart';

class MyActivityDetailsScreen extends StatefulWidget {
  GardenActivity item;
  MyActivityDetailsScreen(this.item,{Key? key}) : super(key: key);

  @override
  _MyActivityDetailsScreenState createState() => _MyActivityDetailsScreenState();
}

class _MyActivityDetailsScreenState extends State<MyActivityDetailsScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;

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
          "Activity details",
          color: Colors.white,
          maxLines: 2,
        ),
      ),
      body: SafeArea(
        child:   mainWidget()
      ),
    );
  }

  Widget mainWidget() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Text("Activity details..."),
    );
  }



  List<GardenActivity> items = [];

  Future<dynamic> myInit() async {
    items = await GardenActivity.get_items();
    return "Done";
  }


}
