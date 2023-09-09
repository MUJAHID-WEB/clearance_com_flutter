import 'package:clearance/models/api_models/home_Section_model.dart';
import 'dart:convert';
BrandProductsModel brandProductsModelFromJson(String str) => BrandProductsModel.fromJson(json.decode(str));

String brandProductsModelToJson(BrandProductsModel data) => json.encode(data.toJson());

class BrandProductsModel{
  BrandProductsModel({
    this.message,
    this.data,
    this.totalSize
  });

  String? message;
  int? totalSize;
  List<Product>? data;

  factory BrandProductsModel.fromJson(Map<String, dynamic> json) => BrandProductsModel(
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