// To parse this JSON data, do
//
//     final productsFilteredByCateModel = productsFilteredByCateModelFromJson(jsonString);

import 'dart:convert';

import 'home_Section_model.dart';

FilteredProductsModel productsFilteredByCateModelFromJson(String str) => FilteredProductsModel.fromJson(json.decode(str));

String productsFilteredByCateModelToJson(FilteredProductsModel data) => json.encode(data.toJson());

class FilteredProductsModel {
  FilteredProductsModel({
    this.message,
    this.data,
  });

  String? message;
  Data? data;

  factory FilteredProductsModel.fromJson(Map<String, dynamic> json) => FilteredProductsModel(
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
    this.brands,
    this.prices,
    this.colors,
    this.attributes
  });

  int? totalSize;
  int? limit;
  int? offset;
  List<Product> ?products;
  List<Brand>? brands;
  List<Attribute>? attributes;
  List<String>? colors;
  List<Price>? prices;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalSize: json["total_size"],
    limit: json["limit"],
    offset: json["offset"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    brands: List<Brand>.from(json["brands"].map((x) => Brand.fromJson(x))),
    attributes: List<Attribute>.from(json["attributes"].map((x) => Attribute.fromJson(x))),
    colors: List<String>.from(json["colors"].map((x) => x)),
    prices: List<Price>.from(json["prices"].map((x) => Price.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_size": totalSize,
    "limit": limit,
    "offset": offset,
    "products": List<dynamic>.from(products!.map((x) => x.toJson())),
    "brands": List<dynamic>.from(brands!.map((x) => x.toJson())),
    "attributes": List<dynamic>.from(attributes!.map((x) => x.toJson())),
    "colors": List<dynamic>.from(colors!.map((x) => x)),
    "prices": List<dynamic>.from(prices!.map((x) => x.toJson())),
  };
}

class Attribute {
  Attribute({
    this.id,
    this.name,
    this.options,
  });

  int? id;
  String? name;
  List<String>? options;

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    id: json["id"],
    name: json["name"],
    options: List<String>.from(json["options"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "options": List<dynamic>.from(options!.map((x) => x)),
  };
}

class Brand {
  Brand({
    this.id,
    this.name,
    this.image,
  });

  int? id;
  String ?name;
  String? image;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}

class Price {
  Price({
    this.minPrice,
    this.maxPrice,
    this.text,
  });

  String? minPrice;
  String? maxPrice;
  String? text;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    minPrice: json["min_price"].toString(),
    maxPrice: json["max_price"].toString(),
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "min_price": minPrice,
    "max_price": maxPrice,
    "text": text,
  };
}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
