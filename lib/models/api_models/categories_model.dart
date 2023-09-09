// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

import 'home_Section_model.dart';

CategoriesModel categoriesModelFromJson(String str) => CategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(CategoriesModel data) => json.encode(data.toJson());

class CategoriesModel {
  CategoriesModel({
    this.message,
    this.data,
  });

  String ?message;
  List<CategoryItemModel>? data;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
    message: json["message"],
    data: List<CategoryItemModel>.from(json["data"].map((x) => CategoryItemModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CategoryItemModel {
  CategoryItemModel({
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
  String? name;
  String? slug;
  String? icon;
  String? banner;
  int? parentId;
  int? position;
  int? productsStyle;
  int? isGift;
  List<CategoryItemModel>? childes;
  List<Product>? products;

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) => CategoryItemModel(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    icon: json["icon"],
    banner: json["banner"],
    parentId: json["parent_id"],
    position: json["position"],
    productsStyle: json["products_style"],
    isGift: json["is_gift"],
    childes: List<CategoryItemModel>.from(json["childes"].map((x) => CategoryItemModel.fromJson(x))),
    products:json["products"]==null?null: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
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
    "products": List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}

// class Product {
//   Product({
//     this.id,
//     this.name,
//     this.slug,
//     this.shareLink,
//     this.details,
//     this.thumbnail,
//     this.images,
//     this.price,
//     this.priceFormatted,
//     this.offerPrice,
//     this.offerPriceFormatted,
//     this.isFavourite,
//     this.inStock,
//     this.rating,
//   });
//
//   int id;
//   String name;
//   String slug;
//   String shareLink;
//   String details;
//   String thumbnail;
//   List<String> images;
//   double price;
//   String priceFormatted;
//   double offerPrice;
//   String offerPriceFormatted;
//   bool isFavourite;
//   bool inStock;
//   Rating rating;
//
//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//     id: json["id"],
//     name: json["name"],
//     slug: json["slug"],
//     shareLink: json["share_link"],
//     details: json["details"] == null ? null : json["details"],
//     thumbnail: json["thumbnail"],
//     images: List<String>.from(json["images"].map((x) => x)),
//     price: json["price"].toDouble(),
//     priceFormatted: json["price_formatted"],
//     offerPrice: json["offer_price"].toDouble(),
//     offerPriceFormatted: json["offer_price_formatted"],
//     isFavourite: json["is_favourite"],
//     inStock: json["in_stock"],
//     rating: Rating.fromJson(json["rating"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "slug": slug,
//     "share_link": shareLink,
//     "details": details == null ? null : details,
//     "thumbnail": thumbnail,
//     "images": List<dynamic>.from(images.map((x) => x)),
//     "price": price,
//     "price_formatted": priceFormatted,
//     "offer_price": offerPrice,
//     "offer_price_formatted": offerPriceFormatted,
//     "is_favourite": isFavourite,
//     "in_stock": inStock,
//     "rating": rating.toJson(),
//   };
// }

// class Rating {
//   Rating({
//     this.overallRating,
//     this.totalRating,
//   });
//
//   int overallRating;
//   int totalRating;
//
//   factory Rating.fromJson(Map<String, dynamic> json) => Rating(
//     overallRating: json["overall_rating"],
//     totalRating: json["total_rating"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "overall_rating": overallRating,
//     "total_rating": totalRating,
//   };
// }
