// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

import 'package:clearance/models/api_models/product_details_model.dart';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    this.message,
    this.data,
  });

  String ?message;
  Data? data;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
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
    this.subTotal,
    this.subTotalFormated,
    this.totalTax,
    this.totalTaxFormated,
    this.totalDiscountOnProduct,
    this.totalDiscountOnProductFormated,
    this.totalShippingCost,
    this.totalShippingCostFormated,
    this.codCost,
    this.codCostFormatted,
    this.hasCod,
    this.couponDiscountFormated,
    this.total,
    this.estimatedTax,
    this.estimatedTaxFormatted,
    this.totalFormated,
    this.cart,
    required this.restForFreeShipping,
    required this.restForFreeShippingFormatted,
  });

  double? subTotal;
  String? subTotalFormated;
  double? totalTax;
  double? estimatedTax;
  String? estimatedTaxFormatted;
  String? totalTaxFormated;
  double? totalDiscountOnProduct;
  String? totalDiscountOnProductFormated;
  double? totalShippingCost;
  double? codCost;
  String? codCostFormatted;
  bool? hasCod;
  String? totalShippingCostFormated;
  String? couponDiscountFormated;
  double? total;
  String? totalFormated;
  List<Cart>? cart;
  double? restForFreeShipping;
  String? restForFreeShippingFormatted;
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    subTotal: json["sub_total"].toDouble(),
    subTotalFormated: json["sub_total_formated"],
    totalTax: double.parse(json["total_tax"].toString()),
    restForFreeShipping: double.parse(json["rest_for_free_shipping"].toString()),
    totalTaxFormated: json["total_tax_formated"],
    restForFreeShippingFormatted: json["rest_for_free_shipping_formatted"],
    totalDiscountOnProduct: json["total_discount_on_product"].toDouble(),
    totalDiscountOnProductFormated: json["total_discount_on_product_formated"],
    estimatedTaxFormatted: json["estimated_tax_formated"],
    totalShippingCost: json["total_shipping_cost"].toDouble(),
    totalShippingCostFormated: json["total_shipping_cost_formated"],
    codCost: double.parse(json["cod_cost"].toString()),
    codCostFormatted: json["cod_cost_formated"],
    hasCod: json["has_cod"],
    estimatedTax: json["estimated_tax"].toDouble(),
    couponDiscountFormated: json["coupon_discount_formated"].toString(),
    total: json["total"].toDouble(),
    totalFormated: json["total_formated"],
    cart: List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sub_total": subTotal,
    "sub_total_formated": subTotalFormated,
    "total_tax": totalTax,
    "total_tax_formated": totalTaxFormated,
    "total_discount_on_product": totalDiscountOnProduct,
    "total_discount_on_product_formated": totalDiscountOnProductFormated,
    "total_shipping_cost": totalShippingCost,
    "total_shipping_cost_formated": totalShippingCostFormated,
    "total": total,
    "estimated_tax": estimatedTax,
    "estimated_tax_formated": estimatedTaxFormatted,
    "total_formated": totalFormated,
    "rest_for_free_shipping_formatted": restForFreeShippingFormatted,
    "rest_for_free_shipping": restForFreeShipping,
    "cart": List<dynamic>.from(cart!.map((x) => x.toJson())),
  };
}

class Cart {
  Cart({
    this.id,
    this.customerId,
    this.cartGroupId,
    this.productId,
    this.choices,
    this.variations,
    this.variant,
    this.availableQuantity,
    this.vendorName,
    this.quantity,
    this.price,
    this.offerPriceFormatted,
    this.priceNum,
    this.tax,
    this.discount,
    this.slug,
    this.name,
    this.thumbnail,
    this.createdAt,
    this.shop,
  });

  int? id;
  int? customerId;
  String ?cartGroupId;
  int? productId;
  dynamic choices;
  dynamic variations;
  String? variant;
  int? availableQuantity;
  String? vendorName;
  int? quantity;
  String? price;
  String? offerPriceFormatted;
  double? priceNum;
  double? tax;
  double? discount;
  String? slug;
  String? name;
  String ?thumbnail;
  DateTime? createdAt;
  Shop? shop;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    id: json["id"],
    customerId: json["customer_id"],
    cartGroupId: json["cart_group_id"],
    productId: json["product_id"],
    choices: json["choices"],
    variations: json["variations"],
    variant: json["variant"],
    availableQuantity: json["available_quantity"],
    vendorName: json["vendor_name"],
    quantity: json["quantity"],
    price: json["price"],
    offerPriceFormatted: json["offer_price_formatted"],
    priceNum: json["price_num"].toDouble(),
    tax: double.parse(json["tax"].toString()),
    discount: json["discount"].toDouble(),
    slug: json["slug"],
    name: json["name"],
    thumbnail: json["thumbnail"],
    createdAt: DateTime.parse(json["created_at"]),
    shop: Shop.fromJson(json["shop"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_id": customerId,
    "cart_group_id": cartGroupId,
    "product_id": productId,
    "choices": choices,
    "variations": variations,
    "variant": variant,
    "available_quantity": availableQuantity,
    "vendor_name": vendorName,
    "quantity": quantity,
    "price": price,
    "price_num": priceNum,
    "tax": tax,
    "discount": discount,
    "slug": slug,
    "name": name,
    "thumbnail": thumbnail,
    "created_at": createdAt!.toIso8601String(),
  };
}

