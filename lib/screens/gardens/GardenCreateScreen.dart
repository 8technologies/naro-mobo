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
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marcci/models/RespondModel.dart';
import 'package:marcci/screens/crops/CropsScreen.dart';
import 'package:marcci/sections/widgets.dart';

import '../../models/CropModel.dart';
import '../../models/GardenModel.dart';
import '../../models/GroupModel.dart';
import '../../models/LoactionModel.dart';
import '../../models/OptionPickerModel.dart';
import '../../models/ParishModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';
import '../OtherPages/single_option_picker.dart';
import '../pickers/ParishPickerScreen.dart';

class GardenCreateScreen extends StatefulWidget {
  GardenModel item;

  GardenCreateScreen(
    this.item, {
    Key? key,
  }) : super(key: key);

  @override
  _GardenCreateScreenState createState() => _GardenCreateScreenState();
}

class _GardenCreateScreenState extends State<GardenCreateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool onLoading = false;
  String error_message = "";

  @override
  void initState() {
    if (widget.item.id > 0) {
      isEditing = true;
    }
    initFuture = init();
    super.initState();
  }

  init() async {
    return 'Done';
  }

  Future<void> submit_form({
    bool announceChanges= false,
    bool askReset=  false,
  }) async {

    //check if photo is selected
    if (local_image_path.isEmpty) {
      Utils.toast("Please first select a photo of the garden.");
      return;
    }

    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please first fix errors.");
      return;
    }

    if (widget.item.gps_longi.isEmpty || widget.item.gps_lati.isEmpty) {
      Utils.toast("Please first get the GPS location of the garden.");
      return;
    }

    error_message = "";
    setState(() {
      onLoading = true;
    });

    print("PLEASE wait...");

    Map<String, dynamic> formDataMap = widget.item.toJson();
    if (local_image_path.isNotEmpty) {
      formDataMap['file'] = await DioObj.MultipartFile.fromFile(
          local_image_path,
          filename: local_image_path);
    }
    formDataMap['task'] = 'create';
    if (isEditing) {
      formDataMap['id'] = widget.item.id;
      formDataMap['task'] = 'update';
    }

    RespondModel r =
        RespondModel(await Utils.http_post('gardens', formDataMap));

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
    try {
      await GardenModel.getOnlineItems();
      await GardenModel.get_items();
    } catch (e) {}
    setState(() {});

    try {
      if (isEditing) {
        List<GardenModel> items = await GardenModel.get_items(
          where: "id = ${widget.item.id}",
        );
        if (items.isNotEmpty) {
          widget.item = items.first;
        }
      }
    } catch (e) {}

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
          "${isEditing ? 'Updating' : 'Registering new'} garden",
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
                            left: MySize.size5,
                            right: MySize.size5,
                            bottom: MySize.size10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10, top: 20),
                              child: FormBuilderTextField(
                                name: 'name',
                                initialValue: widget.item.name,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                onChanged: (x) {
                                  widget.item.name = Utils.to_str(x, '');
                                },
                                keyboardType: TextInputType.name,
                                decoration: AppTheme.InputDecorationTheme1(
                                  label: "Garden Name",
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Garden name is required.",
                                  ),
                                ]),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderTextField(
                              decoration: AppTheme.InputDecorationTheme1(
                                label:
                                    "Garden Location (District, Subcounty & Parish)",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              readOnly: true,
                              onTap: () async {
                                ParishModel? p = await Get.to(() =>
                                    ParishPickerScreen(widget.item.parish_id,
                                        widget.item.parish_text));

                                if (p == null) {
                                  Utils.toast("No location selected");
                                  return;
                                }
                                widget.item.parish_id = p.id.toString();
                                widget.item.parish_text = p.name;
                                //patch
                                _formKey.currentState!.patchValue({
                                  'parish_text': widget.item.parish_text,
                                });
                                setState(() {});
                              },
                              initialValue: widget.item.parish_text,
                              textCapitalization: TextCapitalization.sentences,
                              name: "parish_text",
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FormBuilderTextField(
                              decoration: AppTheme.InputDecorationTheme1(
                                label:
                                    "Pick Garden GPS Location (Latitude, Longitude)",
                              ),
                              readOnly: true,
                              onTap: () async {
                                Position pos =
                                    await Utils.get_device_location();
                                widget.item.gps_lati = pos.latitude.toString();
                                widget.item.gps_longi =
                                    pos.longitude.toString();
                                _formKey.currentState!.patchValue({
                                  "gps": '${pos.latitude}, ${pos.longitude}',
                                });
                              },
                              initialValue:
                                  '${widget.item.gps_longi}, ${widget.item.gps_longi}',
                              textCapitalization: TextCapitalization.words,
                              name: "gps",
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FormBuilderTextField(
                              decoration: AppTheme.InputDecorationTheme1(
                                label:
                                    "Select groundnut variety planted in this garden",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              readOnly: true,
                              onTap: () async {
                                CropModel? p = await Get.to(() => CropsScreen({
                                      'isPicker': true,
                                    }));

                                if (p == null) {
                                  Utils.toast("No location selected");
                                  return;
                                }
                                widget.item.crop_id = p.id.toString();
                                widget.item.crop_text = p.name;
                                //patch
                                _formKey.currentState!.patchValue({
                                  'crop_text': widget.item.crop_text,
                                });
                                setState(() {});
                              },
                              initialValue: widget.item.crop_text,
                              textCapitalization: TextCapitalization.sentences,
                              name: "crop_text",
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderDateTimePicker(
                              decoration: AppTheme.InputDecorationTheme1(
                                label: 'Planting date',
                              ),
                              inputType: InputType.date,
                              initialValue:
                                  Utils.toDate(widget.item.planting_date),
                              name: 'planting_date',
                              onChanged: (x) {
                                widget.item.planting_date = Utils.to_str(x, '');
                              },
                            ),
                            const SizedBox(height: 20),
                            FormBuilderDropdown<String>(
                              name: 'production_scale',
                              dropdownColor: Colors.white,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Production scale",
                              ),
                              initialValue: [
                                'Small scale',
                                'Medium scale',
                                'Large scale'
                              ].contains(widget.item.production_scale)
                                  ? widget.item.production_scale
                                  : null,
                              onChanged: (x) {
                                String y = x.toString();
                                widget.item.production_scale = y;
                                setState(() {});
                              },
                              isDense: true,
                              items: [
                                'Small scale',
                                'Medium scale',
                                'Large scale'
                              ]
                                  .map((sub) => DropdownMenuItem(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        value: sub,
                                        child: Text(sub),
                                      ))
                                  .toList(),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: FormBuilderTextField(
                                name: 'land_occupied',
                                initialValue: widget.item.land_occupied,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                onChanged: (x) {
                                  widget.item.land_occupied =
                                      Utils.to_str(x, '');
                                },
                                keyboardType: TextInputType.number,
                                decoration: AppTheme.InputDecorationTheme1(
                                  label: "Land occupied (In Acres) ",
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FormBuilderTextField(
                              name: 'details',
                              initialValue: widget.item.details,
                              textCapitalization: TextCapitalization.words,
                              minLines: 3,
                              maxLines: 4,
                              onChanged: (x) {
                                widget.item.details = Utils.to_str(x, '');
                              },
                              keyboardType: TextInputType.text,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Garden Details",
                              ),
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
                                        imageUrl: widget.item.getPhoto(),
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
                            SizedBox(
                              height: 10,
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

  List<OptionPickerModel> selectedLocations = [];
  List<LocarionModel> locations = [];
  List<GroupModel> groups = [];
  List<OptionPickerModel> subs = [];
  bool is_loading = false;
  bool isEditing = false;

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
      widget.item.crop_id = "1";
      widget.item.crop_id = element.id.toString();
      widget.item.name = element.name.toString();
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
        widget.item.crop_id = r.first.id.toString();
        widget.item.crop_text = r.first.name.toString();
        _formKey.currentState!.patchValue({
          'crop_text': widget.item.crop_text,
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
