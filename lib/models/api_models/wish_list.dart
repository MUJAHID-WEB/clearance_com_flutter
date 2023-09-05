import 'package:clearance/models/api_models/home_Section_model.dart';

class WishList {
  String? message;
  List<Product>? data;

  WishList({this.message, this.data});

  WishList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Product>[];
      json['data'].forEach((v) {
        data!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      // data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
