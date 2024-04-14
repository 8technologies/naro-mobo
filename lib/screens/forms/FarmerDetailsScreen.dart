import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:get/get.dart';
import 'package:marcci/models/FarmModel.dart';
import 'package:marcci/models/FarmerOfflineModel.dart';

import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import 'FarmerProfilingStep1Screen.dart';

class FarmerDetailsScreen extends StatefulWidget {
  FarmModel item;

  FarmerDetailsScreen(this.item, {super.key});

  @override
  State<FarmerDetailsScreen> createState() => _FarmerDetailsScreenState();
}

class _FarmerDetailsScreenState extends State<FarmerDetailsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: FxText.titleLarge(
            "Farmer Details",
            color: Colors.white,
            fontWeight: 700,
          ),
          backgroundColor: CustomTheme.primary,
          actions: [
            IconButton(
              onPressed: () {
                FarmerOfflineModel off = FarmerOfflineModel();
                off = FarmerOfflineModel.fromJson(widget.item.toJson());
                off.local_id = widget.item.id.toString();
                Get.to(() => FarmerProfilingStep1Screen(off));
              },
              icon: const Icon(
                Icons.edit,
                size: 25,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                title_detail_widget("First name", widget.item.first_name),
                title_detail_widget("Last name", widget.item.last_name),
                title_detail_widget("Gender", widget.item.gender),
                //marital_status
                title_detail_widget(
                    "Marital status", widget.item.marital_status),
                //family_size
                title_detail_widget("Family size", widget.item.family_size),
                //education_level
                title_detail_widget(
                    "Education Level", widget.item.education_level),
                title_detail_widget("Yea of birth", widget.item.year_of_birth),
                title_detail_widget("Phone Number", widget.item.phone),

                widget.item.phone_number.isNotEmpty
                    ? title_detail_widget(
                        "Phone Number 2", widget.item.phone_number)
                    : Container(),

                title_detail_widget("Is the phone registered on mobile money?",
                    widget.item.is_mm_registered),
                title_detail_widget("Does the phone belong to the farmer?",
                    widget.item.is_your_phone),
                title_detail_widget(
                    "National ID Number", widget.item.national_id_number),
                title_detail_widget("Email Address", widget.item.email),
                title_detail_widget("Group", widget.item.farmer_group_text),
                //is_pwd
                title_detail_widget("Is the farmer a person with disability?",
                    widget.item.is_pwd),
                //is_refugee
                title_detail_widget(
                    "Is the farmer a refugee?", widget.item.is_refugee),

                title_detail_widget("Language", widget.item.language_text),
                title_detail_widget("Other economic activities",
                    widget.item.other_economic_activity),
                title_detail_widget("Farming scale", widget.item.farming_scale),
                //land_under_farming_in_acres
                title_detail_widget("Land under farming in acres",
                    widget.item.land_under_farming_in_acres),
                //ever_bought_insurance
                title_detail_widget("Has farmer ever bought insurance?",
                    widget.item.ever_bought_insurance),
                //poverty_level
                title_detail_widget("Poverty level", widget.item.poverty_level),
                //ever_received_credit
                title_detail_widget("Has farmer ever received credit?",
                    widget.item.ever_received_credit),
                //food_security_level
                title_detail_widget(
                    "Food security level", widget.item.food_security_level),

                //date registered created_at
                title_detail_widget(
                    "Date registered", Utils.to_date_1(widget.item.created_at)),
              ],
            ),
          ),
        ));
  }
}

Widget title_detail_widget(String title, String detail) {
  return Container(
    padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
    child: Flex(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      direction: Axis.vertical,
      children: [
        FxText.titleMedium(
          title,
          fontWeight: 800,
          color: Colors.black,
        ),
        const SizedBox(
          height: 0,
        ),
        FxText.bodyMedium(
          detail.isEmpty ? "-" : detail,
          color: Colors.grey.shade600,
        ),
      ],
    ),
  );
}
