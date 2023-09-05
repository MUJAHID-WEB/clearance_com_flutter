abstract class MainStates {}

class MainStatesInitialize extends MainStates {}
class LocaleChangedState extends MainStates {}
class ChangeCurrentSelectedHomeSectionState extends MainStates {
  final bool fromTop;
  ChangeCurrentSelectedHomeSectionState({this.fromTop=true});
}
class LoadingConfigDataState extends MainStates {}
class AddCollectionSectionSuccessfulState extends MainStates {}
class LoadingFlashProductsState extends MainStates {}
class LoadingFlashProductsSuccessState extends MainStates {}
class LoadingFlashProductsFailedState extends MainStates {}
class AddressesLoadingState extends MainStates {}
class AddressesLoadedState extends MainStates {}
class RemovingAddressState extends MainStates {}
class DataLoadedSuccessState extends MainStates {}
class LoadingBannersState extends MainStates {}
class ChangingDefaultAddresses extends MainStates {}
class TabChangedState extends MainStates {}
class SelectedCategoryChangedState extends MainStates {}
class DefaultAddressShippingChangedState extends MainStates {}
class FaqChangedState extends MainStates {}
class AddingProductToWishList extends MainStates {}
class SuccessfullyAddingProductToWishList extends MainStates {}
class RemovingProductFromWishList extends MainStates {}
class SuccessfullyRemovedProductFromWishList extends MainStates {}
class LoadingFeaturedState extends MainStates {}
class FeaturedProductsDataLoadedSuccessState extends MainStates {}
class AppBarChanged extends MainStates {}
class ErrorLoadingDataState extends MainStates {}
class ConnectionStateChanging extends MainStates {}
class ConnectionStateChanged extends MainStates {}
class Initializing extends MainStates {}
