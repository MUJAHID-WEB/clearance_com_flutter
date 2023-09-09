
String liveClearanceUrl='https://www.clearance.ae/api';
String clearanceTestUrl='https://www.clearance.ae/test-app/api';


 String baseLink='https://www.clearance.ae';
 //String baseLink='https://staging.clearance.ae';
 String clearanceUrl='$baseLink/api';

///
///
String callSuccessPlaceOrderEnd='$baseLink/pay-telr/success';// should edit ###$$$$$$$$$$$$$$$$$$$
String callSuccessPlaceOrderPostPayEnd='$baseLink/post-pay/success';// should edit ###$$$$$$$$$$$$$$$$$$$
String callFailPlaceOrderEnd='$baseLink/pay-telr/fail';// should edit ###$$$$$$$$$$$$$$$$$$$
///
String successRedirectPayLink='$baseLink/pay-telr/success';
String successRedirectPostPayPayLink='$baseLink/post-pay/success';
String failRedirectPayLink='$baseLink/pay-telr/fail';
String failRedirectPostPayPayLink='$baseLink/post-pay/fail';
String backRedirectPayLink='$baseLink/pay-telr/back';
String backRedirectPpostPayPayLink='$baseLink/post-pay/back';

///
///
// end points

String configEnd='/v7/config';
String bannersEnd='/v7//banners?banner_type=main_banner';
String homeSectionAndroidEnd='/v7/android/products/home-sections-all/withColor';
String homeSectionIosEnd='/v7/iphone/products/home-sections-all/withColor';
String categoriesEnd='/v7/categories';
String productByCateIdEnd='/v7/categories/products/';
String filteredCategoryEndEnd='/v7/products';
String productDetailsEnd='/v7/products/details/';
String forgotPassEnd='/v7/auth/forgot-password';
String phoneLoginEnd='/v7/auth/phone/login';
String emailLoginEnd='/v7/auth/email/login';
String guestRegisterEnd='/v7/auth/register-guest';
String socialLoginEnd='/v7/auth/social-login';
String registerEnd='/v7/auth/register';
String newRegisterEnd='/v7/auth/register';
String userInfoEnd='/v7/customer/info';
String getContactUsInfoEP='/v7/android/information_contact_us';
String logOutEnd='/v7/auth/logout';
String deleteAccountEnd='/v7/auth/delete-account';
String verifyPhone='/v7/auth/firebase/verify-guest-phone';
String storeFcmToken='/v7/firebase_device_tokens';
String resetPasswordByPhone='/v7/phone/reset-password';
String updateProfileEP='/v7/customer/update-profile';
String emailCheckExistenceEP='/v7/email/check-existence/';
String phoneCheckExistenceEP='/v7/phone/check-existence/';
String sendOtpEP='/v7/phone/send_otp';
String verifyOtpEP='/v7/phone/verify_otp';
String appDesignConfiguration='/v7/app-design-configuration';
String getProductsForBrandPaginationEP='/v7/brands/brand-products-pagination';
String getProductsForFlashDealsPaginationEP='/v7/flash-deals/getProductsHasFlashDeals';

//cart
String addToCartEnd='/v7/cart/add';
String getCartEnd='/v7/cart';
String getCartWithEstimatedTaxEnd='/v7/cart/cart_shipping';
String removeCartItemEnd='/v7/cart/remove';
//address
String addressesListEnd='/v7/customer/address/list';
String addAddressEnd='/v7/customer/address/add';
String setDefaultAddress='/v7/customer/address/set-default';
String removeAddressEnd='/v7/customer/address/delete';
//wishlist
String addProductToWishListEnd='/v7/customer/wish-list/add';
String removeProductFromWishListEnd='/v7/customer/wish-list/remove';
String getWishListEnd='/v7/customer/wish-list';
//filters

String filtersEnd='/v7/products/filters';

//place order
String placeOrderEnd='/v7/customer/order/place';
//search
String autoCompleteSearchEnd='/v7/products/auto-complete';

String mainProductsEnd='/v7/products';

String updateCartItemEnd='/v7/cart/update';
///
///
///
///
///

//payment
String getPaymentLinkEnd='/v7/customer/order/pay-telr';
String getPaymentLinkPostPayEnd='/v7/customer/order/post-pay';

//coupon
String applyCouponCodeEnd='/v7/coupon/apply';

String getFeaturedProductsEnd='/v7/products/featured';
String getShoppingRequiredInformationForProductEnd='/v7/products/shopping-product-required-information/';

String addReviewEnd='/v7/products/reviews/submit';
String cancelOrderEnd='/v7/order/cancel-order';

String getOrdersList='/v7/customer/order/list';

//temp link
String bannerLink='https://md-admin.brainclick.org/public/animated-gif-email-example-01.gif';
String categoryOfferLink='https://md-admin.brainclick.org/public/offer.gif';
String firstAppScreenImage='https://clearance.ae/test-app/assets/img.jpeg';