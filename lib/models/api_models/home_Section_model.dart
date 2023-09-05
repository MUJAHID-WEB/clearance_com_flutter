// To parse this JSON data, do
//
//     final homeSections = homeSectionsFromJson(jsonString);

import 'dart:convert';

import 'package:clearance/models/api_models/starting_setting_model.dart';

HomeSections homeSectionsFromJson(String str) => HomeSections.fromJson(json.decode(str));

String homeSectionsToJson(HomeSections data) => json.encode(data.toJson());

class HomeSections {
  HomeSections({
    this.message,
    this.data,
    this.settings
  });

  String? message;
  List<HomeSectionItem>? data;
  StartingSettings? settings;
  factory HomeSections.fromJson(Map<String, dynamic> json) => HomeSections(
    message: json["message"],
    data: List<HomeSectionItem>.from(json["data"]["home-data"].map((x) => HomeSectionItem.fromJson(x))),
    settings:json["data"]["starting-setting"] != null ? StartingSettings.fromJson(json["data"]["starting-setting"]) : null
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}


class HomeSectionItem {
  HomeSectionItem({
    this.id,
    this.category,
    this.backColor,
    this.frontColor,
    this.subCategories,
    this.sections,
  });

  int? id;
  String? category;
  String? backColor;
  String? frontColor;
  List<SubCategory>? subCategories;
  List<Section>? sections;

