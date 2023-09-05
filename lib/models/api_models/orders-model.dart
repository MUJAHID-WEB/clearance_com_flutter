// To parse this JSON data, do
//
//     final ordersModel = ordersModelFromJson(jsonString);

import 'dart:convert';

import 'package:clearance/models/api_models/home_Section_model.dart';

OrdersModel ordersModelFromJson(String str) => OrdersModel.fromJson(json.decode(str));

// String ordersModelToJson(OrdersModel data) => json.encode(data.toJson());

class OrdersModel {
  OrdersModel({
    this.message,
    this.data,
  });

  String? message;
  List<OrderItemModel>? data;

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
    message: json["message"],
    data: List<OrderItemModel>.from(json["data"].map((x) => OrderItemModel.fromJson(x))),
  );

  // Map<String, dynamic> toJson() => {
  //   "message": message,
  //   "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  // };
}

class OrderItemModel {
  OrderItemModel({
    this.id,
    this.customerId,
    this.paymentStatus,
    this.orderStatus,
    this.paymentMethod,
    this.transactionRef,
    this.orderAmount,
    this.shippingAddress,
    this.shippingAddressData,
    this.billingAddress,
    this.billingAddressData,
    this.discountAmount,
    this.discountType,
    this.couponCode,
    this.shippingMethodId,
    this.shippingCost,
    this.orderGroupId,
    this.verificationCode,
    this.orderNote,
    this.sellerId,
    this.createdAt,
    this.details,
  });

  int ?id;
  int? customerId;
  String ?paymentStatus;
  String? orderStatus;
  String? paymentMethod;
  String? transactionRef;
  double ?orderAmount;
  int? shippingAddress;
  ShippingAddressData ?shippingAddressData;
  int? billingAddress;
  dynamic billingAddressData;
  double? discountAmount;
  dynamic discountType;
  dynamic couponCode;
  int ?shippingMethodId;
  double ?shippingCost;
  String? orderGroupId;
  String ?verificationCode;
  dynamic orderNote;
  String? sellerId;
  DateTime? createdAt;
  List<OrderDetail>? details;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
    id: json["id"],
    customerId: json["customer_id"],
    paymentStatus: json["payment_status"],
    orderStatus: json["order_status"],
    paymentMethod: json["payment_method"],
    transactionRef: json["transaction_ref"],
    orderAmount: json["order_amount"].toDouble(),
    shippingAddress: json["shipping_address"],
    shippingAddressData: json["shipping_address_data"]==null?null:ShippingAddressData.fromJson(json["shipping_address_data"]),
    billingAddress: json["billing_address"],
    billingAddressData: json["billing_address_data"],
    discountAmount:double.parse(json["discount_amount"].toString()) ,
    discountType: json["discount_type"],
    couponCode: json["coupon_code"],
    shippingMethodId: json["shipping_method_id"],
    shippingCost: json["shipping_cost"].toDouble(),
    orderGroupId: json["order_group_id"],
    verificationCode: json["verification_code"],
    orderNote: json["order_note"],
    sellerId: json["seller_id"],
    createdAt: DateTime.parse(json["created_at"]),
    details: List<OrderDetail>.from(json["details"].map((x) => OrderDetail.fromJson(x))),
  );

}

class OrderDetail {
  OrderDetail({
    this.id,
    this.orderId,
    this.productId,
    this.productDetails,
    this.qty,
    this.price,
    this.tax,
    this.discount,
    this.deliveryStatus,
    this.paymentStatus,
    this.shippingMethodId,
    this.variant,
    this.discountType,
    this.isStockDecreased,
  });

  int? id;
  int? orderId;
  int? productId;
  Product? productDetails;
  int? qty;
  String? price;
  double? tax;
  double? discount;
  String? deliveryStatus;
  String? paymentStatus;
  dynamic shippingMethodId;
  String? variant;
  String? discountType;
  int? isStockDecreased;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    id: json["id"],
    orderId: json["order_id"],
    productId: json["product_id"],
    productDetails:Product.fromJson(json["product_details"]),
    qty: json["qty"],
    price: json["price"],
    tax: double.parse(json["tax"].toString()),
    discount: json["discount"].toDouble(),
    deliveryStatus:json["delivery_status"],
    paymentStatus: json["payment_status"],
    shippingMethodId: json["shipping_method_id"],
    variant: json["variant"],
    discountType: json["discount_type"],
    isStockDecreased: json["is_stock_decreased"],
  );


}







class ShippingAddressData {
  ShippingAddressData({
    this.id,
    this.customerId,
    this.contactPersonName,
    this.addressType,
    this.address,
    this.city,
    this.zip,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    this.isBilling,
  });

  int? id;
  int? customerId;
  String? contactPersonName;
  String? addressType;
  String? address;
  String? city;
  String? zip;
  String ?phone;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic state;
  dynamic country;
  dynamic latitude;
  dynamic longitude;
  int? isBilling;

  factory ShippingAddressData.fromJson(Map<String, dynamic> json) => ShippingAddressData(
    id: json["id"],
    customerId: json["customer_id"],
    contactPersonName: json["contact_person_name"],
    addressType: json["address_type"],
    address: json["address"],
    city: json["city"],
    zip: json["zip"],
    phone: json["phone"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    state: json["state"],
    country: json["country"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    isBilling: json["is_billing"],
  );


}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String> ?reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
