// // To parse this JSON data, do
// //
// //     final productDetailsModel = productDetailsModelFromJson(jsonString);
//
// import 'dart:convert';
//
// import 'package:clearance/models/api_models/config_model.dart';
//
// import 'home_Section_model.dart';
//
// ProductDetailsModel productDetailsModelFromJson(String str) => ProductDetailsModel.fromJson(json.decode(str));
//
// String productDetailsModelToJson(ProductDetailsModel data) => json.encode(data.toJson());
//
// class ProductDetailsModel {
//   ProductDetailsModel({
//     this.message,
//     this.data,
//   });
//
//   String? message;
//   Data? data;
//
//   factory ProductDetailsModel.fromJson(Map<String, dynamic> json) => ProductDetailsModel(
//     message: json["message"],
//     data: Data.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "message": message,
//     // "data": data!.toJson(),
//   };
// }
//
// class Data {
//   Data({
//     this.id,
//     this.name,
//     this.details,
//     this.description,
//     this.model,
//     this.features,
//     this.slug,
//     this.categories,
//     this.colors,
//     this.shareLink,
//     this.thumbnail,
//     this.images,
//     this.price,
//     this.priceFormatted,
//     this.offerPrice,
//     this.offerPriceFormatted,
//     this.isFavourite,
//     this.inStock,
//     this.rating,
//     this.variation,
//     this.choiceOptions,
//     this.brand,
//     this.relatedProducts,
//     this.similarProducts,
//     this.hasDiscount,
//     this.hasTax,
//     this.tax,
//     this.unitPrice,
//     this.currentStock,
//     this.reviewsCount,
//     this.sellerId,
//     this.seller,
//     this.shop,
//     this.isFavSeller,
//     this.reviews,
//   });
//
//   int? id;
//   String? name;
//   String ?details;
//   dynamic description;
//   dynamic model;
//   dynamic features;
//   String ?slug;
//   List<Category>? categories;
//   List<Color> ?colors;
//   String ?shareLink;
//   String? thumbnail;
//   List<String>? images;
//   double? price;
//   String? priceFormatted;
//   double? offerPrice;
//   String? offerPriceFormatted;
//   bool ?isFavourite;
//   bool ?inStock;
//   Rating? rating;
//   List<Variation>? variation;
//   List<ChoiceOption>? choiceOptions;
//   Brand? brand;
//   List<Product>? relatedProducts;
//   List<Product>? similarProducts;
//   bool ?hasDiscount;
//   bool? hasTax;
//   String ?tax;
//   String ?unitPrice;
//   int? currentStock;
//   int ?reviewsCount;
//   String? sellerId;
//   Seller? seller;
//   Shop? shop;
//   bool? isFavSeller;
//   List<dynamic>? reviews;
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     id: json["id"],
//     name: json["name"],
//     details: json["details"],
//     description: json["description"],
//     model: json["model"],
//     features: json["features"],
//     slug: json["slug"],
//     categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
//     colors:json["colors"]==null?null: List<Color>.from(json["colors"].map((x) => x)),
//     shareLink: json["share_link"],
//     thumbnail: json["thumbnail"],
//     images: List<String>.from(json["images"].map((x) => x)),
//     price: json["price"].toDouble(),
//     priceFormatted: json["price_formatted"],
//     offerPrice: json["offer_price"].toDouble(),
//     offerPriceFormatted: json["offer_price_formatted"],
//     isFavourite: json["is_favourite"],
//     inStock: json["in_stock"],
//     rating: Rating.fromJson(json["rating"]),
//     variation: List<Variation>.from(json["variation"].map((x) => Variation.fromJson(x))),
//     choiceOptions: List<ChoiceOption>.from(json["choice_options"].map((x) => ChoiceOption.fromJson(x))),
//     brand: Brand.fromJson(json["brand"]),
//     relatedProducts: List<Product>.from(json["related_products"].map((x) => Product.fromJson(x))),
//     similarProducts: List<Product>.from(json["similar_products"].map((x) => Product.fromJson(x))),
//     hasDiscount: json["has_discount"],
//     hasTax: json["has_tax"],
//     tax: json["tax"],
//     unitPrice: json["unit_price"],
//     currentStock: json["current_stock"],
//     reviewsCount: json["reviews_count"],
//     sellerId: json["seller_id"].toString(),
//     seller:json["seller"]==null?null: Seller.fromJson(json["seller"]),
//     shop:json["shop"]==null?null: Shop.fromJson(json["shop"]),
//     isFavSeller: json["is_fav_seller"],
//     reviews: List<dynamic>.from(json["reviews"].map((x) => x)),
//   );
//
//   // Map<String, dynamic> toJson() => {
//   //   "id": id,
//   //   "name": name,
//   //   "details": details,
//   //   "description": description,
//   //   "model": model,
//   //   "features": features,
//   //   "slug": slug,
//   //   "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
//   //   "colors": List<dynamic>.from(colors.map((x) => x)),
//   //   "share_link": shareLink,
//   //   "thumbnail": thumbnail,
//   //   "images": List<dynamic>.from(images.map((x) => x)),
//   //   "price": price,
//   //   "price_formatted": priceFormatted,
//   //   "offer_price": offerPrice,
//   //   "offer_price_formatted": offerPriceFormatted,
//   //   "is_favourite": isFavourite,
//   //   "in_stock": inStock,
//   //   "rating": rating.toJson(),
//   //   "variation": List<dynamic>.from(variation.map((x) => x.toJson())),
//   //   "choice_options": List<dynamic>.from(choiceOptions.map((x) => x.toJson())),
//   //   "brand": brand.toJson(),
//   //   "related_products": List<dynamic>.from(relatedProducts.map((x) => x.toJson())),
//   //   "similar_products": List<dynamic>.from(similarProducts.map((x) => x.toJson())),
//   //   "has_discount": hasDiscount,
//   //   "has_tax": hasTax,
//   //   "tax": tax,
//   //   "unit_price": unitPrice,
//   //   "current_stock": currentStock,
//   //   "reviews_count": reviewsCount,
//   //   "seller_id": sellerId,
//   //   "seller": seller,
//   //   "is_fav_seller": isFavSeller,
//   //   "reviews": List<dynamic>.from(reviews.map((x) => x)),
//   // };
// }
// class Seller {
//   Seller({
//     this.name,
//     this.fName,
//     this.lName,
//     this.email,
//     this.review,
//     this.image,
//   });
//
//   String? name;
//   String? fName;
//   String? lName;
//   String? email;
//   double? review;
//   String? image;
//
//   factory Seller.fromJson(Map<String, dynamic> json) => Seller(
//     name: json["name"],
//     fName: json["f_name"],
//     lName: json["l_name"],
//     email: json["email"],
//     review: double.parse(json["review"].toString()),
//     image: json["image"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "f_name": fName,
//     "l_name": lName,
//     "email": email,
//     "review": review,
//     "image": image,
//   };
// }
//
// class Shop {
//   Shop({
//     this.name,
//     this.image,
//   });
//
//   String? name;
//
//   String? image;
//
//   factory Shop.fromJson(Map<String, dynamic> json) => Shop(
//     name: json["name"],
//     image: json["image"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "image": image,
//   };
// }
// class Brand {
//   Brand({
//     this.id,
//     this.name,
//     this.image,
//   });
//
//   int? id;
//   String? name;
//   String? image;
//
//   factory Brand.fromJson(Map<String, dynamic> json) => Brand(
//     id: json["id"],
//     name: json["name"].toString(),
//     image: json["image"].toString(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "image": image,
//   };
// }
//
// class Category {
//   Category({
//     this.id,
//     this.name,
//   });
//
//   int ?id;
//   String? name;
//
//   factory Category.fromJson(Map<String, dynamic> json) => Category(
//     id: json["id"],
//     name: json["name"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//   };
// }
//
// class ChoiceOption {
//   ChoiceOption({
//     this.name,
//     this.title,
//     this.options,
//   });
//
//   String? name;
//   String? title;
//   List<String>? options;
//
//   factory ChoiceOption.fromJson(Map<String, dynamic> json) => ChoiceOption(
//     name: json["name"].toString(),
//     title: json["title"].toString(),
//     options: List<String>.from(json["options"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "title": title,
//     "options": List<dynamic>.from(options!.map((x) => x)),
//   };
// }
//
// class Rating {
//   Rating({
//     this.overallRating,
//     this.totalRating,
//   });
//
//   String? overallRating;
//   String? totalRating;
//
//   factory Rating.fromJson(Map<String, dynamic> json) => Rating(
//     overallRating: json["overall_rating"].toString(),
//     totalRating: json["total_rating"].toString(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "overall_rating": overallRating,
//     "total_rating": totalRating,
//   };
// }
//
//
//
//
//
// class Variation {
//   Variation({
//     this.type,
//     this.price,
//     this.priceFormated,
//     this.offerPrice,
//     this.offerPriceFormated,
//     this.sku,
//     this.qty,
//   });
//
//   String? type;
//   double? price;
//   String? priceFormated;
//   double? offerPrice;
//   String? offerPriceFormated;
//   String? sku;
//   int? qty;
//
//   factory Variation.fromJson(Map<String, dynamic> json) => Variation(
//     type: json["type"],
//     price: json["price"].toDouble(),
//     priceFormated: json["price_formated"],
//     offerPrice: json["offer_price"].toDouble(),
//     offerPriceFormated: json["offer_price_formated"],
//     sku: json["sku"].toString(),
//     qty: json["qty"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "type": type,
//     "price": price,
//     "price_formated": priceFormated,
//     "offer_price": offerPrice,
//     "offer_price_formated": offerPriceFormated,
//     "sku": sku,
//     "qty": qty,
//   };
// }
//
// class EnumValues<T> {
//   Map<String, T>? map;
//   Map<T, String>? reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map!.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap!;
//   }
// }

