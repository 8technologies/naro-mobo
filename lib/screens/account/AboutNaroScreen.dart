import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:marcci/theme/app_theme.dart';

import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_text.dart';

class AboutNaroScreen extends StatefulWidget {
  const AboutNaroScreen({super.key});

  @override
  AboutNaroScreenState createState() => AboutNaroScreenState();
}

class AboutNaroScreenState extends State<AboutNaroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.primary,
      appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarColor: CustomTheme.primary),
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
              Text("${AppConfig.app_name} App",
                  style: MyText.display1(context)!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w300)),
              Container(height: 5),
              Container(width: 120, height: 3, color: Colors.white),
              Container(height: 15),
              Text("Version",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_20)),
              Text("2.1.0",
                  style: MyText.body1(context)!.copyWith(color: Colors.white)),
              Container(height: 15),
              Text("Last Update",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_20)),
              Text("December 2023",
                  style: MyText.body1(context)!.copyWith(color: Colors.white)),
              Container(height: 25),
              Text(
                  'The National Agricultural Research Organisation (NARO) is an agency of the Ministry of Agriculture, Animal Industry and Fisheries (MAAIF).'
                  '\n\nWith the mandate to coordinate and oversee all aspects of public-funded agricultural research in Uganda.'
                  '\n\nEstablished as a body corporate by the National Agricultural Research Act of 2005, NARO comprises a Governing Council, a Secretariat and 16 Public Agricultural Research Institutes (PARIs) spread across the country.'
                  '\n\nNARO is mandated to undertake research in all aspects of agriculture including crops, livestock, fisheries, forestry, agro-machinery, natural resources and socio-economics.',
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
                child: Text("Visit NARO Website",
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
