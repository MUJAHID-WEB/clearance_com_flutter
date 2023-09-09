import 'package:bloc/bloc.dart';
import 'package:clearance/models/api_models/coupon_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clearance/core/cache/cache.dart';
import 'package:clearance/models/api_models/cart_model.dart';

import '../../../../../core/constants/networkConstants.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/network/dio_helper.dart';
import '../../account/cubit/account_cubit.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartStates> {
  CartCubit() : super(CartInitialState());
  

  static CartCubit get(context) => BlocProvider.of(context);

  String? token;
  CartModel? cartModel;
  CouponModel? couponModel;
  bool isCouponStillAvailable=false;
  String currentRemovingItemId='';
  String currentMovingToWishListItemId='';
  String currentUpdatingQtyItemId='';
void disableCouponStillAvailable(){
  isCouponStillAvailable=false;
}
  Future<void> getCartDetails({
  required bool updateAllList,


}) async {
    token=getCachedToken();
    
    if(updateAllList) {
      emit(CartLoadingState());
    }
    else{


        emit(CartLoadingSuccessStateDidntUpdateAllList());
    }

    await MainDioHelper.getData(
        url: getCartWithEstimatedTaxEnd, token: token)
        .then((value) {
      logg('got cart');
      logg(value.toString());
      
      cartModel = CartModel.fromJson(value.data);

      logg('cart model filled');
      emit(CartLoadedSuccessState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorPlacingOrderState(error.response.toString()));
    });
  }

  Future<void> removeItem(String itemId)async{
    currentRemovingItemId=itemId;
    emit(RemovingCartItemState());





    await MainDioHelper.postData(
        url: removeCartItemEnd, token:  getCachedToken(),
        data: {
          'key': itemId,

        }
    )
        .then((value) {
      logg('success remove item from cart');
      logg(value.toString());
      isCouponStillAvailable=false;
      
      
      

     getCartDetails(updateAllList: false).then((value) {
       currentRemovingItemId='';
       emit(RemovingCartItemStateSuccessState());
     });

    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      currentRemovingItemId='';
      emit(ErrorRemovingCartItemState());
    });


  }

  Future<void> applyCoupon(String couponCode)async{

    emit(ApplyingCouponCode());
    await MainDioHelper.getData(
        url: applyCouponCodeEnd+'?code=$couponCode', token: token,
    )
        .then((value) {
      logg('success applied coupon');
      logg(value.toString());
      couponModel=CouponModel.fromJson(value.data);
      logg('couponModel.status'+couponModel!.status.toString());

      isCouponStillAvailable=true;
      
      
      
     getCartDetails(updateAllList: true,).then((value) {
       emit(CouponCodeAppliedSuccessfully());
     });

    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      currentRemovingItemId='';
      emit(ErrorRemovingCartItemState());
    });


  }



  Future<void> moveToWishList(String itemId,String productId , BuildContext context)async{
    currentMovingToWishListItemId=itemId;
    emit(MovingItemToWishListState());

    await MainDioHelper.postData(
        url: removeCartItemEnd, token:  getCachedToken(),
        data: {
          'key': itemId,

        }
    )
        .then((value) {
      logg('success move item from cart to wishlist');
      logg(value.toString());
      isCouponStillAvailable=false;
      
      
      

      

       MainDioHelper.postData(
          url: addProductToWishListEnd, token:  getCachedToken(),
          data: {
            'product_id': productId,

          }
      ).then((value) => logg('added to wishlist'));
      AccountCubit.get(context).getWishListProducts();
     getCartDetails(
       updateAllList: false,
     ).then((value) {
       currentMovingToWishListItemId='';
       emit(MovingItemToWishListSuccessState());
     });

    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      currentMovingToWishListItemId='';
      emit(ErrorMovingItemToWishListState());
    });


  }


  
  
  
  
  
  
  
  
  
  
  
  

  void updateQty(int index,String newQty,String currentItemEditedId) {
    currentUpdatingQtyItemId=currentItemEditedId;
    updateQtyInApi(
        cartModel!.data!.cart![index].id.toString(),newQty,)
        .then((value) {
      isCouponStillAvailable=false;
      
      

      return null;
    });
  }


  Future<void> updateQtyInApi(String itemId,String newQty)async{
    
    emit(EditingCartCountStatus());







    await MainDioHelper.postData(
        url: updateCartItemEnd, token:  getCachedToken(),
        data: {
          'key': itemId,
          'quantity': newQty,

        }
    )
        .then((value) {
      logg('success update item in cart');
      logg(value.toString());
      
      
      
      
      getCartDetails(
        updateAllList: false,
      ).then((value) {
        currentUpdatingQtyItemId='';
        emit(EditingCartCountSuccessStatus());
      });

    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorRemovingCartItemState());
    });


  }






}
