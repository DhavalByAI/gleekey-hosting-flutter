/*
// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

User_model User_modelFromJson(String str) =>
    User_model.fromJson(json.decode(str));

String User_modelToJson(User_model data) => json.encode(data.toJson());

class User_model {
  User_model({
    required this.status,
    required this.message,
    required this.data,
    required this.userDetails,
    required this.accessToken,
    required this.tokenType,
  });

  bool? status;
  String? message;
  Data? data;
  UserDetails? userDetails;
  String? accessToken;
  String? tokenType;

  factory User_model.fromJson(Map<String, dynamic> json) => User_model(
        status: json["status"] ?? '',
        message: json["message"] ?? '',
        data: Data.fromJson(json["data"]),
        userDetails: UserDetails.fromJson(json["user_details"]),
        accessToken: json["access_token"] ?? '',
        tokenType: json["token_type"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
        "user_details": userDetails?.toJson(),
        "access_token": accessToken,
        "token_type": tokenType,
      };
}

class Data {
  Data({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.formattedPhone,
    required this.carrierCode,
    required this.defaultCountry,
    required this.address,
    required this.address2,
    required this.countryId,
    required this.stateId,
    required this.cityId,
    required this.pincode,
    required this.profileImage,
    required this.balance,
    required this.status,
    required this.sponserCode,
    this.referralCode,
    required this.userProMember,
    required this.userAgent,
    required this.userHost,
    required this.agentRequest,
    required this.hostRequest,
    required this.promemberRequest,
    required this.isAgent,
    required this.isGst,
    required this.createdAt,
    required this.updatedAt,
    required this.profileSrc,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? formattedPhone;
  String? carrierCode;
  String? defaultCountry;
  String? address;
  String? address2;
  int? countryId;
  int? stateId;
  int? cityId;
  String? pincode;
  String? profileImage;
  int? balance;
  String? status;
  String? sponserCode;
  dynamic referralCode;
  int? userProMember;
  int? userAgent;
  int? userHost;
  int? agentRequest;
  int? hostRequest;
  int? promemberRequest;
  int? isAgent;
  int? isGst;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? profileSrc;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] ?? '',
        firstName: json["first_name"] ?? '',
        lastName: json["last_name"] ?? '',
        email: json["email"] ?? '',
        phone: json["phone"] ?? '',
        formattedPhone: json["formatted_phone"] ?? '',
        carrierCode: json["carrier_code"] ?? '',
        defaultCountry: json["default_country"] ?? '',
        address: json["address"] ?? '',
        address2: json["address_2"] ?? '',
        countryId: json["country_id"] ?? '',
        stateId: json["state_id"] ?? '',
        cityId: json["city_id"] ?? '',
        pincode: json["pincode"] ?? '',
        profileImage: json["profile_image"] ?? '',
        balance: json["balance"] ?? '',
        status: json["status"] ?? '',
        sponserCode: json["sponser_code"] ?? '',
        referralCode: json["referral_code"] ?? '',
        userProMember: json["user_pro_member"] ?? '',
        userAgent: json["user_agent"] ?? '',
        userHost: json["user_host"] ?? '',
        agentRequest: json["agent_request"] ?? '',
        hostRequest: json["host_request"] ?? '',
        promemberRequest: json["promember_request"] ?? '',
        isAgent: json["is_agent"] ?? '',
        isGst: json["is_gst"] ?? '',
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now()),
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now()),
        profileSrc: json["profile_src"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "formatted_phone": formattedPhone,
        "carrier_code": carrierCode,
        "default_country": defaultCountry,
        "address": address,
        "address_2": address2,
        "country_id": countryId,
        "state_id": stateId,
        "city_id": cityId,
        "pincode": pincode,
        "profile_image": profileImage,
        "balance": balance,
        "status": status,
        "sponser_code": sponserCode,
        "referral_code": referralCode,
        "user_pro_member": userProMember,
        "user_agent": userAgent,
        "user_host": userHost,
        "agent_request": agentRequest,
        "host_request": hostRequest,
        "promember_request": promemberRequest,
        "is_agent": isAgent,
        "is_gst": isGst,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "profile_src": profileSrc,
      };
}

class UserDetails {
  UserDetails({
    required this.dateOfBirth,
    required this.gender,
  });

  DateTime dateOfBirth;
  String gender;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        dateOfBirth: DateTime.parse(json["date_of_birth"] ?? DateTime.now()),
        gender: json["gender"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "date_of_birth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "gender": gender,
      };
}
*/

// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

User_model User_modelFromJson(String str) =>
    User_model.fromJson(json.decode(str));

String User_modelToJson(User_model data) => json.encode(data.toJson());

