// To parse this JSON data, do
//
//     final configModel = configModelFromJson(jsonString);

import 'dart:convert';

ConfigModel configModelFromJson(String str) => ConfigModel.fromJson(json.decode(str));

String configModelToJson(ConfigModel data) => json.encode(data.toJson());

class ConfigModel {
  ConfigModel({
    this.message,
    this.data,
  });

  String ?message;
  Data ?data;

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    // "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.systemDefaultCurrency,
    this.digitalPayment,
    this.cashOnDelivery,
    this.baseUrls,
    this.staticUrls,
    this.aboutUs,
    this.privacyPolicy,
    this.faq,
    this.termsConditions,
    this.currencyList,
    this.currencySymbolPosition,
    this.businessMode,
    this.maintenanceMode,
    this.language,
    this.colors,
    this.unit,
    this.shippingMethod,
    this.emailVerification,
    this.phoneVerification,
    this.countryCode,
    this.countries,
    this.socialLogin,
    this.currencyModel,
    this.forgotPasswordVerification,
    this.announcement,
    this.pixelAnalytics,
    this.softwareVersion,
    this.decimalPointSettings,
    this.inhouseSelectedShippingType,
    this.billingInputByCustomer,
  });

  int? systemDefaultCurrency;
  bool? digitalPayment;
  bool? cashOnDelivery;
  BaseUrls? baseUrls;
  StaticUrls? staticUrls;
  String ?aboutUs;
  String ?privacyPolicy;
  List<Faq> ?faq;
  List<Country>? countries;
  String ?termsConditions;
  List<CurrencyList>? currencyList;
  String ?currencySymbolPosition;
  String ?businessMode;
  bool? maintenanceMode;
  List<Language> ?language;
  List<Color>? colors;
  List<String>? unit;
  String? shippingMethod;
  bool? emailVerification;
  bool? phoneVerification;
  String ?countryCode;
  List<SocialLogin>? socialLogin;
  String? currencyModel;
  String? forgotPasswordVerification;
  Announcement ?announcement;
  dynamic pixelAnalytics;
  dynamic softwareVersion;
  int? decimalPointSettings;
  String? inhouseSelectedShippingType;
  int? billingInputByCustomer;
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    systemDefaultCurrency: json["system_default_currency"],
    digitalPayment: json["digital_payment"],
    cashOnDelivery: json["cash_on_delivery"],
    baseUrls: BaseUrls.fromJson(json["base_urls"]),
    staticUrls: StaticUrls.fromJson(json["static_urls"]),
    aboutUs: json["about_us"],
    privacyPolicy: json["privacy_policy"],
    faq: List<Faq>.from(json["faq"].map((x) => Faq.fromJson(x))),
    countries: List<Country>.from(json["countries"].map((x) => Country.fromJson(x))),
    termsConditions: json["terms_&_conditions"],
    currencyList: List<CurrencyList>.from(json["currency_list"].map((x) => CurrencyList.fromJson(x))),
    currencySymbolPosition: json["currency_symbol_position"],
    businessMode: json["business_mode"],
    maintenanceMode: json["maintenance_mode"],
    language: List<Language>.from(json["language"].map((x) => Language.fromJson(x))),
    colors: List<Color>.from(json["colors"].map((x) => Color.fromJson(x))),
    unit: List<String>.from(json["unit"].map((x) => x)),
    shippingMethod: json["shipping_method"],
    emailVerification: json["email_verification"],
    phoneVerification: json["phone_verification"],
    countryCode: json["country_code"],
    socialLogin: List<SocialLogin>.from(json["social_login"].map((x) => SocialLogin.fromJson(x))),
    currencyModel: json["currency_model"],
    forgotPasswordVerification: json["forgot_password_verification"],
    announcement: Announcement.fromJson(json["announcement"]),
    pixelAnalytics: json["pixel_analytics"],
    softwareVersion: json["software_version"],
    decimalPointSettings: json["decimal_point_settings"],
    inhouseSelectedShippingType: json["inhouse_selected_shipping_type"],
    billingInputByCustomer: json["billing_input_by_customer"],
  );

  // Map<String, dynamic> toJson() => {
  //   "system_default_currency": systemDefaultCurrency,
  //   "digital_payment": digitalPayment,
  //   "cash_on_delivery": cashOnDelivery,
  //   "base_urls": baseUrls.toJson(),
  //   "static_urls": staticUrls.toJson(),
  //   "about_us": aboutUs,
  //   "privacy_policy": privacyPolicy,
  //   "faq": List<dynamic>.from(faq.map((x) => x.toJson())),
  //   "terms_&_conditions": termsConditions,
  //   "currency_list": List<dynamic>.from(currencyList.map((x) => x.toJson())),
  //   "currency_symbol_position": currencySymbolPosition,
  //   "business_mode": businessMode,
  //   "maintenance_mode": maintenanceMode,
  //   "language": List<dynamic>.from(language.map((x) => x.toJson())),
  //   "colors": List<dynamic>.from(colors.map((x) => x.toJson())),
  //   "unit": List<dynamic>.from(unit.map((x) => x)),
  //   "shipping_method": shippingMethod,
  //   "email_verification": emailVerification,
  //   "phone_verification": phoneVerification,
  //   "country_code": countryCode,
  //   "social_login": List<dynamic>.from(socialLogin.map((x) => x.toJson())),
  //   "currency_model": currencyModel,
  //   "forgot_password_verification": forgotPasswordVerification,
  //   "announcement": announcement.toJson(),
  //   "pixel_analytics": pixelAnalytics,
  //   "software_version": softwareVersion,
  //   "decimal_point_settings": decimalPointSettings,
  //   "inhouse_selected_shipping_type": inhouseSelectedShippingType,
  //   "billing_input_by_customer": billingInputByCustomer,
  // };
}
class Country {
  Country({
    this.id,
    this.iso,
    this.name,
    this.nicename,
    this.iso3,
    this.numcode,
    this.phonecode,
    this.status,
  });

