import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:marcci/screens/account/login_screen.dart';
import 'package:marcci/theme/app_theme.dart';

import '../../utils/AppConfig.dart';
import 'RegisterScreen.dart';

class BoardingWelcomeScreen extends StatefulWidget {
  BoardingWelcomeScreen();

  @override
  _CourseTasksScreenState createState() => _CourseTasksScreenState();
}

class _CourseTasksScreenState extends State<BoardingWelcomeScreen> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  _CourseTasksScreenState();

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Image(
                image: AssetImage(
                  AppConfig.logo,
                ),
                fit: BoxFit.cover,
                width: (MediaQuery.of(context).size.width / 2.5),
              ),
            ),
            SizedBox(
              height: 45,
            ),
            FxText.headlineMedium(
              "Welcome to ${AppConfig.APP_NAME}!",
              fontWeight: 900,
              color: CustomTheme.primary,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                children: [
                  FxText.bodyLarge(
                    "Introducing ${AppConfig.APP_NAME} Mobile App - the ultimate mobile app for farmers."
                    "\n\nManage your crops with precision using researched production protocols, smart notifications, and expert advice. Stay on top of tasks, receive real-time weather updates, and optimize your farming operations. "
                    "\n\nLet's get started now with ${AppConfig.APP_NAME} App for efficient and successful crop management!",
                    fontWeight: 600,
                    textAlign: TextAlign.justify,
                    color: Colors.grey.shade800,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FxButton.rounded(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
              child: FxText.headlineSmall(
                'Create Account',
                fontWeight: 800,
                color: Colors.white,
              ),
              borderRadiusAll: 100,
              onPressed: () {
                Get.to(() => RegisterScreen());
              },
              backgroundColor: CustomTheme.primaryDark,
            ),
            SizedBox(
              height: 20,
            ),
            Divider(),
            Row(
              children: [
                FxText.bodyLarge('Already have account?'),
                FxButton.text(
                    padding: EdgeInsets.only(
                      left: 2,
                    ),
                    onPressed: () {
                      Get.to(() => LoginScreen());
                    },
                    child: FxText.bodyLarge(
                      'Login',
                      fontWeight: 800,
                      color: CustomTheme.primaryDark,
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    ));
  }
}
