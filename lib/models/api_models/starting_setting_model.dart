

class StartingSettings {
  StartingSettings({
    required this.primaryColor,
    required this.mainBackgroundColor,
    required this.titleColor,
    required this.subCategoriesColor,
    required this.buyNowButtonColor,
    required this.priceColor,
    required this.shareButtonColor,
    required this.includingTaxColor,
    required this.giftBackColor,
    required this.categoryHeaderColor,
    required this.newSoftGreyColor,
    required this.mainGreyColor,
    required this.mainCatGreyColor,
    required this.newSoftGreyColorAux,
    required this.flashDealForeColor,
    required this.flashDealBackColor,
    required this.offersTheme,
    required this.squareCurvedLogoUrl,
    required this.squareLogoUrl,
    required this.rectangularCurvedLogoUrl,
    required this.androidMinVersion,
    required this.iosMinVersion,
    required this.showPaymentUsingCards,
    required this.showCashPayment,
    required this.showFlashDeals,
    required this.showNotifications,
    required this.showCollectionGrid,
    required this.showFeedBack,
    required this.showWhatsAppContact,
    required this.closedHour,
    required this.countOfRequestToSave,
  });

  String primaryColor;
  String mainBackgroundColor;
  String titleColor;
  String subCategoriesColor;
  String buyNowButtonColor;
  String priceColor;
  String shareButtonColor;
  String includingTaxColor;
  String giftBackColor;
  String categoryHeaderColor;
  String newSoftGreyColor;
  String mainGreyColor;
  String mainCatGreyColor;
  String newSoftGreyColorAux;
  String flashDealForeColor;
  String flashDealBackColor;
  OffersTheme offersTheme;
  String squareCurvedLogoUrl;
  String squareLogoUrl;
  String rectangularCurvedLogoUrl;
  int androidMinVersion;
  int iosMinVersion;
  bool showPaymentUsingCards;
  bool showCashPayment;
  bool showFlashDeals;
  bool showCollectionGrid;
  bool showFeedBack;
  bool showWhatsAppContact;
  bool showNotifications;
  int closedHour;
  int countOfRequestToSave;

  factory StartingSettings.fromJson(Map<String, dynamic> json) => StartingSettings(
    primaryColor:  json["primaryColor"],
    mainBackgroundColor: json["mainBackgroundColor"],
    titleColor:  json["titleColor"],
    subCategoriesColor:  json["subCategoriesColor"],
    buyNowButtonColor: json["buyNowButtonColor"],
    priceColor: json["priceColor"],
    countOfRequestToSave: json.containsKey("countOfRequestToSave") ? json["countOfRequestToSave"]: 60,
    shareButtonColor:  json["shareButtonColor"],
    includingTaxColor: json["includingTaxColor"],
    giftBackColor:  json["giftBackColor"],
    categoryHeaderColor: json["categoryHeaderColor"],
    newSoftGreyColor: json["newSoftGreyColor"],
    mainGreyColor:  json["mainGreyColor"],
    mainCatGreyColor:  json["mainCatGreyColor"],
    newSoftGreyColorAux:  json["newSoftGreyColorAux"],
    flashDealForeColor:  json["flash_deal_foreColor"],
    flashDealBackColor:  json["flash_deal_backColor"],
    offersTheme:  OffersTheme.fromJson(json["offersTheme"]),
    squareCurvedLogoUrl: json["square_curved_logo_url"],
    squareLogoUrl:  json["square_logo_url"],
    rectangularCurvedLogoUrl:  json["rectangular_curved_logo_url"],
    androidMinVersion:  json["android_min_version"],
    iosMinVersion:  json["ios_min_version"],
    showPaymentUsingCards : json.containsKey("show_payment_using_cards") ? json["show_payment_using_cards"] : true,
    showCashPayment : json.containsKey("show_Cash_payment") ? json["show_Cash_payment"] : true,
    showNotifications : json.containsKey("show_notifications") ? json["show_notifications"] : true,
    showFeedBack : json.containsKey("show_feedBack") ? json["show_feedBack"] : true,
    showWhatsAppContact : json.containsKey("show_contact_with_whatsapp") ? json["show_contact_with_whatsapp"] : true,
    showFlashDeals: json.containsKey("show_flash_deal") ? json["show_flash_deal"] : false,
    showCollectionGrid: json.containsKey("collection_grid") ? json["collection_grid"] : false,
    closedHour: json["closed_hour"],
  );

  Map<String, dynamic> toJson() => {
    "primaryColor":  primaryColor,
    "mainBackgroundColor":  mainBackgroundColor,
    "titleColor": titleColor,
    "subCategoriesColor":  subCategoriesColor,
    "buyNowButtonColor":  buyNowButtonColor,
    "priceColor":  priceColor,
    "countOfRequestToSave":  countOfRequestToSave,
    "shareButtonColor":  shareButtonColor,
    "includingTaxColor":  includingTaxColor,
    "giftBackColor":  giftBackColor,
    "categoryHeaderColor":  categoryHeaderColor,
    "newSoftGreyColor":  newSoftGreyColor,
    "mainGreyColor":  mainGreyColor,
    "mainCatGreyColor": mainCatGreyColor,
    "newSoftGreyColorAux":  newSoftGreyColorAux,
    "flash_deal_foreColor":  flashDealForeColor,
    "flash_deal_backColor":  flashDealBackColor,
    "offersTheme": offersTheme.toJson(),
    "square_curved_logo_url":  squareCurvedLogoUrl,
    "square_logo_url":  squareLogoUrl,
    "rectangular_curved_logo_url":  rectangularCurvedLogoUrl,
    "showPaymentUsingCards" : showPaymentUsingCards,
    "showCashPayment" : showCashPayment,
    "show_flash_deal" : showFlashDeals,
    "show_feedBack" : showFeedBack,
    "show_contact_with_whatsapp" : showFeedBack,
    "show_notifications" : showNotifications,
    "android_min_version":androidMinVersion,
    "ios_min_version":iosMinVersion,
    "closed_hour":closedHour,
    "collection_grid":showCollectionGrid,
  };
}

class OffersTheme {
  OffersTheme({
    required this.everyThingMustGo,
    required this.hardClearance,
    required this.clearanceSale,
    required this.freshSale,
  });

  ClearanceSale everyThingMustGo;
  ClearanceSale hardClearance;
  ClearanceSale clearanceSale;
  ClearanceSale freshSale;

  factory OffersTheme.fromJson(Map<String, dynamic> json) => OffersTheme(
    everyThingMustGo:  ClearanceSale.fromJson(json["everyThingMustGo"]),
    hardClearance: ClearanceSale.fromJson(json["hardClearance"]),
    clearanceSale:  ClearanceSale.fromJson(json["clearanceSale"]),
    freshSale:  ClearanceSale.fromJson(json["freshSale"]),
  );

  Map<String, dynamic> toJson() => {
    "everyThingMustGo": everyThingMustGo.toJson(),
    "hardClearance": hardClearance.toJson(),
    "clearanceSale": clearanceSale.toJson(),
    "freshSale": freshSale.toJson(),
  };
}

class ClearanceSale {
  ClearanceSale({
    required this.backgroundColor,
    required this.foregroundColor,
  });

  String backgroundColor;
  String foregroundColor;

  factory ClearanceSale.fromJson(Map<String, dynamic> json) => ClearanceSale(
    backgroundColor: json["backgroundColor"],
    foregroundColor: json["foregroundColor"],
  );

  Map<String, dynamic> toJson() => {
    "backgroundColor": backgroundColor,
    "foregroundColor": foregroundColor,
  };
}
