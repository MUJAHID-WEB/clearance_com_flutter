import 'package:bloc/bloc.dart';
import 'package:clearance/core/cache/cache.dart';
import 'package:clearance/models/api_models/home_Section_model.dart';
import 'package:clearance/models/api_models/product_details_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/constants/networkConstants.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/network/dio_helper.dart';
import '../../../../../models/api_models/brand_products_model.dart';

part 'brand_products_state.dart';

class BrandProductsCubit extends Cubit<BrandProductsState> {
  BrandProductsCubit() : super(InitialBrandProductsState());

  static BrandProductsCubit get (context)=> BlocProvider.of(context);

  BrandProductsModel? brandProductsModel;
  List<Product> products=[];
  int pageNumber=1;

  void getBrandProducts({int pageSize=10 , required String resourceId , required resourceType}) async{
    emit(LoadingBrandProductsState());

    pageNumber++;

    await MainDioHelper.postData(
        url: getProductsForBrandPaginationEP,data: {
        "resource_id" : resourceId,
        "resource_type" :resourceType,
        "pageNumber" : pageNumber,
        "pageSize" : pageSize
    }, token: getCachedToken())
        .then((value) {
       brandProductsModel=BrandProductsModel.fromJson(value.data);
       products.addAll(brandProductsModel?.data ?? []);
       emit(SuccessBrandProductsState());
    }).catchError((error){
      logg('an error occurred');
      logg(error.toString());
          emit(FailureBrandProductsState());
    });
  }

}
