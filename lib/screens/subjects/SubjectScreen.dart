import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/models/MySubjects.dart';

import '../../models/SessionOnline.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';
import '../../utils/my_widgets.dart';
import '../sessions/SessionOnlineScreen.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({Key? key, required this.data}) : super(key: key);
  final dynamic data;

  @override
  _CourseTasksScreenState createState() => _CourseTasksScreenState();
}

class _CourseTasksScreenState extends State<SubjectScreen> {
  late ThemeData themeData;

  _CourseTasksScreenState();

  late Future<dynamic> futureInit;

  Future<Null> _my_init() async {
    futureInit = my_init();
    setState(() {});
  }

  MySubjects item = MySubjects();

  List<SessionOnline> sessionsOnline = [];

  Future<dynamic> my_init() async {
    item = widget.data;
    sessionsOnline =
        await SessionOnline.getItems(where : ' subject_id = ${item.id} ');

    setState(() {});
    return "Done";
  }

  @override
  void initState() {
    _my_init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        titleSpacing: 0,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        // remove back button in appbar.

        title: FxText.titleLarge(
          "${item.subject_name} - ${item.short_name} ",
          color: Colors.white,
        ),
      ),
      body: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            toolbarHeight: 48,
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*-------------- Build Tabs here ------------------*/
                TabBar(
                  padding: EdgeInsets.only(bottom: 0),
                  labelPadding: EdgeInsets.only(bottom: 2, left: 8, right: 8),
                  indicatorPadding: EdgeInsets.all(0),
                  labelColor: CustomTheme.primary,
                  isScrollable: true,
                  enableFeedback: true,
                  indicator: UnderlineTabIndicator(
                      borderSide:
                          BorderSide(color: CustomTheme.primary, width: 4)),
                  tabs: [
                    Tab(
                        height: 30,
                        child: FxText.titleMedium(
                          "Summary",
                          fontWeight: 600,
                          color: CustomTheme.primary,
                        )),
                    Tab(
                        height: 30,
                        child: FxText.titleMedium("Lessons",
                            fontWeight: 600, color: CustomTheme.primary)),
                    Tab(
                        height: 30,
                        child: Container(
                          child: FxText.titleMedium("Resources",
                              fontWeight: 600, color: CustomTheme.primary),
                        )),
                    Tab(
                        height: 30,
                        child: Container(
                          child: FxText.titleMedium("Exams",
                              fontWeight: 600, color: CustomTheme.primary),
                        )),
                  ],
                )
              ],
            ),
          ),

          /*--------------- Build Tab body here -------------------*/
          body: TabBarView(
            children: <Widget>[
              FutureBuilder(
                  future: futureInit,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return myListLoaderWidget(context);
                      default:
                        return mainFragment();
                    }
                  }),
              FutureBuilder(
                  future: futureInit,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return myListLoaderWidget(context);
                      default:
                        return attendanceList();
                    }
                  }),
              FutureBuilder(
                  future: futureInit,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return myListLoaderWidget(context);
                      default:
                        return studentsFragment();
                    }
                  }),
              CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Text("Coming soon...");
                      },
                      childCount: 1,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget singleWidget(String title, String subTitle) {
    /*   return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: valueUnitWidget(
        context,
        '${title} :',
        subTitle,
        fontSize: 10,
        titleColor: CustomTheme.primary,
        color: Colors.grey.shade600,
      ),
    );*/
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(top: 4, bottom: 4),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2.5,
            alignment: Alignment.centerRight,
            child: FxText.bodyLarge(
              '$title :'.toUpperCase(),
              textAlign: TextAlign.right,
              color: CustomTheme.primary,
              fontWeight: 700,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
              child: FxText.bodyLarge(
            subTitle,
            maxLines: 10,
          )),
        ],
      ),
    );
  }

  mainFragment() {
    return Container(
      child: ListView(
        children: [
          const SizedBox(
            height: 8,
          ),
          singleWidget('Subject name', ' ${item.subject_name}'),
          singleWidget('Subject code', '${item.code}'),
          singleWidget('Subject class', '${item.name}'),
          singleWidget('Subject teacher', '${item.subject_teacher_name}'),
        ],
      ),
    );
  }

  studentsFragment() {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return const Center(child: Text('Coming soon'));
            }, childCount: 1),
          ),
        ],
      ),
    );
  }

  void _showMyBottomSheetExhibitModel(context) {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            child: Container(
              padding: EdgeInsets.only(bottom: 20),
              margin: EdgeInsets.only(left: 13, right: 13, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MySize.size16),
                  topRight: Radius.circular(MySize.size16),
                  bottomLeft: Radius.circular(MySize.size16),
                  bottomRight: Radius.circular(MySize.size16),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(0),
                child: ListView(
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            FxText.titleLarge(
                              "Exhibit Details".toUpperCase(),
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: 700,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    singleWidget('Exhibit type', 'ex.exhibit_catgory'),
                    singleWidget('Wildlife', 'ex.wildlife'),
                    singleWidget('Wildlife', 'ex.wildlife'),
                    singleWidget('Wildlife', 'ex.wildlife'),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget attendanceList() {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                SessionOnline m = sessionsOnline[index];
                return ListTile(
                  onTap: () {
                    Get.to(() => SessionOnlineScreen(
                          data: m,
                        ));
                  },
                  title: FxText.titleMedium(
                    m.title,
                    color: Colors.black,
                    fontWeight: 700,
                  ),
                  subtitle: FxText.bodySmall(Utils.to_date_1(m.due_date)),
                  trailing: FxContainer(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    color: Colors.green.shade50,
                    child: FxText.bodySmall(
                      'SUBMITTED',
                      color: Colors.green.shade700,
                      fontWeight: 800,
                    ),
                  ),
                );
              },
              childCount: sessionsOnline.length,
            ),
          ),
        ],
      ),
    );
  }
}
