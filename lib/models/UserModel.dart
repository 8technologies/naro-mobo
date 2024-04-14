import 'package:marcci/utils/AppConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class UserModel {
  static String table_name = "users";
  static String end_point = "my-students";
  int id = 0;
  String username = "";
  String password = "";
  String name = "";
  String avatar = "";
  String remember_token = "";
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String first_name = "";
  String last_name = "";
  String date_of_birth = "";
  String place_of_birth = "";
  String sex = "";
  String home_address = "";
  String current_address = "";
  String phone_number_1 = "";
  String phone_number_2 = "";
  String email = "";
  String nationality = "";
  String religion = "";
  String spouse_name = "";
  String spouse_phone = "";
  String father_name = "";
  String father_phone = "";
  String mother_name = "";
  String mother_phone = "";
  String languages = "";
  String emergency_person_name = "";
  String emergency_person_phone = "";
  String national_id_number = "";
  String passport_number = "";
  String tin = "";
  String nssf_number = "";
  String bank_name = "";
  String bank_account_number = "";
  String primary_school_name = "";
  String primary_school_year_graduated = "";
  String seconday_school_name = "";
  String seconday_school_year_graduated = "";
  String high_school_name = "";
  String high_school_year_graduated = "";
  String degree_university_name = "";
  String degree_university_year_graduated = "";
  String masters_university_name = "";
  String masters_university_year_graduated = "";
  String phd_university_name = "";
  String phd_university_year_graduated = "";
  String user_type = "";
  String demo_id = "";
  String user_id = "";
  String user_batch_importer_id = "";
  String school_pay_account_id = "";
  String school_pay_payment_code = "";
  String given_name = "";
  String residential_type = "";
  String transportation = "";
  String swimming = "";
  String outstanding = "";
  String guardian_relation = "";
  String referral = "";
  String previous_school = "";
  String deleted_at = "";
  String marital_status = "";
  String verification = "";
  String current_class_id = "";
  String current_theology_class_id = "";
  String status = "";

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'avatar': avatar,
      'remember_token': remember_token,
      'created_at': created_at,
      'updated_at': updated_at,
      'enterprise_id': enterprise_id,
      'first_name': first_name,
      'last_name': last_name,
      'date_of_birth': date_of_birth,
      'place_of_birth': place_of_birth,
      'sex': sex,
      'home_address': home_address,
      'current_address': current_address,
      'phone_number_1': phone_number_1,
      'phone_number_2': phone_number_2,
      'email': email,
      'nationality': nationality,
      'religion': religion,
      'spouse_name': spouse_name,
      'spouse_phone': spouse_phone,
      'father_name': father_name,
      'father_phone': father_phone,
      'mother_name': mother_name,
      'mother_phone': mother_phone,
      'languages': languages,
      'emergency_person_name': emergency_person_name,
      'emergency_person_phone': emergency_person_phone,
      'national_id_number': national_id_number,
      'passport_number': passport_number,
      'tin': tin,
      'nssf_number': nssf_number,
      'bank_name': bank_name,
      'bank_account_number': bank_account_number,
      'primary_school_name': primary_school_name,
      'primary_school_year_graduated': primary_school_year_graduated,
      'seconday_school_name': seconday_school_name,
      'seconday_school_year_graduated': seconday_school_year_graduated,
      'high_school_name': high_school_name,
      'high_school_year_graduated': high_school_year_graduated,
      'degree_university_name': degree_university_name,
      'degree_university_year_graduated': degree_university_year_graduated,
      'masters_university_name': masters_university_name,
      'masters_university_year_graduated': masters_university_year_graduated,
      'phd_university_name': phd_university_name,
      'phd_university_year_graduated': phd_university_year_graduated,
      'user_type': user_type,
      'demo_id': demo_id,
      'user_id': user_id,
      'user_batch_importer_id': user_batch_importer_id,
      'school_pay_account_id': school_pay_account_id,
      'school_pay_payment_code': school_pay_payment_code,
      'given_name': given_name,
      'residential_type': residential_type,
      'transportation': transportation,
      'swimming': swimming,
      'outstanding': outstanding,
      'guardian_relation': guardian_relation,
      'referral': referral,
      'previous_school': previous_school,
      'deleted_at': deleted_at,
      'marital_status': marital_status,
      'verification': verification,
      'current_class_id': current_class_id,
      'current_theology_class_id': current_theology_class_id,
      'status': status,
    };
  }

  static UserModel fromJson(dynamic m) {
    UserModel obj = new UserModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.username = Utils.to_str(m['username'], '');
    obj.password = Utils.to_str(m['password'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.avatar = Utils.to_str(m['avatar'], '');
    if (!obj.avatar.contains('http')) {
      obj.avatar = "${AppConfig.MAIN_SITE_URL}/${obj.avatar}";
    }
    obj.remember_token = Utils.to_str(m['remember_token'], '');
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.first_name = Utils.to_str(m['first_name'], '');
    obj.last_name = Utils.to_str(m['last_name'], '');
    obj.date_of_birth = Utils.to_str(m['date_of_birth'], '');
    obj.place_of_birth = Utils.to_str(m['place_of_birth'], '');
    obj.sex = Utils.to_str(m['sex'], '');
    obj.home_address = Utils.to_str(m['home_address'], '');
    obj.current_address = Utils.to_str(m['current_address'], '');
    obj.phone_number_1 = Utils.to_str(m['phone_number_1'], '');
    obj.phone_number_2 = Utils.to_str(m['phone_number_2'], '');
    obj.email = Utils.to_str(m['email'], '');
    obj.nationality = Utils.to_str(m['nationality'], '');
    obj.religion = Utils.to_str(m['religion'], '');
    obj.spouse_name = Utils.to_str(m['spouse_name'], '');
    obj.spouse_phone = Utils.to_str(m['spouse_phone'], '');
    obj.father_name = Utils.to_str(m['father_name'], '');
    obj.father_phone = Utils.to_str(m['father_phone'], '');
    obj.mother_name = Utils.to_str(m['mother_name'], '');
    obj.mother_phone = Utils.to_str(m['mother_phone'], '');
    obj.languages = Utils.to_str(m['languages'], '');
    obj.emergency_person_name = Utils.to_str(m['emergency_person_name'], '');
    obj.emergency_person_phone = Utils.to_str(m['emergency_person_phone'], '');
    obj.national_id_number = Utils.to_str(m['national_id_number'], '');
    obj.passport_number = Utils.to_str(m['passport_number'], '');
    obj.tin = Utils.to_str(m['tin'], '');
    obj.nssf_number = Utils.to_str(m['nssf_number'], '');
    obj.bank_name = Utils.to_str(m['bank_name'], '');
    obj.bank_account_number = Utils.to_str(m['bank_account_number'], '');
    obj.primary_school_name = Utils.to_str(m['primary_school_name'], '');
    obj.primary_school_year_graduated =
        Utils.to_str(m['primary_school_year_graduated'], '');
    obj.seconday_school_name = Utils.to_str(m['seconday_school_name'], '');
    obj.seconday_school_year_graduated =
        Utils.to_str(m['seconday_school_year_graduated'], '');
    obj.high_school_name = Utils.to_str(m['high_school_name'], '');
    obj.high_school_year_graduated =
        Utils.to_str(m['high_school_year_graduated'], '');
    obj.degree_university_name = Utils.to_str(m['degree_university_name'], '');
    obj.degree_university_year_graduated =
        Utils.to_str(m['degree_university_year_graduated'], '');
    obj.masters_university_name =
        Utils.to_str(m['masters_university_name'], '');
    obj.masters_university_year_graduated =
        Utils.to_str(m['masters_university_year_graduated'], '');
    obj.phd_university_name = Utils.to_str(m['phd_university_name'], '');
    obj.phd_university_year_graduated =
        Utils.to_str(m['phd_university_year_graduated'], '');
    obj.user_type = Utils.to_str(m['user_type'], '');
    obj.demo_id = Utils.to_str(m['demo_id'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.user_batch_importer_id = Utils.to_str(m['user_batch_importer_id'], '');
    obj.school_pay_account_id = Utils.to_str(m['school_pay_account_id'], '');
    obj.school_pay_payment_code =
        Utils.to_str(m['school_pay_payment_code'], '');
    obj.given_name = Utils.to_str(m['given_name'], '');
    obj.residential_type = Utils.to_str(m['residential_type'], '');
    obj.transportation = Utils.to_str(m['transportation'], '');
    obj.swimming = Utils.to_str(m['swimming'], '');
    obj.outstanding = Utils.to_str(m['outstanding'], '');
    obj.guardian_relation = Utils.to_str(m['guardian_relation'], '');
    obj.referral = Utils.to_str(m['referral'], '');
    obj.previous_school = Utils.to_str(m['previous_school'], '');
    obj.deleted_at = Utils.to_str(m['deleted_at'], '');
    obj.marital_status = Utils.to_str(m['marital_status'], '');
    obj.verification = Utils.to_str(m['verification'], '');
    obj.current_class_id = Utils.to_str(m['current_class_id'], '');
    obj.current_theology_class_id =
        Utils.to_str(m['current_theology_class_id'], '');
    obj.status = Utils.to_str(m['status'], '');

    return obj;
  }

  String s(dynamic m) {
    return Utils.to_str(m, '');
  }

  static deleteAllItems() async {}

  static Future<UserModel> getItemById(String id) async {
    UserModel item = UserModel();
    try {
      List<UserModel> items = await UserModel.getItems(where: "id = $id");
      if (items.isNotEmpty) {
        item = items.first;
      }
    } catch (E) {
      item = UserModel();
    }
    return item;
  }

  static Future<List<UserModel>> getItems({String where = '1'}) async {
    List<UserModel> items = await UserModel.getLocalData(where);
    UserModel.getOnlineData();

    if (items.isEmpty) {
      await UserModel.getOnlineData();
      items = await UserModel.getLocalData(where);
    }
    return items;
  }

  static Future<void> getOnlineData() async {
    if (!(await Utils.is_connected())) {
      return;
    }

    RespondModel resp =
        RespondModel(await Utils.http_get('${UserModel.end_point}', {}));

    if (resp.code != 1) {
      return;
    }

    if (!resp.data.runtimeType.toString().contains('List')) {
      return;
    }

    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await db.transaction((txn) async {
      for (dynamic d in resp.data) {
        UserModel _u = UserModel.fromJson(d);
        try {
          await txn.insert(
            UserModel.table_name,
            _u.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        } catch (e) {
          Utils.toast("Failed to save student because ${e.toString()}");
        }
      }
    });

    return;
  }

  static Future<List<UserModel>> getLocalData(String where) async {
    List<UserModel> data = [];
    if (!(await UserModel.initTable())) {
      Utils.toast("Failed to init students store.");
      return data;
    }
    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(UserModel.table_name, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(UserModel.fromJson(maps[i]));
    });
    return data;
  }

  Future<bool> save() async {
    bool isSuccess = false;
    if (!(await initTable())) {
      return false;
    }
    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return false;
    }

    try {
      await db.insert(
        UserModel.table_name,
        toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', remember_token);

      isSuccess = true;
    } catch (e) {
      Utils.toast("Failed because ${e.toString()}");
      isSuccess = false;
    }

    return isSuccess;
  }

  static Future<bool> initTable() async {
    Database db = await openDatabase(AppConfig.DATABASE_PATH);
    if (!db.isOpen) {
      return false;
    }

    String sql =
        "CREATE TABLE IF NOT EXISTS ${UserModel.table_name} (id INTEGER PRIMARY KEY, username TEXT, password TEXT, name TEXT, avatar TEXT, remember_token TEXT, created_at TEXT, updated_at TEXT, enterprise_id TEXT, first_name TEXT, last_name TEXT, date_of_birth TEXT, place_of_birth TEXT, sex TEXT, home_address TEXT, current_address TEXT, phone_number_1 TEXT, phone_number_2 TEXT, email TEXT, nationality TEXT, religion TEXT, spouse_name TEXT, spouse_phone TEXT, father_name TEXT, father_phone TEXT, mother_name TEXT, mother_phone TEXT, languages TEXT, emergency_person_name TEXT, emergency_person_phone TEXT, national_id_number TEXT, passport_number TEXT, tin TEXT, nssf_number TEXT, bank_name TEXT, bank_account_number TEXT, primary_school_name TEXT, primary_school_year_graduated TEXT, seconday_school_name TEXT, seconday_school_year_graduated TEXT, high_school_name TEXT, high_school_year_graduated TEXT, degree_university_name TEXT, degree_university_year_graduated TEXT, masters_university_name TEXT, masters_university_year_graduated TEXT, phd_university_name TEXT, phd_university_year_graduated TEXT, user_type TEXT, demo_id TEXT, user_id TEXT, user_batch_importer_id TEXT, school_pay_account_id TEXT, school_pay_payment_code TEXT, given_name TEXT, residential_type TEXT, transportation TEXT, swimming TEXT, outstanding TEXT, guardian_relation TEXT, referral TEXT, previous_school TEXT, deleted_at TEXT, marital_status TEXT, verification TEXT, current_class_id TEXT, current_theology_class_id TEXT, status TEXT)";
    try {
      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');
      return false;
    }

    return true;
  }
}
