/*
* File : Login
* Version : 1.0.0
* */

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as DioObj;
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marcci/models/PestsAndDiseaseModel.dart';
import 'package:marcci/models/PestsAndDiseaseReportModel.dart';
import 'package:marcci/models/RespondModel.dart';
import 'package:marcci/screens/gardens/GardenList.dart';
import 'package:marcci/screens/petsts/PestsScreen.dart';
import 'package:marcci/sections/widgets.dart';

import '../../models/CropModel.dart';
import '../../models/GardenModel.dart';
import '../../models/GroupModel.dart';
import '../../models/LoactionModel.dart';
import '../../models/OptionPickerModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';
import '../OtherPages/single_option_picker.dart';

class PestReportCreateScreen extends StatefulWidget {
  PestReportCreateScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PestReportCreateScreenState createState() => _PestReportCreateScreenState();
}

class _PestReportCreateScreenState extends State<PestReportCreateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool onLoading = false;
  String error_message = "";
  PestsAndDiseaseReportModel item = PestsAndDiseaseReportModel();

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
    bool askReset = false,
  }) async {
    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please first fix errors.");
      return;
    }
    error_message = "";
    setState(() {
      onLoading = true;
    });

    print("PLEASE WAINT...");

    Map<String, dynamic> formDataMap = item.toJson();
    if (local_image_path.isNotEmpty) {
      formDataMap['file'] = await DioObj.MultipartFile.fromFile(
          local_image_path,
          filename: local_image_path);
    }
    print(formDataMap);

    RespondModel r =
        RespondModel(await Utils.http_post('pests-report', formDataMap));

    if (r.code != 1) {
      Utils.toast('Failed to update because ${r.message}.', color: Colors.red);
      error_message = r.message;
      setState(() {
        onLoading = false;
      });
      return;
    }

    await PestsAndDiseaseReportModel.getOnlineItems();
    await PestsAndDiseaseReportModel.get_items();

    setState(() {
      onLoading = false;
    });
    Navigator.pop(context, true);
    Utils.toast(r.message);

    return;
  }

  List<CropModel> crops = [];

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
          "Reporting Pests and Diseases",
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
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Select garden",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              readOnly: true,
                              onTap: () async {
                                GardenModel? p =
                                    await Get.to(() => GardenList(true));
                                if (p == null) {
                                  Utils.toast("No location selected");
                                  return;
                                }
                                item.garden_id = p.id.toString();
                                item.garden_text = p.name;
                                //patch
                                _formKey.currentState!.patchValue({
                                  'garden_text': item.garden_text,
                                });
                                setState(() {});
                              },
                              initialValue: item.garden_text,
                              textCapitalization: TextCapitalization.sentences,
                              name: "garden_text",
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderTextField(
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Select pest or disease",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              readOnly: true,
                              onTap: () async {
                                PestsAndDiseaseModel? p = await Get.to(
                                    () => PestsScreen({'isPicker': true}));
                                if (p == null) {
                                  Utils.toast("No item selected");
                                  return;
                                }
                                item.pests_and_disease_id = p.id.toString();
                                item.pests_and_disease_text = p.description;
                                //patch
                                _formKey.currentState!.patchValue({
                                  'pests_and_disease_text':
                                      item.pests_and_disease_text,
                                });
                                setState(() {});
                              },
                              initialValue: item.pests_and_disease_text,
                              textCapitalization: TextCapitalization.sentences,
                              name: "pests_and_disease_text",
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FxText.titleLarge(
                              'Garden Photo',
                              fontWeight: 700,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: () {
                                showImagePicker(context);
                              },
                              child: FxContainer(
                                height: Get.width / 1.8,
                                borderColor: CustomTheme.primaryDark,
                                bordered: true,
                                color: CustomTheme.primaryDark.withAlpha(40),
                                child: local_image_path.isNotEmpty
                                    ? Image.file(
                                        File(local_image_path),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                    : CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        imageUrl: item.photo,
                                        placeholder: (context, url) =>
                                            ShimmerLoadingWidget(
                                          height: double.infinity,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                          child: FxContainer(
                                              color: CustomTheme.primaryDark,
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
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10, top: 20),
                              child: FormBuilderTextField(
                                name: 'name',
                                initialValue: item.description,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                onChanged: (x) {
                                  item.description = Utils.to_str(x, '');
                                },
                                minLines: 3,
                                maxLines: 5,
                                keyboardType: TextInputType.name,
                                decoration: AppTheme.InputDecorationTheme1(
                                  label: "Pest or disease description",
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText:
                                        "Pest or disease description is required.",
                                  ),
                                ]),
                              ),
                            ),
                            alertWidget(error_message, 'danger'),
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

  List<OptionPickerModel> selectedLocations = [];
  List<LocarionModel> locations = [];
  List<GroupModel> groups = [];
  List<OptionPickerModel> subs = [];
  bool is_loading = false;

  pick_disability() async {
    if (is_loading) {
      return;
    }
    setState(() {
      is_loading = true;
    });

    if (crops.isEmpty) {
      crops = await CropModel.get_items();
    }

    subs.clear();
    for (var element in crops) {
      OptionPickerModel item = OptionPickerModel();
      item.parent_id = "1";
      item.id = element.id.toString();
      item.name = element.name.toString();
      subs.add(item);
    }

    setState(() {
      is_loading = false;
    });

    selectedLocations.clear();
    // ignore: use_build_context_synchronously
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SingleOptionPicker(
              "Select a crop", subs, selectedLocations, true)),
    );
    setState(() {
      is_loading = false;
    });

    if (result.runtimeType.toString() == 'List<OptionPickerModel>') {
      List<OptionPickerModel> r = result;
      if (r.isNotEmpty && Utils.int_parse(r.first.id) > 0) {
        item.crop_id = r.first.id.toString();
        item.crop_text = r.first.name.toString();
        _formKey.currentState!.patchValue({
          'crop_text': item.crop_text,
        });
        setState(() {});
      }
    }
  }

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
