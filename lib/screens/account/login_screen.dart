import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:marcci/screens/account/RegisterScreen.dart';

import '../../../utils/AppConfig.dart';
import '../../../utils/Utils.dart';
import '../../models/LoggedInUserModel.dart';
import '../../models/RespondModel.dart';
import '../../theme/custom_theme.dart';
import '../OnBoardingScreen.dart';
import '../full_app/full_app.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> submit_form() async {
    //LoggedInUserModel.fromJson("{id: 2206, username: muhsin, name: Muhsin  Mutagubya, avatar: images/a027e8675a269daa7eb85dee0cabd9f5.png, created_at: 2022-09-16T17:17:27.000000Z, updated_at: 2023-01-12T06:55:05.000000Z, enterprise_id: 7, first_name: Muhsin, last_name: Mutagubya, date_of_birth: 1992-02-12, place_of_birth: Old Kampala, sex: Male, home_address: Masaka, current_address: Kira, phone_number_1: +256700869880, phone_number_2: , email: muhsinmutagubya@gmail.com, nationality: Ugandan, religion: Islam, spouse_name: Shariffa Muhsin, spouse_phone: 0770479228, father_name: Sheikh Muhammad Mutagubya, father_phone: 0702811466, mother_name: Fatumah Nalubanga, mother_phone: 0702684117, languages: Arabic, English, Luganda, emergency_person_name: Dr. Ashraf Mutagubya, emergency_person_phone: +256705719772, national_id_number: CM9202410117LA, passport_number: A00348931, tin: null, nssf_number: null, bank_name: Equity Bank, bank_account_number: 1027101079959, primary_school_name: Kabowa Hidayat, primary_school_year_graduated: 2009, degree_university_year_graduated: 2020, masters_university_name: null, masters_university_year_graduated: null, phd_university_name: null, phd_university_year_graduated: null, user_type: employee, demo_id: 0, user_id: null, user_batch_importer_id: 0, school_pay_account_id: null, school_pay_payment_code: null, given_name: null, residential_type: Day, transportation: 25, swimming: No, outstanding: null, guardian_relation: null, referral: null, previous_school: null, deleted_at: null, marital_status: null, verification: 0, current_class_id: 0, current_theology_class_id: 0, status: 2, token: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3NjaG9vbGR5bmFtaWNzLnVnL2FwaS91c2Vycy9sb2dpbiIsImlhdCI6MTY3NTUwNDg3OCwiZXhwIjoxNjc1NTA4NDc4LCJuYmYiOjE2NzU1MDQ4NzgsImp0aSI6InRLOVRKaUkwM2lkbHdqTmYiLCJzdWIiOiIyMjA2IiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.LH5safY3WweC-tdhvA4zbqTWi-UfrvdsVOMKkfBKWPo}");

    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please fix errors in the form.", color: Colors.red);
      return;
    }

    Map<String, dynamic> formDataMap = {};
    formDataMap = {
      'username': _formKey.currentState?.fields['username']?.value,
      'password': _formKey.currentState?.fields['password']?.value,
    };

    is_loading = true;
    error_message = "";
    setState(() {});
    print("====================GETTING===============");
    RespondModel? resp = null;
    try {
      resp = RespondModel(await Utils.http_post('users/login', formDataMap));
    } catch (e) {
      is_loading = false;
      error_message =
          "Failed to connect to internet. Check your connection and try again";
      setState(() {});
      return;
    }

    print("===========${resp.code}===============");
    if (resp.code != 1) {
      is_loading = false;
      error_message = resp.message;
      setState(() {});
      return;
    }

    LoggedInUserModel u = LoggedInUserModel.fromJson(resp.data);
    if (!(await u.save())) {
      is_loading = false;
      error_message = 'Failed to log you in.';
      setState(() {});
      return;
    }

    LoggedInUserModel lu = await LoggedInUserModel.getLoggedInUser();

    if (lu.id < 1) {
      is_loading = false;
      error_message = 'Failed to retrieve you in.';
      setState(() {});
      return;
    }
    if (lu.remember_token.length < 5) {
      is_loading = false;
      error_message = 'Failed to retrieve you in.';
      setState(() {});
      return;
    }

    await Utils.setPref("token", lu.remember_token);
    String tok = await Utils.getPref("token");
    if (tok.length < 5) {
      is_loading = false;
      error_message = 'Failed to retrieve you in.';
      setState(() {});
      return;
    }

    is_loading = false;
    setState(() {});

    Get.off(() => FullApp());
  }

  String error_message = "";
  bool is_loading = false;

  @override
  void initState() {
    Utils.init_theme();
  }

  @override
  Widget build(BuildContext context) {
    is_loading = false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(color: Colors.white)),
      body: ListView(
        children: [
          FxContainer(
              borderRadiusAll: 0,
              marginAll: 0,
              padding:
                  EdgeInsets.only(left: 25, right: 25, top: 50, bottom: 10),
              color: Colors.white,
              child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        height: 50,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Image(
                        width: MediaQuery.of(context).size.width / 3,
                        fit: BoxFit.cover,
                        image: AssetImage(AppConfig.logo1),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FxText.headlineMedium(
                        "Login",
                        fontWeight: 900,
                        color: Colors.black,
                      ),
                      /* SizedBox(
                        height: 20,
                      ),
                      FxText.titleLarge("Sign in"),*/
                      const SizedBox(
                        height: 10,
                      ),
                      Container(height: 25),
                      FormBuilderTextField(
                        name: 'username',
                        autofocus: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "This field is required.",
                          ),
                        ]),
                        decoration: InputDecoration(
                          enabledBorder: CustomTheme.input_outline_border,
                          border: CustomTheme.input_outline_focused_border,
                          labelText: "Enter your Phone Number",
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
                          labelText: "Enter Your Password",
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.red),
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
                                child: FxText.bodyLarge(
                                  "LOGIN",
                                  color: Colors.white,
                                  fontWeight: 700,
                                )),
                      ),
                      Container(height: 5),
                      Row(
                        children: <Widget>[
                          Spacer(),
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 14),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(foregroundColor: Colors.transparent),
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                  color: CustomTheme.primary, fontSize: 14),
                            ),
                            onPressed: () {
                              Get.to(() => RegisterScreen());
                              return;
                              submit_form();
                            },
                          )
                        ],
                      ),
                    ],
                  ))),
          SizedBox(
            height: 200,
          )
        ],
      ),
    );
  }
}
