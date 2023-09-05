// To parse this JSON data, do
//
//     final bannersModel = bannersModelFromJson(jsonString);

import 'dart:convert';

BannersModel bannersModelFromJson(String str) => BannersModel.fromJson(json.decode(str));

String bannersModelToJson(BannersModel data) => json.encode(data.toJson());

class BannersModel {
  BannersModel({
    this.message,
    this.data,
  });

  String? message;
  List<BannerItem> ?data;

  factory BannersModel.fromJson(Map<String, dynamic> json) => BannersModel(
    message: json["message"],
    data: List<BannerItem>.from(json["data"].map((x) => BannerItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class BannerItem {
  BannerItem({
    this.title,
    this.photo,
    this.bannerType,
    this.url,
    this.resourceType,
    this.resourceId,
  });

  dynamic title;
  String? photo;
  String? bannerType;
  String? url;
  String? resourceType;
  int? resourceId;

  factory BannerItem.fromJson(Map<String, dynamic> json) => BannerItem(
    title: json["title"],
    photo: json["photo"],
    bannerType: json["banner_type"],
    url: json["url"],
    resourceType: json["resource_type"],
    resourceId: json["resource_id"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "photo": photo,
    "banner_type": bannerType,
    "url": url,
    "resource_type": resourceType,
    "resource_id": resourceId,
  };
}
