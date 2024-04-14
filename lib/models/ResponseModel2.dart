// To parse this JSON data, do
//
//     final responseModel2 = responseModel2FromJson(jsonString);

import 'dart:convert';

class ResponseModel2 {
  ResponseModel2({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<Datum> data;

  factory ResponseModel2.fromRawJson(String str) => ResponseModel2.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResponseModel2.fromJson(Map<String, dynamic> json) => ResponseModel2(
    code: json["code"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.avatar,
    this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
    required this.enterpriseId,
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    this.placeOfBirth,
    this.sex,
    this.homeAddress,
    this.currentAddress,
    this.phoneNumber1,
    this.phoneNumber2,
    required this.email,
    this.nationality,
    this.religion,
    this.spouseName,
    this.spousePhone,
    this.fatherName,
    this.fatherPhone,
    this.motherName,
    this.motherPhone,
    this.languages,
    this.emergencyPersonName,
    this.emergencyPersonPhone,
    this.nationalIdNumber,
    this.passportNumber,
    this.tin,
    this.nssfNumber,
    this.bankName,
    this.bankAccountNumber,
    this.primarySchoolName,
    this.primarySchoolYearGraduated,
    this.secondaySchoolName,
    this.secondaySchoolYearGraduated,
    this.highSchoolName,
    this.highSchoolYearGraduated,
    this.degreeUniversityName,
    this.degreeUniversityYearGraduated,
    this.mastersUniversityName,
    this.mastersUniversityYearGraduated,
    this.phdUniversityName,
    this.phdUniversityYearGraduated,
    required this.userType,
    required this.demoId,
    this.userId,
    required this.userBatchImporterId,
    required this.schoolPayAccountId,
    required this.schoolPayPaymentCode,
    this.givenName,
    this.deletedAt,
    this.maritalStatus,
    required this.verification,
    required this.currentClassId,
    required this.currentTheologyClassId,
    required this.status,
  });

  int id;
  String username;
  String password;
  String name;
  String avatar;
  String? rememberToken;
  DateTime createdAt;
  DateTime updatedAt;
  int enterpriseId;
  String firstName;
  String lastName;
  String? dateOfBirth;
  String? placeOfBirth;
  Sex? sex;
  String? homeAddress;
  String? currentAddress;
  String? phoneNumber1;
  String? phoneNumber2;
  String email;
  Nationality? nationality;
  Religion? religion;
  Languages? spouseName;
  Languages? spousePhone;
  String? fatherName;
  String? fatherPhone;
  String? motherName;
  String? motherPhone;
  Languages? languages;
  String? emergencyPersonName;
  String? emergencyPersonPhone;
  Languages? nationalIdNumber;
  Languages? passportNumber;
  dynamic tin;
  dynamic nssfNumber;
  dynamic bankName;
  dynamic bankAccountNumber;
  dynamic primarySchoolName;
  dynamic primarySchoolYearGraduated;
  dynamic secondaySchoolName;
  dynamic secondaySchoolYearGraduated;
  dynamic highSchoolName;
  dynamic highSchoolYearGraduated;
  dynamic degreeUniversityName;
  dynamic degreeUniversityYearGraduated;
  dynamic mastersUniversityName;
  dynamic mastersUniversityYearGraduated;
  dynamic phdUniversityName;
  dynamic phdUniversityYearGraduated;
  UserType userType;
  int demoId;
  String? userId;
  int userBatchImporterId;
  String schoolPayAccountId;
  String schoolPayPaymentCode;
  String? givenName;
  dynamic deletedAt;
  dynamic maritalStatus;
  int verification;
  int currentClassId;
  int currentTheologyClassId;
  int status;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    username: json["username"],
    password: json["password"],
    name: json["name"],
    avatar: json["avatar"],
    rememberToken: json["remember_token"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    enterpriseId: json["enterprise_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    dateOfBirth: json["date_of_birth"],
    placeOfBirth: json["place_of_birth"],
    sex: sexValues.map[json["sex"]]!,
    homeAddress: json["home_address"],
    currentAddress: json["current_address"],
    phoneNumber1: json["phone_number_1"],
    phoneNumber2: json["phone_number_2"],
    email: json["email"],
    nationality: nationalityValues.map[json["nationality"]]!,
    religion: religionValues.map[json["religion"]]!,
    spouseName: languagesValues.map[json["spouse_name"]]!,
    spousePhone: languagesValues.map[json["spouse_phone"]]!,
    fatherName: json["father_name"],
    fatherPhone: json["father_phone"],
    motherName: json["mother_name"],
    motherPhone: json["mother_phone"],
    languages: languagesValues.map[json["languages"]]!,
    emergencyPersonName: json["emergency_person_name"],
    emergencyPersonPhone: json["emergency_person_phone"],
    nationalIdNumber: languagesValues.map[json["national_id_number"]]!,
    passportNumber: languagesValues.map[json["passport_number"]]!,
    tin: json["tin"],
    nssfNumber: json["nssf_number"],
    bankName: json["bank_name"],
    bankAccountNumber: json["bank_account_number"],
    primarySchoolName: json["primary_school_name"],
    primarySchoolYearGraduated: json["primary_school_year_graduated"],
    secondaySchoolName: json["seconday_school_name"],
    secondaySchoolYearGraduated: json["seconday_school_year_graduated"],
    highSchoolName: json["high_school_name"],
    highSchoolYearGraduated: json["high_school_year_graduated"],
    degreeUniversityName: json["degree_university_name"],
    degreeUniversityYearGraduated: json["degree_university_year_graduated"],
    mastersUniversityName: json["masters_university_name"],
    mastersUniversityYearGraduated: json["masters_university_year_graduated"],
    phdUniversityName: json["phd_university_name"],
    phdUniversityYearGraduated: json["phd_university_year_graduated"],
    userType: userTypeValues.map[json["user_type"]]!,
    demoId: json["demo_id"],
    userId: json["user_id"],
    userBatchImporterId: json["user_batch_importer_id"],
    schoolPayAccountId: json["school_pay_account_id"],
    schoolPayPaymentCode: json["school_pay_payment_code"],
    givenName: json["given_name"],
    deletedAt: json["deleted_at"],
    maritalStatus: json["marital_status"],
    verification: json["verification"],
    currentClassId: json["current_class_id"],
    currentTheologyClassId: json["current_theology_class_id"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "password": password,
    "name": name,
    "avatar": avatar,
    "remember_token": rememberToken,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "enterprise_id": enterpriseId,
    "first_name": firstName,
    "last_name": lastName,
    "date_of_birth": dateOfBirth,
    "place_of_birth": placeOfBirth,
    "sex": sexValues.reverse[sex],
    "home_address": homeAddress,
    "current_address": currentAddress,
    "phone_number_1": phoneNumber1,
    "phone_number_2": phoneNumber2,
    "email": email,
    "nationality": nationalityValues.reverse[nationality],
    "religion": religionValues.reverse[religion],
    "spouse_name": languagesValues.reverse[spouseName],
    "spouse_phone": languagesValues.reverse[spousePhone],
    "father_name": fatherName,
    "father_phone": fatherPhone,
    "mother_name": motherName,
    "mother_phone": motherPhone,
    "languages": languagesValues.reverse[languages],
    "emergency_person_name": emergencyPersonName,
    "emergency_person_phone": emergencyPersonPhone,
    "national_id_number": languagesValues.reverse[nationalIdNumber],
    "passport_number": languagesValues.reverse[passportNumber],
    "tin": tin,
    "nssf_number": nssfNumber,
    "bank_name": bankName,
    "bank_account_number": bankAccountNumber,
    "primary_school_name": primarySchoolName,
    "primary_school_year_graduated": primarySchoolYearGraduated,
    "seconday_school_name": secondaySchoolName,
    "seconday_school_year_graduated": secondaySchoolYearGraduated,
    "high_school_name": highSchoolName,
    "high_school_year_graduated": highSchoolYearGraduated,
    "degree_university_name": degreeUniversityName,
    "degree_university_year_graduated": degreeUniversityYearGraduated,
    "masters_university_name": mastersUniversityName,
    "masters_university_year_graduated": mastersUniversityYearGraduated,
    "phd_university_name": phdUniversityName,
    "phd_university_year_graduated": phdUniversityYearGraduated,
    "user_type": userTypeValues.reverse[userType],
    "demo_id": demoId,
    "user_id": userId,
    "user_batch_importer_id": userBatchImporterId,
    "school_pay_account_id": schoolPayAccountId,
    "school_pay_payment_code": schoolPayPaymentCode,
    "given_name": givenName,
    "deleted_at": deletedAt,
    "marital_status": maritalStatus,
    "verification": verification,
    "current_class_id": currentClassId,
    "current_theology_class_id": currentTheologyClassId,
    "status": status,
  };
}

enum Languages { EMPTY }

final languagesValues = EnumValues({
  "-": Languages.EMPTY
});

enum Nationality { EMPTY, UGANDAN }

final nationalityValues = EnumValues({
  "": Nationality.EMPTY,
  "Ugandan": Nationality.UGANDAN
});

enum Religion { EMPTY, MUSLIM, ISLAM, CHRISTIAN, RELIGION_ISLAM }

final religionValues = EnumValues({
  "Christian": Religion.CHRISTIAN,
  "": Religion.EMPTY,
  "Islam": Religion.ISLAM,
  "Muslim": Religion.MUSLIM,
  "ISLAM": Religion.RELIGION_ISLAM
});

enum Sex { MALE, FEMALE }

final sexValues = EnumValues({
  "Female": Sex.FEMALE,
  "Male": Sex.MALE
});

enum UserType { STUDENT }

final userTypeValues = EnumValues({
  "student": UserType.STUDENT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
