import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/models/GardenActivity.dart';
import 'package:marcci/models/GardenModel.dart';
import 'package:marcci/screens/gardens/GardenCreateScreen.dart';
import 'package:marcci/screens/gardens/MyActivitiesCalender.dart';
import 'package:marcci/screens/gardens/MyActivitiesList.dart';
import 'package:marcci/theme/custom_theme.dart';
import 'package:marcci/utils/Utils.dart';

import '../../sections/widgets.dart';
import '../../utils/AppConfig.dart';
import '../finance/TransactionList.dart';

class GardenScreen extends StatefulWidget {
  final GardenModel item;

  GardenScreen(this.item, {super.key});

  @override
  GardenScreenState createState() => GardenScreenState();
}

class GardenScreenState extends State<GardenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: SizedBox(height: 24)),
          _buildKeyStatsGrid(),
          SliverToBoxAdapter(child: SizedBox(height: 16)),
          _buildActionButtons(),
          _buildDetailsCard(
            title: "Garden Information",
            children: [
              _buildDetailRow('Production Scale', widget.item.production_scale),
              _buildDetailRow(
                  'Date Created', Utils.to_date(widget.item.created_at)),
              _buildDetailRow('Garden GPS',
                  "${widget.item.gps_lati}, ${widget.item.gps_longi}"),
            ],
          ),
          if (widget.item.is_harvested.toLowerCase() == 'yes')
            _buildDetailsCard(
              title: "Harvest Details",
              children: [
                _buildDetailRow(
                    'Harvest Date', Utils.to_date(widget.item.harvest_date)),
                _buildDetailRow('Harvest Quality', widget.item.harvest_quality),
                _buildDetailRow(
                    'Quantity Harvested', widget.item.quantity_harvested),
                _buildDetailRow('Harvest Notes', widget.item.harvest_notes,
                    isLast: true),
              ],
            ),
          _buildDetailsCard(
            title: "General Notes",
            isHtml: true,
            htmlContent: widget.item.details,
          ),
          SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: CustomTheme.primary,
      iconTheme: IconThemeData(color: Colors.white),
      title: FxText.titleLarge(widget.item.name,
          color: Colors.white, fontWeight: 700),
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: (String value) {
            if (value == "update") {
              Get.to(() => GardenCreateScreen(widget.item));
            } else if (value == "pest") {
              Utils.toast("Coming soon!");
            }
          },
          color: Colors.white,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'update',
              child: ListTile(
                leading: Icon(FeatherIcons.edit, color: CustomTheme.primary),
                title: Text('Update Garden Info'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'pest',
              child: ListTile(
                leading: Icon(FeatherIcons.alertTriangle,
                    color: CustomTheme.primary),
                title: Text('Report Pest/Disease'),
              ),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              "${AppConfig.STORAGE_URL}/${widget.item.photo}",
              fit: BoxFit.cover,
              // Simple loading and error widgets for network images
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                    child: CircularProgressIndicator(color: Colors.white));
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/gardens.png',
                    fit: BoxFit.cover); // Fallback image
              },
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyStatsGrid() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FxContainer(
          paddingAll: 16,
          borderRadiusAll: 16,
          color: Colors.white,
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 2.5,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildStatCard(
                  FeatherIcons.award, "Crop Type", widget.item.crop_text),
              _buildStatCard(FeatherIcons.maximize, "Land Size",
                  widget.item.land_occupied),
              _buildStatCard(
                  FeatherIcons.barChart, "Status", widget.item.status),
              _buildStatCard(FeatherIcons.calendar, "Planted On",
                  Utils.to_date_1(widget.item.planting_date)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, color: CustomTheme.primary, size: 16),
            SizedBox(width: 8),
            FxText.bodyMedium(label, color: Colors.grey.shade600),
          ],
        ),
        SizedBox(height: 6),
        FxText.titleMedium(
          value.isNotEmpty ? value : "N/A",
          fontWeight: 700,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(() => MyActivitiesList());
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: CustomTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FeatherIcons.activity,
                          size: 20, color: CustomTheme.primary),
                      SizedBox(height: 8),
                      FxText.bodyLarge(
                        "Garden\nActivities",
                        fontWeight: 700,
                        textAlign: TextAlign.center,
                        color: CustomTheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.to(() => TransactionListScreen());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: CustomTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FeatherIcons.dollarSign,
                          size: 20, color: CustomTheme.primary),
                      SizedBox(height: 8),
                      FxText.bodyLarge("Financial\nRecords",
                          fontWeight: 700, color: CustomTheme.primary),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard({
    required String title,
    List<Widget> children = const [],
    bool isHtml = false,
    String? htmlContent,
  }) {
    // Don't build the card if there's no content to show
    if (!isHtml && children.isEmpty)
      return SliverToBoxAdapter(child: SizedBox.shrink());
    if (isHtml &&
        (htmlContent == null ||
            htmlContent.isEmpty ||
            htmlContent == '<p></p>')) {
      return SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: FxContainer(
          color: Colors.white,
          borderRadiusAll: 16,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxText.titleLarge(title,
                  fontWeight: 800, color: CustomTheme.primary),
              Divider(height: 24, color: Colors.grey.shade200),
              if (!isHtml)
                Column(children: children)
              else
                Html(
                  data: htmlContent,
                  style: {
                    '*': Style(
                        color: Colors.grey.shade700, fontSize: FontSize(16)),
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.bodyLarge(label, color: Colors.grey.shade600),
          SizedBox(width: 16),
          Expanded(
            child: FxText.bodyLarge(
              value.isNotEmpty ? value : "Not provided",
              fontWeight: 600,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
