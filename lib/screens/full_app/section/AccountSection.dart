import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/screens/account/AccountChangePassword.dart';
import 'package:marcci/screens/account/AccountEdit.dart';
import 'package:marcci/screens/gardens/ProductionGuide.dart';

import '../../../theme/custom_theme.dart';
import '../../../utils/AppConfig.dart';
import '../../../utils/Utils.dart';

class AccountSection extends StatefulWidget {
  const AccountSection({Key? key}) : super(key: key);

  @override
  _AccountSectionState createState() => _AccountSectionState();
}

class _AccountSectionState extends State<AccountSection> {
  late CustomTheme theme;

  @override
  void initState() {
    super.initState();
    theme = CustomTheme();
  }

  Widget _buildSingleRow(String name, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
        ),
        FxSpacing.width(20),
        Expanded(
            child: FxText.bodyMedium(
          name,
          fontWeight: 600,
        )),
        FxSpacing.width(20),
        const Icon(
          FeatherIcons.chevronRight,
          size: 20,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          "Account",
          color: Colors.white,
          maxLines: 2,
        ),
      ),
      body: ListView(
        padding: FxSpacing.fromLTRB(20, 20, 20, 20),
        children: [
          FxText.bodySmall(
            'MY ACCOUNT',
            fontWeight: 700,
            letterSpacing: 0.2,
            muted: true,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(
                FeatherIcons.user,
                size: 20,
              ),
              FxSpacing.width(20),
              Expanded(child: FxText.bodyMedium('My account', fontWeight: 600)),
              FxSpacing.width(20),
              FxContainer(
                onTap: () {
                  do_logout();
                },
                padding: FxSpacing.xy(20, 8),
                borderRadiusAll: 4,
                color: CustomTheme.primary,
                child: FxText.bodySmall(
                  'Log Out',
                  fontWeight: 700,
                  letterSpacing: 0.3,
                  color: CustomTheme.bg_primary_light,
                ),
              ),
            ],
          ),
          FxSpacing.height(20),
          InkWell(
            onTap: () {
              Get.to(() => AccountEdit());
            },
            child: Row(
              children: [
                Icon(
                  FeatherIcons.userCheck,
                  size: 20,
                  color: CustomTheme.primary,
                ),
                FxSpacing.width(20),
                FxText.bodyMedium('Edit my profile',
                    color: CustomTheme.primary, fontWeight: 600),
              ],
            ),
          ),
          FxSpacing.height(20),
          InkWell(
            onTap: () {
              Get.to(() => AccountChangePassword());
            },
            child: Row(
              children: [
                const Icon(
                  FeatherIcons.key,
                  size: 20,
                ),
                FxSpacing.width(20),
                FxText.bodyMedium('Change password', fontWeight: 600),
              ],
            ),
          ),
          FxSpacing.height(20),
          FxText.bodySmall(
            'MY CONTENT & ACTIVITY',
            fontWeight: 700,
            letterSpacing: 0.2,
            muted: true,
          ),
          FxSpacing.height(20),
          InkWell(
            onTap: () {
              Get.to(() => ProductionGuidesScreen({}));
            },
            child: Row(
              children: [
                const Icon(
                  FeatherIcons.anchor,
                  size: 20,
                ),
                FxSpacing.width(20),
                Expanded(
                    child: FxText.bodyMedium(
                  'My Gardens',
                  fontWeight: 600,
                )),
                FxSpacing.width(20),
                FxContainer(
                  color: Colors.red.shade700,
                  paddingAll: 3,
                  borderRadiusAll: 50,
                  child: FxText.bodyMedium(
                    '12',
                    color: Colors.white,
                    fontWeight: 600,
                    muted: true,
                  ),
                ),
                FxSpacing.width(4),
                const Icon(
                  FeatherIcons.chevronRight,
                  size: 20,
                ),
              ],
            ),
          ),
          FxSpacing.height(20),
          InkWell(
            onTap: () {
              Utils.toast("Coming soon...");
            },
            child: Row(
              children: [
                const Icon(
                  FeatherIcons.tag,
                  size: 20,
                ),
                FxSpacing.width(20),
                Expanded(
                    child: FxText.bodyMedium(
                  'My Products & Services',
                  fontWeight: 600,
                )),
                FxSpacing.width(20),
                FxText.bodyMedium(
                  '42',
                  fontWeight: 600,
                  muted: true,
                ),
                FxSpacing.width(4),
                const Icon(
                  FeatherIcons.chevronRight,
                  size: 20,
                ),
              ],
            ),
          ),
          FxSpacing.height(20),
          InkWell(
            onTap: () {
              Utils.toast("Coming soon...");
            },
            child: Row(
              children: [
                const Icon(
                  Icons.question_mark,
                  size: 20,
                ),
                FxSpacing.width(20),
                Expanded(
                    child: FxText.bodyMedium(
                  'My Questions',
                  fontWeight: 600,
                )),
                FxSpacing.width(20),
                FxText.bodyMedium(
                  '11',
                  fontWeight: 600,
                  muted: true,
                ),
                FxSpacing.width(4),
                const Icon(
                  FeatherIcons.chevronRight,
                  size: 20,
                ),
              ],
            ),
          ),
          FxSpacing.height(20),
          FxSpacing.height(20),
          FxText.bodySmall(
            'SUPPORT',
            fontWeight: 700,
            letterSpacing: 0.2,
            muted: true,
          ),
          FxSpacing.height(20),
          _buildSingleRow('NARO HOTLINE - Toll free', FeatherIcons.phone),
          FxSpacing.height(20),
          _buildSingleRow('Important contacts', FeatherIcons.list),
          FxSpacing.height(20),
          InkWell(
              onTap: () {
                Utils.launchURL("${AppConfig.DASHBOARD_URL}/policy}");
              },
              child: _buildSingleRow('Privacy policy', FeatherIcons.shield)),
          FxSpacing.height(20),
          _buildSingleRow(
              'Report a technical problem', FeatherIcons.alertOctagon),
          FxSpacing.height(20),
          const Divider(
            thickness: 0.8,
          ),
          FxSpacing.height(8),
          FxContainer(
            color: CustomTheme.primary.withAlpha(28),
            borderRadiusAll: 4,
            child: FxText.bodyMedium(
              "© 2023 NARO GROUNDNUT - All rights reserved.",
              textAlign: TextAlign.center,
              fontWeight: 700,
              letterSpacing: 0.2,
              color: CustomTheme.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> do_logout() async {
    Utils.toast("Logging you out!");
    Utils.logout();
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushNamedAndRemoveUntil(
        context, "/OnBoardingScreen", (r) => false);
  }
}
