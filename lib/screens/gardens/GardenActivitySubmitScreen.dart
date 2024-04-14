/*
* File : Login
* Version : 1.0.0
* */

import 'dart:io';

import 'package:dio/dio.dart' as DioObj;
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marcci/models/RespondModel.dart';
import 'package:marcci/sections/widgets.dart';

import '../../models/GardenActivity.dart';
import '../../theme/app_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';

class GardenActivitySubmitScreen extends StatefulWidget {
  GardenActivity activity;

  GardenActivitySubmitScreen(
    this.activity, {
    Key? key,
  }) : super(key: key);

  @override
  _GardenActivitySubmitScreenState createState() =>
      _GardenActivitySubmitScreenState();
}

class _GardenActivitySubmitScreenState
    extends State<GardenActivitySubmitScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool onLoading = false;
  String error_message = "";

  @override
  void initState() {
    initFuture = init();
    super.initState();
  }

  init() async {
    return 'Done';
  }

  Future<void> submit_form({
    bool announceChanges = false,
    bool askReset=  false,
  }) async {
    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please first fix errors.");
      return;
    }

    error_message = "";
    setState(() {
      onLoading = true;
    });


    Map<String, dynamic> formDataMap = {
      'activity_id': widget.activity.id,
      'farmer_activity_status': widget.activity.farmer_activity_status,
      'farmer_comment': widget.activity.farmer_comment,
      'activity_date_done': widget.activity.activity_date_done,
    };
    if (local_image_path.isNotEmpty) {
      formDataMap['file'] = await DioObj.MultipartFile.fromFile(
          local_image_path,
          filename: local_image_path);
    }

    RespondModel r =
        RespondModel(await Utils.http_post('garden-activities', formDataMap));

    if (r.code != 1) {
      Utils.toast('Failed to update because ${r.message}.', color: Colors.red);
      error_message = r.message;
      setState(() {
        onLoading = false;
      });
      return;
    }

    setState(() {
      onLoading = true;
    });
    await GardenActivity.getOnlineItems();

    setState(() {
      onLoading = false;
    });
    Navigator.pop(context, true);
    Utils.toast(r.message);

    return;
  }

  void resetForm() {
    setState(() {});

    _formKey.currentState!.patchValue({
      'finance_category_text': '',
      'amount': '',
      'description': '',
    });

    setState(() {});
  }

  var initFuture;

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
          "Submitting activity",
          color: Colors.white,
          maxLines: 2,
        ),
      ),
      body: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView(
              children: [
                Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(
                        left: MySize.size16, right: MySize.size16),
                    child: FormBuilder(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MySize.size10,
                            left: MySize.size5,
                            right: MySize.size5,
                            bottom: MySize.size10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderTextField(
                              name: 'activity_name',
                              initialValue: widget.activity.activity_name,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Activity",
                              ),
                              readOnly: true,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderTextField(
                              name: 'garden_text',
                              initialValue: widget.activity.garden_text,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Garden",
                              ),
                              readOnly: true,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderDropdown<String>(
                              name: 'status',
                              dropdownColor: Colors.white,
                              validator:
                              FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Status is required.",
                                ),
                              ]),
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Was this activity done?",
                              ),
                              onChanged: (x) {
                                String y = x.toString();
                                if (y == 'Yes - (Done)') {
                                  widget.activity.farmer_activity_status =
                                      'Done';
                                } else {
                                  widget.activity.farmer_activity_status =
                                      'Skipped';
                                }

                                setState(() {});
                              },
                              isDense: true,
                              items: ['Yes - (Done)', 'No - (Missed)']
                                  .map((sub) => DropdownMenuItem(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        value: sub,
                                        child: Text(sub),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            widget.activity.farmer_activity_status != 'Done'
                                ? SizedBox()
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FormBuilderDateTimePicker(
                                        decoration:
                                            AppTheme.InputDecorationTheme1(
                                          label:
                                              'Date when activity was carried out',
                                        ),
                                        inputType: InputType.date,
                                        lastDate: DateTime.now(),
                                        name: 'activity_date_done',
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                            errorText: "Date is required.",
                                          ),
                                        ]),
                                        onChanged: (x) {
                                          widget.activity.activity_date_done =
                                              Utils.to_str(x, '');
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      FxText.titleMedium(
                                        'Attach Activity Photo',
                                        fontWeight: 700,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showImagePicker(context);
                                        },
                                        child: FxContainer(
                                          height: Get.width / 1.8,
                                          borderColor: CustomTheme.primaryDark,
                                          bordered: true,
                                          color: CustomTheme.primaryDark
                                              .withAlpha(40),
                                          child: local_image_path.isNotEmpty
                                              ? Image.file(
                                                  File(local_image_path),
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                )
                                              : Center(
                                                  child: FxContainer(
                                                      color: CustomTheme
                                                          .primaryDark,
                                                      borderRadiusAll: 100,
                                                      paddingAll: 20,
                                                      child: Icon(
                                                        FeatherIcons.camera,
                                                        size: Get.width / 6,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            FormBuilderTextField(
                              name: 'farmer_comment',
                              initialValue: widget.activity.farmer_comment,
                              textCapitalization: TextCapitalization.words,
                              minLines: 3,
                              maxLines: 4,
                              onChanged: (x) {
                                widget.activity.farmer_comment =
                                    Utils.to_str(x, '');
                              },
                              validator:
                              FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Remarks is required.",
                                ),
                              ]),
                              keyboardType: TextInputType.text,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Activity remarks",
                              ),
                            ),
                            alertWidget(error_message, 'success'),
                            const SizedBox(
                              height: 15,
                            ),
                            onLoading
                                ? Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                CustomTheme.primary),
                                      ),
                                    ))
                                : FxButton.block(
                                    onPressed: () {
                                      submit_form();
                                    },
                                    borderRadiusAll: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.check,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Center(
                                            child: FxText.titleLarge(
                                          "SUBMIT",
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
            );
          }),
    );
  }

  bool is_loading = false;

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: FxSpacing.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        _onImageButtonPressed(ImageSource.camera);
                      },
                      dense: false,
                      leading: Icon(FeatherIcons.camera,
                          size: 30, color: CustomTheme.primary),
                      title: FxText(
                        "Use camera",
                        fontWeight: 500,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    ListTile(
                        dense: false,
                        onTap: () {
                          Navigator.pop(context);
                          _onImageButtonPressed(ImageSource.gallery);
                        },
                        leading: Icon(FeatherIcons.image,
                            size: 28, color: CustomTheme.primary),
                        title: FxText(
                          "Pick from gallery",
                          fontWeight: 500,
                          color: Colors.black,
                          fontSize: 18,
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;

  Future<void> _onImageButtonPressed(
    ImageSource source,
  ) async {
    try {
      pickedFile = await _picker.pickImage(source: source, imageQuality: 40);
      displayPickedPhoto();
    } catch (e) {
      Utils.toast("Failed to get photo because $e");
    }
  }

  String local_image_path = "";

  Future<void> displayPickedPhoto() async {
    if (pickedFile == null) {
      return;
    }
    if (pickedFile?.path == null) {
      return;
    }
    if (pickedFile?.name == null) {
      return;
    }

    var tempFile = pickedFile?.path.toString();
    if (!(await (File(tempFile.toString()).exists()))) {
      return;
    }
    local_image_path = tempFile.toString();
    setState(() {});
  }
}
