import 'dart:convert';

import 'package:clearance/core/main_cubits/cubit_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clearance/modules/main_layout/sub_layouts/categories/cubit/states_categories.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/cache/cache.dart';
import '../../../../../core/constants/networkConstants.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/network/dio_helper.dart';
import '../../../../../models/api_models/categories_model.dart';
import '../../../../../models/api_models/detailed_category.dart';
import '../../../../../models/api_models/home_Section_model.dart';
import '../../../../../models/api_models/product_filtered_by_cate.dart';

class CategoriesCubit extends Cubit<CategoriesStates>{
  CategoriesCubit() : super(CatInitializeState());

  static CategoriesCubit get(context) => BlocProvider.of(context);



  String? token=getCachedToken();


  int currentMainCatIndex=0;
  int selectedSubIndex=0;
  int pageNum=1;
  Map<String, dynamic>? data;
  CategoriesModel? categoriesModel;
  DetailedCategoriesModel? detailedCategoryModel;
  String currentViewedCategoryIndex='0';
  String selectedCategoryOrder='0';
  String selectedSortByKey = 'latest';
  String currentCateId = '';
  FilteredProductsModel? productsFilteredByCateModel;
  List<Product>? filteredProductByCategory=[];
  List<List<Product>> sectionProducts=List.generate(50, (index) => []);
  List<String> selectedAttribute = [];
  List<String> selectedUserList = [];
  List<String> selectedColorsList = [];
  List<Brand> selectedBrandsList = [];
  List<Price> selectedPricesList = [];
  List<Attribute> selectedAttributeObjectList = [];

  
  List<SortByItem> sortByValues(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);

    return [
      SortByItem(
        key:  'latest',
        displayValue: localizationStrings!.latest,
      )
      ,SortByItem(
        key:   'low-high',
        displayValue: localizationStrings.lowToHigh,
      )
      ,SortByItem(
        key:  'high-low',
        displayValue: localizationStrings.highToLow,
      )
      ,SortByItem(
        key:     'a-z',
        displayValue: localizationStrings.aToZ,
      )
      ,SortByItem(
        key:    'z-a',
        displayValue: localizationStrings.zToA,
      )
      ,

    ];
  }


  
  void changeCurrentMainCatIndex(int index){
    currentMainCatIndex=index;
    emit(CatIndexChangedState());
  }
