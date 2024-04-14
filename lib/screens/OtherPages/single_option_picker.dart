import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:flutx/widgets/widgets.dart';

import '../../models/OptionPickerModel.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';

// ignore: must_be_immutable
class SingleOptionPicker extends StatefulWidget {
  List<OptionPickerModel> items;
  // ignore: non_constant_identifier_names
  List<OptionPickerModel> selected_items;
  String title;
  // ignore: non_constant_identifier_names
  bool single_select;

  SingleOptionPicker(
      this.title, this.items, this.selected_items, this.single_select,
      {Key? key})
      : super(key: key);

  @override
  State<SingleOptionPicker> createState() => SingleOptionPickerState();
}

class SingleOptionPickerState extends State<SingleOptionPicker> {
  final PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _do_refresh();
  }

  // ignore: non_constant_identifier_names
  bool is_loading = false;

  Future<void> _onRefresh(BuildContext context) async {
    is_loading = true;
    setState(() {});

    return;
  }

  // ignore: non_constant_identifier_names
  bool search_form_is_open = false;
  // ignore: non_constant_identifier_names
  TextEditingController search_controler = TextEditingController();
  var seachrFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.single_select
          ? null
          : FloatingActionButton.extended(
              backgroundColor: CustomTheme.primary,
              elevation: 10,
              onPressed: () {
                done_selecting();
                //Utils.navigate_to(AppConfig.TasksCreateScreen, context);
              },
              label: Row(
                children: [
                  const Icon(
                    Icons.check,
                    size: 18,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: FxText(
                      "DONE SELECTING",
                      fontWeight: 800,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
      appBar: AppBar(
        systemOverlayStyle: Utils.overlay(),
        elevation: 1,
        title: search_form_is_open
            ? Container(
                padding: const EdgeInsets.only(left: 0, top: 10),
                height: 35,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                margin: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
                child: TextFormField(
                  decoration: CustomTheme.input_decoration_4(
                    labelText: "Search...",
                  ),
                  controller: search_controler,
                  focusNode: seachrFocusNode,
                  textInputAction: TextInputAction.search,
                  textCapitalization: TextCapitalization.sentences,
                  onFieldSubmitted: (s) {
                    _do_refresh();
                  },
                  onChanged: (s) {
                    _do_refresh();
                  },
                ),
              )
            : FxText.titleLarge(
                widget.title,
                color: Colors.grey.shade800,
              ),
        actions: [
          InkWell(
              onTap: () {
                setState(() {
                  seachrFocusNode.requestFocus();
                  search_form_is_open = !search_form_is_open;
                });
              },
              child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Icon(
                    search_form_is_open ? Icons.clear : Icons.search,
                    size: 25,
                    color: CustomTheme.primary,
                  )))
        ],
      ),
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: _do_refresh,
        color: CustomTheme.primary,
        backgroundColor: CustomTheme.primary,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ListTile(
                    dense: true,
                    selected:
                        widget.selected_items.contains(ready_items[index]),
                    title: FxText(ready_items[index].name,
                        fontWeight: 600, fontSize: 18),
                    onTap: () {
                      pick_location(ready_items[index]);
                    },
                    trailing: widget.selected_items.contains(ready_items[index])
                        ? Icon(
                            Icons.check,
                            size: 25,
                            color: CustomTheme.primary,
                          )
                        : const SizedBox(),
                  );
                },
                childCount: ready_items.length, // 1000 list items
              ),
            )
          ],
        ),
      )),
    );
  }

  // ignore: non_constant_identifier_names
  List<OptionPickerModel> ready_items = [];
  // ignore: non_constant_identifier_names
  String search_keyword = "";

  // ignore: non_constant_identifier_names
  Future<void> _do_refresh() async {
    search_keyword = "";
    is_loading = true;
    setState(() {});
    if (search_controler.text.toString().isNotEmpty) {
      search_keyword = search_controler.text.toString();
    }

    ready_items.clear();
    if (search_keyword.length > 1) {
      for (var element in widget.items) {
        if (element.name.toLowerCase().contains(search_keyword.toLowerCase())) {
          if (widget.selected_items.contains(element.id.toString())) {
            element.selected = true;
          } else {
            element.selected = false;
          }
          ready_items.add(element);
        }
      }
    } else {
      for (var element in widget.items) {
        if (widget.selected_items.contains(element.id.toString())) {
          element.selected = true;
        } else {
          element.selected = false;
        }
        ready_items.add(element);
      }
    }

    is_loading = false;
    setState(() {});

    return await _onRefresh(context);
  }

  // ignore: non_constant_identifier_names
  Future<void> pick_location(OptionPickerModel item) async {
    if (Utils.contains(widget.selected_items, item)) {
      widget.selected_items.remove(item);
    } else {
      widget.selected_items.add(item);
    }

    if (widget.single_select) {
      done_selecting();
    }
    _do_refresh();
  }

  // ignore: non_constant_identifier_names
  void done_selecting() {
    Navigator.pop(context, widget.selected_items);
  }
}
