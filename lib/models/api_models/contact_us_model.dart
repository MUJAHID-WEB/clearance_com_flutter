// To parse this JSON data, do
//
//     final contactUsModel = contactUsModelFromJson(jsonString);

import 'dart:convert';

ContactUsModel contactUsModelFromJson(String str) => ContactUsModel.fromJson(json.decode(str));

String contactUsModelToJson(ContactUsModel data) => json.encode(data.toJson());

class ContactUsModel {
  ContactUsModel({
    this.message,
    this.data,
  });

  String? message;
  Data? data;

  factory ContactUsModel.fromJson(Map<String, dynamic> json) => ContactUsModel(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    this.whatsAppPhone,
    this.phone,
    this.messageContactUs,
    this.whatsappMessage,
  });

  String? whatsAppPhone;
  String? phone;
  String? messageContactUs;
  String? whatsappMessage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    whatsAppPhone: json["whatsApp-phone"],
    phone: json["phone"],
    messageContactUs: json["message-contact-us"],
    whatsappMessage: json.containsKey('Default_whatsapp_message') ? json["Default_whatsapp_message"]:null,
  );

  Map<String, dynamic> toJson() => {
    "whatsApp-phone": whatsAppPhone,
    "phone": phone,
    "message-contact-us": messageContactUs,
    "Default_whatsapp_message": whatsappMessage,
  };
}