  factory HomeSectionItem.fromJson(Map<String, dynamic> json) => HomeSectionItem(
    id: json["id"],
    category: json["category"],
    frontColor: json["category_front_color"],
    backColor: json["category_back_color"],
    subCategories: List<SubCategory>.from(json["sub_categories"].map((x) => SubCategory.fromJson(x))),
    sections: List<Section>.from(json["sections"].map((x) => Section.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_back_color": backColor,
    "category_front_color": frontColor,
    "category": category,
    "sub_categories": List<dynamic>.from(subCategories!.map((x) => x.toJson())),
    "sections": List<dynamic>.from(sections!.map((x) => x.toJson())),
  };
}

class Section {
  Section({
    this.id,
    this.homeSectionType,
    this.color,
    this.resourceType,
    this.title,
    this.photo,
    this.productsStyle,
    this.hsBanner,
    this.hsBanner2,
    this.hsOffers,
    this.hsProducts,
  });

  int? id;
  int? homeSectionType;
  String? color;
  String? resourceType;
  String? title;
  String? photo;
  int? productsStyle;
  HsBanner? hsBanner;
  HsBanner? hsBanner2;
  List<dynamic>? hsOffers;
  List<Product>? hsProducts;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    id: json["id"],
    homeSectionType: json["home_section_type"],
    color: json["color"],
    resourceType: json["resource_type"],
    title: json["title"],
    photo: json["photo"],
    productsStyle: json["products_style"],
    hsBanner: json["hs_banner"] == null ? null : HsBanner.fromJson(json["hs_banner"]),
    hsBanner2: json["hs_banner2"] == null ? null : HsBanner.fromJson(json["hs_banner2"]),
    hsOffers: List<dynamic>.from(json["hs_offers"].map((x) => x)),
    hsProducts:json["hs_products"]==null?null: List<Product>.from(json["hs_products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "home_section_type": homeSectionType,
    "color": color,
    "resource_type": resourceType,
    "title": title,
    "photo": photo,
    "products_style": productsStyle,
    "hs_banner": hsBanner,
    "hs_banner2": hsBanner2,
    "hs_offers": List<dynamic>.from(hsOffers!.map((x) => x)),
    "hs_products": List<dynamic>.from(hsProducts!.map((x) => x.toJson())),
  };
}

// class HomeSectionItem {
//   HomeSectionItem({
//     this.id,
//     this.homeSectionType,
//     this.color,
//     this.resourceType,
//     this.title,
//     this.photo,
//     this.productsStyle,
//     this.hsBanner,
//     this.hsOffers,
//     this.hsProducts,
//   });
//
//   int? id;
//   int? homeSectionType;
//   String? color;
//   String? resourceType;
//   String? title;
//   String? photo;
//   int? productsStyle;
//   dynamic hsBanner;
//   List<dynamic>? hsOffers;
//   List<Product>? hsProducts;
//
//   factory HomeSectionItem.fromJson(Map<String, dynamic> json) => HomeSectionItem(
//     id: json["id"],
//     homeSectionType: json["home_section_type"],
//     color: json["color"],
//     resourceType: json["resource_type"],
//     title: json["title"],
//     photo: json["photo"],
//     productsStyle: json["products_style"],
//     hsBanner: json["hs_banner"],
//     hsOffers: List<dynamic>.from(json["hs_offers"].map((x) => x)),
//     hsProducts: List<Product>.from(json["hs_products"].map((x) => Product.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "home_section_type": homeSectionType,
//     "color": color,
//     "resource_type": resourceType,
//     "title": title,
//     "photo": photo,
//     "products_style": productsStyle,
//     "hs_banner": hsBanner,
//     "hs_offers": List<dynamic>.from(hsOffers!.map((x) => x)),
//     "hs_products": List<dynamic>.from(hsProducts!.map((x) => x.toJson())),
//   };
// }

class HsBanner {
  HsBanner({
    this.id,
    this.photo,
    this.bannerType,
    this.published,
    this.createdAt,
    this.updatedAt,
    this.url,
    this.resourceType,
    this.resourceId,
    this.newUrl,
  });

  int ?id;
  String? photo;
  String? bannerType;
  int? published;
  DateTime? createdAt;
  DateTime ?updatedAt;
  String? url;
  String? resourceType;
  int ?resourceId;
  String? newUrl;

  factory HsBanner.fromJson(Map<String, dynamic> json) => HsBanner(
    id: json["id"],
    photo: json["photo"],
    bannerType: json["banner_type"],
    published: json["published"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    url: json["url"],
    resourceType: json["resource_type"],
    resourceId: json["resource_id"],
    newUrl: json["new_url"],
  );

  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "photo": photo,
  //   "banner_type": bannerType,
  //   "published": published,
  //   "created_at": createdAt.toIso8601String(),
  //   "updated_at": updatedAt.toIso8601String(),
  //   "url": url,
  //   "resource_type": resourceType,
  //   "resource_id": resourceId,
  //   "new_url": newUrl,
  // };
}

class Product {
  Product({
    this.id,
    this.name,
    this.slug,
    this.shareLink,
    this.details,
    this.thumbnail,
    this.images,
    this.price,
    this.priceFormatted,
    this.offerPrice,
    this.offerPriceFormatted,
    this.isFavourite,
    this.inStock,
    this.rating,
    this.flashDealDetails,
    this.flashDealMaxAllowedQuantity
  });

  int? id;
  String? name;
  String? slug;
  String? shareLink;
  String? details;
  String? thumbnail;
  List<String>? images;
  double? price;
  String? priceFormatted;
  double? offerPrice;
  String? offerPriceFormatted;
  bool? isFavourite;
  bool? inStock;
  Rating? rating;
  FlashDealDetails? flashDealDetails;
  int? flashDealMaxAllowedQuantity;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    shareLink: json["share_link"],
    details: json["details"],
    thumbnail: json["thumbnail"],
    images: List<String>.from(json["images"].map((x) => x)),
    price: json["price"].toDouble(),
    priceFormatted: json["price_formatted"],
    offerPrice: json["offer_price"].toDouble(),
    offerPriceFormatted: json["offer_price_formatted"],
    isFavourite: json["is_favourite"],
    inStock: json["in_stock"],
    rating: Rating.fromJson(json["rating"]),
    flashDealDetails: json["flash_deal_details"] == null ? null : FlashDealDetails.fromJson(json["flash_deal_details"]),
    flashDealMaxAllowedQuantity: json["flash_deal_max_allowed_quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "share_link": shareLink,
    "details": details,
    "thumbnail": thumbnail,
    "images": List<dynamic>.from(images!.map((x) => x)),
    "price": price,
    "price_formatted": priceFormatted,
    "offer_price": offerPrice,
    "offer_price_formatted": offerPriceFormatted,
    "is_favourite": isFavourite,
    "in_stock": inStock,
    "rating": rating!.toJson(),
    "flash_deal_details": flashDealDetails == null ? null : flashDealDetails!.toJson(),
    "flash_deal_max_allowed_quantity": flashDealMaxAllowedQuantity,
  };
}

class FlashDealDetails {
  FlashDealDetails({
    this.startDate,
    this.endDate,
  });

  String? startDate;
  String? endDate;

  factory FlashDealDetails.fromJson(Map<String, dynamic> json) =>
      FlashDealDetails(
          startDate: json["start_date"],
          endDate: json["end_date"]
      );

  Map<String, dynamic> toJson() =>
      {
        "start_date": startDate,
        "end_date": endDate
      };
}

class Rating {
  Rating({
    this.overallRating,
    this.totalRating,
  });

  double? overallRating;
  double? totalRating;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    overallRating: double.parse(json["overall_rating"].toString()),
    totalRating: double.parse(json["total_rating"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "overall_rating": overallRating,
    "total_rating": totalRating,
  };
}
class SubCategory {
  SubCategory({
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
  List<SubCategory>? childes;
  dynamic products;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    icon: json["icon"],
    banner: json["banner"],
    parentId: json["parent_id"],
    position: json["position"],
    productsStyle: json["products_style"],
    isGift: json["is_gift"],
    childes: List<SubCategory>.from(json["childes"].map((x) => SubCategory.fromJson(x))),
    products: json["products"],
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
    "products": products,
  };
}
