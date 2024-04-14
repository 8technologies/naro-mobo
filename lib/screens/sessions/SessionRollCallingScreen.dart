import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/utils/Utils.dart';

import '../../models/SessionLocal.dart';
import '../../models/TemporaryModel.dart';
import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';

class SessionRollCallingScreen extends StatefulWidget {
  dynamic data;

  SessionRollCallingScreen({Key? key, this.data}) : super(key: key);

  @override
  SessionRollCallingScreenState createState() =>
      new SessionRollCallingScreenState();
}

class SessionRollCallingScreenState extends State<SessionRollCallingScreen> {
  Future<void> submit_form() async {
    await doSave(true);
    Utils.boot_system();
    Navigator.pop(context, true);
    Utils.toast("Thanks");
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
                'Expected: ${item.expectedMembers.length}, Present: ${item.presentMembers.length}, Absent: ${item.absentMembers.length}',
                color: Colors.white,
              ),
            ],
          )),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: item.expectedMembers.length,
                itemBuilder: (context, index) {
                  final TemporaryModel member = item.expectedMembers[index];
                  return Container(
                    color: item.presentMembers.contains(member.id)
                        ? Colors.green.shade50
                        : item.absentMembers.contains(member.id)
                            ? Colors.red.shade50
                            : Colors.white,
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
                              InkWell(
                                onTap: () {
                                  addToPresent(member.id);
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      FxText.bodyMedium(
                                        'PRESENT',
                                        fontWeight: 700,
                                        color: Colors.green.shade900,
                                        letterSpacing: .01,
                                      ),
                                      SizedBox(
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
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  addToAbsent(member.id);
                                },
                                child: Container(
                                  child: Column(
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
                                        color: item.absentMembers
                                                .contains(member.id)
                                            ? Colors.red.shade700
                                            : Colors.white,
                                        height: 25,
                                        bordered: true,
                                        borderColor: Colors.red.shade800,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: FxButton.outlined(
                    borderColor: CustomTheme.primary,
                    onPressed: () {
                      pause_session();
                    },
                    child: FxText.titleMedium(
                      'PAUSE',
                      color: CustomTheme.primary,
                      fontWeight: 800,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: FxButton.block(
                    borderColor: CustomTheme.primary,
                    onPressed: () {
                      submit_form();
                    },
                    child: FxText.titleMedium(
                      'SUBMIT',
                      color: Colors.white,
                      fontWeight: 800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  SessionLocal item = SessionLocal();

  void init() {
    if (widget.data.runtimeType != item.runtimeType) {
      Utils.toast('Data not found.');
      Navigator.pop(context, true);
      return;
    }
    item = widget.data;
    item.getExpectedMembers();
    item.getPresentMembers();
    item.getAbsentMembers();
    setState(() {});
  }

  Future<void> addToPresent(int _id) async {
    if (!item.presentMembers.contains(_id)) {
      item.presentMembers.add(_id);
    }
    item.absentMembers.remove(_id);
    setState(() {});
    await doSave(false);
  }

  Future<void> addToAbsent(int _id) async {
    if (!item.absentMembers.contains(_id)) {
      item.absentMembers.add(_id);
    }
    item.presentMembers.remove(_id);
    setState(() {});
    await doSave(false);
  }

  Future<void> doSave(bool isFinal) async {
    if (isFinal) {
      item.closed = 'yes';
    } else {
      item.closed = 'no';
    }

    item.present = jsonEncode(item.presentMembers);
    item.absent = jsonEncode(item.absentMembers);

    await item.save();
  }

  Future<void> pause_session() async {
    await doSave(false);
    Navigator.pop(context, true);
    Utils.toast("Roll call paused.");
  }
}