// To parse this JSON data, do
//
//     final productDetailsModel = productDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'home_Section_model.dart';

ProductDetailsModel productDetailsModelFromJson(String str) => ProductDetailsModel.fromJson(json.decode(str));

String productDetailsModelToJson(ProductDetailsModel data) => json.encode(data.toJson());

class ProductDetailsModel {
  ProductDetailsModel({
    this.message,
    this.data,
  });

  String? message;
  Data? data;

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) => ProductDetailsModel(
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
    this.details,
    this.description,
    this.model,
    this.features,
    this.slug,
    this.categories,
    this.colors,
    this.shareLink,
    this.thumbnail,
    this.images,
    this.price,
    this.priceFormatted,
    this.offerPrice,
    this.offerPriceFormatted,
    this.isFavourite,
    this.inStock,
    this.rating,
    this.variation,
    this.choiceOptions,
    this.brand,
    this.relatedProducts,
    this.similarProducts,
    this.hasDiscount,
    this.hasTax,
    this.tax,
    this.unitPrice,
    this.currentStock,
    this.reviewsCount,
    this.sellerId,
    this.seller,
    this.shop,
    this.isFavSeller,
    this.reviews,
    this.flashDealDetails,
    this.flashDealMaxAllowedQuantity,
  });

  int? id;
  String ?name;
  String ?details;
  dynamic description;
  dynamic model;
  dynamic features;
  String ?slug;
  List<Category>? categories;
  dynamic colors;
  String? shareLink;
  String? thumbnail;
  List<String>? images;
  double? price;
  String? priceFormatted;
  double? offerPrice;
  String? offerPriceFormatted;
  bool? isFavourite;
  bool? inStock;
  Rating? rating;
  List<Variation>? variation;
  List<ChoiceOption>? choiceOptions;
  Brand ?brand;
  List<Product>? relatedProducts;
  List<Product>? similarProducts;
  bool? hasDiscount;
  bool? hasTax;
  String ?tax;
  String ?unitPrice;
  int? currentStock;
  int? reviewsCount;
  int? sellerId;
  Seller? seller;
  Shop? shop;
  bool? isFavSeller;
  List<dynamic>? reviews;
  FlashDealDetails? flashDealDetails;
  int? flashDealMaxAllowedQuantity;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    details: json["details"],
    description: json["description"],
    model: json["model"],
    features: json["features"],
    slug: json["slug"],
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    colors: null, //json["colors"],
    shareLink: json["share_link"],
    thumbnail: json["thumbnail"],
    images: List<String>.from(json["images"].map((x) => x)),
    price: json["price"].toDouble(),
    priceFormatted: json["price_formatted"],
    offerPrice: json["offer_price"].toDouble(),
    offerPriceFormatted: json["offer_price_formatted"],
    isFavourite: json["is_favourite"],
    inStock: json["in_stock"],
    rating: Rating.fromJson(json["rating"]),
    variation: List<Variation>.from(json["variation"].map((x) => Variation.fromJson(x))),
    choiceOptions: List<ChoiceOption>.from(json["choice_options"].map((x) => ChoiceOption.fromJson(x))),
    brand: Brand.fromJson(json["brand"]),
    relatedProducts: List<Product>.from(json["related_products"].map((x) => Product.fromJson(x))),
    similarProducts: List<Product>.from(json["similar_products"].map((x) => Product.fromJson(x))),
    hasDiscount: json["has_discount"],
    hasTax: json["has_tax"],
    tax: json["tax"],
    unitPrice: json["unit_price"],
    currentStock: json["current_stock"],
    reviewsCount: json["reviews_count"],
    sellerId: json["seller_id"],
    seller: json["seller"]==null ? null :Seller.fromJson(json["seller"]),
    shop: Shop.fromJson(json["shop"]),
    isFavSeller: json["is_fav_seller"],
    reviews: List<dynamic>.from(json["reviews"].map((x) => x)),
    flashDealDetails: json["flash_deal_details"] == null ? null : FlashDealDetails.fromJson(json["flash_deal_details"]),
    flashDealMaxAllowedQuantity: json["flash_deal_max_allowed_quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "details": details,
    "description": description,
    "model": model,
    "features": features,
    "slug": slug,
    "categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
    "colors": colors,
    "share_link": shareLink,
    "thumbnail": thumbnail,
    "images": List<dynamic>.from(images!.map((x) => x)),
    "price": price,
    "price_formatted": priceFormatted,
    "offer_price": offerPrice,
    "offer_price_formatted": offerPriceFormatted,
    "is_favourite": isFavourite,
    "in_stock": inStock,
    "rating": rating!.toJson(),
    "variation": List<dynamic>.from(variation!.map((x) => x.toJson())),
    "choice_options": List<dynamic>.from(choiceOptions!.map((x) => x.toJson())),
    "brand": brand!.toJson(),
    "related_products": List<dynamic>.from(relatedProducts!.map((x) => x.toJson())),
    "similar_products": List<dynamic>.from(similarProducts!.map((x) => x.toJson())),
    "has_discount": hasDiscount,
    "has_tax": hasTax,
    "tax": tax,
    "unit_price": unitPrice,
    "current_stock": currentStock,
    "reviews_count": reviewsCount,
    "seller_id": sellerId,
    "seller": seller!.toJson(),
    "shop": shop!.toJson(),
    "is_fav_seller": isFavSeller,
    "reviews": List<dynamic>.from(reviews!.map((x) => x)),
    "flash_deal_details": flashDealDetails == null ? null : flashDealDetails!.toJson(),
    "flash_deal_max_allowed_quantity": flashDealMaxAllowedQuantity,
  };
}

