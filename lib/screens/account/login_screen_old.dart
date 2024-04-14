import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../utils/AppConfig.dart';
import '../../../utils/Utils.dart';
import '../../models/RespondModel.dart';
import '../../theme/custom_theme.dart';

class LoginScreenOld extends StatefulWidget {
  const LoginScreenOld({Key? key}) : super(key: key);

  @override
  LoginScreenOldState createState() => new LoginScreenOldState();
}

class LoginScreenOldState extends State<LoginScreenOld> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> submit_form() async {
    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please fix errors in the form.", color: Colors.red);
      return;
    }

    Map<String, dynamic> formDataMap = {};
    formDataMap = {
      'phone_number': _formKey.currentState?.fields['username']?.value,
      'password': _formKey.currentState?.fields['password']?.value,
    };

    is_loading = true;
    error_message = "";
    setState(() {});

    RespondModel resp =
    RespondModel(await Utils.http_post('users/login', formDataMap));

    if (resp.code != 1) {
      is_loading = false;
      error_message = resp.message;
      setState(() {});
      return;
    }

    // await LoggedInUserModel.save_token(resp.data['token']);
    // await LoggedInUserModel.login_user(resp.data);

    is_loading = false;
    setState(() {});

    Navigator.pushNamedAndRemoveUntil(
        context, "/OnBoardingScreen", (r) => false);
    Utils.toast("Logged in successfully.", color: Colors.green);
  }

  String error_message = "";
  bool is_loading = false;

  @override
  void initState() {
    Utils.init_theme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: null,
      body: Container(
        margin: EdgeInsets.only(top: 60),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: AssetImage("${AppConfig.LOGIN_PICS}bg-2.jpg"),
              fit: BoxFit.fill),
        ),
        padding: EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 10),
        child: ListView(
          children: [
            FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Image(
                      width: 170,
                      fit: BoxFit.cover,
                      image: AssetImage(AppConfig.logo),
                    ),
                    /* SizedBox(
                          height: 20,
                        ),
                        FxText.titleLarge("Sign in"),*/
                    SizedBox(
                      height: 40,
                    ),
                    Container(height: 25),
                    FormBuilderTextField(
                      name: 'username',
                      autofocus: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "This field is required.",
                        ),
                        FormBuilderValidators.email(
                          errorText: "Enter a valid email address.",
                        ),
                      ]),
                      decoration: InputDecoration(
                          enabledBorder: CustomTheme.input_outline_border,
                          border: CustomTheme.input_outline_focused_border,
                          label: FxText.bodyLarge("Email address",color: Colors.white,fontWeight: 700,
                          )

                      ),
                    ),
                    Container(height: 25),
                    FormBuilderTextField(
                      name: 'password',
                      obscureText: true,
                      autofocus: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        enabledBorder: CustomTheme.input_outline_border,
                        border: CustomTheme.input_outline_focused_border,
                        labelText: "Password",
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Password is required.",
                        ),
                      ]),
                    ),
                    Container(height: 10),
                    error_message.isEmpty
                        ? SizedBox()
                        : FxContainer(
                      margin: EdgeInsets.only(bottom: 10),
                      color: Colors.red.shade50,
                      child: Text(
                        error_message,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 20,
                      ),
                      child: is_loading
                          ? Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(15),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        ),
                      )
                          : CupertinoButton(
                          color: CustomTheme.primary,
                          onPressed: () {
                            submit_form();
                          },
                          borderRadius:
                          BorderRadius.all(Radius.circular(50)),
                          padding: FxSpacing.xy(32, 8),
                          pressedOpacity: 0.5,
                          child: FxText.bodyMedium("Sign In",
                              color: Colors.white)),
                    ),
                    Container(height: 5),
                    Row(
                      children: <Widget>[
                        Spacer(),
                        Text(
                          "Forgot password?",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 14),
                        ),
                        TextButton(
                          style:
                          TextButton.styleFrom(foregroundColor: Colors.transparent),
                          child: Text(
                            "Reset password",
                            style: TextStyle(
                                color: CustomTheme.primary, fontSize: 14),
                          ),
                          onPressed: () {
                            submit_form();
                          },
                        )
                      ],
                    ),
                  ],
                )),
            SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}
