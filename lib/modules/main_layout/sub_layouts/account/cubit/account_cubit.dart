import 'package:bloc/bloc.dart';
import 'package:clearance/modules/auth_screens/cubit/cubit_auth.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cubit/cart_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clearance/core/main_cubits/cubit_main.dart';
import 'package:clearance/models/api_models/home_Section_model.dart';
import 'package:clearance/models/api_models/wish_list.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../../core/cache/cache.dart';
import '../../../../../core/constants/networkConstants.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/network/dio_helper.dart';
import '../../../../../models/api_models/contact_us_model.dart';
import '../../../../../models/api_models/orders-model.dart';
import '../../../../auth_screens/cubit/states_auth.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountStates> {
  AccountCubit() : super(AccountInitial());

  static AccountCubit get(context) => BlocProvider.of(context);

  WishList? wishListModel;
  String addressType = 'home';
  int addressIdForPayment = 0;
  String currentOrderDetailsViewId = '0';
  String phoneNum = '55';
  String currentEvaluatingProductId = '0';
  double currentRating = 3.0;
  List<Product>? wishListProducts;
  OrdersModel? ordersModel;
  List<OrderItemModel>? orders;
  List<OrderItemModel>? currentOrderList;
  ContactUsModel? contactUsModel;
  bool isLocationSelected = false;

  List<MultipartFile> images = [];

  removePic(int index) {
    emit(SuccessPickedFiles());
  }

  openImages() async {}

  void resetSelectedImages() {}

  void setCurrentEvaluatingProductId(String newCurrentEvaluatingProductId) {
    currentEvaluatingProductId = newCurrentEvaluatingProductId;
    logg('updated currentEvaluatingProductId: ' + currentEvaluatingProductId);
  }

  Future<void> removeFromFav(String itemId) async {
    emit(LoadingWishListDataState());
    await MainDioHelper.postData(
        url: removeProductFromWishListEnd,
        token: getCachedToken(),
        data: {
          'product_id': itemId,
        }).then((value) {
      getWishListProducts();

      emit(OrderCanceledSuccess());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
    });
  }

  void setNewRating(double newRating) {
    currentRating = newRating;
    logg('updated newRating: ' + currentRating.toString());
  }

  Future<void> sendAndSaveReview(String commentText) async {}

  Future<void> updateProfile(
      {required String code,
      required String dial,
      required String firstName,
      required String lastName,
      required String email,
      required String phoneNumber,
      required BuildContext context}) async {
    emit(LoadingState());
    logg(' Updating Profile ');
    await MainDioHelper.postData(
        url: updateProfileEP,
        token: getCachedToken(),
        data: {
          'f_name': firstName,
          'l_name': lastName,
          'email': email,
          'country_dial_code': dial,
          'phone': phoneNumber
        }).then((value) {
      logg('Profile updated');
      var authCubit = AuthCubit.get(context);
      authCubit.userInfoModel!.data!.fName = firstName;
      authCubit.userInfoModel!.data!.lName = lastName;
      authCubit.userInfoModel!.data!.email = email;
      authCubit.userInfoModel!.data!.phone = phoneNumber;
      saveCacheName(firstName);
      saveCacheEmail(email);
      saveCachePhoneDialCode(dial);
      saveCachePhoneCode(code);
      saveCachePhoneNumber(phoneNumber.substring(dial.length));
      MainCubit.get(context).getMainCacheUserData();
      emit(UpdateProfileSuccess());
      authCubit.emit(CheckingAuthStateDone());
    }).catchError((error) {
      logg(error.response.toString());
      emit(ErrorUpdateProfile(message: error.response.data['message']));
    });
  }

  Future<void> cancelOrder(String orderId) async {
    await MainDioHelper.postData(
        url: cancelOrderEnd,
        token: getCachedToken(),
        data: {
          'order_id': orderId,
        }).then((value) {
      logg('response value' + value.toString());
      getOrders().then((value) => applyOrdersListFilter('pending'));

      emit(OrderCanceledSuccess());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
    });
  }

  void applyOrdersListFilter(String filter) {
    logg('applying filter: ' + filter);
    if (orders == null) {
      logg('getting orders in applyOrdersListFilter');
      getOrders().then((value) => currentOrderList =
          orders!.where((element) => element.orderStatus == filter).toList());
    } else {
      currentOrderList =
          orders!.where((element) => element.orderStatus == filter).toList();
    }

    logg(currentOrderList.toString());
    emit(FilterApplied());
  }

  void resetOrdersModel() {
    ordersModel = null;
  }

  void changeAddressType(String newAddressType) {
    if (newAddressType != addressType) {
      addressType = newAddressType;
      emit(AddressTypeChanged());
    }
  }

  void changeCurrentOrderDetailsViewId(String newCurrentOrderDetailsViewId) {
    currentOrderDetailsViewId = newCurrentOrderDetailsViewId;
    emit(AddressTypeChanged());
  }

  Future<void> getWishListProducts() async {
    emit(LoadingWishListDataState());

    await MainDioHelper.getData(url: getWishListEnd, token: getCachedToken())
        .then((value) {
      logg('WishList got');
      wishListModel = WishList.fromJson(value.data);
      wishListProducts = wishListModel!.data;

      emit(WishListDataSuccessState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorWishListDataState());
    });
  }

  Future<void> getOrders() async {
    emit(LoadingOrdersState());

    await MainDioHelper.getData(url: getOrdersList, token: getCachedToken())
        .then((value) {
      logg('ordersList got');
      logg(value.toString());
      ordersModel = OrdersModel.fromJson(value.data);

      orders = ordersModel!.data;

      emit(OrdersListSuccessState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorLoadingDataState(msg: error.toString()));
    });
  }

  void updatePhoneNum(PhoneNumber newVal) {
    phoneNum = newVal.toString();
    logg('phoneNum:' + phoneNum);
  }

  Future<void> addNewAddress({
    required BuildContext context,
    required String contactPersonNAme,
    required String address,
    required String address2,
    required String city,
    required String phone,
    required String email,
    required String state,
    required String country,
  }) async {
    emit(SavingAddressState());
    await MainDioHelper.postData(
        url: addAddressEnd,
        token: getCachedToken(),
        data: {
          'contact_person_name': contactPersonNAme,
          'address_type': addressType,
          'address': address,
          'city': city,
          'zip': '752',
          'phone': phone,
          'email': email,
          'state': state,
          'country': country,
          'is_billing': '0',
          'is_default': '1'
        }).then((value) async {
      logg(value.toString());
      addressIdForPayment = value.data['data']['id'];
      await MainCubit.get(context).getAddresses();
      CartCubit.get(context).getCartDetails(updateAllList: true);

      emit(AddingAddressSuccessState(msg: value.data['message'].toString()));
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorLoadingDataState(msg: error.toString()));
    });
  }

  void getContactUsInformation() async {
    emit(LoadingContactUsDataState());
    await MainDioHelper.getData(
            url: getContactUsInfoEP, token: getCachedToken())
        .then((value) {
      contactUsModel = ContactUsModel.fromJson(value.data);
      emit(SuccessContactUsDataState());
    }).catchError((error) {
      logg('error in contact us');
      logg(error.toString());
      emit(FailureContactUsDataState());
    });
  }
}
