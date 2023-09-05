
import 'dart:io';
import 'dart:io' show Platform;
import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/models/api_models/banners_model.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/cubit/account_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clearance/core/main_cubits/states_main.dart';
import 'package:clearance/l10n/l10n.dart';
import 'package:clearance/models/api_models/addresses_model.dart';
import 'dart:convert' as convert;
import '../../appMainInitial.dart';
import '../../models/api_models/config_model.dart' as config;
import '../../models/api_models/featured_products.dart';
import '../../models/api_models/flash_products_model.dart';
import '../../models/api_models/home_Section_model.dart';
import '../../modules/main_layout/sub_layouts/categories/cubit/cubit_categories.dart';
import '../cache/cache.dart';
import '../constants/networkConstants.dart';
import '../main_functions/main_funcs.dart';
import '../network/dio_helper.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(MainStatesInitialize());

  static MainCubit get(context) => BlocProvider.of(context);

  String selectedTab = 'home';
  Locale? appLocale;
  String featuredProductLimit = '10';
  int featuredProductOffset = 0;
  int currentSelectedHomeSectionIndex = (showCollectionGrid ?? true) ? -2 : 0;


  String? token ;
  bool isFirstApplicationRun = getCachedFirstApplicationRun() ?? true;

  String? name;
  String defaultShippingAddressId = '0';

  String? email;

  bool isConnected = false;

  String? currentViewFaqAnswerId = '-15';

  bool cacheGot = false;
  String? selectedHomeCategoryFilter = getCachedSelectedHomeCategoryId();

  bool _firstInitial = true;
  bool firstDialogInitial = true;
  config.ConfigModel? configModel;
  HomeSections? homeSectionModel;
  AddressesModel? addressesModel;
  FeaturedProductsModel? featuredProductsModel;
   Function(int index)? moveToHomeTap;
   List<HomeSectionItem> sections=[];
  
  BannersModel? bannersModel;
  List<BannerItem>? banners;
  FlashProductsModel? flashProductsModel;
  List<Product> products=[];
  List<int> pageNumberForSections=[];

  List<Product> featuredProducts = [];
  String? defaultLang = getCachedLocal();
  String? currentAppBarWidget;
  int pageNumber=0;
 void navigateToTap(int index){
   print('hi');
   moveToHomeTap!.call(index);
 }
  
  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { 
      logg('android');
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; 
    } else if(Platform.isAndroid) {
      logg('android');
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      logg('info: '+androidInfo.toString());
      logg('info: '+androidInfo.id.toString()+'_'+androidInfo.model.toString());
      
      return androidInfo.id.toString()+'_'+androidInfo.model.toString(); 
    }
    
  }
  
  
  
  
  
  bool firstTime = true;
  void updateDefaultLang(){
    defaultLang = getCachedLocal();
  }
  void updateToken(){
    token=getCachedToken();
  }

  void initial({required bool isLogout , required BuildContext context}) {
    
    if (firstTime || isLogout) {
      firstTime = false;
      getConfigData();
      getHomeSection(context);
      getBanners();
      getAddresses();
      changeDefaultAddressId(getCachedDefaultAddress() ?? '0');
      
    }
  }

  void lazyLoading(ScrollController controller){
    if(currentSelectedHomeSectionIndex!=-2){
      return ;
    }
    if(sections.length < homeSectionModel!.data!.length && controller.position.pixels >=
        controller.position.maxScrollExtent / 1.1){
      sections.add(homeSectionModel!.data![sections.length]);
      emit(AddCollectionSectionSuccessfulState());
    }
  }


  void changeFirstRunStatus(bool newVal) {
    saveCachedFirstApplicationRun(newVal);
    isFirstApplicationRun = newVal;
  }
 void changeCurrentSelectedHomeSection(int index , {bool fromTop=true}) {
   currentSelectedHomeSectionIndex=index;
   emit(ChangeCurrentSelectedHomeSectionState(fromTop: fromTop));
  }

  dynamic connectivityResult;

  Future<bool> checkConnectivity() async {
    logg('checkConnectivity');
    emit(ConnectionStateChanging());

    if (Platform.isWindows) {
      isConnected =
          true; 
      
    } else {
      connectivityResult = await (Connectivity().checkConnectivity());

      isConnected = connectivityResult != ConnectivityResult.none;
    }

    logg('connected: ' + isConnected.toString());
    emit(ConnectionStateChanged());
    return isConnected;
  }

  void changeSelectedFaqViewAnswer(String faqId) {
    currentViewFaqAnswerId = faqId;
    emit(FaqChangedState());
  }

  
  void changeSelectedTab(String newSelectedTab) {
    selectedTab = newSelectedTab;
    emit(TabChangedState());
  }

  void changeSelectedCategoryId(String categoryId) {
    saveCacheSelectedHomeCategoryId(categoryId);
    selectedHomeCategoryFilter = categoryId;
    emit(SelectedCategoryChangedState());
  }

  Future<void> changeDefaultAddressId(String id) async{
    emit(ChangingDefaultAddresses());
    defaultShippingAddressId = id;
    saveCacheDefaultAddress(defaultShippingAddressId);
    await MainDioHelper.postData(
      url: setDefaultAddress,
      data: {
        'address_id': id,
      },
      token: token,
    ).then((value) {
      logg('successPlaceOrderStatus= ' + value.toString());
getAddresses();

    }).catchError((error) {
      logg(error.response.toString());
      emit(ErrorLoadingDataState());
    });
    emit(DefaultAddressShippingChangedState());
  }

  Address? getDefaultShippingAddressItemValues() {
    return addressesModel!.data!.firstWhere(
        (element) => element.isDefault==1,
        orElse: () {
      logg('test no id selected');
      return Address(id: 0);
    });
  }

  

  Future<void> removeAddress(String id) async {
    

    emit(RemovingAddressState());
    MainDioHelper.postData(
        url: removeAddressEnd,
        token: getCachedToken(),
        data: {'address_id': id}).then((value) {
      if (defaultShippingAddressId == id) {
        
        removeDefaultAddress();
      }
      getAddresses();

      
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorLoadingDataState());
    });
  }

  void getMainCacheUserData() {
    logg('getting getMainCacheUserData');
    token = getCachedToken();
    name = getCachedName();
    email = getCachedEmail();

    cacheGot = true;
  }

  void disableCacheGotFlag() {
    cacheGot = false;
  }

  void removeDefaultAddress() {
    defaultShippingAddressId = '0';
    removeDefaultCachedAddress();
  }

  void setLocale(Locale locale, BuildContext context,bool isFirstScreen) {
    if (!L10n.all.contains(locale)) {
      logg('locale not available');
      return;
    }

    appLocale = locale;
    logg('locale changed to:' + appLocale!.languageCode.toString());
    saveCacheLocal(appLocale!.languageCode.toString());
    updateDefaultLang();
    MainCubit.get(context)..getConfigData()..getHomeSection(context);

    isFirstScreen
        ? navigateToAndFinishUntil(context, const MainAppMaterialApp())
    
        :Navigator.pop(context);
    
  }

  void setInitialLocale(Locale locale, BuildContext context) {
    if (!L10n.all.contains(locale)) {
      logg('locale not available');
      return;
    }

    appLocale = locale;
    logg('locale InitialLocale:' + appLocale!.languageCode.toString());
    saveCacheLocal(appLocale!.languageCode.toString());
    emit(LocaleChangedState());
  }

  void getSavedAppLocale() {
    String? savedLangCode = getCachedLocal();
    if (savedLangCode != null) {
      appLocale = Locale.fromSubtags(languageCode: savedLangCode);
    } else {
      appLocale = const Locale.fromSubtags(languageCode: 'en');
    }

    
    logg('SavedAppLocale' + appLocale!.languageCode.toString());
    
    emit(LocaleChangedState());
  }

  void initialLocale(Locale locale) {
    if (_firstInitial) {
      if (!L10n.all.contains(locale)) {
        logg('locale not available');
        return;
      }
      appLocale = locale;
      logg('locale initialLocale' + appLocale!.languageCode.toString());

      _firstInitial = false;
      emit(LocaleChangedState());
    }
  }

  void changeFirstDialogVal() {
    firstDialogInitial = false;
    emit(state);
  }

  Future<void> getConfigData() async {
    
    
    
    emit(LoadingConfigDataState());

    await MainDioHelper.getData(url: configEnd, token: token).then((value) {
      logg('config data got');
      configModel = config.ConfigModel.fromJson(value.data);
      logg(configModel.toString());
      
      
      emit(DataLoadedSuccessState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorLoadingDataState());
    });
  }

  Future<void> getBanners() async {
    
    
    
    emit(LoadingBannersState());

    await MainDioHelper.getData(url: bannersEnd, token: token).then((value) {
      logg('config data got');
      bannersModel = BannersModel.fromJson(value.data);
      logg(configModel.toString());
      banners = bannersModel!.data;
      
      
      emit(DataLoadedSuccessState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorLoadingDataState());
    });
  }

  Future<void> addProductToWishList(String productId , BuildContext context) async {
    
    await MainDioHelper.postData(
        url: addProductToWishListEnd,
        token:  getCachedToken(),
        data: {
          'product_id': productId,
        }).then((value) {
      logg('Added Product To WishList');
      AccountCubit.get(context).getWishListProducts();
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      
    });
  }

  Future<void> removeProductFromWishList(String productId , BuildContext context) async {
    

    

    await MainDioHelper.postData(
        url: removeProductFromWishListEnd,
        token:  getCachedToken(),
        data: {
          'product_id': productId,
        }).then((value) {
      logg('Removing Product To WishList');
      AccountCubit.get(context).getWishListProducts();
      
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      
    });
  }

  Future<void> getHomeSection(BuildContext context) async {
    
    homeSectionModel = null;
    emit(LoadingConfigDataState());

    await MainDioHelper.getData(url:Platform.isAndroid ? homeSectionAndroidEnd : homeSectionIosEnd , token: token)
        .then((value) {
      logg('home section data got');
      saveCacheHomeData(convert.jsonEncode(value.data));
      logg(value.toString());
      homeSectionModel = HomeSections.fromJson(value.data);
      sections.add(homeSectionModel!.data![0]);
      CacheHelper.saveData(key: 'StartingSettings', value: convert.jsonEncode(value.data["data"]["starting-setting"]));
      setStartingSettings();
      changeCurrentSelectedHomeSection(showCollectionGrid! ? -2 : 0);
      pageNumberForSections=List.generate(homeSectionModel!.data!.length, (index) => 1);
      CategoriesCubit.get(context).sectionProducts.clear();
      CategoriesCubit.get(context).sectionProducts=List.generate(homeSectionModel!.data!.length, (index) => []);
      emit(DataLoadedSuccessState());
    }).catchError((error) {
      logg('an error occurred in home');
      logg(error.toString());
      emit(ErrorLoadingDataState());
    });
  }

  Future<void> getAddresses() async {
    emit(AddressesLoadingState());
    MainDioHelper.getData(url: addressesListEnd, token: token).then((value) {
      logg('addressesModel data got');
      addressesModel = AddressesModel.fromJson(value.data);
      print(addressesModel!.data ?? '');
      emit(AddressesLoadedState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorLoadingDataState());
    });
  }

  Future<void> removeAddresses()async{
    addressesModel=null;
    saveCacheDefaultAddress('0');
  }

  Future<void> getFeaturedProducts() async {
    
    

    featuredProductOffset += 1;
    emit(LoadingFeaturedState());

    MainDioHelper.getData(
            url: getFeaturedProductsEnd +
                '?limit=$featuredProductLimit&offset=$featuredProductOffset',
            token: token)
        .then((value) {
      logg('featuredProductsModel data got');
      featuredProductsModel = FeaturedProductsModel.fromJson(value.data);

      featuredProducts += featuredProductsModel!.data!.products!;
      
      
      

      emit(FeaturedProductsDataLoadedSuccessState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorLoadingDataState());
    });
  }
  void getFlashProducts({int pageSize=10}) async{
    emit(LoadingFlashProductsState());

    pageNumber++;

    await MainDioHelper.postData(
        url: getProductsForFlashDealsPaginationEP,
        data: {
      "pageNumber" : pageNumber,
      "pageSize" : pageSize
    }, token: getCachedToken())
        .then((value) {
          logg(value.data.toString());
      flashProductsModel=FlashProductsModel.fromJson(value.data);
      products.addAll(flashProductsModel?.data ?? []);
      emit(LoadingFlashProductsSuccessState());
    }).catchError((error){
      logg('an error occurred');
      logg(error.toString());
      emit(LoadingFlashProductsFailedState());
    });
  }
   void getLocalHomeSectionData(BuildContext context) {
    if(getCachedHomeData()==null){
      return ;
    }
   homeSectionModel= HomeSections.fromJson(convert.jsonDecode(getCachedHomeData()!));
    setStartingSettings();
    if(showWhatsAppContact ?? true) {
      AccountCubit.get(context).getContactUsInformation();
    }
    emit(DataLoadedSuccessState());
  }
}
