
import 'package:clearance/core/cache/cache.dart';
import 'package:clearance/core/main_cubits/cubit_main.dart';
import 'package:clearance/modules/auth_screens/cubit/cubit_auth.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clearance/modules/main_layout/sub_layouts/main_payment/cubit/states_payment.dart';

import '../../../../../core/constants/networkConstants.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/network/dio_helper.dart';
import '../../../../../core/shared_widgets/payment.dart';
import '../../../../../models/local_models/local_models.dart';
import '../../account/cubit/account_cubit.dart';

class PaymentCubit extends Cubit<PaymentsStates> {
  PaymentCubit() : super(PaymentsStatesInitialize());

  static PaymentCubit get(context) => BlocProvider.of(context);
  bool isLoadingCard = true;
  String? selectedPaymentId='2';
  
  bool deliveryAtHomeDoor = true;
  bool deliveryTomorrow = false;
  String? token = getCachedToken();

  List<DeliveryMethodModel> deliveryMethods = [
    DeliveryMethodModel(
        id: 1,
        title: 'On door delivery',
        subTitle:
            'You wil find your product at your door and we will send a picture for you',
        isSelected: false),
    DeliveryMethodModel(
        id: 2,
        title: 'Deliver tomorrow',
        subTitle:
            'You wil find your product at your door and we will send a picture for you',
        isSelected: true),
    DeliveryMethodModel(
        id: 3,
        title: 'Express delivery',
        subTitle:
            'You wil find your product at your door and we will send a picture for you',
        isSelected: false),
  ];

  Future<void> initSelectedPaymentId() async{
    selectedPaymentId = '2';
    
  }

  void changeSelectedPaymentMethodId(String selectedId) {
    selectedPaymentId = selectedId;
    logg('selectedPaymentId' + selectedPaymentId!);
    
    emit(SelectedMethodChanged());
  }

  void changeDeliveryMethodId(String id) {
    if (deliveryMethods
            .firstWhere((element) => element.id.toString() == id)
            .isSelected ==
        false) {
      deliveryMethods
          .firstWhere((element) => element.id.toString() == id)
          .isSelected = true;
    } else {
      deliveryMethods
          .firstWhere((element) => element.id.toString() == id)
          .isSelected = false;
    }

    emit(SelectedMethodChanged());
  }

  String? paymentLink;


  Future<String?> callSucessPlaceOrder( String paymentMethod

      ) async {

    await MainDioHelper.getData(
      url: paymentMethod=='telr'?callSuccessPlaceOrderEnd:callSuccessPlaceOrderPostPayEnd,

      token: getCachedToken(),
    ).then((value) {
      logg('successPlaceOrderStatus= ' + value.toString());


    }).catchError((error) {
      logg(error.response.toString());
      emit(ErrorPaymentState(error.response.data['message'].toString()));
    });
  }
  Future<String?> callCanceledPlaceOrder(

      ) async {

    await MainDioHelper.postData(
      url: callFailPlaceOrderEnd,

      token: getCachedToken(),
    ).then((value) {
      logg('canceledPlaceOrderStatus= ' + value.toString());
    }).catchError((error) {
      logg(error.response.toString());
      emit(ErrorPaymentState(error.response.data['message'].toString()));
    });
  }
  void changeLoadingCardStatus(bool enableStatus) {

    isLoadingCard = enableStatus;

    emit(ChangeLoadingCardStatus());
  }

  Future<void> placeOrder(String defaultShippingAddress,String note,BuildContext context)async{
    logg('placing order');
    emit(PlacingOrderStateInPayment());
    await MainDioHelper.getData(url: placeOrderEnd+'?address_id=$defaultShippingAddress&order_note=$note',
      token: getCachedToken(),
    ).then((value){
      logg('placed order');
      MainCubit.get(context).getAddresses();
      emit(SuccessfullyOrderPlacedInPaymen());
      BlocProvider.of<CartCubit>(context).getCartDetails(updateAllList: true,);
      BlocProvider.of<CartCubit>(context).disableCouponStillAvailable();
      AuthCubit.get(context).checkUserAuth();
    }).catchError((error,st) {
      logg('an error occurred');
      if(error.response != null) {
        if (error.response.data['errors'][0]['code'] == 'user-not-verified') {
          emit(ErrorSendingPaymentData(error: 'user-not-verified'));
        }
        else {
          emit(ErrorSendingPaymentData(error: error.response.data['message']));
        }
      }
      else {
        emit(ErrorPlacingOrderStateInPayment('Something went wrong, please try again'));
      }
    });
  }
  Future<String?> getPaymentLinkAndRedirect( {

      required BuildContext context,
    required String paymentMethod,
      }
      ) async {
    paymentLink = null;
    emit(GettingPaymentLik());
    String addressId = (AccountCubit
        .get(context)
        .addressIdForPayment == 0 ? getCachedDefaultAddress()! : AccountCubit
        .get(context)
        .addressIdForPayment).toString();
    await MainDioHelper.getData(
      url: paymentMethod == 'telr' ? getPaymentLinkEnd
          + '?address_id=$addressId'
          : getPaymentLinkPostPayEnd + '?address_id=$addressId',
      token: getCachedToken(),
    ).then((value) {
      logg('val= ' + value.toString());
      paymentLink = value.data['data']['url'];
      if (paymentLink != null) {
        logg('pay link:' + paymentLink!);
        navigateTo(
            context,
            PaymentWebView(
              paymentLink: paymentLink!,
              paymentMethod: paymentMethod,
            )).then((value) {
              return null;
        }).catchError((error) {
          print(error);
          emit(ErrorSendingPaymentData(error: error.response.data['message']));
        });
      }
    }).catchError((error){
      print(error);
      if (error.response.data['errors'][0]['code'] == 'user-not-verified') {
        emit(ErrorSendingPaymentData(
            error: error.response.data['errors'][0]['code']));
        return;
      }
      emit(ErrorSendingPaymentData(error: error.response.data['message']));
    });
  }}
