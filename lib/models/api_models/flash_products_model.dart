import 'package:clearance/models/api_models/home_Section_model.dart';
import 'dart:convert';
FlashProductsModel brandProductsModelFromJson(String str) => FlashProductsModel.fromJson(json.decode(str));

String brandProductsModelToJson(FlashProductsModel data) => json.encode(data.toJson());

class FlashProductsModel{
  FlashProductsModel({
    this.message,
    this.data,
    this.totalSize
  });

  String? message;
  int? totalSize;
  List<Product>? data;

  factory FlashProductsModel.fromJson(Map<String, dynamic> json) => FlashProductsModel(
    message: json["message"],
    totalSize: json["totalSize"],
    data: List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "totalSize": totalSize,
    "data": List<Product>.from(data?.map((x) => x.toJson()) ?? []),
  };
}