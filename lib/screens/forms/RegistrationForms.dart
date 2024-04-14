import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:marcci/theme/app_theme.dart';

class RegistrationForms extends StatefulWidget {
  const RegistrationForms({Key? key}) : super(key: key);

  @override
  _RegistrationFormsState createState() => _RegistrationFormsState();
}

class _RegistrationFormsState extends State<RegistrationForms>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();

    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: Text("⌛ Loading..."),
                  );
                default:
                  return mainWidget();
              }
            }),
      ),
    );
  }

  Widget mainWidget() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 10,
            right: 0,
            top: 15,
            bottom: 15,
          ),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.start,
            direction: Axis.horizontal,
            children: [
              const FxContainer(
                color: Colors.white,
                paddingAll: 0,
                child: Icon(
                  Icons.arrow_back,
                  size: 35,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: FxText.titleLarge(
                  "REGISTRATION FORMS",
                  fontWeight: 900,
                  color: Colors.black,
                ),
              ),
              /*   Image(
                image: AssetImage(
                  AppConfig.logo2,
                ),
                fit: BoxFit.cover,
                width: (MediaQuery.of(context).size.width / 7),
              ),*/
            ],
          ),
        ),
        const Divider(
          height: 0,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: RefreshIndicator(
              onRefresh: doRefresh,
              color: CustomTheme.primary,
              backgroundColor: Colors.white,
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      FxText.bodyLarge(
                        "There are 8 in this list. Use these forms to register or to apply.",
                        height: 1,
                        fontWeight: 800,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      menuItemWidget(
                          '2. Counselling centre',
                          'Register new or manage your counselling centres.',
                          () => {}),
                      menuItemWidget(
                          '3. Institutions',
                          'Register new or manage your institutions.',
                          () => {}),
                      FxContainer(
                        margin: EdgeInsets.only(left: 30, right: 30, top: 15),
                        color: Colors.grey.shade200,
                        bordered: true,
                        borderColor: Colors.black,
                        child: FxText.bodyLarge(
                          'End of the menu. Scroll back to top to go through it again.',
                          fontWeight: 800,
                          color: Colors.black,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();
    setState(() {});
  }

  Future<dynamic> myInit() async {
    return "Done";
  }

  menuItemWidget(String title, String subTitle, Function screen) {
    return InkWell(
      onTap: () => {screen()},
      child: Container(
        padding: EdgeInsets.only(left: 0, bottom: 5, top: 20),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: CustomTheme.primary, width: 2),
        )),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.titleLarge(
                    title,
                    color: Colors.black,
                    fontWeight: 900,
                  ),
                  FxText.bodyLarge(
                    subTitle,
                    height: 1,
                    fontWeight: 600,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 35,
            )
          ],
        ),
      ),
    );
  }
}
