import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/cache/cache.dart';
import '../../../../../core/constants/networkConstants.dart';
import '../../../../../core/main_cubits/cubit_main.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/network/dio_helper.dart';
import '../../../../../models/api_models/product_details_model.dart';
import '../../../../../models/api_models/product_required_information_for_shopping_model.dart';
import '../../../../../models/local_models/local_models.dart';
import '../../cart/cubit/cart_cubit.dart';

part 'required_product_details_state.dart';

class RequiredProductDetailsCubit extends Cubit<RequiredProductDetailsState> {
  RequiredProductDetailsCubit() : super(RequiredProductDetailsInitial());

  static RequiredProductDetailsCubit get(context) => BlocProvider.of(context);


  ProductRequiredInformationForShoppingModel? productRequiredModel;

  String? skuStringRequired;
  List<SelectedChoice> selectedChoicesRequired = [];
  Variation? updatedVariationRequired;
  String? selectedColorRequired = '';
  List<String>? skuLisRequired = [];
  String? skuTextRequired = '';
  bool containSizeRequired = true;
  int currentProductQuantityRequired = 0;

  void resetSelectedChoicesRequired() {
    logg('resetting');
    selectedChoicesRequired = [];
    selectedColorRequired = null;
    skuTextRequired = '';
  }
  void changeSelectedColorRequired(BuildContext context, String colorCode) {
    selectedColorRequired = colorCode;
    skuStringRequired = getSkuString(
        getColorNameFromConfig(context, selectedColorRequired ?? ''));

    updateProductDetails(skuStringRequired!);
    emit(ChoiceChangedState());
  }
  void addSelectedChoiceRequired(BuildContext context, int id,
      String choiceTitle, String choiceName, String choiceValue) {
    logg('adding choices');
    if (choiceTitle == 'Size' || choiceTitle == 'القياس') {
      containSizeRequired = true;
    }
    try {
      selectedChoicesRequired
          .removeWhere((item) => item.choiceName == choiceName);
    } on Exception catch (_) {
      logg('value not existed');
    }
    selectedChoicesRequired.add(
        SelectedChoice(id: id, choiceName: choiceName, choiceVal: choiceValue));
    skuLisRequired!.add(choiceValue);
    logg('selectedChoices: ');
    for (int i = 0; i < selectedChoicesRequired.length; i++) {
      logg(selectedChoicesRequired[i].choiceName.toString() + ': ');
      logg(selectedChoicesRequired[i].choiceVal.toString());
    }

    skuStringRequired = getSkuString(
        getColorNameFromConfig(context, selectedColorRequired ?? ''),);

    updateProductDetails(skuStringRequired!);
    emit(ChoiceChangedState());
  }

  void updateProductDetails(String sku) {
      resetQtyRequired();
      skuTextRequired = '';
      logg('sku in updateProductDetails: ' + sku);
      updatedVariationRequired = productRequiredModel!.data!.variation!
          .firstWhere((element) => element.type == sku);
      logg('variation updated');
      logg(updatedVariationRequired!.qty.toString());
      emit(ChoiceChangedState());
      return;
    }
  void increaseQtyRequired() {
    if (!containSizeRequired) {
      emit(PleaseChooseSizeState());
      return;
    }
    currentProductQuantityRequired += 1;
    emit(QuantityChangedState());
  }

  void decreaseQtyRequired() {
    if (!containSizeRequired) {
      emit(PleaseChooseSizeState());
      return;
    }
    currentProductQuantityRequired -= 1;
    emit(QuantityChangedState());
  }

