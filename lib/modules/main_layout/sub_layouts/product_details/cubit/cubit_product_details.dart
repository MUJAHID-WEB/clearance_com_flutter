import 'package:clearance/modules/main_layout/sub_layouts/cart/cubit/cart_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clearance/core/cache/cache.dart';
import 'package:clearance/core/main_cubits/cubit_main.dart';
import 'package:clearance/models/api_models/product_details_model.dart';
import 'package:clearance/models/local_models/local_models.dart';
import 'package:clearance/modules/main_layout/sub_layouts/product_details/cubit/states_product_details.dart';
import '../../../../../core/constants/networkConstants.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/network/dio_helper.dart';
import '../../../../../models/api_models/product_required_information_for_shopping_model.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsStates> {
  ProductDetailsCubit() : super(ProductDetailsInitializeState());

  static ProductDetailsCubit get(context) => BlocProvider.of(context);

  ProductDetailsModel? productDetailsModel;

  bool firstRun = true;
  String? skuString;
  List<SelectedChoice> selectedChoices = [];
  Variation? updatedVariation;
  String? selectedColor = '';
  List<String>? skuLis = [];
  String? skuText = '';
  int currentProductQuantity = 0;
  bool containSize = true;
  void changeFirstRunVal(bool val) {
    firstRun = val;
  }

  void resetSelectedChoices() {
    logg('resetting');
    selectedChoices = [];
    selectedColor = null;
    skuText = '';
  }


  void changeSelectedColor(BuildContext context, String colorCode) {
    selectedColor = colorCode;
    skuString =
        getSkuString(getColorNameFromConfig(context, selectedColor ?? ''));

    updateProductDetails(skuString!);
    emit(ChoiceChangedState());
  }


  void addSelectedChoice(BuildContext context, int id, String choiceTitle,
      String choiceName, String choiceValue) {
    logg('adding choices');
    if (choiceTitle == 'Size' || choiceTitle == 'القياس') {
      containSize = true;
    }
    try {
      selectedChoices.removeWhere((item) => item.choiceName == choiceName);
    } on Exception catch (_) {
      logg('value not existed');
    }
    selectedChoices.add(
        SelectedChoice(id: id, choiceName: choiceName, choiceVal: choiceValue));
    skuLis!.add(choiceValue);
    logg('selectedChoices: ');
    for (int i = 0; i < selectedChoices.length; i++) {
      logg(selectedChoices[i].choiceName.toString() + ': ');
      logg(selectedChoices[i].choiceVal.toString());
    }

    skuString =
        getSkuString(getColorNameFromConfig(context, selectedColor ?? ''));

    updateProductDetails(skuString!);
    emit(ChoiceChangedState());
  }


  void updateProductDetails(String sku) {
    resetQty();
    skuText = '';
    logg('sku in updateProductDetails: ' + sku);
    updatedVariation = productDetailsModel!.data!.variation!.firstWhere((element) => element.type == sku);
    logg('variation updated');
    logg(updatedVariation!.qty.toString());
    emit(ChoiceChangedState());
  }

  void increaseQty() {
    if (!containSize) {
      emit(PleaseChooseSizeState());
      return;
    }
    currentProductQuantity += 1;
    emit(QuantityChangedState());
  }

  void decreaseQty() {
    if (!containSize) {
      emit(PleaseChooseSizeState());
      return;
    }
    currentProductQuantity -= 1;
    emit(QuantityChangedState());
  }


  void resetQty() {
    currentProductQuantity = 1;
    emit(QuantityChangedState());
  }

  String? getSkuString(String? selectedColorNameFromConfig) {
    selectedChoices.sort(
      (a, b) => a.id.compareTo(b.id),
    );
    logg('--=++**');
    if (selectedColorNameFromConfig != '') {
      skuText =
          skuText!.replaceAll(' ', '') + selectedColorNameFromConfig! + '-';
    } else {
      skuText = skuText!.replaceAll(' ', '');
    }

    for (int x = 0; x < selectedChoices.length; x++) {
      if (x == selectedChoices.length - 1) {
        skuText = skuText!.replaceAll(' ', '') + selectedChoices[x].choiceVal;
      } else {
        skuText =
            skuText!.replaceAll(' ', '') + selectedChoices[x].choiceVal + '-';
      }
    }
    logg(skuText!.replaceAll(' ', ''));
    skuText = skuText!.replaceAll(' ', '');
    logg('--');

    return skuText;
  }


  Future<void> getProductDetails(
    BuildContext context,
    String productId,
  ) async {
    productDetailsModel = null;
    skuLis = [];
    skuText = '';

    emit(LoadingProductDetailsState());
    await MainDioHelper.getData(
            url: productDetailsEnd + productId, token: getCachedToken())
        .then((value) {
      logg('product details got');
      logg(value.toString());
      productDetailsModel = ProductDetailsModel.fromJson(value.data);
      logg('productDetailsModel filled');
      if (productDetailsModel!.data!.colors != null) {
        selectedColor = productDetailsModel!.data!.colors![0].code;
      }

      if (productDetailsModel!.data!.choiceOptions!.isNotEmpty) {
        logg('choice options is not empty');
        for (int i = 0;
            i < productDetailsModel!.data!.choiceOptions!.length;
            i++) {
          selectedChoices.add(SelectedChoice(
              id: i,
              choiceName: productDetailsModel!.data!.choiceOptions![i].name!,
              choiceVal:
                  productDetailsModel!.data!.choiceOptions![i].options![0]));
          skuLis!.add(productDetailsModel!.data!.choiceOptions![i].options![0]);
          if (productDetailsModel!.data!.choiceOptions![i].title!
                  .toLowerCase()
                  .contains("size") ||
              productDetailsModel!.data!.choiceOptions![i].title == 'القياس') {
            containSize = false;
          }
        }
        logg('update sku text');
        skuText =
            getSkuString(getColorNameFromConfig(context, selectedColor ?? ''));
        logg('updateProductDetails');
        updateProductDetails(skuText!);
        selectedChoices = [];
        logg('sku is: ' + skuLis.toString());
      } else {
        containSize = true;
      }

      emit(ProductDetailsDataLoadedSuccessState());
    }).catchError((error, st) {
      logg('an error occurred in product details');
      print(error);
      emit(ErrorLoadingDataState());
    });
  }

  Future<void> addToCart(
      {required String productId,
      required String quantity,
      bool buyNow = false,
      required BuildContext context}) async {
    if (!containSize) {
      emit(PleaseChooseSizeState());
      return;
    }
    emit(AddingToCartState(buyNowButton: buyNow));
    Map<String, dynamic> ghPayLoadData = {
      'id': productId,
      'quantity': quantity,
    };
    logg('selected choices is: ' + selectedChoices.toString());
    for (var e in selectedChoices) {
      logg('test: ' + e.choiceVal);
      ghPayLoadData[e.choiceName.toString()] = e.choiceVal;
    }

    if (selectedColor != null) {
      logg('color: ' + selectedColor!);
      ghPayLoadData['color'] = selectedColor;
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
