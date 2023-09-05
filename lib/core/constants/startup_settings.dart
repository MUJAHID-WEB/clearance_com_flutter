import 'dart:io';

import 'package:clearance/core/cache/cache.dart';
import 'dart:convert' as convert;

import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';

import '../../models/api_models/starting_setting_model.dart';
import '../main_functions/main_funcs.dart';


late Color mainBackgroundColor ;
late Color titleColor;
 Color primaryColor = const Color(0xffcc3333);
late Color subCategoriesColor ;
late Color buyNowButtonColor ;
late Color priceColor ;
late Color shareButtonColor ;
late Color includingTaxColor ;
late Color giftBackColor ;
late Color categoryHeaderColor ;
late Color newSoftGreyColor ;
late Color mainGreyColor ;
late Color mainCatGreyColor;
late Color newSoftGreyColorAux ;
late Color firstOfferBackColor;
late Color firstOfferForeColor;
late Color secondOfferBackColor;
late Color secondOfferForeColor;
late Color thirdOfferBackColor;
late Color thirdOfferForeColor;
late Color fourthOfferBackColor;
late Color fourthOfferForeColor;
late Color flashDealForeColor;
late Color flashDealBackColor;
late StartingSettings settings;
int? closedHour;
bool? showCollectionGrid;
bool? showPaymentUsingCards;
bool? showCashPayment;
bool? showFlashDeals;
bool? showNotifications;
bool? showFeedBack;
bool? showWhatsAppContact;
int countOfRequestToSave=60;



late bool thereData;
late int? version;
 setStartingSettings()async{
   String? cachedData= await CacheHelper.getData(key: 'StartingSettings');
   thereData=(cachedData!=null);
   if(thereData) {
     settings = StartingSettings.fromJson(convert.jsonDecode(cachedData!));
   }
   print('there data '+thereData.toString());
   firstOfferBackColor =  Color(thereData ? int.parse(settings.offersTheme.everyThingMustGo.backgroundColor) : 0xffCC3333);
   firstOfferForeColor =  Color(thereData ? int.parse(settings.offersTheme.everyThingMustGo.foregroundColor) : 0xffF6F6F7);
   secondOfferBackColor =  Color(thereData ? int.parse(settings.offersTheme.hardClearance.backgroundColor) : 0xFFFF5722);
   secondOfferForeColor =  Color(thereData ? int.parse(settings.offersTheme.hardClearance.foregroundColor) : 0xffF6F6F7);
   thirdOfferBackColor =  Color(thereData ? int.parse(settings.offersTheme.clearanceSale.backgroundColor) : 0xffFFC107);
   thirdOfferForeColor =  Color(thereData ? int.parse(settings.offersTheme.clearanceSale.foregroundColor) : 0xff000000);
   fourthOfferBackColor =  Color(thereData ? int.parse(settings.offersTheme.freshSale.backgroundColor) : 0xFF43A047);
   fourthOfferForeColor =  Color(thereData ? int.parse(settings.offersTheme.freshSale.foregroundColor) : 0xffF6F6F7);
  mainBackgroundColor =  Color(thereData ? int.parse(settings.mainBackgroundColor) : 0xffF6F6F7);
  titleColor =  Color(thereData ? int.parse(settings.titleColor) : 0xff57636F);
  primaryColor =  Color( thereData ? int.parse(settings.primaryColor) : 0xffCC3333);
  subCategoriesColor =  Color(thereData ? int.parse(settings.subCategoriesColor) : 0xfffc808f);
  buyNowButtonColor =  Color(thereData ? int.parse(settings.buyNowButtonColor) : 0xffFFC107);
  priceColor =  Color(thereData ? int.parse(settings.priceColor) : 0xff43A047);
  shareButtonColor =  Color(thereData ? int.parse(settings.shareButtonColor) : 0xff4CAF50);
  includingTaxColor =  Color(thereData ? int.parse(settings.includingTaxColor) : 0xff00BCD4);
   giftBackColor =  Color(thereData ? int.parse(settings.giftBackColor) : 0xffD9FFF5);
   categoryHeaderColor = Color(thereData ? int.parse(settings.categoryHeaderColor) : 0xffAB00FF);
   newSoftGreyColor = Color(thereData ? int.parse(settings.newSoftGreyColor) : 0xffCCCCCC);
   mainGreyColor = Color(thereData ? int.parse(settings.mainGreyColor) : 0xffC4E4FF);
   mainCatGreyColor = Color(thereData ? int.parse(settings.mainCatGreyColor) : 0xffDBD7D7);
   newSoftGreyColorAux = Color(thereData ? int.parse(settings.newSoftGreyColorAux) : 0xffe2e1e1);

   flashDealForeColor =  Color(thereData ? int.parse(settings.flashDealForeColor) : 0xffffffff);
   flashDealBackColor =  Color(thereData ? int.parse(settings.flashDealBackColor) : 0xffCC3333);
   closedHour=thereData ? settings.closedHour : 14;
   showCollectionGrid=thereData ? settings.showCollectionGrid :false;
   version=thereData ? (Platform.isAndroid ? settings.androidMinVersion : settings.iosMinVersion) : 25;
   showPaymentUsingCards=thereData ? settings.showPaymentUsingCards : true;
   showCashPayment=thereData ?settings.showCashPayment : true;
   showNotifications=thereData ? settings.showNotifications : false;
   showFlashDeals=thereData ? settings.showFlashDeals : true;
   showFeedBack=thereData ? settings.showFeedBack : true;
   showWhatsAppContact=thereData ? settings.showWhatsAppContact : true;
   countOfRequestToSave = thereData ? settings.countOfRequestToSave :60;

   if(thereData) {
     if (convert.jsonDecode(cachedData!).containsKey('download_images')) {
       if (convert.jsonDecode(cachedData)['download_images']) {
         await downloadImage(imageName: 'squareCurvedLogoUrl',
             imageUrl: settings.squareCurvedLogoUrl);
         await downloadImage(
             imageName: 'rectangularCurvedLogoUrl',
             imageUrl: settings.rectangularCurvedLogoUrl
         );
       }
     }
   }
}

Future<String> changeSvgColor(String svgPath) async {
  String svgCode =await rootBundle.loadString(svgPath);
  if(thereData ) {
    svgCode=svgCode.replaceAll("CC3333", settings.primaryColor.substring(4).toUpperCase());
  }
  return svgCode;
}

downloadImage({required String imageName , required String imageUrl})async{
  try {
    logg('fetch image\n');
    var imageId = await ImageDownloader.downloadImage(imageUrl , destination: AndroidDestinationType.custom(directory: 'clearance_images')
      ..inExternalFilesDir()
      ..subDirectory("clearance_images/$imageName.png"));
    if (imageId == null) {
    }
    logg('image id :  ' + imageId!);
    String? path = await ImageDownloader.findPath(imageId );
    CacheHelper.saveData(key: imageName, value: path);
    logg('path : '  + path!);
  }  catch (error) {
  }
}
