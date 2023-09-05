// To parse this JSON data, do
//
//     final productRequiredInformationForShoppingModel = productRequiredInformationForShoppingModelFromJson(jsonString);

import 'dart:convert';

import 'package:clearance/models/api_models/product_details_model.dart';

ProductRequiredInformationForShoppingModel productRequiredInformationForShoppingModelFromJson(String str) => ProductRequiredInformationForShoppingModel.fromJson(json.decode(str));

String productRequiredInformationForShoppingModelToJson(ProductRequiredInformationForShoppingModel data) => json.encode(data.toJson());

class ProductRequiredInformationForShoppingModel {
  ProductRequiredInformationForShoppingModel({
    this.message,
    this.data,
  });

  String? message;
  Data? data;

  factory ProductRequiredInformationForShoppingModel.fromJson(Map<String, dynamic> json) => ProductRequiredInformationForShoppingModel(
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.name,
    this.price,
    this.priceFormatted,
    this.offerPrice,
    this.offerPriceFormatted,
    this.colors,
    this.image,
    this.variation,
    this.choiceOptions,
    this.currentStock,
    this.flashDealDetails,
    this.flashDealMaxAllowedQuantity,
  });

  int? id;
  String? name;
  double? price;
  String? priceFormatted;
  double? offerPrice;
  String? offerPriceFormatted;
  dynamic colors;
  String? image;
  List<Variation>? variation;
  List<ChoiceOption>? choiceOptions;
  dynamic flashDealDetails;
  dynamic flashDealMaxAllowedQuantity;
  int? currentStock;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    price: json["price"].toDouble(),
    priceFormatted: json["price_formatted"],
    offerPrice: json["offer_price"].toDouble(),
    offerPriceFormatted: json["offer_price_formatted"],
    currentStock: json["current_stock"],
    colors: null, //json["colors"],
    image: json["image"] == null ? null : json["image"],
    variation: json["variation"] == null ? null : List<Variation>.from(json["variation"].map((x) => Variation.fromJson(x))),
    choiceOptions: json["choice_options"] == null ? null : List<ChoiceOption>.from(json["choice_options"].map((x) => ChoiceOption.fromJson(x))),
    flashDealDetails: json["flash_deal_details"],
    flashDealMaxAllowedQuantity: json["flash_deal_max_allowed_quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "price": price,
    "price_formatted": priceFormatted,
    "offer_price": offerPrice,
    "offer_price_formatted": offerPriceFormatted,
    "colors": colors,
    "current_stock": currentStock,
    "image": image == null ? null : image,
    "variation": variation == null ? null : List<dynamic>.from(variation!.map((x) => x.toJson())),
    "choice_options": choiceOptions == null ? null : List<dynamic>.from(choiceOptions!.map((x) => x.toJson())),
    "flash_deal_details": flashDealDetails,
    "flash_deal_max_allowed_quantity": flashDealMaxAllowedQuantity,
  };
}


