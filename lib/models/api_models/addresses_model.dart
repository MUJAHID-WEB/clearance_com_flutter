// To parse this JSON data, do
//
//     final addressesModel = addressesModelFromJson(jsonString);

import 'dart:convert';

AddressesModel addressesModelFromJson(String str) => AddressesModel.fromJson(json.decode(str));

String addressesModelToJson(AddressesModel data) => json.encode(data.toJson());

class AddressesModel {
  AddressesModel({
    this.message,
    this.data,
  });

  String? message;
  List<Address>? data;

  factory AddressesModel.fromJson(Map<String, dynamic> json) => AddressesModel(
    message: json["message"],
    data: List<Address>.from(json["data"].map((x) => Address.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Address {
  Address({
    this.id,
    this.contactPersonName,
    this.addressType,
    this.address,
    this.address2,
    this.city,
    this.zip,
    this.phone,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    this.isBilling,
    this.isDefault,
  });

  int? id;
  String? contactPersonName;
  String? addressType;
  String? address;
  dynamic address2;
  String? city;
  String? zip;
  String? phone;
  dynamic state;
  dynamic country;
  dynamic latitude;
  dynamic longitude;
  int? isBilling;
  int? isDefault;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    contactPersonName: json["contact_person_name"],
    addressType: json["address_type"],
    address: json["address"],
    address2: json["address2"],
    city: json["city"],
    zip: json["zip"],
    phone: json["phone"],
    state: json["state"],
    country: json["country"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    isBilling: json["is_billing"],
    isDefault: json["is_default"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "contact_person_name": contactPersonName,
    "address_type": addressType,
    "address": address,
    "address2": address2,
    "city": city,
    "zip": zip,
    "phone": phone,
    "state": state,
    "country": country,
    "latitude": latitude,
    "longitude": longitude,
    "is_billing": isBilling,
  };
}
