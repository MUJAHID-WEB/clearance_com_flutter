import 'package:flutter/cupertino.dart';

class ShortAddress {
  ShortAddress({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  int id;
  String name;
  String phone;
  String address;
}

class PaymentMethod {
  PaymentMethod({
    required this.id,
    required this.title,
    required this.subTitle,

  });

  int id;
  String title;
  Widget? subTitle;

}
class DeliveryMethodModel {
  DeliveryMethodModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.isSelected,

  });

  int id;
  String title;
  String? subTitle;
  bool isSelected;

}

class PublicFeature {
  PublicFeature({
    required this.id,
    required this.image,
    required this.title,
     this.fixTitle,
    required this.subTitle,
     this.sellerEvaluate,
  });

  int id;
  String image;
  String title;
  String? fixTitle;
  String subTitle;
  double? sellerEvaluate;
}

class OrdersListModel {
  OrdersListModel({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.color,
    required this.quantity,
    required this.price,
  });

  int id;
  String title;
  String imagePath;
  String color;
  String quantity;
  String price;
}

class FavouriteLocalModel {
  FavouriteLocalModel({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.color,
    required this.price,
  });

  int id;
  String title;
  String imagePath;
  String color;

  String price;
}

class CoupounsLocalModel {
  CoupounsLocalModel({
    required this.id,
    required this.title,
    required this.discountType,
    required this.endDate,
    required this.details,
    required this.status,
  });

  int id;
  String title;
  String discountType;
  String endDate;

  String details;
  String status;
}

class HomeCategoriesFilterModel {
  HomeCategoriesFilterModel({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  int id;
  String title;
  String imageUrl;
}

class CategoriesModel {
  CategoriesModel({
    required this.id,
    required this.name,
  });

  int id;
  String name;
}

class HomeBannersModel {
  HomeBannersModel({
    required this.id,
    required this.imageUrl,
  });

  int id;

  String imageUrl;
}

class HomeGroupModel {
  HomeGroupModel({
    required this.id,
    required this.groupType,
    required this.title,
    required this.titleIcon,
    required this.products,
  });

  int id;
  String groupType;
  String title;
  String titleIcon;
  List<ProductModel> products;
}

class ProductModel {
  ProductModel({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.endDate,
    required this.oldValue,
    required this.percentageDiscount,
    required this.newValue,
    required this.rate,
    required this.rateCount,
    required this.details,
    required this.status,
  });

  int id;
  String title;
  String imagePath;
  String endDate;
  String oldValue;
  String percentageDiscount;
  String newValue;
  String rate;
  String rateCount;

  String details;
  String status;
}

class SelectedChoice{
  final String choiceName;
  final int id;
  final String choiceVal;

  SelectedChoice({required this.choiceName,required this.choiceVal,required this.id});
}

