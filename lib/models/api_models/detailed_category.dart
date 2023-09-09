// To parse this JSON data, do
//
//     final detailedCategoriesModel = detailedCategoriesModelFromJson(jsonString);

import 'dart:convert';

import 'home_Section_model.dart';

DetailedCategoriesModel detailedCategoriesModelFromJson(String str) => DetailedCategoriesModel.fromJson(json.decode(str));

String detailedCategoriesModelToJson(DetailedCategoriesModel data) => json.encode(data.toJson());

class DetailedCategoriesModel {
  DetailedCategoriesModel({
    this.message,
    this.data,
  });

  String? message;
  Data? data;

  factory DetailedCategoriesModel.fromJson(Map<String, dynamic> json) => DetailedCategoriesModel(
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
    this.id,
    this.name,
    this.slug,
    this.icon,
    this.banner,
    this.parentId,
    this.position,
    this.productsStyle,
    this.isGift,
    this.childes,
    this.products,
  });

  int? id;
  String ?name;
  String? slug;
  String? icon;
  String? banner;
  int? parentId;
  int? position;
  int? productsStyle;
  int? isGift;
  List<Data>? childes;
  List<Product>? products;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    icon: json["icon"],
    banner: json["banner"],
    parentId: json["parent_id"],
    position: json["position"],
    productsStyle: json["products_style"],
    isGift: json["is_gift"],
    childes: List<Data>.from(json["childes"].map((x) => Data.fromJson(x))),
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "icon": icon,
    "banner": banner,
    "parent_id": parentId,
    "position": position,
    "products_style": productsStyle,
    "is_gift": isGift,
    "childes": List<dynamic>.from(childes!.map((x) => x.toJson())),
    // "products": List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}
