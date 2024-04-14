// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:marcci/models/RespondModel.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/custom_theme.dart';
import '../../../utils/Utils.dart';
import '../../sections/widgets.dart';

class AccountChangePassword extends StatefulWidget {
  const AccountChangePassword({
    Key? key,
  }) : super(key: key);

  @override
  AccountChangePasswordState createState() => AccountChangePasswordState();
}

class AccountChangePasswordState extends State<AccountChangePassword>
    with SingleTickerProviderStateMixin {
  bool is_loading = false;

  String password_1 = "";
  String password_2 = "";
  String password_3 = "";

  @override
  void initState() {
    super.initState();
  }

  final _fKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          systemOverlayStyle: Utils.overlay(),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.black,
            ),
          ),
          actions: [
            is_loading
                ? Padding(
                    padding:
                        const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(CustomTheme.primary),
                      ),
                    ),
                  )
                : FxButton.text(
                    onPressed: () {
                      save_form();
                    },
                    child: FxText.bodyLarge(
                      "SAVE",
                      color: CustomTheme.primary,
                      fontWeight: 800,
                    ))
          ],
          title: FxText.titleMedium(
            "Changing password",
            color: Colors.black,
            fontWeight: 700,
          ),
        ),
        body: FormBuilder(
          key: _fKey,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                left: 15,
                                top: 10,
                                right: 15,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  error_message.isEmpty
                                      ? SizedBox()
                                      : FxContainer(
                                          margin: EdgeInsets.only(bottom: 10),
                                          color: Colors.red.shade50,
                                          child: Text(
                                            error_message,
                                          ),
                                        ),
                                  FormBuilderTextField(
                                    decoration: CustomTheme.in_3(
                                      label: "Current password",
                                    ),
                                    validator:
                                        MyWidgets.my_validator_field_required(
                                            context, 'This field '),
                                    obscureText: true,
                                    obscuringCharacter: '*',
                                    keyboardType: TextInputType.visiblePassword,
                                    name: "password_1",
                                    onChanged: (x) {
                                      password_1 = x.toString();
                                    },
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: 15),
                                  FormBuilderTextField(
                                    decoration: CustomTheme.in_3(
                                      label: "New password",
                                    ),
                                    validator:
                                        MyWidgets.my_validator_field_required(
                                            context, 'This field '),
                                    obscureText: true,
                                    obscuringCharacter: '*',
                                    keyboardType: TextInputType.visiblePassword,
                                    name: "password_2",
                                    onChanged: (x) {
                                      password_2 = x.toString();
                                    },
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: 15),
                                  FormBuilderTextField(
                                    decoration: CustomTheme.in_3(
                                      label: "Re-enter new password",
                                    ),
                                    validator:
                                        MyWidgets.my_validator_field_required(
                                            context, 'This field '),
                                    name: "password_3",
                                    obscureText: true,
                                    obscuringCharacter: '*',
                                    keyboardType: TextInputType.visiblePassword,
                                    onChanged: (x) {
                                      password_3 = x.toString();
                                    },
                                    textInputAction: TextInputAction.done,
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                          ],
                        ));
                  },
                  childCount: 1, // 1000 list items
                ),
              ),
            ],
          ),
        ));
  }

  String error_message = "";

  // ignore: non_constant_identifier_names
  save_form() async {
    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color: Colors.red.shade700);
      return;
    }

    if (password_2.length < 3) {
      Utils.toast('Password too short.', color: Colors.red.shade700);
      return;
    }

    if (password_2 != password_3) {
      Utils.toast('New password did not match with confirmation password.',
          color: Colors.red.shade700);
      return;
    }
    Utils.toast('Updating password...', color: Colors.green.shade700);
    setState(() {
      error_message = "";
      is_loading = true;
    });

    RespondModel resp =
        RespondModel(await Utils.http_post('password-change', {
          'current_password' : password_1,
          'password' : password_2,
        }));

    setState(() {
      error_message = "";
      is_loading = false;
    });

    if (resp.code != 1) {
      is_loading = false;
      error_message = resp.message;
      setState(() {});
      Utils.toast('Failed', color: Colors.red.shade700);
      return;
    }

    Utils.toast('Password changed successfully!');

    Navigator.pop(context);
    return;
  }
}