class User_model {
  User_model({
    required this.status,
    required this.message,
    required this.data,
    required this.userDetails,
    required this.accessToken,
    required this.tokenType,
  });

  var status;
  var message;
  Data? data;
  UserDetails? userDetails;
  var accessToken;
  var tokenType;

  factory User_model.fromJson(Map<String, dynamic> json) => User_model(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        userDetails: UserDetails.fromJson(json["user_details"]),
        accessToken: json["access_token"],
        tokenType: json["token_type"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
        "user_details": userDetails?.toJson(),
        "access_token": accessToken,
        "token_type": tokenType,
      };
}

class Data {
  Data({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.formattedPhone,
    this.carrierCode,
    this.defaultCountry,
    required this.address,
    required this.address2,
    required this.countryId,
    required this.stateId,
    required this.cityId,
    required this.pincode,
    this.profileImage,
    required this.balance,
    required this.status,
    this.sponserCode,
    this.referralCode,
    required this.userProMember,
    required this.userAgent,
    required this.userHost,
    required this.agentRequest,
    required this.hostRequest,
    required this.promemberRequest,
    required this.isAgent,
    required this.isGst,
    required this.createdAt,
    required this.updatedAt,
    required this.profileSrc,
    required this.kycStatus,
    required this.totalProperty,
    required this.totalListed,
    required this.totalPending,
    required this.totalReservation,
    required this.totalPendingAmount,
    required this.totalRecivedAmount,
  });

  var id;
  var firstName;
  var lastName;
  var email;
  var phone;
  var formattedPhone;
  var carrierCode;
  var defaultCountry;
  var address;
  var address2;
  var countryId;
  var stateId;
  var cityId;
  var pincode;
  var profileImage;
  var balance;
  var status;
  var sponserCode;
  var referralCode;
  var userProMember;
  var userAgent;
  var userHost;
  var agentRequest;
  var hostRequest;
  var promemberRequest;
  var isAgent;
  var isGst;
  var kycStatus;
  var totalProperty;
  var totalListed;
  var totalPending;
  var totalReservation;
  var createdAt;
  var updatedAt;
  var profileSrc;
  var totalPendingAmount;
  var totalRecivedAmount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
      phone: json["phone"],
      formattedPhone: json["formatted_phone"],
      carrierCode: json["carrier_code"],
      defaultCountry: json["default_country"],
      address: json["address"],
      address2: json["address_2"],
      countryId: json["country_id"],
      stateId: json["state_id"],
      cityId: json["city_id"],
      pincode: json["pincode"],
      profileImage: json["profile_image"],
      balance: json["balance"],
      status: json["status"],
      sponserCode: json["sponser_code"],
      referralCode: json["referral_code"],
      userProMember: json["user_pro_member"],
      userAgent: json["user_agent"],
      userHost: json["user_host"],
      agentRequest: json["agent_request"],
      hostRequest: json["host_request"],
      promemberRequest: json["promember_request"],
      isAgent: json["is_agent"],
      isGst: json["is_gst"],
      kycStatus: json["kyc_status"],
      totalProperty: json["total_property"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      profileSrc: json["profile_src"],
      totalReservation: json['total_reservation'],
      totalPendingAmount: json['total_pending_amount'],
      totalRecivedAmount: json['total_recived_amount'],
      totalListed: json['total_listed'],
      totalPending: json['total_pending']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "formatted_phone": formattedPhone,
        "carrier_code": carrierCode,
        "default_country": defaultCountry,
        "address": address,
        "address_2": address2,
        "country_id": countryId,
        "state_id": stateId,
        "city_id": cityId,
        "pincode": pincode,
        "profile_image": profileImage,
        "balance": balance,
        "status": status,
        "sponser_code": sponserCode,
        "referral_code": referralCode,
        "user_pro_member": userProMember,
        "user_agent": userAgent,
        "user_host": userHost,
        "agent_request": agentRequest,
        "host_request": hostRequest,
        "promember_request": promemberRequest,
        "is_agent": isAgent,
        "is_gst": isGst,
        "kyc_status": kycStatus,
        "total_property": totalProperty,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "profile_src": profileSrc,
        "total_reservation": totalReservation,
        "total_pending_amount": totalPendingAmount,
        "total_pending_amount": totalRecivedAmount,
        "total_listed": totalListed,
        "total_pending": totalPending,
      };
}

class UserDetails {
  UserDetails({
    required this.dateOfBirth,
    required this.about,
    required this.gender,
  });

  var dateOfBirth;
  var about;
  var gender;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        dateOfBirth: json["date_of_birth"],
        about: json["about"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "date_of_birth": dateOfBirth,
        "about": about,
        "gender": gender,
      };
}
