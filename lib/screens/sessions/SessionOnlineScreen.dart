
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/utils/Utils.dart';

import '../../models/SessionOnline.dart';
import '../../models/TemporaryModel.dart';
import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';

//SessionOnlineScreen
class SessionOnlineScreen extends StatefulWidget {
  dynamic data;

  SessionOnlineScreen({Key? key, this.data}) : super(key: key);

  @override
  SessionOnlineScreenState createState() => new SessionOnlineScreenState();
}

class SessionOnlineScreenState extends State<SessionOnlineScreen> {
  Future<void> submit_form() async {
    init();
    return;
  }

  String error_message = "";
  bool is_loading = false;

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
                '${item.title}',
                color: Colors.white,
                fontWeight: 700,
                height: .6,
              ),
              FxText.titleSmall(
                'Expected: ${item.expectedMembers.length}, Present: ${item.presentMembers.length}, Absent: ${item.expectedMembers.length - item.presentMembers.length}',
                color: Colors.white,
              ),
            ],
          )),
      body: ListView.builder(
          itemCount: item.expectedMembers.length,
          itemBuilder: (context, index) {
            final TemporaryModel member = item.expectedMembers[index];
            return Container(
              color: item.presentMembers.contains(member.id)
                  ? Colors.green.shade50
                  :  Colors.red.shade50,
              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  roundedImage(member.image.toString(), 5, 5),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: FxText.titleLarge(
                        member.title,
                        fontSize: 16,
                        color: Colors.grey.shade900,
                        fontWeight: 600,
                      )),
                  Container(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            FxText.bodyMedium(
                              'PRESENT',
                              fontWeight: 700,
                              color: Colors.green.shade900,
                              letterSpacing: .01,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            FxContainer(
                              borderRadiusAll: 100,
                              width: 25,
                              height: 25,
                              bordered: true,
                              color: item.presentMembers
                                  .contains(member.id)
                                  ? Colors.green.shade700
                                  : Colors.white,
                              borderColor: Colors.green.shade900,
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ), Column(
                          children: [
                            FxText.bodyMedium(
                              'ABSENT',
                              fontWeight: 700,
                              color: Colors.red.shade900,
                              letterSpacing: .01,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            FxContainer(
                              borderRadiusAll: 100,
                              width: 25,
                              color: (!item.presentMembers
                                  .contains(member.id))
                                  ? Colors.red.shade700
                                  : Colors.white,
                              height: 25,
                              bordered: true,
                              borderColor: Colors.red.shade800,
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  SessionOnline item = SessionOnline();

  Future<void> init() async {
    if (widget.data.runtimeType.toString() != 'SessionOnline') {
      Utils.toast('Data not found.');
      Navigator.pop(context, true);
      return;
    }
    item = widget.data;
    await item.getExpectedMembers();
    await item.getPresentMembers();
    setState(() {});
  }

}
