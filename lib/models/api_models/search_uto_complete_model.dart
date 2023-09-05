// To parse this JSON data, do
//
//     final searchAutoCompleteModel = searchAutoCompleteModelFromJson(jsonString);

import 'dart:convert';

SearchAutoCompleteModel searchAutoCompleteModelFromJson(String str) => SearchAutoCompleteModel.fromJson(json.decode(str));

String searchAutoCompleteModelToJson(SearchAutoCompleteModel data) => json.encode(data.toJson());

class SearchAutoCompleteModel {
  SearchAutoCompleteModel({
    this.message,
    this.data,
  });

  String? message;
  List<SearchAutoCompleteItem>? data;

  factory SearchAutoCompleteModel.fromJson(Map<String, dynamic> json) => SearchAutoCompleteModel(
    message: json["message"],
    data: List<SearchAutoCompleteItem>.from(json["data"].map((x) => SearchAutoCompleteItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SearchAutoCompleteItem {
  SearchAutoCompleteItem({
    this.id,
    this.name,
    this.slug,
    this.category,
    this.result,
  });

  int? id;
  String? name;
  String? slug;
  String? category;
  String? result;

  factory SearchAutoCompleteItem.fromJson(Map<String, dynamic> json) => SearchAutoCompleteItem(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    category: json["category"],
    result: json["result"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "category": category,
    "result": result,
  };
}