class Brand {
  Brand({
    this.id,
    this.name,
    this.image,
  });

  int? id;
  String? name;
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

class Category {
  Category({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class ChoiceOption {
  ChoiceOption({
    this.name,
    this.title,
    this.options,
  });

  String? name;
  String ?title;
  List<String>? options;

  factory ChoiceOption.fromJson(Map<String, dynamic> json) => ChoiceOption(
    name: json["name"],
    title: json["title"],
    options: List<String>.from(json["options"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "title": title,
    "options": List<dynamic>.from(options!.map((x) => x)),
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
//   int price;
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
//     details: json["details"],
//     thumbnail: json["thumbnail"],
//     images: List<String>.from(json["images"].map((x) => x)),
//     price: json["price"],
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
//     "details": details,
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

class Seller {
  Seller({
    this.name,
    this.fName,
    this.lName,
    this.email,
    this.gender,
    this.birthdate,
    this.review,
    this.image,
  });

  String? name;
  String? fName;
  String? lName;
  String? email;
  dynamic gender;
  String?birthdate;
  int ?review;
  String? image;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    name: json["name"],
    fName: json["f_name"],
    lName: json["l_name"],
    email: json["email"],
    gender: json["gender"],
    birthdate: json["birthdate"],
    review: json["review"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "f_name": fName,
    "l_name": lName,
    "email": email,
    "gender": gender,
    "birthdate": birthdate,
    "review": review,
    "image": image,
  };
}

class Shop {
  Shop({
    this.image,
    this.name,
  });

  String? image;
  String ?name;

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
    image: json["image"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "name": name,
  };
}

class Variation {
  Variation({
    this.type,
    this.price,
    this.priceFormated,
    this.offerPrice,
    this.offerPriceFormated,
    this.sku,
    this.qty,
    this.sealedQuantity,
  });

  String? type;
  double? price;
  String ?priceFormated;
  double? offerPrice;
  String? offerPriceFormated;
  String ?sku;
  int ?qty;
  int ?sealedQuantity;

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
    type: json["type"],
    price: json["price"].toDouble(),
    priceFormated: json["price_formated"],
    offerPrice: json["offer_price"].toDouble(),
    offerPriceFormated: json["offer_price_formated"],
    sku: json["sku"],
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "price": price,
    "price_formated": priceFormated,
    "offer_price": offerPrice,
    "offer_price_formated": offerPriceFormated,
    "sku": sku,
    "qty": qty,
  };
}
