// To parse this JSON data, do
//
//     final couponModel = couponModelFromJson(jsonString);

import 'dart:convert';

CouponModel couponModelFromJson(String str) => CouponModel.fromJson(json.decode(str));

String couponModelToJson(CouponModel data) => json.encode(data.toJson());

class CouponModel {
  CouponModel({
    this.status,
    this.discount,
    this.messages,
  });

  int? status;
  String? discount;
  String? messages;

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
    status: json["status"],
    discount: json["discount"].toString(),
    messages: json["messages"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "discount": discount,
    "messages": messages,
  };
}
