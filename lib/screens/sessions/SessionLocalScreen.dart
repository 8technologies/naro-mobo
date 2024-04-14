import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../models/SessionLocal.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import 'SessionOnlineScreen.dart';

class SessionLocalScreen extends StatefulWidget {
  SessionLocalScreen({Key? key}) : super(key: key);

  @override
  SessionLocalScreenState createState() => new SessionLocalScreenState();
}

class SessionLocalScreenState extends State<SessionLocalScreen> {
  List<SessionLocal> sessions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

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
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxText.titleLarge(
                'Roll calls (Offline)',
                color: Colors.white,
                fontWeight: 700,
                height: .6,
              ),
            ],
          )),
      body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                height: 1,
              ),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final SessionLocal m = sessions[index];
            return ListTile(
              onTap: () {
                Get.to(() => SessionOnlineScreen(data: m));
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
                color: Colors.red.shade50,
                child: FxText.bodySmall(
                  'NOT SUBMITTED',
                  color: Colors.red.shade700,
                  fontWeight: 800,
                ),
              ),
            );
          }),
    );
  }

  Future<void> init() async {
    sessions = await SessionLocal.getItems(where : ' 1 ');
    setState(() {});
  }
}
