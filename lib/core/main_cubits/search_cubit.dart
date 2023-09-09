import 'package:bloc/bloc.dart';
import 'package:clearance/core/constants/networkConstants.dart';
import 'package:clearance/core/main_cubits/search_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clearance/core/cache/cache.dart';

import '../../../models/api_models/product_filtered_by_cate.dart';

import '../../models/api_models/home_Section_model.dart';
import '../../models/api_models/search_uto_complete_model.dart';
import '../cache/cache.dart';
import '../main_functions/main_funcs.dart';
import '../network/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of(context);

  List<SearchAutoCompleteItem> suggestions = [];

  String? token = getCachedToken();
  FilteredProductsModel? filteredProductsModel;
  List<Product> products=[];
  int pageNumber=0;
  SearchAutoCompleteModel? searchAutoCompleteModel;
  bool inSearchProcess = false;

  void updateSuggestion(String query) async {
    emit(UpdatingSuggestions());
    logg('query: ' + query);
    

    
    

    
    
    

    await MainDioHelper.getData(
        url: autoCompleteSearchEnd + '?search_text=$query', token: token)
        .then((value) {
      logg('search autocomplete data got');


      searchAutoCompleteModel = SearchAutoCompleteModel.fromJson(value.data);

      suggestions = searchAutoCompleteModel!.data!;
      logg(suggestions.toString());
      emit(DataLoadedSuccessState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorLoadingDataState());
    });

    
    
    
    
    
    
    
    
    emit(UpdatedSuggestions());
  }

  Future<void> getSearchResults(String searchText, String customCateId) async {
    
    inSearchProcess = true;
    pageNumber++;

    emit(LoadingSearchResults());
    await MainDioHelper.getData(
        url: mainProductsEnd +
            '?search_text=$searchText' +
            '&offset=$pageNumber&limit=10&categories=[$customCateId]',
        token: token)
        .then((value) {
      logg('search data got');
      logg(value.data.toString());
      filteredProductsModel = FilteredProductsModel.fromJson(value.data);
      products.addAll(filteredProductsModel!.data!.products ?? []);
      inSearchProcess = false;
      emit(DataLoadedSuccessState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      inSearchProcess = false;
      emit(ErrorLoadingDataState());
    });
  }
}
