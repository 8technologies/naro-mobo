import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/models/GardenModel.dart';
import 'package:marcci/theme/custom_theme.dart';
import 'package:marcci/utils/AppConfig.dart';

import 'GardenCreateScreen.dart';
import 'GardenScreen.dart';

class GardenList extends StatefulWidget {
  final bool isPick;

  GardenList(this.isPick, {Key? key}) : super(key: key);

  @override
  _GardenListState createState() => _GardenListState();
}

class _GardenListState extends State<GardenList> {
  late Future<void> futureInit;
  List<GardenModel> _allItems = [];
  List<GardenModel> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureInit = doRefresh();
    _searchController.addListener(_filterGardens);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterGardens);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> doRefresh() async {
    setState(() {
      futureInit = myInit();
    });
  }

  Future<void> myInit() async {
    _allItems = await GardenModel.get_items();
    _filteredItems = _allItems;
  }

  void _filterGardens() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems.where((garden) {
        return garden.name.toLowerCase().contains(query) ||
            garden.crop_text.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA), // Clean, light background
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: FxText.titleLarge("My Gardens",
            color: Colors.black, fontWeight: 700),
        actions: [
          IconButton(
            icon: Icon(FeatherIcons.plusCircle,
                color: CustomTheme.primary, size: 28),
            onPressed: () async {
              await Get.to(() => GardenCreateScreen(GardenModel()));
              doRefresh(); // Refresh list after creation
            },
            tooltip: 'Create New Garden',
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: futureInit,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(color: CustomTheme.primary));
            }
            return _buildMainContent();
          },
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildHeaderAndSearch(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: doRefresh,
            color: CustomTheme.primary,
            child: _filteredItems.isEmpty
                ? _buildEmptyState()
                : _buildGardensListView(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderAndSearch() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.bodyLarge(
            "You are managing ${_allItems.length} garden${_allItems.length == 1 ? '' : 's'}.",
            color: Colors.grey.shade700,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by garden or crop name...',
              prefixIcon:
                  Icon(FeatherIcons.search, color: Colors.grey.shade500),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: CustomTheme.primary, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGardensListView() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        GardenModel m = _filteredItems[index];
        return _buildGardenListItem(m); // Changed to the new list item widget
      },
    );
  }

  // The new, compact list item widget
  Widget _buildGardenListItem(GardenModel garden) {
    return FxContainer(
      onTap: () {
        if (widget.isPick) {
          Get.back(result: garden);
          return;
        }
        Get.to(() => GardenScreen(garden));
      },
      margin: EdgeInsets.only(bottom: 12),
      color: Colors.white,
      borderRadiusAll: 12,
      paddingAll: 12,
      child: Row(
        children: [
          // Left side: Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              "${AppConfig.STORAGE_URL}/${garden.photo}",
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/gardens.png',
                    height: 80, width: 80, fit: BoxFit.cover);
              },
            ),
          ),
          SizedBox(width: 16),
          // Middle: Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.titleMedium(garden.name,
                    fontWeight: 700, overflow: TextOverflow.ellipsis),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(FeatherIcons.award,
                        size: 14, color: Colors.grey.shade600),
                    SizedBox(width: 6),
                    Expanded(
                        child: FxText.bodyMedium(garden.crop_text,
                            color: Colors.grey.shade700,
                            overflow: TextOverflow.ellipsis)),
                  ],
                ),
                SizedBox(height: 8),
                _buildStatusChip(garden.status),
              ],
            ),
          ),
          // Right side: Chevron
          Icon(FeatherIcons.chevronRight, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor = CustomTheme.skyBlue;
    if (status.toLowerCase() == 'harvested') {
      chipColor = CustomTheme.green;
    } else if (status.toLowerCase() == 'growing') {
      chipColor = CustomTheme.peach;
    }

    return FxContainer(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      color: chipColor.withOpacity(0.1),
      borderRadiusAll: 8,
      child: FxText.bodySmall(
        status.isNotEmpty ? status : "N/A",
        color: chipColor.withBlue(100).withGreen(50),
        fontWeight: 700,
      ),
    );
  }

  Widget _buildEmptyState() {
    bool isSearching = _searchController.text.isNotEmpty;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? FeatherIcons.search : FeatherIcons.wind,
            size: 60,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 24),
          FxText.titleLarge(
            isSearching ? "No Results Found" : "No Gardens Yet",
            fontWeight: 700,
            color: Colors.grey.shade800,
          ),
          SizedBox(height: 8),
          FxText.bodyLarge(
            isSearching
                ? "Try a different search term."
                : "Create your first garden to get started.",
            color: Colors.grey.shade600,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          if (!isSearching)
            ElevatedButton.icon(
              onPressed: () async {
                await Get.to(() => GardenCreateScreen(GardenModel()));
                doRefresh();
              },
              icon: Icon(Icons.add),
              label: FxText.bodyLarge("Create a Garden", fontWeight: 700),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomTheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
        ],
      ),
    );
  }
}
