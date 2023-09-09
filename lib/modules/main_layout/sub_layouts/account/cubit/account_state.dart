
abstract class AccountStates {}

class AccountInitial extends AccountStates {}
class LoadingWishListDataState extends AccountStates {}
class LoadingContactUsDataState extends AccountStates {}
class FailureContactUsDataState extends AccountStates {}
class SuccessContactUsDataState extends AccountStates {}
class WishListDataSuccessState extends AccountStates {}
class SuccessPickedFiles extends AccountStates {}
class LoadingOrdersState extends AccountStates {}
class OrdersListSuccessState extends AccountStates {}
class SavingAddressState extends AccountStates {}
class AddressTypeChanged extends AccountStates {}
class FilterApplied extends AccountStates {}
class SavingReviewListState extends AccountStates {}
class SuccessfullySaveReviewList extends AccountStates {}
class OrderCanceledSuccess extends AccountStates {}
class UpdateProfileSuccess extends AccountStates {}
class LoadingState extends AccountStates {}
class ErrorUpdateProfile extends AccountStates {
  String? message;
  ErrorUpdateProfile({this.message});
}
class UpdateAccountPage extends AccountStates {}
class AddingAddressSuccessState extends AccountStates {
  final String? msg;

  AddingAddressSuccessState({required this.msg});

}
class ErrorLoadingDataState extends AccountStates {
  final String? msg;
  ErrorLoadingDataState({required this.msg});

}
class ErrorWishListDataState extends AccountStates {}
