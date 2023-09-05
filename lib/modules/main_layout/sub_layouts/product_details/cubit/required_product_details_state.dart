part of 'required_product_details_cubit.dart';

@immutable
abstract class RequiredProductDetailsState {}

class RequiredProductDetailsInitial extends RequiredProductDetailsState {}

class LoadingProductDetailsState extends RequiredProductDetailsState {}
class AddingToCartState extends RequiredProductDetailsState {
  final bool buyNowButton;
  AddingToCartState({this.buyNowButton=false});
}

class PleaseChooseSizeState extends RequiredProductDetailsState {}
class ChoiceChangedState extends RequiredProductDetailsState {}
class QuantityChangedState extends RequiredProductDetailsState {
}
class SuccessAddingToCartState extends RequiredProductDetailsState {
  final String? msg;
  final bool moveToPayment;
  SuccessAddingToCartState({required this.msg , this.moveToPayment=false});
}

class ProductDetailsDataLoadedSuccessState extends RequiredProductDetailsState {}

class ErrorLoadingDataState extends RequiredProductDetailsState {}
class ErrorAddingToCartState extends RequiredProductDetailsState {}