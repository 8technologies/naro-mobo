import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';

import '../../controllers/full_app_controller.dart';
import '../../theme/custom_theme.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  TestScreenState createState() => new TestScreenState();
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 138,
      height: 50,
      child: Text("Romina"),
    );
  }
}

class TestScreenState extends State<TestScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormBuilderState>();

  String error_message = "";
  bool is_loading = false;
  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  String appTitle = 'Fluent UI Showcase for Flutter';

  late FullAppController controller;

  List<Widget> buildTab() {
    List<Widget> tabs = [];
    for (int i = 0; i < controller.navItems.length; i++) {
      tabs.add(
        Container(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              FxText.bodySmall(controller.navItems[i].title,
                  fontSize: 12,
                  color: (controller.currentIndex == i)
                      ? CustomTheme.primary
                      : CustomTheme.red),
            ],
          ),
        ),
      );
    }
    return tabs;
  }

  @override
  void initState() {
    super.initState();

    controller = FxControllerStore.putOrFind(FullAppController(this));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

    );
  }
}