void changeCurrentSubIndex(int index){
  selectedSubIndex=index;
    emit(CatIndexChangedState());
  }
  void resetCurrentSubIndex(){
    selectedSubIndex=0;
    emit(CatIndexChangedState());
  }
  void updateCurrentCateId(String currentId) {
    logg('updating cate id');
    currentCateId = currentId;
  }
  void resetFilters() {
    logg('resetting filters');
    selectedColorsList = [];
    selectedBrandsList = [];
    selectedPricesList = [];
    filteredProductByCategory=[];
    selectedAttributeObjectList = [];
  }


  void addSelectedAttribute(Attribute attribute) {
    
    

    logg(selectedAttributeObjectList.toString());
    logg('selectedAttName:' + attribute.name.toString());
    logg('selectedAttOptions:' + attribute.options.toString());
    int? index = selectedAttributeObjectList
        .indexWhere((element) => element.id == attribute.id);

    logg('index: ' + index.toString());

    if (index >= 0) {
      logg('exist');
      selectedAttributeObjectList
          .firstWhere((element) => element.id == attribute.id)
          .options = List.from(attribute.options!);
    } else {
      logg('not exist');
      selectedAttributeObjectList.add(attribute);
    }
    
    
    

    logg('list attributes: ' + selectedAttributeObjectList.toString());

    
    
    
    
    
    
    emit(FiltersChangedState());
  }

  void addSelectedListToMainList(List list) {
    selectedColorsList = List.from(list);
    
    
    
    
    
    
    emit(FiltersChangedState());
  }

  void addSelectedListToBrandList(List list) {
    selectedBrandsList = List.from(list);

    
    
    
    
    
    
    
    emit(FiltersChangedState());
  }
  void addSelectedListToPriceList(List list) {
    selectedPricesList = List.from(list);
    
    
    
    
    
    
    emit(FiltersChangedState());
  }


  void removeSelectedItemFromBrandList(int index) {
    selectedBrandsList.removeAt(index);
    
    
    
    
    
    
    emit(FiltersChangedState());
  }

  void removeSelectedItemFromPriceList(int index) {
    selectedPricesList.removeAt(index);
    
    
    
    
    
    
    emit(FiltersChangedState());
  }

  void removeSelectedItemFromColorList(int index) {
    selectedColorsList.removeAt(index);
    
    
    
    
    
    
    emit(FiltersChangedState());
  }

  void removeSelectedOptionFromAttributesList(
      int attributeIndex, int optionIndex) {
    selectedAttributeObjectList[attributeIndex].options!.removeAt(optionIndex);

    
    
    
    
    
    
    emit(FiltersChangedState());
  }

  Future<void> changeSelectedSortByKeyValue(String sortByKey) async {
    selectedSortByKey = sortByKey;
    emit(CatIndexChangedState());
    getFilteredCategoryProducts(
        currentCateId,
        token
    );

  }


  Future<void> getDetailedCategoryById(String id)async{
    detailedCategoryModel=null;
    emit(LoadingDetailedCategoryByIdState());
    String categoryIdUrlPart = 'categories=[$id]';
    logg('url:'+categoriesEnd+'/'+id);
    await MainDioHelper.getData(url: filteredCategoryEndEnd+'?'+categoryIdUrlPart, token: '').then((value) {
      logg('getDetailedCategoryById got');

      detailedCategoryModel = DetailedCategoriesModel.fromJson(value.data);
      logg('categories model: '+detailedCategoryModel.toString());
      emit(FilteredDataLoadedSuccessState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorLoadingDataState());
    });
  }
  Future<void> changeSelectedCat(String index)async{
    selectedCategoryOrder=index;
    emit(CatIndexChangedState());
  }
  Future<void> updateCatIndex(String index)async{
    currentViewedCategoryIndex=index;
    emit(CatIndexChangedState());
  }
  Future<void> loadCategories() async {

    categoriesModel=null;
    emit(LoadingCategoriesDataState());

    await MainDioHelper.getData(url: categoriesEnd, token: '').then((value) {
      

      
      categoriesModel =  CategoriesModel.fromJson(value.data);
      logg('categories model: '+categoriesModel.toString());
      
      
      
      
      emit(FilteredDataLoadedSuccessState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorLoadingDataState());
    });
    
    
    
    
    
    
    
    
  }

  Future<void> getFilteredCategoryProducts(
      String selectedId, String? token,

      {
        List<Price>? prices,
        List<Brand>? brands,
        List<Attribute>? attributes,
        List<String>? colors,
        int? pageNumber,
        BuildContext? context,
        int? sectionIndex,
        bool? pagination,
      }

      ) async {
    emit(LoadingFilteredCategoryProductsState());
    if(pagination!=null){
      if(pagination){
        pageNum+=1;
      }
    }else{
      productsFilteredByCateModel = null;
      filteredProductByCategory=[];
      pageNum=1;
    }

    List<String> brandsList=[]
    ;
    if(brands!=null) {
      brands.forEach((element) {
        brandsList.add(element.id!.toString());
      });
    }
    logg('tet brandsList:'+brandsList.toString());

    
    List<String> pricesList=[]
    ;
    if(prices!=null) {
      prices.forEach((element) {
        pricesList.add('"'+element.minPrice!.toString()+"-"+element.maxPrice!.toString()+'"');
      });
    }
    logg('tet pricesList:'+pricesList.toString());




    List<Map<String,List<String>>> attributesList=[


    ]
    ;
    if(attributes!=null) {
      attributes.forEach((element) {
        attributesList.add({
          element.name.toString():element.options!
        });
      });
    }
    logg('tet attributesList:'+attributesList.toString());

    
    
    
    List<String> colorsList=[]
    ;
    if(colors!=null) {
      colors.forEach((element) {
        colorsList.add('"'+element.toString().replaceRange(0, 1, '%23')+'"');
      });
    }
    logg('tet colorsList:'+colorsList.toString());
    
    
    
    String categoryIdUrlPart = 'categories=[$selectedId]';
    
    
    
    String? attributesJsonStr;
    if(attributes!=null){
      attributesJsonStr = jsonEncode(attributes.map((e) => e.options!.isNotEmpty?
          e.toJson():'').toList()
      );
      if (attributesJsonStr== '[""]'){
        attributesJsonStr='[]';
      }
      logg('test: '+attributesJsonStr);
    }
    logg('testtttt');
    String brandsUrlPart = brandsList.isNotEmpty?'&brands=$brandsList':'';
    String pricesUrlPart = pricesList.isNotEmpty?'&prices=$pricesList':'';
    String colorsUrlPart = colorsList.isNotEmpty?'&colors=$colorsList':'';
    String sortByUrlPart = '&sort_by=$selectedSortByKey';
    String attributesUrlPart = attributesJsonStr!=null?'&attributes=$attributesJsonStr':'';



    await MainDioHelper.getData(
        url: filteredCategoryEndEnd + '?limit=20&offset=${pageNumber ?? pageNum}&' + categoryIdUrlPart+brandsUrlPart+pricesUrlPart
            +colorsUrlPart+attributesUrlPart+sortByUrlPart, token: token)
        .then((value) {
      logg('productByCateId got');
      
logg(value.toString());
      productsFilteredByCateModel = FilteredProductsModel.fromJson(value.data);
      if(pageNumber != null){
        MainCubit.get(context).pageNumberForSections[sectionIndex!]++;
        sectionProducts[sectionIndex].addAll(productsFilteredByCateModel!.data!.products!);
      }
      else {
        if (pagination != null) {
          if (pagination) {
            filteredProductByCategory!.addAll(
                productsFilteredByCateModel!.data!.products!);
          }
        } else {
          filteredProductByCategory =
              productsFilteredByCateModel!.data!.products;
        }
      }

      emit(FilteredDataLoadedSuccessState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorLoadingDataState());
    });
    
    
    
    
    
    
    
    
  }

}


class SortByItem{
  final String key;
  final String displayValue;

  SortByItem({required this.key, required this.displayValue});

}