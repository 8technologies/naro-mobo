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
import 'package:marcci/models/ProductModel.dart';
import 'package:marcci/models/RespondModel.dart';
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

class ProductCreateScreen extends StatefulWidget {
  ProductCreateScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ProductCreateScreenState createState() => _ProductCreateScreenState();
}

class _ProductCreateScreenState extends State<ProductCreateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool onLoading = false;
  String error_message = "";
  ProductModel item = ProductModel();

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

    Map<String, dynamic> formDataMap = {
      'name': _formKey.currentState!.fields['name']!.value,
      'category': _formKey.currentState!.fields['category']!.value,
      'price': _formKey.currentState!.fields['price']!.value,
      'offer_type': _formKey.currentState!.fields['offer_type']!.value,
      'details': _formKey.currentState!.fields['details']!.value,
      'state': _formKey.currentState!.fields['state']!.value,
    };
    if (local_image_path.isNotEmpty) {
      formDataMap['file'] = await DioObj.MultipartFile.fromFile(
          local_image_path,
          filename: local_image_path);
    }

    RespondModel r =
        RespondModel(await Utils.http_post('products', formDataMap));

    if (r.code != 1) {
      Utils.toast('Failed to update because ${r.message}.', color: Colors.red);
      error_message = r.message;
      setState(() {
        onLoading = false;
      });
      return;
    }

    await GardenModel.get_items();
    await GardenModel.get_items();

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
      'details': '',
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
          "Creating new product",
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
                            FxText.titleLarge(
                              'Item\'s Photo',
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

                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderDropdown<String>(
                              name: 'category',
                              dropdownColor: Colors.white,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Item's category",
                              ),
                              onChanged: (x) {
                                String y = x.toString();
                                item.category = y;
                                setState(() {});
                              },
                              isDense: true,
                              items: [
                                'Crop',
                                'Farm tool',
                                'Fertilizer',
                                'Pesticide',
                                'Seed',
                                'Service'
                                    'Other'
                              ]
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
                            FormBuilderDropdown<String>(
                              name: 'offer_type',
                              dropdownColor: Colors.white,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Nature of offer",
                              ),
                              onChanged: (x) {
                                String y = x.toString();
                                item.offer_type = y;
                                setState(() {});
                              },
                              isDense: true,
                              items: [
                                'For Sale',
                                'For Hire',
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
                              margin: EdgeInsets.only(bottom: 10, top: 20),
                              child: FormBuilderTextField(
                                name: 'name',
                                initialValue: item.name,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                onChanged: (x) {
                                  item.name = Utils.to_str(x, '');
                                },
                                keyboardType: TextInputType.name,
                                decoration: AppTheme.InputDecorationTheme1(
                                  label: "Product Name",
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Product name is required.",
                                  ),
                                ]),
                              ),
                            ),

                            Container(
                              margin:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: FormBuilderTextField(
                                name: 'price',
                                initialValue: item.price,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                onChanged: (x) {
                                  item.price = Utils.to_str(x, '');
                                },
                                keyboardType: TextInputType.number,
                                decoration: AppTheme.InputDecorationTheme1(
                                  label: "Unit Price (UGX) ",
                                ),
                              ),
                            ),

                            FormBuilderTextField(
                              name: 'state',
                              initialValue: item.state,
                              textCapitalization: TextCapitalization.none,
                              onChanged: (x) {
                                item.state = Utils.to_str(x, '');
                              },
                              keyboardType: TextInputType.number,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Contact Phone Number",
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FormBuilderTextField(
                              name: 'details',
                              initialValue: item.details,
                              textCapitalization: TextCapitalization.words,
                              minLines: 3,
                              maxLines: 4,

                              onChanged: (x) {
                                item.details = Utils.to_str(x, '');
                              },
                              keyboardType: TextInputType.text,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Item\'s Details",
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
                                          "UPLOAD PRODUCT",
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
