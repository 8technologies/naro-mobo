import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class FarmModel {
  static String end_point = "farmers";
  static String tableName = "farmers";
  int id = 0;
  String organisation_id = "";
  String organisation_text = "";
  String farmer_group_id = "";
  String farmer_group_text = "";
  String first_name = "";
  String last_name = "";
  String country_id = "";
  String country_text = "";
  String language_id = "";
  String language_text = "";
  String national_id_number = "";
  String national_text_number = "";
  String gender = "";
  String education_level = "";
  String year_of_birth = "";
  String phone = "";
  String email = "";
  String is_your_phone = "";
  String is_mm_registered = "";
  String other_economic_activity = "";
  String location_id = "";
  String location_text = "";
  String address = "";
  String latitude = "";
  String longitude = "";
  String password = "";
  String farming_scale = "";
  String land_holding_in_acres = "";
  String land_under_farming_in_acres = "";
  String ever_bought_insurance = "";
  String ever_received_credit = "";
  String status = "";
  String created_by_user_id = "";
  String created_by_user_text = "";
  String created_by_agent_id = "";
  String created_by_agent_text = "";
  String agent_id = "";
  String agent_text = "";
  String created_at = "";
  String updated_at = "";
  String poverty_level = "";
  String food_security_level = "";
  String marital_status = "";
  String family_size = "";
  String farm_decision_role = "";
  String is_pwd = "";
  String is_refugee = "";
  String date_of_birth = "";
  String age_group = "";
  String language_preference = "";
  String phone_number = "";
  String phone_type = "";
  String preferred_info_type = "";
  String home_gps_latitude = "";
  String home_gps_longitude = "";
  String village = "";
  String street = "";
  String house_number = "";
  String land_registration_numbers = "";
  String labor_force = "";
  String equipment_owned = "";
  String livestock = "";
  String crops_grown = "";
  String has_bank_account = "";
  String has_mobile_money_account = "";
  String payments_or_transfers = "";
  String financial_service_provider = "";
  String has_credit = "";
  String loan_size = "";
  String loan_usage = "";
  String farm_business_plan = "";
  String covered_risks = "";
  String insurance_company_name = "";
  String insurance_cost = "";
  String repaid_amount = "";
  String photo = "";
  String district_id = "";
  String district_text = "";
  String subcounty_id = "";
  String subcounty_text = "";
  String parish_id = "";
  String parish_text = "";
  String bank_id = "";
  String bank_text = "";
  String other_livestock_count = "";
  String poultry_count = "";
  String sheep_count = "";
  String goat_count = "";
  String cattle_count = "";
  String bank_account_number = "";
  String has_receive_loan = "";

  static fromJson(dynamic m) {
    FarmModel obj = new FarmModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.organisation_id = Utils.to_str(m['organisation_id'], '');
    obj.organisation_text = Utils.to_str(m['organisation_text'], '');
    obj.farmer_group_id = Utils.to_str(m['farmer_group_id'], '');
    obj.farmer_group_text = Utils.to_str(m['farmer_group_text'], '');
    obj.first_name = Utils.to_str(m['first_name'], '');
    obj.last_name = Utils.to_str(m['last_name'], '');
    obj.country_id = Utils.to_str(m['country_id'], '');
    obj.country_text = Utils.to_str(m['country_text'], '');
    obj.language_id = Utils.to_str(m['language_id'], '');
    obj.language_text = Utils.to_str(m['language_text'], '');
    obj.national_id_number = Utils.to_str(m['national_id_number'], '');
    obj.national_text_number = Utils.to_str(m['national_text_number'], '');
    obj.gender = Utils.to_str(m['gender'], '');
    obj.education_level = Utils.to_str(m['education_level'], '');
    obj.year_of_birth = Utils.to_str(m['year_of_birth'], '');
    obj.phone = Utils.to_str(m['phone'], '');
    obj.email = Utils.to_str(m['email'], '');
    obj.is_your_phone = Utils.to_str(m['is_your_phone'], '');
    obj.is_mm_registered = Utils.to_str(m['is_mm_registered'], '');
    obj.other_economic_activity =
        Utils.to_str(m['other_economic_activity'], '');
    obj.location_id = Utils.to_str(m['location_id'], '');
    obj.location_text = Utils.to_str(m['location_text'], '');
    obj.address = Utils.to_str(m['address'], '');
    obj.latitude = Utils.to_str(m['latitude'], '');
    obj.longitude = Utils.to_str(m['longitude'], '');
    obj.password = Utils.to_str(m['password'], '');
    obj.farming_scale = Utils.to_str(m['farming_scale'], '');
    obj.land_holding_in_acres = Utils.to_str(m['land_holding_in_acres'], '');
    obj.land_under_farming_in_acres =
        Utils.to_str(m['land_under_farming_in_acres'], '');
    obj.ever_bought_insurance = Utils.to_str(m['ever_bought_insurance'], '');
    obj.ever_received_credit = Utils.to_str(m['ever_received_credit'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.created_by_user_id = Utils.to_str(m['created_by_user_id'], '');
    obj.created_by_user_text = Utils.to_str(m['created_by_user_text'], '');
    obj.created_by_agent_id = Utils.to_str(m['created_by_agent_id'], '');
    obj.created_by_agent_text = Utils.to_str(m['created_by_agent_text'], '');
    obj.agent_id = Utils.to_str(m['agent_id'], '');
    obj.agent_text = Utils.to_str(m['agent_text'], '');
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.poverty_level = Utils.to_str(m['poverty_level'], '');
    obj.food_security_level = Utils.to_str(m['food_security_level'], '');
    obj.marital_status = Utils.to_str(m['marital_status'], '');
    obj.family_size = Utils.to_str(m['family_size'], '');
    obj.farm_decision_role = Utils.to_str(m['farm_decision_role'], '');
    obj.is_pwd = Utils.to_str(m['is_pwd'], '');
    obj.is_refugee = Utils.to_str(m['is_refugee'], '');
    obj.date_of_birth = Utils.to_str(m['date_of_birth'], '');
    obj.age_group = Utils.to_str(m['age_group'], '');
    obj.language_preference = Utils.to_str(m['language_preference'], '');
    obj.phone_number = Utils.to_str(m['phone_number'], '');
    obj.phone_type = Utils.to_str(m['phone_type'], '');
    obj.preferred_info_type = Utils.to_str(m['preferred_info_type'], '');
    obj.home_gps_latitude = Utils.to_str(m['home_gps_latitude'], '');
    obj.home_gps_longitude = Utils.to_str(m['home_gps_longitude'], '');
    obj.village = Utils.to_str(m['village'], '');
    obj.street = Utils.to_str(m['street'], '');
    obj.house_number = Utils.to_str(m['house_number'], '');
    obj.land_registration_numbers =
        Utils.to_str(m['land_registration_numbers'], '');
    obj.labor_force = Utils.to_str(m['labor_force'], '');
    obj.equipment_owned = Utils.to_str(m['equipment_owned'], '');
    obj.livestock = Utils.to_str(m['livestock'], '');
    obj.crops_grown = Utils.to_str(m['crops_grown'], '');
    obj.has_bank_account = Utils.to_str(m['has_bank_account'], '');
    obj.has_mobile_money_account =
        Utils.to_str(m['has_mobile_money_account'], '');
    obj.payments_or_transfers = Utils.to_str(m['payments_or_transfers'], '');
    obj.financial_service_provider =
        Utils.to_str(m['financial_service_provider'], '');
    obj.has_credit = Utils.to_str(m['has_credit'], '');
    obj.loan_size = Utils.to_str(m['loan_size'], '');
    obj.loan_usage = Utils.to_str(m['loan_usage'], '');
    obj.farm_business_plan = Utils.to_str(m['farm_business_plan'], '');
    obj.covered_risks = Utils.to_str(m['covered_risks'], '');
    obj.insurance_company_name = Utils.to_str(m['insurance_company_name'], '');
    obj.insurance_cost = Utils.to_str(m['insurance_cost'], '');
    obj.repaid_amount = Utils.to_str(m['repaid_amount'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.district_id = Utils.to_str(m['district_id'], '');
    obj.district_text = Utils.to_str(m['district_text'], '');
    obj.subcounty_id = Utils.to_str(m['subcounty_id'], '');
    obj.subcounty_text = Utils.to_str(m['subcounty_text'], '');
    obj.parish_id = Utils.to_str(m['parish_id'], '');
    obj.parish_text = Utils.to_str(m['parish_text'], '');
    obj.bank_id = Utils.to_str(m['bank_id'], '');
    obj.bank_text = Utils.to_str(m['bank_text'], '');
    obj.other_livestock_count = Utils.to_str(m['other_livestock_count'], '');
    obj.poultry_count = Utils.to_str(m['poultry_count'], '');
    obj.sheep_count = Utils.to_str(m['sheep_count'], '');
    obj.goat_count = Utils.to_str(m['goat_count'], '');
    obj.cattle_count = Utils.to_str(m['cattle_count'], '');
    obj.bank_account_number = Utils.to_str(m['bank_account_number'], '');
    obj.has_receive_loan = Utils.to_str(m['has_receive_loan'], '');

    return obj;
  }

  static Future<List<FarmModel>> getLocalData({String where = "1"}) async {
    List<FarmModel> data = [];
    if (!(await FarmModel.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps =
        await db.query(tableName, where: where, orderBy: ' id DESC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(FarmModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<FarmModel>> get_items({String where = '1'}) async {
    List<FarmModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await FarmModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      FarmModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<FarmModel>> getOnlineItems() async {
    List<FarmModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get('${FarmModel.end_point}', {}));

    if (resp.code != 1) {
      return [];
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return [];
    }

    if (resp.data.runtimeType.toString().contains('List')) {
      if (await Utils.is_connected()) {
        await FarmModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          FarmModel sub = FarmModel.fromJson(x);
          try {
            batch.insert(tableName, sub.toJson(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (e) {
            print("faied to save becaus ${e.toString()}");
          }
        }

        try {
          await batch.commit(continueOnError: true);
        } catch (e) {
          print("faied to save to commit BRECASE == ${e.toString()}");
        }
      });
    }

    return data;
  }

  save() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.insert(
        tableName,
        toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  toJson() {
    return {
      'id': id,
      'organisation_id': organisation_id,
      'organisation_text': organisation_text,
      'farmer_group_id': farmer_group_id,
      'farmer_group_text': farmer_group_text,
      'first_name': first_name,
      'last_name': last_name,
      'country_id': country_id,
      'country_text': country_text,
      'language_id': language_id,
      'language_text': language_text,
      'national_id_number': national_id_number,
      'national_text_number': national_text_number,
      'gender': gender,
      'education_level': education_level,
      'year_of_birth': year_of_birth,
      'phone': phone,
      'email': email,
      'is_your_phone': is_your_phone,
      'is_mm_registered': is_mm_registered,
      'other_economic_activity': other_economic_activity,
      'location_id': location_id,
      'location_text': location_text,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'password': password,
      'farming_scale': farming_scale,
      'land_holding_in_acres': land_holding_in_acres,
      'land_under_farming_in_acres': land_under_farming_in_acres,
      'ever_bought_insurance': ever_bought_insurance,
      'ever_received_credit': ever_received_credit,
      'status': status,
      'created_by_user_id': created_by_user_id,
      'created_by_user_text': created_by_user_text,
      'created_by_agent_id': created_by_agent_id,
      'created_by_agent_text': created_by_agent_text,
      'agent_id': agent_id,
      'agent_text': agent_text,
      'created_at': created_at,
      'updated_at': updated_at,
      'poverty_level': poverty_level,
      'food_security_level': food_security_level,
      'marital_status': marital_status,
      'family_size': family_size,
      'farm_decision_role': farm_decision_role,
      'is_pwd': is_pwd,
      'is_refugee': is_refugee,
      'date_of_birth': date_of_birth,
      'age_group': age_group,
      'language_preference': language_preference,
      'phone_number': phone_number,
      'phone_type': phone_type,
      'preferred_info_type': preferred_info_type,
      'home_gps_latitude': home_gps_latitude,
      'home_gps_longitude': home_gps_longitude,
      'village': village,
      'street': street,
      'house_number': house_number,
      'land_registration_numbers': land_registration_numbers,
      'labor_force': labor_force,
      'equipment_owned': equipment_owned,
      'livestock': livestock,
      'crops_grown': crops_grown,
      'has_bank_account': has_bank_account,
      'has_mobile_money_account': has_mobile_money_account,
      'payments_or_transfers': payments_or_transfers,
      'financial_service_provider': financial_service_provider,
      'has_credit': has_credit,
      'loan_size': loan_size,
      'loan_usage': loan_usage,
      'farm_business_plan': farm_business_plan,
      'covered_risks': covered_risks,
      'insurance_company_name': insurance_company_name,
      'insurance_cost': insurance_cost,
      'repaid_amount': repaid_amount,
      'photo': photo,
      'district_id': district_id,
      'district_text': district_text,
      'subcounty_id': subcounty_id,
      'subcounty_text': subcounty_text,
      'parish_id': parish_id,
      'parish_text': parish_text,
      'bank_id': bank_id,
      'bank_text': bank_text,
      'other_livestock_count': other_livestock_count,
      'poultry_count': poultry_count,
      'sheep_count': sheep_count,
      'goat_count': goat_count,
      'cattle_count': cattle_count,
      'bank_account_number': bank_account_number,
      'has_receive_loan': has_receive_loan,
    };
  }

  static Future initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "$tableName ("
        "id INTEGER PRIMARY KEY"
        ",organisation_id TEXT"
        ",organisation_text TEXT"
        ",farmer_group_id TEXT"
        ",farmer_group_text TEXT"
        ",first_name TEXT"
        ",last_name TEXT"
        ",country_id TEXT"
        ",country_text TEXT"
        ",language_id TEXT"
        ",language_text TEXT"
        ",national_id_number TEXT"
        ",national_text_number TEXT"
        ",gender TEXT"
        ",education_level TEXT"
        ",year_of_birth TEXT"
        ",phone TEXT"
        ",email TEXT"
        ",is_your_phone TEXT"
        ",is_mm_registered TEXT"
        ",other_economic_activity TEXT"
        ",location_id TEXT"
        ",location_text TEXT"
        ",address TEXT"
        ",latitude TEXT"
        ",longitude TEXT"
        ",password TEXT"
        ",farming_scale TEXT"
        ",land_holding_in_acres TEXT"
        ",land_under_farming_in_acres TEXT"
        ",ever_bought_insurance TEXT"
        ",ever_received_credit TEXT"
        ",status TEXT"
        ",created_by_user_id TEXT"
        ",created_by_user_text TEXT"
        ",created_by_agent_id TEXT"
        ",created_by_agent_text TEXT"
        ",agent_id TEXT"
        ",agent_text TEXT"
        ",created_at TEXT"
        ",updated_at TEXT"
        ",poverty_level TEXT"
        ",food_security_level TEXT"
        ",marital_status TEXT"
        ",family_size TEXT"
        ",farm_decision_role TEXT"
        ",is_pwd TEXT"
        ",is_refugee TEXT"
        ",date_of_birth TEXT"
        ",age_group TEXT"
        ",language_preference TEXT"
        ",phone_number TEXT"
        ",phone_type TEXT"
        ",preferred_info_type TEXT"
        ",home_gps_latitude TEXT"
        ",home_gps_longitude TEXT"
        ",village TEXT"
        ",street TEXT"
        ",house_number TEXT"
        ",land_registration_numbers TEXT"
        ",labor_force TEXT"
        ",equipment_owned TEXT"
        ",livestock TEXT"
        ",crops_grown TEXT"
        ",has_bank_account TEXT"
        ",has_mobile_money_account TEXT"
        ",payments_or_transfers TEXT"
        ",financial_service_provider TEXT"
        ",has_credit TEXT"
        ",loan_size TEXT"
        ",loan_usage TEXT"
        ",farm_business_plan TEXT"
        ",covered_risks TEXT"
        ",insurance_company_name TEXT"
        ",insurance_cost TEXT"
        ",repaid_amount TEXT"
        ",photo TEXT"
        ",district_id TEXT"
        ",district_text TEXT"
        ",subcounty_id TEXT"
        ",subcounty_text TEXT"
        ",parish_id TEXT"
        ",parish_text TEXT"
        ",bank_id TEXT"
        ",bank_text TEXT"
        ",other_livestock_count TEXT"
        ",poultry_count TEXT"
        ",sheep_count TEXT"
        ",goat_count TEXT"
        ",cattle_count TEXT"
        ",bank_account_number TEXT"
        ",has_receive_loan TEXT"
        ")";

    try {
      //await db.execute("DROP TABLE ${tableName}");
      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  static deleteAll() async {
    if (!(await FarmModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(FarmModel.tableName);
  }

  delete() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.delete(tableName, where: 'id = $id');
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  getFullName() {
    return "$first_name $last_name";
  }

  getPhone() {
    return "$phone";
  }
}
