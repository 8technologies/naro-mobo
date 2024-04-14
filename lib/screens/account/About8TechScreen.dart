import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:marcci/theme/app_theme.dart';

import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_text.dart';

class About8TechScreen extends StatefulWidget {
  const About8TechScreen({super.key});

  @override
  About8TechScreenState createState() => About8TechScreenState();
}

class About8TechScreenState extends State<About8TechScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.primary2,
      appBar: AppBar(
          backgroundColor: CustomTheme.primary2,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: CustomTheme.primary2,
              systemNavigationBarDividerColor: CustomTheme.primary2,
              statusBarColor: CustomTheme.primary2),
          title: const Text("About", style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.verified, color: Colors.white),
              onPressed: () {},
            )
          ]),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("8Tech Consults",
                  style: MyText.display1(context)!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w300)),
              Container(height: 5),
              Container(width: 120, height: 3, color: Colors.white),
              Container(height: 15),
              Text("Vision",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_20)),
              Text("“Innovating for the future generation”",
                  style: MyText.body1(context)!.copyWith(color: Colors.white)),
              Container(height: 15),
              Text("Mission",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_20)),
              Text(
                  "“To contribute towards social and economic development: through the development and deployment of innovative technologies.”",
                  style: MyText.body1(context)!.copyWith(color: Colors.white)),
              Container(height: 25),
              Text(
                  'Eight Tech Consults Ltd is an ICT services and Management consultancy firm that was formed with very strict core values of believing in freedom of respect and the value of the mind.'
                  '\n\nWe see our employees and clients as a foundation of our company. We believe in value creation and a shared sense of purpose with clients, yet keeping things simple.'
                  '\n\nWe’re imaginative but never irrelevant, confident but never cocky, down to earth but never dull in innovating for the future.'
                  '\n\nWe stand by a high sense of integrity, honesty, and truthfulness. We approach any business need with an open mind in order to provide appropriate solutions to customers, ensuring total customer satisfaction.',
                  style: MyText.body1(context)!.copyWith(color: Colors.white)),
              Container(height: 25),
              FxButton.outlined(
                backgroundColor: Colors.white,
                borderColor: Colors.white,
                borderRadius: BorderRadius.circular(4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                onPressed: () {
                  Utils.launchBrowser(AppConfig.terms);
                },
                child: Text("Visit 8Tech Website",
                    style:
                        MyText.body1(context)!.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
