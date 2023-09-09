// // To parse this JSON data, do
// //
// //     final productsFilteredByCateModel = productsFilteredByCateModelFromJson(jsonString);
//
// import 'dart:convert';
//
// ProductsFilteredByCateModel productsFilteredByCateModelFromJson(String str) => ProductsFilteredByCateModel.fromJson(json.decode(str));
//
// String productsFilteredByCateModelToJson(ProductsFilteredByCateModel data) => json.encode(data.toJson());
//
// class ProductsFilteredByCateModel {
//   ProductsFilteredByCateModel({
//     this.message,
//     this.data,
//   });
//
//   String message;
//   List<Datum> data;
//
//   factory ProductsFilteredByCateModel.fromJson(Map<String, dynamic> json) => ProductsFilteredByCateModel(
//     message: json["message"],
//     data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "message": message,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//   };
// }
//
// class Datum {
//   Datum({
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
//   int offerPrice;
//   String offerPriceFormatted;
//   bool isFavourite;
//   bool inStock;
//   Rating rating;
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     id: json["id"],
//     name: json["name"],
//     slug: json["slug"],
//     shareLink: json["share_link"],
//     details: json["details"],
//     thumbnail: json["thumbnail"],
//     images: List<String>.from(json["images"].map((x) => x)),
//     price: json["price"],
//     priceFormatted: json["price_formatted"],
//     offerPrice: json["offer_price"],
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
//
// class Rating {
//   Rating({
//     this.overallRating,
//     this.totalRating,
//   });
//
//   dynamic overallRating;
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
