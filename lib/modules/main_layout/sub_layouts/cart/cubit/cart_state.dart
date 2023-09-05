
abstract class CartStates {}

class CartInitialState extends CartStates {}
class CartLoadingState extends CartStates {}
class CartLoadingSuccessStateDidntUpdateAllList extends CartStates {}
class CartLoadedSuccessState extends CartStates {}
class EditingCartCountStatus extends CartStates {}
class EditingCartCountSuccessStatus extends CartStates {}
class ErrorPlacingOrderState extends CartStates {
  final String? error;

  ErrorPlacingOrderState(this.error);
}
class RemovingCartItemState extends CartStates {}
class ApplyingCouponCode extends CartStates {}
class CouponCodeAppliedSuccessfully extends CartStates {}
class PlacingOrderState extends CartStates {}
class SuccessfullyOrderPlaced extends CartStates {}
class RemovingCartItemStateSuccessState extends CartStates {}
class ErrorRemovingCartItemState extends CartStates {}



class MovingItemToWishListState extends CartStates {}
class MovingItemToWishListSuccessState extends CartStates {}
class ErrorMovingItemToWishListState extends CartStates {}


