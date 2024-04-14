import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:marcci/screens/OnBoardingScreen.dart';
import 'package:marcci/screens/full_app/full_app.dart';
import 'package:marcci/theme/app_theme.dart';
import 'package:marcci/utils/AppConfig.dart';

void main() {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();

  //
  // CustomTheme.primary = Color(0xff09a0ce);
  // CustomTheme.primaryDark = Color(0xff09a0ce);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme.init();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      onInit: () {},
      builder: EasyLoading.init(),
      home: OnBoardingScreen(),
      routes: {
        '/OnBoardingScreen': (context) => OnBoardingScreen(),
        AppConfig.FullApp: (context) => FullApp(),
      },
    );
  }
}

class GlobalMaterialLocalizations {}
