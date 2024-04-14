import 'dart:io';

import 'package:dio/dio.dart' as DioObj;
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marcci/models/FinancialRecordModel.dart';
import 'package:marcci/models/GardenModel.dart';

import '../../models/RespondModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';

class TransactionCreateScreen extends StatefulWidget {
  TransactionCreateScreen({
    Key? key,
  }) : super(key: key);

  @override
  _TransactionCreateScreenState createState() =>
      _TransactionCreateScreenState();
}

class _TransactionCreateScreenState extends State<TransactionCreateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool onLoading = false;
  String error_message = "";
  FinancialRecordModel item = FinancialRecordModel();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    setState(() {});
    financeAccounts = await GardenModel.get_items();
    GardenModel.get_items();
  }

  String message = "";
  bool isSuccess = false;

  Future<void> submit_form({
    bool announceChanges = false,
    bool askReset = false,
  }) async {
    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please first fix errors.");
      return;
    }

    setState(() {
      message = "";
      onLoading = true;
    });

    Map<String, dynamic> formDataMap = item.toJson();
    if (local_image_path.isNotEmpty) {
      formDataMap['file'] = await DioObj.MultipartFile.fromFile(
          local_image_path,
          filename: local_image_path);
    }
    formDataMap['date'] = item.created_at;

    RespondModel r = RespondModel(
        await Utils.http_post(FinancialRecordModel.end_point, formDataMap));

    try {
      await FinancialRecordModel.get_items();
    } catch (e) {
      Utils.toast("Failed to refresh records because $e");
    }
    setState(() {
      onLoading = false;
    });

    message = r.message;
    if (r.code == 1) {
      isSuccess = true;
      FinancialRecordModel rec = FinancialRecordModel.fromJson(r.data);
      if (rec.id > 0) {
        try {
          await rec.save();
        } catch (e) {
          Utils.toast("Failed to save record to local because $e");
        }
      }

      Utils.toast('Transaction created successfully!');
      Navigator.pop(context);
      //await FinanceCategory.getOnlineItems();
      return;
    }
    isSuccess = false;

    Utils.toast(r.message);

    return;
  }

  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;

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

  String local_image_path = "";

  void resetForm() {
    setState(() {});

    _formKey.currentState!.reset();
    _formKey.currentState!.patchValue({
      'finance_category_text': '',
      'amount': '',
      'type': '',
      'transaction_date': '',
      'description': '',
    });

    item = new FinancialRecordModel();

    setState(() {});
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
          "Creating financial record",
          fontWeight: 800,
          color: Colors.white,
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              submit_form();
            },
            child: (item.description.length < 3)
                ? SizedBox()
                : onLoading
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ))
                    : Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(FeatherIcons.check,
                            size: MySize.size30, color: Colors.white),
                      ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(
                          height: 15,
                        ),
                        FormBuilderDateTimePicker(
                          name: 'transaction_date',
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          onChanged: (x) {
                            item.created_at = Utils.to_str(x, '');
                            setState(() {});
                          },
                          lastDate: DateTime.now(),
                          inputType: InputType.date,
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "Transaction date",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Date is required.",
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FormBuilderTextField(
                          name: 'garden_text',
                          initialValue: item.garden_text,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          readOnly: true,
                          onTap: () {
                            showBottomSheetAccountPicker();
                          },
                          keyboardType: TextInputType.name,
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "Select garden",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Garden is required.",
                            ),
                          ]),
                        ),

