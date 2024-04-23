import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/theme/app_theme.dart';
import 'package:marcci/utils/Utils.dart';

import 'LeafspotDetectionScreen.dart';

class AIHomeScreen extends StatefulWidget {
  @override
  State<AIHomeScreen> createState() => _AIHomeScreenState();
}

class _AIHomeScreenState extends State<AIHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FxText.titleLarge(
          'NARO - Ai',
          color: Colors.white,
          fontWeight: 900,
        ),
        backgroundColor: CustomTheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: FxText.titleLarge(
                'AI Integration',
                fontWeight: 900,
                fontSize: 35.0,
                textAlign: TextAlign.center,
                color: Colors.red.shade700,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'NARO APP brings AI to Ugandan groundnut farming! Identify varieties, fight disease early, and predict your yield - all for a healthier harvest and maximized profits.',
              style: TextStyle(
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Exciting Features Coming Soon:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 15.0),
            FeatureItem(
              icon: 'ai_prediction.jpeg',
              title: 'Variety Detection',
              description:
                  'Identify groundnut varieties with your phone camera.',
            ),
            FxContainer(
              child: FeatureItem(
                icon: 'ai_pests_detect.jpeg',
                title: 'Pest & Disease Detection',
                description:
                    'Detect pests, diseases, and leaf spots on your crops.',
              ),
                onTap: () {
                  Get.to(() => LeafSpotDetectionScreen());
                }
            ),
            FeatureItem(
              icon: "ai_prediction_1.jpeg",
              title: 'Yield Prediction',
              description: 'AI-driven yield prediction for better planning.',
            ),
            FxButton.block(
              onPressed: () async {
                Utils.toast('Registering for notification...');
                Utils.showLoader(false);
                await Future.delayed(Duration(seconds: 4));
                Utils.toast('Registration successful!');
                Utils.hideLoader();
                Get.back();
              },
              child: FxText.titleLarge(
                'Notify Me When Available',
                color: Colors.white,
                fontWeight: 800,
              ),
              backgroundColor: CustomTheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  FeatureItem(
      {required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 20.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25.0),
              topLeft: Radius.circular(25.0),
              bottomLeft: Radius.circular(25.0),
            ),
            child: Image.asset(
              'assets/images/${icon}', // Placeholder for your app logo
              width: 130,
              height: 130,
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