  void resetQtyRequired() {
    currentProductQuantityRequired = 1;
    emit(QuantityChangedState());
  }
  String? getSkuString(String? selectedColorNameFromConfig) {
      selectedChoicesRequired.sort(
            (a, b) => a.id.compareTo(b.id),
      );
      logg('--=++**');
      if (selectedColorNameFromConfig != '') {
        skuTextRequired = skuTextRequired!.replaceAll(' ', '') +
            selectedColorNameFromConfig! +
            '-';
      } else {
        skuTextRequired = skuTextRequired!.replaceAll(' ', '');
      }

      for (int x = 0; x < selectedChoicesRequired.length; x++) {
        if (x == selectedChoicesRequired.length - 1) {
          skuTextRequired = skuTextRequired!.replaceAll(' ', '') +
              selectedChoicesRequired[x].choiceVal;
        } else {
          skuTextRequired = skuTextRequired!.replaceAll(' ', '') +
              selectedChoicesRequired[x].choiceVal +
              '-';
        }
      }
      logg(skuTextRequired!.replaceAll(' ', ''));
      skuTextRequired = skuTextRequired!.replaceAll(' ', '');
      logg('--');

      return skuTextRequired;
    }
  getRequiredProductInformation(BuildContext context, String productId) async {
    productRequiredModel = null;
    skuLisRequired = [];
    skuTextRequired = '';
    emit(LoadingProductDetailsState());
    await MainDioHelper.getData(
        url: getShoppingRequiredInformationForProductEnd + productId,
        token: getCachedToken())
        .then((value) {
      logg('product details got');
      logg(value.toString());
      productRequiredModel =
          ProductRequiredInformationForShoppingModel.fromJson(value.data);
      logg('productDetailsModel filled');
      if (productRequiredModel!.data!.colors != null) {
        selectedColorRequired = productRequiredModel!.data!.colors![0].code;
      }

      if (productRequiredModel!.data!.choiceOptions!.isNotEmpty) {
        logg('choice options is not empty');
        for (int i = 0;
        i < productRequiredModel!.data!.choiceOptions!.length;
        i++) {
          selectedChoicesRequired.add(SelectedChoice(
              id: i,
              choiceName: productRequiredModel!.data!.choiceOptions![i].name!,
              choiceVal:
              productRequiredModel!.data!.choiceOptions![i].options![0]));
          skuLisRequired!
              .add(productRequiredModel!.data!.choiceOptions![i].options![0]);
          if (productRequiredModel!.data!.choiceOptions![i].title!
              .toLowerCase()
              .contains("size") ||
              productRequiredModel!.data!.choiceOptions![i].title == 'القياس') {
            logg('there is size');
            containSizeRequired = false;
          }
        }
        logg('update sku text');
        skuTextRequired = getSkuString(getColorNameFromConfig(context, selectedColorRequired ?? ''));
        logg('updateProductDetails');
        updateProductDetails(skuTextRequired!);
        selectedChoicesRequired = [];
        logg('sku is: ' + skuLisRequired.toString());
      } else {
        containSizeRequired = true;
      }

      emit(ProductDetailsDataLoadedSuccessState());
    }).catchError((error, st) {
      logg('an error occurred in product required information');
      logg(error.toString());
      emit(ErrorLoadingDataState());
    });
  }

  Future<void> addToCart(
      {required String productId,
        required String quantity,
        bool buyNow = false,
        required BuildContext context}) async {
    if (!containSizeRequired) {
      emit(PleaseChooseSizeState());
      return;
    }
    emit(AddingToCartState(buyNowButton: buyNow));
    Map<String, dynamic> ghPayLoadData = {
      'id': productId,
      'quantity': quantity,
    };
    logg('selected choices is: ' + selectedChoicesRequired.toString());
    for (var e in selectedChoicesRequired) {
      logg('test: ' + e.choiceVal);
      ghPayLoadData[e.choiceName.toString()] = e.choiceVal;
    }

    if (selectedColorRequired != null) {
      logg('color: ' + selectedColorRequired!);
      ghPayLoadData['color'] = selectedColorRequired;
    }
    logg('yytyusdtfyugsdjhfgdl');
    logg(ghPayLoadData.toString());
    await MainDioHelper.postData(
        url: addToCartEnd, token: getCachedToken(), data: ghPayLoadData)
        .then((value) {
      logg(value.toString());
      CartCubit.get(context)
        ..getCartDetails(
          updateAllList: true,
        ).then((value2) {
          emit(SuccessAddingToCartState(
              msg: value.data['message'].toString(), moveToPayment: buyNow));
        })
        ..disableCouponStillAvailable();
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorAddingToCartState());
    });
  }

  String getColorNameFromConfig(
      BuildContext context,
      String selectedColor,
      ) {
    var mainCubit = MainCubit.get(context);
    if (selectedColor == '') {
      logg('selected color empty');
      return '';
    } else {
      String? colorName = mainCubit.configModel!.data!.colors!
          .firstWhere((element) => element.code == selectedColor)
          .name;
      return colorName ?? '';
    }
  }
}
