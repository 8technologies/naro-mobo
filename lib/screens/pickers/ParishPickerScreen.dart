import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';

import '../../models/ParishModel.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';

class ParishPickerScreen extends StatefulWidget {
  String id;
  String name;
  Key? key;

  ParishPickerScreen(this.id, this.name, {super.key});

  @override
  State<ParishPickerScreen> createState() => _ParishPickerScreenState();
}

class _ParishPickerScreenState extends State<ParishPickerScreen> {
  List<ParishModel> items = [];
  List<ParishModel> temp_items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_items();
  }

  bool isLoading = false;
  String keyWord = "";

  Future<void> get_items() async {
    setState(() {
      isLoading = true;
    });

    if (temp_items.length < 5) {
      temp_items = await ParishModel.get_items();
      if (temp_items.length == 0) {
        await ParishModel.getOnlineItems();
        temp_items = await ParishModel.get_items();
      }
    }

    if (keyWord.isNotEmpty) {
      items = temp_items
          .where((element) =>
              element.name.toLowerCase().contains(keyWord.toLowerCase()))
          .toList();
    } else {
      items.addAll(temp_items);
    }

    setState(() {
      isLoading = false;
    });
  }

  bool search = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                search = !search;
                if (!search) {
                  keyWord = "";
                  get_items();
                }
                setState(() {});
              },
              icon: search
                  ? const Icon(
                      Icons.close,
                      size: 35,
                    )
                  : const Icon(
                      Icons.search,
                      size: 35,
                    ),
            ),
            SizedBox(
              width: 10,
            )
          ],
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: search
              ? Container(
                  height: 40,
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    onChanged: (value) {
                      keyWord = value.toString();
                      setState(() {});
                      get_items();
                    },
                    decoration: const InputDecoration(
                      hintText: "Search ...",
                      border: InputBorder.none,
                    ),
                  ),
                )
              : FxText.titleLarge(
                  "Select Parish",
                  fontWeight: 900,
                  color: Colors.white,
                ),
          backgroundColor: CustomTheme.primary,
          systemOverlayStyle: Utils.init_theme(),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: get_items,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        widget.id = items[index].id.toString();
                        widget.name = items[index].name;
                        Navigator.pop(context, items[index]);
                      },
                      title: Text(items[index].name),
                    );
                  },
                  itemCount: items.length,
                ),
              ));
  }
}
