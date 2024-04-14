import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/models/MySubjects.dart';

import '../../theme/custom_theme.dart';
import '../../utils/my_widgets.dart';
import 'SubjectScreen.dart';

class SubjectsScreen extends StatefulWidget {
  SubjectsScreen({Key? key}) : super(key: key);

  @override
  SubjectsScreenState createState() => new SubjectsScreenState();
}

class SubjectsScreenState extends State<SubjectsScreen> {
  List<MySubjects> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doRefresh();
  }

  Future<dynamic> doRefresh() async {
    futureInit = init();
    setState(() {});
  }

  late Future<dynamic> futureInit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          titleSpacing: 0,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          // remove back button in appbar.
          title: FxText.titleLarge(
            'My Subjects (${items.length})',
            color: Colors.white,
            fontWeight: 700,
            height: .6,
          )),
      body: FutureBuilder(
          future: futureInit,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return myListLoaderWidget(context);
            }
            if (items.isEmpty) {
              return Center(child: FxText('No item found.'));
            }

            return RefreshIndicator(
              backgroundColor: Colors.white,
              onRefresh: doRefresh,
              child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                        height: 1,
                      ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final MySubjects m = items[index];
                    return ListTile(
                      onTap: () {
                        Get.to(() => SubjectScreen(
                              data: m,
                            ));
                      },
                      leading: FxContainer(
                        width: (Get.width / 6),
                        height: (Get.width / 6),
                        borderRadiusAll: 100,
                        color: CustomTheme.primary.withAlpha(40),
                        paddingAll: 10,
                        alignment: Alignment.center,
                        child: FxText.titleLarge(
                          "${m.short_name}",
                          color: Colors.black,
                          fontWeight: 900,
                        ),
                      ),
                      title: FxText.titleMedium(
                        m.subject_name,
                        color: Colors.black,
                        fontWeight: 700,
                      ),
                      subtitle: FxText.bodySmall(
                          "${m.name} - ${m.subject_teacher_name}"),
                      trailing: FxContainer(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 5),
                        color: CustomTheme.primary.withAlpha(10),
                        child: Icon(Icons.chevron_right),
                      ),
                    );
                  }),
            );
          }),
    );
  }

  Future<void> init() async {
    items = await MySubjects.getItems();
    setState(() {});
  }
}
