/*
* File : Login
* Version : 1.0.0
* */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:marcci/models/MyClasses.dart';
import 'package:marcci/models/MySubjects.dart';
import 'package:marcci/models/RespondModel.dart';
import 'package:marcci/sections/widgets.dart';

import '../../models/SessionLocal.dart';
import '../../models/TemporaryModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';
import 'SessionRollCallingScreen.dart';

class SessionCreateNewScreen extends StatefulWidget {
  final dynamic data;

  SessionCreateNewScreen({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  _SessionCreateNewScreenState createState() => _SessionCreateNewScreenState();
}

class _SessionCreateNewScreenState extends State<SessionCreateNewScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool onLoading = false;
  String error_message = "";
  SessionLocal item = SessionLocal();

  @override
  void initState() {
    init();
    super.initState();
  }

  List<MySubjects> my_subjects = [];

  init() async {
    if (widget.data.runtimeType.toString() == 'MyClasses') {
      classModel = widget.data;
      item.type = 'Class attendance';
      item.title = '${classModel.name} - Roll-call';
      item.academic_class_id = classModel.id.toString();

      subs.clear();
      my_subjects = await MySubjects.getItems();

      for (MySubjects element in my_subjects) {
        if (element.academic_class_id.toString() == classModel.id.toString()) {
          subs.add("${element.subject_name} - #${element.id}");
        }
      }
    } else {
      Navigator.pop(context);
      Utils.toast('Type not found.');
      return;
    }

    setState(() {});
  }

  List<String> subs = [];

  MyClasses classModel = new MyClasses();

  Future<void> submit_form({
    bool announceChanges= false,
    bool askReset=  false,
  }) async {
    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please first fix errors.");
      return;
    }

    item.due_date =
        Utils.to_str(_formKey.currentState?.fields['date']?.value, '');
    if (item.due_date.isEmpty) {
      Utils.toast('Select date');
      return;
    }

    if (item.subject_id.isEmpty) {
      Utils.toast('Select subject');
      return;
    }

    List<Map<String, dynamic>> items = [];
    for (var student in (await classModel.getStudents())) {
      TemporaryModel x = TemporaryModel();
      x.id = student.id;
      x.title = student.name;
      x.image = student.avatar;
      items.add(x.toJson());
    }
    item.expected = jsonEncode(items);
    item.present = '[]';
    item.closed = 'No';

    if (item.id < 1) {
      item.id = DateTime.now().millisecondsSinceEpoch;
    }
    await item.save();
    Get.off(() => SessionRollCallingScreen(data: item));
    return;
    error_message = "";
    setState(() {
      onLoading = true;
    });

    RespondModel r =
        RespondModel(await Utils.http_post('update-bio/${item.id}', {}));

    setState(() {
      onLoading = false;
    });

    if (r.code != 1) {
      Utils.toast('Failed to update because ${r.message}.', color: Colors.red);
      error_message = r.message;
      setState(() {});
      return;
    }

    await item.save();

    Utils.toast("Success!");
    setState(() {});
    Navigator.pop(context);
    return;
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
          "Creating new roll-call ${classModel.id}",
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: [
          Container(
              color: Colors.white,
              padding:
                  EdgeInsets.only(left: MySize.size16, right: MySize.size16),
              child: FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MySize.size10,
                      left: MySize.size5,
                      right: MySize.size5,
                      bottom: MySize.size10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 10),
                        child: FormBuilderTextField(
                          name: 'title',
                          readOnly: true,
                          initialValue: item.title,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          onChanged: (x) {
                            item.title = Utils.to_str(x, '');
                          },
                          keyboardType: TextInputType.name,
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "Title",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Title",
                            ),
                          ]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20, top: 10),
                        child: FormBuilderDateTimePicker(
                          name: 'date',
                          initialEntryMode: DatePickerEntryMode.calendar,
                          initialValue: DateTime.now(),
                          inputType: InputType.date,
                          currentDate: DateTime.now(),
                          onChanged: (x) {
                            item.due_date = Utils.to_str(x, '');
                          },
                          keyboardType: TextInputType.datetime,
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "Date",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Date",
                            ),
                          ]),
                        ),
                      ),
                      FormBuilderDropdown<String>(
                        name: 'subject',
                        dropdownColor: Colors.white,
                        decoration: AppTheme.InputDecorationTheme1(
                          label: "Subject",
                        ),
                        onChanged: (x) {
                          String y = x.toString();
                          for (var element in my_subjects) {
                            if (element.academic_class_id.toString() ==
                                item.academic_class_id.toString()) {
                              if (y.toString() ==
                                  "${element.subject_name} - #${element.id}") {
                                item.subject_id = element.id.toString();
                                print(item.subject_id.toString());
                                break;
                              }
                            }
                          }
                        },
                        isDense: true,
                        items: subs
                            .map((sub) => DropdownMenuItem(
                                  alignment: AlignmentDirectional.centerStart,
                                  value: sub,
                                  child: Text(sub),
                                ))
                            .toList(),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      alertWidget(error_message, 'success'),
                      onLoading
                          ? Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    CustomTheme.primary),
                              ))
                          : FxButton.block(
                              onPressed: () {
                                submit_form();
                              },
                              borderRadiusAll: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Center(
                                      child: FxText.titleLarge(
                                    "SUBMIT CHANGES",
                                    color: Colors.white,
                                    fontWeight: 700,
                                  )),
                                ],
                              ))
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
