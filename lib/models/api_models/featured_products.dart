// To parse this JSON data, do
//
//     final featuredProductsModel = featuredProductsModelFromJson(jsonString);

import 'dart:convert';

import 'home_Section_model.dart';

FeaturedProductsModel featuredProductsModelFromJson(String str) => FeaturedProductsModel.fromJson(json.decode(str));

String featuredProductsModelToJson(FeaturedProductsModel data) => json.encode(data.toJson());

class FeaturedProductsModel {
  FeaturedProductsModel({
    this.message,
    this.data,
  });

  String? message;
  Data? data;

  factory FeaturedProductsModel.fromJson(Map<String, dynamic> json) => FeaturedProductsModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.totalSize,
    this.limit,
    this.offset,
    this.products,
  });

  int? totalSize;
  int? limit;
  int? offset;
  List<Product>? products;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalSize: json["total_size"],
    limit: json["limit"],
    offset: json["offset"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_size": totalSize,
    "limit": limit,
    "offset": offset,
    // "products": List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}