/*                        Align(
                          alignment: Alignment.centerLeft,
                          child: FxButton.text(
                              onPressed: () async {
                                */ /* await Get.to(
                                    () => FinancialAccountCreateScreen());*/ /*
                                //await RespondModel.get_items();
                                init();
                              },
                              child: FxText.titleMedium(
                                "Create new category",
                                color: CustomTheme.primary,
                                fontWeight: 900,
                              )),
                        ),*/
                        SizedBox(
                          height: 25,
                        ),
                        FormBuilderRadioGroup(
                          name: 'category',
                          onChanged: (x) {
                            item.category = x.toString();
                            setState(() {});
                          },
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "Transaction type",
                          ),
                          options: [
                            FormBuilderFieldOption(
                                value: 'Income',
                                child: const Text('Income (+)')),
                            FormBuilderFieldOption(
                                value: 'Expense',
                                child: const Text('Expense (-)')),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 20),
                          child: FormBuilderTextField(
                            name: 'amount',
                            initialValue: "",
                            textInputAction: TextInputAction.next,
                            readOnly: false,
                            onChanged: (x) {
                              item.amount = x.toString();
                              setState(() {});
                            },
                            keyboardType: TextInputType.number,
                            decoration: AppTheme.InputDecorationTheme1(
                              label: "Amount",
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.min(
                                1,
                                errorText: "Amount too low.",
                              ),
                              FormBuilderValidators.required(
                                errorText: "Amount is required.",
                              ),
                            ]),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 0, top: 10),
                          child: FormBuilderTextField(
                            name: 'description',
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.done,
                            onChanged: (x) {
                              item.description = Utils.to_str(x, '');
                              setState(() {});
                            },
                            keyboardType: TextInputType.name,
                            decoration: AppTheme.InputDecorationTheme1(
                              label: "Record description",
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.minLength(
                                3,
                                errorText: "Description too short.",
                              ),
                              FormBuilderValidators.required(
                                errorText: "Account description is required.",
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            showImagePicker(context);
                          },
                          child: FxContainer(
                            bordered: true,
                            border: Border.all(color: CustomTheme.primary),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    local_image_path.isEmpty
                                        ? SizedBox()
                                        : Image.file(
                                            File(local_image_path),
                                            fit: BoxFit.cover,
                                            width: Get.width / 5,
                                            height: Get.width / 5,
                                          ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        FxText.titleLarge(
                                            "Attach a receipt photo",
                                            color: CustomTheme.primary,
                                            fontWeight: 900,
                                            fontSize: 20),
                                        FxText.bodySmall("(Optional)",
                                            color: Colors.black,
                                            fontWeight: 400,
                                            fontSize: 12),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        message.isEmpty
                            ? SizedBox()
                            : FxContainer(
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 0, top: 10),
                                child: FxText.bodyMedium(
                                  message,
                                  color: isSuccess
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                  fontWeight: 900,
                                ),
                              ),
                        onLoading
                            ? Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      CustomTheme.primary),
                                ))
                            : InkWell(
                                onTap: () {
                                  submit_form();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: CustomTheme.primary),
                                    color: CustomTheme.primary.withAlpha(25),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: FxText.bodyMedium(
                                              "SAVE TRANSACTION",
                                              fontSize: 20,
                                              color: CustomTheme.primary)),
                                    ],
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<Null> _onRefresh() async {
    init();
    return null;
  }

  List<GardenModel> financeAccounts = [];

  Future<void> showBottomSheetAccountPicker() async {
    await GardenModel.get_items();
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MySize.size16),
                  topRight: Radius.circular(MySize.size16),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    child: FxText.titleLarge(
                      "Select garden",
                      fontWeight: 800,
                      color: CustomTheme.primary,
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: Colors.white,
                      backgroundColor: CustomTheme.primary,
                      child: Container(
                        padding: EdgeInsets.only(top: 0),
                        child: ListView.builder(
                          itemBuilder: (context, position) {
                            return ListTile(
                              enableFeedback: true,
                              onTap: () {
                                item.garden_id =
                                    financeAccounts[position].id.toString();
                                item.garden_text =
                                    financeAccounts[position].name;
                                _formKey.currentState!.patchValue({
                                  'garden_text': financeAccounts[position].name,
                                });
                                setState(() {});
                                Navigator.pop(context);
                              },
                              title: FxText.titleMedium(
                                financeAccounts[position].name,
                                color: CustomTheme.primary,
                                fontWeight: 700,
                              ),
                              subtitle: FxText.bodySmall(
                                  financeAccounts[position].details),
                              /*trailing: FxText(
                                financeAccounts[position].balance_text,
                                color: (Utils.int_parse(financeAccounts[position]
                                            .balance
                                            .toString()) <
                                        0)
                                    ? Colors.red.shade700
                                    : Colors.black,
                                maxLines: 1,
                                fontWeight: 800,
                              ),*/
                              visualDensity: VisualDensity.compact,
                              dense: true,
                            );
                          },
                          itemCount: financeAccounts.length,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
