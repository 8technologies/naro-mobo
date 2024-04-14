import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../models/FarmerOfflineModel.dart';
import '../../models/ParishModel.dart';
import '../../sections/widgets.dart';
import '../../theme/app_theme.dart';
import '../../utils/Utils.dart';
import '../pickers/ParishPickerScreen.dart';

class FarmerProfilingStep1Screen extends StatefulWidget {
  FarmerOfflineModel item;

  FarmerProfilingStep1Screen(
    this.item, {
    Key? key,
  }) : super(key: key);

  @override
  FarmerProfilingStep1ScreenState createState() =>
      FarmerProfilingStep1ScreenState();
}

class FarmerProfilingStep1ScreenState extends State<FarmerProfilingStep1Screen>
    with SingleTickerProviderStateMixin {
  var initFuture;
  final _fKey = GlobalKey<FormBuilderState>();
  String error_message = "";

  Future<bool> init_form() async {
    if (widget.item.first_name.isNotEmpty) {
      //_fKey.currentState!.patchValue(widget.item.toJson());
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    initFuture = init_form();
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        title: FxText.titleMedium(
          "Farmer profiling",
          fontSize: 20,
          fontWeight: 700,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CustomTheme.primary,
        actions: [
          FxButton.text(
              onPressed: () {
                submit_form();
              },
              backgroundColor: Colors.white,
              child: FxText.bodyLarge(
                "SAVE",
                fontWeight: 800,
                color: Colors.white,
              ))
        ],
      ),
      body: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            return FormBuilder(
              key: _fKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 0,
                          right: 15,
                        ),
                        child: Column(
                          children: [
                            section_1_personal_information(
                                "PERSONAL INFORMATION"),
                            section_2_LOCATION_INFORMATION(
                                'LOCATION INFORMATION'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  _keyboardVisible
                      ? SizedBox()
                      : FxContainer(
                          color: Colors.white,
                          borderRadiusAll: 0,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Column(
                            children: [
                              FxButton.block(
                                  padding: const EdgeInsets.all(16),
                                  borderRadiusAll: 12,
                                  onPressed: () {
                                    submit_form();
                                  },
                                  block: false,
                                  backgroundColor: CustomTheme.primary,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FxText.titleLarge(
                                        'SUBMIT',
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        FeatherIcons.upload,
                                        color: Colors.white,
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              FxButton.block(
                                  padding: const EdgeInsets.all(16),
                                  borderRadiusAll: 12,
                                  onPressed: () async {
                                    try {
                                      await widget.item.save();
                                      Utils.toast("Saved to local storage");
                                      //pop
                                      Navigator.pop(context, true);
                                    } catch (e) {
                                      Utils.toast(
                                          "Failed to save to local storage",
                                          color: Colors.red.shade700);
                                    }
                                  },
                                  block: false,
                                  backgroundColor: Colors.orange.shade700,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FxText.titleLarge(
                                        'SAVE AS DRAFT',
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        FeatherIcons.save,
                                        color: Colors.white,
                                      )
                                    ],
                                  )),
                            ],
                          ))
                ],
              ),
            );
          }),
    );
  }

  bool _keyboardVisible = false;

  section_2_WORKFORCE(String title) {
    return Column(
      children: [
        SizedBox(height: 10),
        FxContainer(
          paddingAll: 10,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          color: CustomTheme.primary,
          child: FxText.bodyLarge(
            title,
            fontWeight: 600,
            fontSize: 20,
            textAlign: TextAlign.center,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label:
                GetStringUtils("Labor force / Number of employees").capitalize!,
          ),
          keyboardType: TextInputType.number,
          initialValue: widget.item.labor_force,
          textCapitalization: TextCapitalization.words,
          name: "labor_force",
          onChanged: (x) {
            widget.item.labor_force = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
        SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Farm Equipment owned").capitalize!,
          ),
          keyboardType: TextInputType.text,
          initialValue: widget.item.equipment_owned,
          textCapitalization: TextCapitalization.words,
          name: "equipment_owned",
          onChanged: (x) {
            widget.item.equipment_owned = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'livestock',
          initialValue: Utils.initValue(widget.item.livestock, [
            'Yes',
            'No',
          ]),
          items: [
            'Yes',
            'No',
          ]
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item.toString()),
                  ))
              .toList(),
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Does a farmer have livestock?").capitalize!,
          ),
          onChanged: (x) {
            widget.item.livestock = x.toString();
            setState(() {});
          },
        ),
        widget.item.livestock == 'Yes'
            ? Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Number of cattle").capitalize!,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: widget.item.cattle_count,
                    textCapitalization: TextCapitalization.words,
                    name: "cattle_count",
                    onChanged: (x) {
                      widget.item.cattle_count = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Number of goats").capitalize!,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: widget.item.goat_count,
                    textCapitalization: TextCapitalization.words,
                    name: "goat_count",
                    onChanged: (x) {
                      widget.item.goat_count = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Number of sheep").capitalize!,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: widget.item.sheep_count,
                    textCapitalization: TextCapitalization.words,
                    name: "sheep_count",
                    onChanged: (x) {
                      widget.item.sheep_count = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Number of poultry").capitalize!,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: widget.item.poultry_count,
                    textCapitalization: TextCapitalization.words,
                    name: "poultry_count",
                    onChanged: (x) {
                      widget.item.poultry_count = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Number of livestock").capitalize!,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: widget.item.other_livestock_count,
                    textCapitalization: TextCapitalization.words,
                    name: "other_livestock_count",
                    onChanged: (x) {
                      widget.item.other_livestock_count = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                ],
              )
            : SizedBox(),
        const SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Crops grown").capitalize!,
          ),
          initialValue: widget.item.crops_grown,
          name: "crops_grown",
          onChanged: (x) {
            widget.item.crops_grown = x.toString();
          },
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  section_2_BUSINESS_PLANNING(String title) {
    return Column(
      children: [
        SizedBox(height: 10),
        FxContainer(
          paddingAll: 10,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          color: CustomTheme.primary,
          child: FxText.bodyLarge(
            title,
            fontWeight: 600,
            fontSize: 20,
            textAlign: TextAlign.center,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'farming_scale',
          initialValue: Utils.initValue(widget.item.farming_scale, [
            'Small scale',
            'Medium scale',
            'Large scale',
          ]),
          items: [
            'Small scale',
            'Medium scale',
            'Large scale',
          ].map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item.toString()),
            );
          }).toList(),
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Farming Production Scale").capitalize!,
          ),
          onChanged: (x) {
            widget.item.farming_scale = x.toString();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'ever_bought_insurance',
          initialValue: Utils.initValue(widget.item.ever_bought_insurance, [
            'Yes',
            'No',
          ]),
          items: [
            'Yes',
            'No',
          ]
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item.toString()),
                  ))
              .toList(),
          decoration: CustomTheme.in_3(
            label: GetStringUtils(
                    "Has this farmer bought insurance in past 6 months?")
                .capitalize!,
          ),
          onChanged: (x) {
            widget.item.ever_bought_insurance = x.toString();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 15,
        ),
        (widget.item.ever_bought_insurance != "Yes")
            ? SizedBox()
            : Column(
                children: [
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label:
                          GetStringUtils("Insurance company name").capitalize!,
                    ),
                    initialValue: widget.item.insurance_company_name,
                    textCapitalization: TextCapitalization.words,
                    name: "insurance_company_name",
                    onChanged: (x) {
                      widget.item.insurance_company_name = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label:
                          GetStringUtils("Insurance cost (in UGX)").capitalize!,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: widget.item.insurance_cost,
                    textCapitalization: TextCapitalization.words,
                    name: "insurance_cost",
                    onChanged: (x) {
                      widget.item.insurance_cost = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label:
                          GetStringUtils("Insurance Repay Amount").capitalize!,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: widget.item.repaid_amount,
                    textCapitalization: TextCapitalization.words,
                    name: "repaid_amount",
                    onChanged: (x) {
                      widget.item.repaid_amount = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Covered risks").capitalize!,
                    ),
                    keyboardType: TextInputType.text,
                    initialValue: widget.item.covered_risks,
                    textCapitalization: TextCapitalization.words,
                    name: "covered_risks",
                    onChanged: (x) {
                      widget.item.covered_risks = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  Divider(),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'food_security_level',
          initialValue: Utils.initValue(widget.item.food_security_level, [
            'High food security',
            'Moderate food security',
            'Low food security',
            'Very low food security',
          ]),
          items: [
            'High food security',
            'Moderate food security',
            'Low food security',
            'Very low food security',
          ].map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item.toString()),
            );
          }).toList(),
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Food security level").capitalize!,
          ),
          onChanged: (x) {
            widget.item.food_security_level = x.toString();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'has_receive_loan',
          initialValue: Utils.initValue(widget.item.has_receive_loan, [
            'Yes',
            'No',
          ]),
          items: [
            'Yes',
            'No',
          ].map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item.toString()),
            );
          }).toList(),
          decoration: CustomTheme.in_3(
            label: GetStringUtils(
                    "Has this farmer received a loan in past 6 months?")
                .capitalize!,
          ),
          onChanged: (x) {
            widget.item.has_receive_loan = x.toString();
            setState(() {});
          },
        ),
        widget.item.has_receive_loan != 'Yes'
            ? SizedBox()
            : Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderDropdown(
                    dropdownColor: Colors.white,
                    isDense: true,
                    name: 'loan_usage',
                    initialValue: Utils.initValue(widget.item.loan_usage, [
                      'Input',
                      'Equipment',
                      'Livestock',
                      'Personal',
                    ]),
                    items: [
                      'Input',
                      'Equipment',
                      'Livestock',
                      'Personal',
                    ].map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item.toString()),
                      );
                    }).toList(),
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Main Purpose of Loan").capitalize!,
                    ),
                    onChanged: (x) {
                      widget.item.loan_usage = x.toString();
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Loan size (in UGX)").capitalize!,
                    ),
                    initialValue: widget.item.loan_size,
                    name: "loan_size",
                    onChanged: (x) {
                      widget.item.loan_size = x.toString();
                    },
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ],
              ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  section_2_LOCATION_INFORMATION(String title) {
    return Column(
      children: [
        SizedBox(height: 10),
        FxContainer(
          paddingAll: 10,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          color: CustomTheme.primary,
          child: FxText.bodyLarge(
            title,
            fontWeight: 600,
            fontSize: 20,
            textAlign: TextAlign.center,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: AppTheme.InputDecorationTheme1(
            label: "Garden Location (District, Subcounty & Parish)",
          ),
          validator:
              MyWidgets.my_validator_field_required(context, 'This field '),
          readOnly: true,
          onTap: () async {
            ParishModel? p = await Get.to(() => ParishPickerScreen(
                widget.item.parish_id, widget.item.parish_text));

            if (p == null) {
              Utils.toast("No location selected");
              return;
            }
            widget.item.parish_id = p.id.toString();
            widget.item.parish_text = p.name;
            //patch
            _fKey.currentState!.patchValue({
              'parish_text': widget.item.parish_text,
            });
            setState(() {});
          },
          initialValue: widget.item.parish_text,
          textCapitalization: TextCapitalization.sentences,
          name: "parish_text",
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Village").capitalize!,
          ),
          initialValue: widget.item.village,
          textCapitalization: TextCapitalization.words,
          name: "village",
          onChanged: (x) {
            widget.item.village = x.toString();
          },
          textInputAction: TextInputAction.next,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "Village is required."),
          ]),
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("GPS - Longitude").capitalize!,
          ),
          initialValue: widget.item.latitude,
          textCapitalization: TextCapitalization.words,
          name: "latitude",
          readOnly: true,
          onTap: () async {
            Utils.toast("Getting location...");
            Position? location = await Utils.get_device_location();
            widget.item.latitude = location.latitude.toString();
            widget.item.longitude = location.longitude.toString();
            _fKey.currentState!.patchValue({
              "latitude": location.latitude.toString(),
              "longitude": location.longitude.toString(),
            });
            setState(() {});
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("GPS - Longitude").capitalize!,
          ),
          initialValue: widget.item.longitude,
          textCapitalization: TextCapitalization.words,
          name: "longitude",
          readOnly: true,
          onTap: () async {
            Utils.toast("Getting location...");
            Position? location = await Utils.get_device_location();
            widget.item.latitude = location.latitude.toString();
            widget.item.longitude = location.longitude.toString();
            _fKey.currentState!.patchValue({
              "latitude": location.latitude.toString(),
              "longitude": location.longitude.toString(),
            });
            setState(() {});
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  section_1_personal_information(String title) {
    return Column(
      children: [
        const SizedBox(height: 10),
        error_message.isEmpty
            ? const SizedBox()
            : FxContainer(
                margin: const EdgeInsets.only(bottom: 10),
                color: Colors.red.shade50,
                child: Text(
                  error_message,
                ),
              ),
        FxContainer(
          paddingAll: 10,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          color: CustomTheme.primary,
          child: FxText.bodyLarge(
            "Personal Information",
            fontWeight: 600,
            fontSize: 20,
            textAlign: TextAlign.center,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("first name").capitalize!,
          ),
          initialValue: widget.item.first_name,
          textCapitalization: TextCapitalization.words,
          name: "first_name",
          onChanged: (x) {
            widget.item.first_name = x.toString();
          },
          textInputAction: TextInputAction.next,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
                errorText: "First Name is required."),
          ]),
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("last name").capitalize!,
          ),
          initialValue: widget.item.last_name,
          textCapitalization: TextCapitalization.words,
          name: "last_name",
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
                errorText: "Last Name  is required."),
          ]),
          onChanged: (x) {
            widget.item.last_name = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 15),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'gender',
          initialValue: Utils.initValue(
            widget.item.gender,
            [
              'Male',
              'Female',
            ],
          ),
          items: [
            'Male',
            'Female',
          ]
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item.toString()),
                  ))
              .toList(),
          decoration: CustomTheme.in_3(
            label: GetStringUtils("gender").capitalize!,
          ),
          onChanged: (x) {
            widget.item.gender = x.toString();

            setState(() {});
          },
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "Gender is required."),
          ]),
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Year of birth").capitalize!,
          ),
          keyboardType: TextInputType.number,
          initialValue: widget.item.year_of_birth,
          name: "year_of_birth",
          onChanged: (x) {
            widget.item.year_of_birth = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("phone number").capitalize!,
          ),
          initialValue: widget.item.phone_number,
          textCapitalization: TextCapitalization.words,
          name: "phone_number",
          onChanged: (x) {
            widget.item.phone_number = x.toString();
          },
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
                errorText: "Phone number is required."),
            FormBuilderValidators.minLength(10,
                errorText: "Phone number is too short."),
            FormBuilderValidators.maxLength(10,
                errorText: "Phone number is too long."),
          ]),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 15),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'phone_type',
          initialValue: Utils.initValue(
            widget.item.phone_type,
            [
              'Feature phone',
              'Smart phone',
            ],
          ),
          items: [
            'Feature phone',
            'Smart phone',
          ]
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item.toString()),
                  ))
              .toList(),
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Phone type").capitalize!,
          ),
          onChanged: (x) {
            widget.item.phone_type = x.toString();
            setState(() {});
          },
        ),
        const SizedBox(height: 15),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'education_level',
          initialValue: Utils.initValue(
            widget.item.education_level,
            [
              'Primary',
              'Secondary',
              'A\'level',
              'Tertiary',
              'University',
              'None',
            ],
          ),
          items: [
            'Primary',
            'Secondary',
            'A\'level',
            'Tertiary',
            'University',
            'None',
          ]
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item.toString()),
                  ))
              .toList(),
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Education level").capitalize!,
          ),
          onChanged: (x) {
            widget.item.education_level = x.toString();
            setState(() {});
          },
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Email Address").capitalize!,
          ),
          initialValue: widget.item.email,
          textCapitalization: TextCapitalization.words,
          name: "email",
          onChanged: (x) {
            widget.item.email = x.toString();
          },
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.email(
                errorText: "Please enter a valid email address."),
          ]),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 15),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'marital_status',
          initialValue: Utils.initValue(
            widget.item.marital_status,
            [
              'Single',
              'Married',
              'Divorced',
              'Widowed',
            ],
          ),
          items: [
            'Single',
            'Married',
            'Divorced',
            'Widowed',
          ]
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item.toString()),
                  ))
              .toList(),
          decoration: CustomTheme.in_3(
            label: GetStringUtils("marital status").capitalize!,
          ),
          onChanged: (x) {
            widget.item.marital_status = x.toString();
            setState(() {});
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  submit_form() async {
    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color: Colors.red.shade700);
      return;
    }

    if (widget.item.livestock == 'Yes') {
      if (Utils.int_parse(widget.item.cattle_count) < 1) {
        if (Utils.int_parse(widget.item.goat_count) < 1) {
          if (Utils.int_parse(widget.item.sheep_count) < 1) {
            if (Utils.int_parse(widget.item.poultry_count) < 1) {
              if (Utils.int_parse(widget.item.other_livestock_count) < 1) {
                widget.item.other_livestock_count = "0";
              }
            }
          }
        }
      }
    }

    //show bottom sheet that ask submit now or later
    //if submit now, submit to server
    //if submit later, save to local storage

    setState(() {
      error_message = "";
    });

    Utils.showLoader(false);
    widget.item.ready_for_upload = 'Yes';
    await widget.item.save();
    String error = await widget.item.submitSelf();

    Utils.hideLoader();

    if (error.isNotEmpty) {
      Utils.toast(error_message, color: Colors.red.shade700);
      setState(() {
        error_message = error;
      });
      return;
    }
    Utils.toast('Submitted successfully.');
    Navigator.pop(context, true);
    return;
  }
}
