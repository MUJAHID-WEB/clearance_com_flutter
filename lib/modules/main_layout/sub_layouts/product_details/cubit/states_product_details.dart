abstract class ProductDetailsStates {}

class ProductDetailsInitializeState extends ProductDetailsStates {}

class LoadingProductDetailsState extends ProductDetailsStates {}
class AddingToCartState extends ProductDetailsStates {
  final bool buyNowButton;
  AddingToCartState({this.buyNowButton=false});
}

class PleaseChooseSizeState extends ProductDetailsStates {}
class ChoiceChangedState extends ProductDetailsStates {}
class QuantityChangedState extends ProductDetailsStates {
}
class SuccessAddingToCartState extends ProductDetailsStates {
  final String? msg;
  final bool moveToPayment;
  SuccessAddingToCartState({required this.msg , this.moveToPayment=false});
}

class ProductDetailsDataLoadedSuccessState extends ProductDetailsStates {}

class ErrorLoadingDataState extends ProductDetailsStates {}
class ErrorAddingToCartState extends ProductDetailsStates {}
