import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marcci/models/LoggedInUserModel.dart';

import '../theme/app_theme.dart';
import '../utils/AppConfig.dart';
import '../utils/Utils.dart';
import 'account/login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    futureInit = my_init();
    super.initState();
    AppTheme.init();
  }

  late Future<dynamic> futureInit;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: CustomTheme.primary));
      return Scaffold(
        body: FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              return Center(
                child: InkWell(
                  onTap: () {
                    re_load();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                          image: AssetImage(
                            AppConfig.logo,
                          ),
                          fit: BoxFit.cover,
                          width: 200),
                      SizedBox(
                        height: 50,
                      ),
                      Text("⌛ Loading...")
                    ],
                  ),
                ),
              );
            }),
      );
    });
  }

  Future<dynamic> my_init() async {

    String token = await LoggedInUserModel.get_token();
    if (token.toString().length < 20) {
      Get.off(LoginScreen());
      return;
    }

    logged_in_user = (await LoggedInUserModel.getLoggedInUser());

    if (logged_in_user.id < 1) {
      Get.off(LoginScreen());
      return;
    }

    Utils.systemBoot();
    Navigator.pushNamedAndRemoveUntil(context, AppConfig.FullApp, (r) => false);

    return "Done";
  }

  bool is_loading = true;
  LoggedInUserModel logged_in_user = new LoggedInUserModel();

  void re_load() {
    setState(() {
      futureInit = my_init();
    });
  }
}
