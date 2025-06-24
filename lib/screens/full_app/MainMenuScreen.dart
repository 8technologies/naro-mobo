import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/theme/custom_theme.dart';

import '../ai/AIHomeScreen.dart';
import '../account/About8TechScreen.dart';
import '../account/AboutNaroScreen.dart';
import '../crops/CropsScreen.dart';
import '../finance/TransactionList.dart';
import '../forms/FarmersScreen.dart';
import '../gardens/GardenList.dart';
import '../gardens/MyActivitiesList.dart';
import '../products/ProductsScreen.dart';
import '../service_providers/ServiceProvidersScreen.dart';
import 'WeatherForeCastScreen.dart';
import 'section/AccountSection.dart';

// A simple model to hold menu item data for a clean, data-driven UI.
class _MenuItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });
}

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  // A data list drives the UI. Easy to reorder, add, or remove items.
  late final List<_MenuItem> _menuItems;

  @override
  void initState() {
    super.initState();
    _menuItems = [
      _MenuItem(
        icon: FeatherIcons.grid,
        title: 'My Gardens',
        description: 'View & manage all your gardens.',
        color: CustomTheme.green,
        onTap: () => Get.to(() => GardenList(false)),
      ),
      _MenuItem(
        icon: FeatherIcons.activity,
        title: 'My Activities',
        description: 'Track your scheduled farm tasks.',
        color: CustomTheme.purple,
        onTap: () => Get.to(() => MyActivitiesList()),
      ),
      _MenuItem(
        icon: FeatherIcons.dollarSign,
        title: 'Finances',
        description: 'Manage your income & expenses.',
        color: CustomTheme.darkGreen,
        onTap: () => Get.to(() => TransactionListScreen()),
      ),
      _MenuItem(
        icon: FeatherIcons.cpu,
        title: 'AI Assistance',
        description: 'Disease detection & expert advice.',
        color: Colors.deepPurple,
        // Special color for AI
        onTap: () => Get.to(() => AIHomeScreen()),
      ),
      _MenuItem(
        icon: FeatherIcons.shoppingBag,
        title: 'Marketplace',
        description: 'Buy & sell farm products.',
        color: CustomTheme.peach,
        onTap: () => Get.to(() => ProductsScreen()),
      ),
      _MenuItem(
        icon: FeatherIcons.package,
        title: 'Crops & Seeds',
        description: 'Discover the best varieties.',
        color: CustomTheme.skyBlue,
        onTap: () => Get.to(() => CropsScreen({})),
      ),
      _MenuItem(
        icon: FeatherIcons.cloudDrizzle,
        title: 'Weather Info',
        description: 'Get the latest farm forecasts.',
        color: Colors.blueAccent,
        onTap: () => Get.to(() => const WeatherForeCastScreen()),
      ),
      _MenuItem(
        icon: FeatherIcons.users,
        title: 'Service Providers',
        description: 'Find local agricultural services.',
        color: CustomTheme.skyBlue,
        onTap: () => Get.to(() => ServiceProvidersScreen()),
      ),
      _MenuItem(
        icon: FeatherIcons.user,
        title: 'My Account',
        description: 'Manage your profile & settings.',
        color: Colors.grey,
        onTap: () => Get.to(() => AccountSection()),
      ),
      _MenuItem(
        icon: FeatherIcons.info,
        title: 'About NARO',
        description: 'Learn more about NARO.',
        color: Colors.black54,
        onTap: () => Get.to(() => AboutNaroScreen()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA), // Clean, light background
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: FxText.titleLarge(
          "Main Menu",
          color: Colors.black,
          fontWeight: 700,
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cards per row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.9, // Adjust for card height
        ),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          return _buildMenuItemCard(_menuItems[index]);
        },
      ),
    );
  }
}

// The new, modern menu item card widget.
Widget _buildMenuItemCard(_MenuItem item) {
  // Special styling for the AI card
  bool isAICard = item.title == 'AI Assistance';

  return InkWell(
    onTap: item.onTap,
    child: Container(
      padding: const EdgeInsets.all(16.0),
      // FIX: Use the 'decoration' property to avoid conflicts.
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // Conditionally set either the gradient or the solid color.
        gradient: isAICard
            ? LinearGradient(
                colors: [Colors.deepPurple.shade400, CustomTheme.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isAICard ? null : Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxContainer(
            paddingAll: 12,
            borderRadiusAll: 99,
            color: isAICard
                ? Colors.white.withOpacity(0.2)
                : item.color.withOpacity(0.15),
            child: Icon(
              item.icon,
              color: isAICard ? Colors.white : item.color,
              size: 24,
            ),
          ),
          Spacer(),
          FxText.titleMedium(
            item.title,
            fontWeight: 700,
            color: isAICard ? Colors.white : Colors.black,
          ),
          SizedBox(height: 4),
          FxText.bodySmall(
            item.description,
            height: 1.3,
            color:
                isAICard ? Colors.white.withOpacity(0.8) : Colors.grey.shade600,
          ),
        ],
      ),
    ),
  );
}