  int? id;
  String? iso;
  String? name;
  String? nicename;
  String? iso3;
  int? numcode;
  int? phonecode;
  int? status;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    iso: json["iso"],
    name: json["name"],
    nicename: json["nicename"],
    iso3: json["iso3"],
    numcode: json["numcode"],
    phonecode: json["phonecode"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "iso": iso,
    "name": name,
    "nicename": nicename,
    "iso3": iso3,
    "numcode": numcode,
    "phonecode": phonecode,
    "status": status,
  };
}
class Announcement {
  Announcement({
    this.status,
    this.color,
    this.textColor,
    this.announcement,
  });

  String? status;
  String? color;
  String? textColor;
  dynamic announcement;

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
    status: json["status"],
    color: json["color"],
    textColor: json["text_color"],
    announcement: json["announcement"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "color": color,
    "text_color": textColor,
    "announcement": announcement,
  };
}

class BaseUrls {
  BaseUrls({
    this.productImageUrl,
    this.productThumbnailUrl,
    this.brandImageUrl,
    this.customerImageUrl,
    this.bannerImageUrl,
    this.categoryImageUrl,
    this.reviewImageUrl,
    this.sellerImageUrl,
    this.shopImageUrl,
    this.notificationImageUrl,
  });

  String? productImageUrl;
  String? productThumbnailUrl;
  String? brandImageUrl;
  String? customerImageUrl;
  String? bannerImageUrl;
  String? categoryImageUrl;
  String? reviewImageUrl;
  String? sellerImageUrl;
  String? shopImageUrl;
  String? notificationImageUrl;

  factory BaseUrls.fromJson(Map<String, dynamic> json) => BaseUrls(
    productImageUrl: json["product_image_url"],
    productThumbnailUrl: json["product_thumbnail_url"],
    brandImageUrl: json["brand_image_url"],
    customerImageUrl: json["customer_image_url"],
    bannerImageUrl: json["banner_image_url"],
    categoryImageUrl: json["category_image_url"],
    reviewImageUrl: json["review_image_url"],
    sellerImageUrl: json["seller_image_url"],
    shopImageUrl: json["shop_image_url"],
    notificationImageUrl: json["notification_image_url"],
  );

  Map<String, dynamic> toJson() => {
    "product_image_url": productImageUrl,
    "product_thumbnail_url": productThumbnailUrl,
    "brand_image_url": brandImageUrl,
    "customer_image_url": customerImageUrl,
    "banner_image_url": bannerImageUrl,
    "category_image_url": categoryImageUrl,
    "review_image_url": reviewImageUrl,
    "seller_image_url": sellerImageUrl,
    "shop_image_url": shopImageUrl,
    "notification_image_url": notificationImageUrl,
  };
}

class Color {
  Color({
    this.id,
    this.name,
    this.code,
    this.createdAt,
    this.updatedAt,
  });

  int ?id;
  String? name;
  String? code;
  DateTime ?createdAt;
  DateTime? updatedAt;

  factory Color.fromJson(Map<String, dynamic> json) => Color(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}

class CurrencyList {
  CurrencyList({
    this.id,
    this.name,
    this.symbol,
    this.code,
    this.exchangeRate,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? symbol;
  String? code;
  double? exchangeRate;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CurrencyList.fromJson(Map<String, dynamic> json) => CurrencyList(
    id: json["id"],
    name: json["name"],
    symbol: json["symbol"],
    code: json["code"],
    exchangeRate: json["exchange_rate"].toDouble(),
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "symbol": symbol,
    "code": code,
    "exchange_rate": exchangeRate,
    "status": status,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}

class Faq {
  Faq({
    this.id,
    this.question,
    this.answer,
    this.ranking,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? question;
  String? answer;
  int? ranking;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
    ranking: json["ranking"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "ranking": ranking,
    "status": status,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}

class Language {
  Language({
    this.code,
    this.name,
  });

  String? code;
  String? name;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    code: json["code"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
  };
}

class SocialLogin {
  SocialLogin({
    this.loginMedium,
    this.status,
  });

  String? loginMedium;
  bool? status;

  factory SocialLogin.fromJson(Map<String, dynamic> json) => SocialLogin(
    loginMedium: json["login_medium"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "login_medium": loginMedium,
    "status": status,
  };
}

class StaticUrls {
  StaticUrls({
    this.contactUs,
    this.brands,
    this.categories,
    this.customerAccount,
  });

  String ?contactUs;
  String? brands;
  String? categories;
  String? customerAccount;

  factory StaticUrls.fromJson(Map<String, dynamic> json) => StaticUrls(
    contactUs: json["contact_us"],
    brands: json["brands"],
    categories: json["categories"],
    customerAccount: json["customer_account"],
  );

  Map<String, dynamic> toJson() => {
    "contact_us": contactUs,
    "brands": brands,
    "categories": categories,
    "customer_account": customerAccount,
  };
}
