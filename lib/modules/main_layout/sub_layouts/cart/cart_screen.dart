import 'package:clearance/modules/main_layout/sub_layouts/main_payment/cubit/cubit_payment.dart';
import 'package:clearance/modules/main_layout/sub_layouts/main_payment/cubit/states_payment.dart';
import 'package:clearance/modules/main_layout/sub_layouts/product_details/product_details_layout.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/constants/dimensions.dart';
import 'package:clearance/core/styles_colors/styles_colors.dart';
import '../../../../core/error_screens/errors_screens.dart';
import '../../../../core/error_screens/show_error_message.dart';
import '../../../../core/main_cubits/cubit_main.dart';
import '../../../../core/main_cubits/states_main.dart';
import '../../../../core/main_functions/main_funcs.dart';
import '../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../models/api_models/cart_model.dart';
import '../main_payment/main_payment.dart';
import 'cubit/cart_cubit.dart';
import 'cubit/cart_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // cartScrollController.addListener(pagination);
  }

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var mainCubit = MainCubit.get(context);
    String? token = mainCubit.token;

    logg('cart screen build');
    var cartCubit = CartCubit.get(context);
    if (cartCubit.cartModel == null) {
      cartCubit.getCartDetails(
        updateAllList: true,
      );
      cartCubit.disableCouponStillAvailable();
    }
    MainCubit.get(context).getAddresses();
    // return Container();

    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: const UserInfoAndNotificationAppBar(),
        ),
        body: ConditionalBuilder(
          condition: token != null,
          builder: (context) => BlocBuilder<CartCubit, CartStates>(
            builder: (context, state) => ConditionalBuilder(
              condition: cartCubit.cartModel != null,
              builder: (context) => ConditionalBuilder(
                condition: cartCubit.cartModel!.data!.cart!.isNotEmpty,
                builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    cartCubit.cartModel!.data!.restForFreeShipping! > 0
                        ? EnjoyFreeShippingWidget(
                            restValue: cartCubit
                                .cartModel!.data!.restForFreeShippingFormatted!)
                        : const SizedBox.shrink(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding:
                            //       EdgeInsets.symmetric(horizontal: 8.0.w),
                            //   child: Text(
                            //     'Shopping bag',
                            //     style: mainStyle(16.0, FontWeight.w700),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 15.h,
                            // ),
                            // Divider(
                            //   height: 5.h,
                            // ),
                            SizedBox(
                              height: 5.h,
                            ),
                            const CartItemsListView(
                              hideRemoveCauseYouAreInCheckOut: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                    DefaultContainer(
                      borderColor: Colors.grey.withOpacity(0.5),
                      radius: 20.0,
                      childWidget: Column(
                        children: [
                          // SizedBox(
                          //   height: 10.h,
                          // ),
                          const OrderSummaryWithoutDetails(
                            viewCoupon: true,
                            inPaymentScreen: false,
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     logg('tretyasgdhbf');
                          //     navigateToWithNavBar(context, PaymentMainLayout(),
                          //         PaymentMainLayout.routeName);
                          //   },
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(
                          //         horizontal: defaultHorizontalPadding * 3),
                          //     child: DefaultContainer(
                          //         height: 50.h,
                          //         width: double.infinity,
                          //         borderColor: primaryColor,
                          //         backColor: primaryColor,
                          //         childWidget: Center(
                          //           child: Text(
                          //             localizationStrings!.payment,
                          //             style: mainStyle(16.0, FontWeight.w600,
                          //                 color: Colors.white),
                          //           ),
                          //         )),
                          //   ),
                          // ),
                          SizedBox(
                            height: 15.h,
                          ),
                        ],
                      ),
                    ),
                    // const CartItemsListView(
                    //   hideRemoveCauseYouAreInCheckOut: false,
                    // ),
                    // SizedBox(
                    //   height: 10.h,
                    // ),
                  ],
                ),
                fallback: (_) => Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    EmptyError(),
                  ],
                )),
              ),
              fallback: (context) => Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 0.4.sh,
                  child: const DefaultLoader(),
                ),
              ),
            ),
          ),
          fallback: (context) => SizedBox(
              height: 400.h,
              child: const Center(child: Text('Login to view '))),
        ));
  }
}

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var mainCubit = MainCubit.get(context);

    return BlocBuilder<MainCubit, MainStates>(
      builder: (context, state) => Column(
        children: [
          ConditionalBuilder(
            condition: mainCubit.featuredProductsModel != null,
            builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultHorizontalPadding * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizationStrings!.productsYouMayLike,
                    style: mainStyle(16.0, FontWeight.w900),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ConditionalBuilder(
                    condition: mainCubit.featuredProducts.isNotEmpty,
                    builder: (context) => ProductsGridView(
                      isInHome: false,
                      crossAxisCount: 2,
                      towByTowJustTitle: false,
                      productsList: mainCubit.featuredProducts,
                    ),
                    fallback: (_) => const EmptyError(),
                  ),
                ],
              ),
            ),
            fallback: (_) => DefaultLoader(
              customHeight: 50.h,
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          state is LoadingFeaturedState
              ? SizedBox(
                  height: 30.h,
                  child: DefaultLoader(
                    customHeight: 30.h,
                  ),
                )
              : SizedBox(
                  height: 30.h,
                )
        ],
      ),
    );
  }
}

class OrderSummaryWithoutDetails extends StatelessWidget {
  const OrderSummaryWithoutDetails({
    Key? key,
    required this.viewCoupon,
    required this.inPaymentScreen,
  }) : super(key: key);
  final bool viewCoupon;
  final bool inPaymentScreen;

// wrap with consumer for update summary after applying coupon
  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var couponCont = TextEditingController();
    var cartCubit = CartCubit.get(context);
    var paymentCubit = PaymentCubit.get(context);
    return BlocBuilder<CartCubit, CartStates>(
      builder: (context, state) => ConditionalBuilder(
        condition: cartCubit.cartModel != null,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultHorizontalPadding * 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                viewCoupon
                    ? DefaultContainer(
                        height: 50.h,
                        borderColor: newSoftGreyColor,
                        childWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: SimpleLoginInputField(
                              controller: couponCont,
                              hintText: localizationStrings!.enterCoupon,
                              withoutBorders: true,
                              hintStyle: mainStyle(16.0, FontWeight.w300,
                                  color: Colors.grey),
                            )),
                            state is ApplyingCouponCode
                                ? SizedBox(
                                    height: 50.h,
                                    width: 65.w,
                                    child: const DefaultLoader(),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      cartCubit.applyCoupon(couponCont.text);
                                    },
                                    child: DefaultContainer(
                                      height: 50.h,
                                      width: 65.w,
                                      borderColor: primaryColor,
                                      backColor: primaryColor,
                                      childWidget: Center(
                                        child: Text(
                                          localizationStrings.apply,
                                          style: mainStyle(
                                              16.0, FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      )
                    : const SizedBox(),
                cartCubit.isCouponStillAvailable
                    ? Text(
                        cartCubit.couponModel!.messages.toString(),
                        softWrap: true,
                        style: mainStyle(14.0, FontWeight.w600,
                            color: cartCubit.couponModel!.status == 1
                                ? Colors.green
                                : Colors.red),
                      )
                    : const SizedBox(),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                cartCubit.cartModel!.data!.cart!.length
                                    .toString(),
                                style: mainStyle(16, FontWeight.bold),
                              ),
                              Text(
                                localizationStrings!.product_in_cart,
                                style: mainStyle(14, FontWeight.w400),
                              ),
                            ],
                          ),
                          Text(
                            localizationStrings.total +
                                ': ' +
                                ((cartCubit.cartModel!.data!.hasCod! &&
                                        paymentCubit.selectedPaymentId == '3' &&
                                        inPaymentScreen)
                                    ? (double.parse(cartCubit
                                                    .cartModel!.data!.total!
                                                    .toStringAsFixed(2)) +
                                                double.parse(cartCubit
                                                    .cartModel!.data!.codCost!
                                                    .toStringAsFixed(2)))
                                            .toString() +
                                        ' ' +
                                        localizationStrings.aed
                                    : cartCubit.cartModel!.data!.totalFormated
                                        .toString()),
                            style: mainStyle(14, FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          logg('tretyasgdhbf');
                          navigateToWithNavBar(
                              context,
                              const PaymentMainLayout(),
                              PaymentMainLayout.routeName);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultHorizontalPadding * 3),
                          child: DefaultContainer(
                              width: double.infinity,
                              height: 30.h,
                              borderColor: primaryColor,
                              backColor: primaryColor,
                              childWidget: Center(
                                child: Text(
                                  localizationStrings.payment,
                                  style: mainStyle(16.0, FontWeight.w600,
                                      color: Colors.white),
                                ),
                              )),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                if (DateTime.now().hour <= (closedHour ?? 14))
                  Container(
                    padding: EdgeInsets.all(5.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: priceColor,
                            blurRadius: 1,
                            offset: const Offset(0, 0),
                            spreadRadius: 0.5)
                      ],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      localizationStrings.order_delivered_tomorrow,
                      style:
                          mainStyle(16.0, FontWeight.bold, color: priceColor),
                      textAlign: TextAlign.start,
                    ),
                  ),
              ],
            ),
          );
        },
        fallback: (_) => const CircularProgressIndicator(),
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
   OrderSummary({
    Key? key,
    required this.viewCoupon,
    required this.inPaymentScreen,
  }) : super(key: key);
  final bool viewCoupon;
  final bool inPaymentScreen;
  final ValueNotifier<bool> showMore=ValueNotifier(false);
// wrap with consumer for update summary after applying coupon
  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var couponCont = TextEditingController();
    var cartCubit = CartCubit.get(context);
    var paymentCubit = PaymentCubit.get(context);
    return BlocBuilder<CartCubit, CartStates>(
      builder: (context, state) => ConditionalBuilder(
        condition: cartCubit.cartModel != null,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultHorizontalPadding * 3),
            child: ValueListenableBuilder<bool>(
              valueListenable: showMore,
              builder: (context,showMoreValue,_) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    GestureDetector(
                      onTap: (){
                        showMore.value=!showMore.value;
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          !showMoreValue ? localizationStrings!.showMore : localizationStrings!.showLess,
                          style: mainStyle(16.0, FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Column(
                      children: [
                        showMoreValue ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizationStrings.orderSummary,
                              style: mainStyle(16.0, FontWeight.w300),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TableTwoValues(
                              mainKey: localizationStrings.subTotal,
                              value: cartCubit.cartModel!.data!.subTotalFormated
                                  .toString(),
                            ),
                            TableTwoValues(
                              mainKey: localizationStrings.discount,
                              value: '- ' +
                                  cartCubit
                                      .cartModel!.data!.totalDiscountOnProductFormated
                                      .toString(),
                            ),
                            TableTwoValues(
                              mainKey: localizationStrings.couponDiscount,
                              value: '- ' +
                                  cartCubit.cartModel!.data!.couponDiscountFormated
                                      .toString(),
                            ),
                            TableTwoValues(
                              mainKey: localizationStrings.estimated_tax,
                              value: cartCubit.cartModel!.data!.estimatedTaxFormatted
                                  .toString(),
                            ),
                            TableTwoValues(
                              mainKey: localizationStrings.shipping,
                              value: '+ ' +
                                  cartCubit.cartModel!.data!.totalShippingCostFormated
                                      .toString(),
                            ),
                          ],
                        ): const SizedBox.shrink(),
                        BlocBuilder<PaymentCubit, PaymentsStates>(
                          builder: (context, state) {
                            return Column(
                              children: [
                               showMoreValue ? (cartCubit.cartModel!.data!.hasCod! &&
                                        paymentCubit.selectedPaymentId == '3' &&
                                        inPaymentScreen)
                                    ? TableTwoValues(
                                        mainKey: localizationStrings.tolls,
                                        mainKeyStyle:
                                            mainStyle(14.0, FontWeight.w300),
                                        value: '+ ' +
                                            cartCubit
                                                .cartModel!.data!.codCostFormatted
                                                .toString(),
                                      )
                                    : const SizedBox.shrink() :const SizedBox.shrink(),
                                Divider(color: newSoftGreyColor),
                                TableTwoValues(
                                  mainKey: localizationStrings.total,
                                  makeBold: true,
                                  subKey: localizationStrings.includesTax,
                                  mainKeyStyle: mainStyle(14.0, FontWeight.w700),
                                  value: (cartCubit.cartModel!.data!.hasCod! &&
                                          paymentCubit.selectedPaymentId == '3' &&
                                          inPaymentScreen)
                                      ? (double.parse(cartCubit
                                                      .cartModel!.data!.total!
                                                      .toStringAsFixed(2)) +
                                                  double.parse(cartCubit
                                                      .cartModel!.data!.codCost!
                                                      .toStringAsFixed(2)))
                                              .toString() +
                                          ' ' +
                                          localizationStrings.aed
                                      : cartCubit.cartModel!.data!.totalFormated
                                          .toString(),
                                ),
                              ],
                            );
                          },
                        ),
                        if (DateTime.now().hour >= (closedHour ?? 14))
                          Container(
                            padding: EdgeInsets.all(5.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: priceColor,
                                    blurRadius: 1,
                                    offset: const Offset(0, 0),
                                    spreadRadius: 0.5)
                              ],
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              localizationStrings.order_delivered_tomorrow,
                              style: mainStyle(16.0, FontWeight.bold,
                                  color: priceColor),
                              textAlign: TextAlign.start,
                            ),
                          ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 15.h,
                    // ),
                    SizedBox(
                      height: 10.h,
                    ),
                    viewCoupon
                        ? DefaultContainer(
                            height: 50.h,
                            borderColor: newSoftGreyColor,
                            childWidget: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: SimpleLoginInputField(
                                  controller: couponCont,
                                  hintText: localizationStrings.enterCoupon,
                                  withoutBorders: true,
                                  hintStyle: mainStyle(16.0, FontWeight.w300,
                                      color: Colors.grey),
                                )),
                                state is ApplyingCouponCode
                                    ? SizedBox(
                                        height: 50.h,
                                        width: 65.w,
                                        child: const DefaultLoader(),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          cartCubit.applyCoupon(couponCont.text);
                                        },
                                        child: DefaultContainer(
                                          height: 50.h,
                                          width: 65.w,
                                          borderColor: primaryColor,
                                          backColor: primaryColor,
                                          childWidget: Center(
                                            child: Text(
                                              localizationStrings.apply,
                                              style: mainStyle(
                                                  16.0, FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          )
                        : const SizedBox(),
                    cartCubit.isCouponStillAvailable
                        ? Text(
                            cartCubit.couponModel!.messages.toString(),
                            softWrap: true,
                            style: mainStyle(14.0, FontWeight.w600,
                                color: cartCubit.couponModel!.status == 1
                                    ? Colors.green
                                    : Colors.red),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                );
              }
            ),
          );
        },
        fallback: (_) => const CircularProgressIndicator(),
      ),
    );
  }
}

class TableTwoValues extends StatelessWidget {
  const TableTwoValues({
    Key? key,
    required this.mainKey,
    this.makeBold = false,
    required this.value,
    this.subKey,
    this.mainKeyStyle,
  }) : super(key: key);
  final bool makeBold;
  final String mainKey;
  final String? subKey;
  final String value;
  final TextStyle? mainKeyStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          subKey == null
              ? Text(
                  mainKey,
                  style: mainKeyStyle ?? mainStyle(16.0, FontWeight.w300),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mainKey,
                      style: mainKeyStyle ?? mainStyle(16.0, FontWeight.w300),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    // Text(
                    //   subKey!,
                    //   style: mainStyle(16.0, FontWeight.w300),
                    // ),
                  ],
                ),
          subKey == null
              ? Text(
                  value,
                  // textAlign: TextAlign.start,
                  style: mainStyle(
                      16.0, makeBold ? FontWeight.w700 : FontWeight.w300,
                      color:
                          value.startsWith('-') ? primaryColor : Colors.black),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      // textAlign: TextAlign.start,
                      style: mainStyle(
                          16.0, makeBold ? FontWeight.w700 : FontWeight.w300),
                    ),
                    Text(
                      subKey!,
                      style: mainStyle(
                          16.0, makeBold ? FontWeight.w700 : FontWeight.w300),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}

class CartItemsListView extends StatelessWidget {
  const CartItemsListView(
      {Key? key, required this.hideRemoveCauseYouAreInCheckOut})
      : super(key: key);
  final bool hideRemoveCauseYouAreInCheckOut;

  @override
  Widget build(BuildContext context) {
    var cartCubit = CartCubit.get(context);
    List<Cart>? cartItems = [];
    return BlocConsumer<CartCubit, CartStates>(
      listener: (context, state) {},
      builder: (context, state) {
        logg('cart consumer build');

        return Column(
          children: [
            // SortByElement(),
            ConditionalBuilder(
              condition: state is! CartLoadingState,
              builder: (context) {
                cartItems = List.of(cartCubit.cartModel!.data!.cart ?? []);
                return ConditionalBuilder(
                  condition: cartItems!.isNotEmpty,
                  builder: (context) => ListView.separated(
                    itemCount: cartItems!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0,
                        horizontal: defaultHorizontalPadding * 3),
                    itemBuilder: (context, index) =>
                        //
                        //
                        InkWell(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (_)=> ProductDetailsLayout(
                              productId:cartItems![index].productId.toString() ,
                            )));
                          },
                          child: CartItemBuilder(
                              hideRemoveCauseYouAreInCheckOut:
                                  hideRemoveCauseYouAreInCheckOut,
                              cartItem: cartItems![index],
                              itemIndex: index),
                        ),
                    //
                    //
                    scrollDirection: Axis.vertical,
                    separatorBuilder: (context, index) => Divider(
                      height: 15.h,
                      thickness: 3.h,
                      color: primaryColor,
                    ),
                  ),
                  fallback: (context) => const Center(child: EmptyError()),
                );
              },
              fallback: (context) => Center(
                child: DefaultLoader(
                  customWidth: 50.w,
                  customHeight: 50.w,
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            )
          ],
        );
      },
    );
  }
}

class CartItemBuilder extends StatelessWidget {
  const CartItemBuilder({
    Key? key,
    required this.cartItem,
    required this.itemIndex,
    required this.hideRemoveCauseYouAreInCheckOut,
  }) : super(key: key);

  final Cart cartItem;
  final int itemIndex;
  final bool hideRemoveCauseYouAreInCheckOut;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var cartCubit = CartCubit.get(context);
    Map<String, dynamic>? variations;
    if (cartItem.variations!.runtimeType != List<dynamic>) {
      logg('current cart item variation: ');
      variations = cartItem.variations;
      logg(variations.toString());
    } else {
      variations = null;
    }
    if (cartItem.quantity! > cartItem.availableQuantity!) {
      cartItem.quantity = cartItem.availableQuantity;
    }
    return BlocBuilder<CartCubit, CartStates>(
      builder: (context, state) => Container(
        padding: EdgeInsets.all(4.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultImage(
                  backGroundImageUrl: cartItem.thumbnail,
                  width: 100.w,
                  height: 130.h,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.name!,
                        maxLines: 3,
                        style: mainStyle(
                          14.0,
                          FontWeight.w600,
                        ),
                      ),
                      if (cartItem.variant != "") ...{
                        SizedBox(
                          height: 10.h,
                        ),
                        IntrinsicHeight(
                          child: IntrinsicWidth(
                            child: Container(
                              decoration:
                                  BoxDecoration(color: newSoftGreyColor),
                              padding: EdgeInsets.all(2.r),
                              child: Center(
                                child: Text(
                                  cartItem.variant.toString(),
                                  style: mainStyle(14.0, FontWeight.w200,
                                      fontFamily: 'poppins'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      },
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Text(
                            cartItem.price.toString(),
                            textAlign: TextAlign.center,
                            style: mainStyle(16.0, FontWeight.w600,
                                fontFamily: 'poppins',
                                decoration: TextDecoration.lineThrough,
                                decorationThickness: 2),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Text(
                            cartItem.offerPriceFormatted.toString(),
                            style: mainStyle(16.0, FontWeight.w600,
                                color: primaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            hideRemoveCauseYouAreInCheckOut
                ? const SizedBox()
                : Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                if ((cartItem.quantity! - 1) > 0) {
                                  cartCubit.updateQty(
                                      itemIndex,
                                      (cartItem.quantity! - 1).toString(),
                                      cartItem.id.toString());
                                }
                              },
                              child: Container(
                                width: 25.w,
                                height: 25.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Colors.grey),
                                  color: newSoftGreyColorAux,
                                ),
                                child: Center(
                                  child: Text(
                                    '-',
                                    style: mainStyle(14, FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 25.w,
                              height: 25.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: cartCubit.currentUpdatingQtyItemId ==
                                        cartItem.id.toString()
                                    ? DefaultLoader(
                                        customWidth: 25.w,
                                        customHeight: 25.h,
                                      )
                                    : Text(
                                        cartItem.quantity.toString(),
                                        style: mainStyle(14, FontWeight.bold,
                                            fontFamily: 'poppins',
                                            color: Colors.grey),
                                      ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if ((cartItem.quantity! + 1) <=
                                    cartItem.availableQuantity!) {
                                  cartCubit.updateQty(
                                      itemIndex,
                                      (cartItem.quantity! + 1).toString(),
                                      cartItem.id.toString());
                                } else {
                                  showTopModalSheetErrorMessage(
                                      context,
                                      localizationStrings!
                                          .max_quantity_reached);
                                }
                              },
                              child: Container(
                                width: 25.w,
                                height: 25.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Colors.grey),
                                  color: newSoftGreyColorAux,
                                ),
                                child: Center(
                                  child: Text(
                                    '+',
                                    style: mainStyle(14, FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            cartCubit.moveToWishList(cartItem.id.toString(),
                                cartItem.productId.toString(),context);
                          },
                          child: Container(
                              height: 25.w,
                              padding: EdgeInsets.all(2.r),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: Colors.indigo),
                              ),
                              child: Center(
                                child: (state is MovingItemToWishListState &&
                                        cartCubit
                                                .currentMovingToWishListItemId ==
                                            cartItem.id.toString())
                                    ? DefaultLoader(
                                        customWidth: 25.w,
                                        customHeight: 25.h,
                                      )
                                    : Text(
                                        localizationStrings!.moveToWishList,
                                        style: mainStyle(14, FontWeight.bold,
                                            color: Colors.indigo,
                                            fontFamily: 'poppins'),
                                      ),
                              )),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            cartCubit.removeItem(cartItem.id.toString());
                          },
                          child: Container(
                              padding: EdgeInsets.all(2.r),
                              height: 25.w,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: Colors.pinkAccent.withOpacity(0.05)),
                              child: Center(
                                child: state is RemovingCartItemState && cartCubit.currentRemovingItemId==cartItem.id.toString()
                                    ? DefaultLoader(
                                        customWidth: 25.w,
                                        customHeight: 25.h,
                                      )
                                    : Text(
                                        localizationStrings!.remove,
                                        style: mainStyle(14, FontWeight.bold,
                                            color: Colors.red,
                                            fontFamily: 'poppins'),
                                      ),
                              )),
                        ),
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}

// class CartItemBuilder extends StatelessWidget {
//   const CartItemBuilder({
//     Key? key,
//     required this.cartItem,
//     required this.itemIndex,
//     required this.hideRemoveCauseYouAreInCheckOut,
//   }) : super(key: key);
//
//   final Cart cartItem;
//   final int itemIndex;
//   final bool hideRemoveCauseYouAreInCheckOut;
//
//   @override
//   Widget build(BuildContext context) {
//     var localizationStrings = AppLocalizations.of(context);
//     var cartCubit = CartCubit.get(context);
//     Map<String, dynamic>? variations;
//
//     logg('getting variation because type may change in json');
//
// // if changed to null change this condition to null
//     if (cartItem.variations!.runtimeType != List<dynamic>) {
//       logg('current cart item variation: ');
//       variations = cartItem.variations;
//       logg(variations.toString());
//     } else {
//       variations = null;
//     }
//
//     List<String> availableQuantities = [];
//     for (int i = 1; i <= cartItem.availableQuantity!; i++) {
//       availableQuantities.add(i.toString());
//     }
//     if(cartItem.quantity! > cartItem.availableQuantity!){
//       cartItem.quantity=cartItem.availableQuantity;
//     }
//
//     return BlocConsumer<CartCubit, CartStates>(
//       listener: (context, state) {},
//       builder: (context, state) => Column(
//         children: [
//           Row(
//             children: [
//               // SizedBox(
//               //   width: 10.w,
//               // ),
//               Expanded(
//                 // width: 180.w,
//                 child: SizedBox(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     mainAxisSize: MainAxisSize.max,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         cartItem.name!,
//                         style: mainStyle(
//                           14.0,
//                           FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10.h,
//                       ),
//                       Text(
//                         cartItem.variant.toString(),
//                         style: mainStyle(14.0, FontWeight.w200),
//                       ),
//
//                       SizedBox(
//                         height: 10.h,
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             localizationStrings!.price + ': '.toString(),
//                             style: mainStyle(14.0, FontWeight.w600),
//                           ),
//                           Text(
//                             cartItem.price
//                                 .toString(),
//                             textAlign: TextAlign.center,
//                             style: mainStyle(14.0, FontWeight.w600,
//                                 fontFamily: 'poppins',
//                                 decoration: TextDecoration.lineThrough,
//                                 decorationThickness: 2
//                             ),
//                           ),
//                           SizedBox(
//                             width: 3.w,
//                           ),
//                           Text(
//                             cartItem.offerPriceFormatted.toString(),
//                             style: mainStyle(14.0, FontWeight.w600,
//                                 color: primaryColor),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10.h,
//                       ),
//                       Text(
//                         localizationStrings.soldBy +
//                             cartItem.shop!.name.toString(),
//                         style: mainStyle(14.0, FontWeight.w200),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10.w,
//               ),
//               DefaultImage(
//                 backGroundImageUrl: cartItem.thumbnail,
//                 width: 80.w,
//                 height: 90.w,
//                 borderColor: Colors.transparent,
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 10.h,
//           ),
//           hideRemoveCauseYouAreInCheckOut
//               ? SizedBox()
//               : Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Row(
//                         children: [
//                           Text(
//                             localizationStrings.quantity,
//                             style: mainStyle(14.0, FontWeight.w600),
//                           ),
//
//                           cartCubit.currentUpdatingQtyItemId ==
//                                   cartItem.id.toString()
//                               ? DefaultLoader(
//                                   customWidth: 35.w,
//                                   customHeight: 25.h,
//                                 )
//                               : DropdownButtonHideUnderline(
//                                   child: SizedBox(
//                                     width: 45.w,
//                                     height: 25.h,
//                                     child: DropdownButton<String>(
//                                         items: availableQuantities
//                                             .map<DropdownMenuItem<String>>(
//                                                 (String value) {
//                                           return DropdownMenuItem<String>(
//                                             value: value,
//                                             child: Center(
//                                                 child: Text(
//                                               value,
//                                               style: mainStyle(
//                                                   16.0, FontWeight.w600),
//                                             )),
//                                           );
//                                         }).toList(),
//                                         value: cartItem.quantity.toString(),
//                                         isExpanded: true,
//                                         onChanged: (val) {
//                                           cartCubit.updateQty(itemIndex, val!,
//                                               cartItem.id.toString());
//                                         }),
//                                   ),
//                                 ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 4.0.w),
//                             child: Center(
//                               child: Text(
//                                 ' / ' + cartItem.availableQuantity.toString(),
//                                 style: mainStyle(14.0, FontWeight.w600),
//                               ),
//                             ),
//                           ),
//                           // Icon(
//                           //   Icons.arrow_drop_down_sharp,
//                           //   color: Colors.black,
//                           //   size: 18.0.sp,
//                           // )
//                         ],
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         ConditionalBuilder(
//                           condition: cartCubit.currentMovingToWishListItemId !=
//                               cartItem.id.toString(),
//                           builder: (context) => SizedBox(
//                             width: 120.w,
//                             child: GestureDetector(
//                               onTap: () {
//                                 cartCubit.moveToWishList(cartItem.id.toString(),
//                                     cartItem.productId.toString());
//                               },
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   SizedBox(
//                                     width: 20.w,
//                                     height: 20.w,
//                                     child: Padding(
//                                       padding: EdgeInsets.all(1.0.sp),
//                                       child: Icon(
//                                         Icons.favorite_border,
//                                         size: 18.sp,
//                                       ),
//                                     ),
//                                   ),
//                                   Text(
//                                     localizationStrings.moveToWishList,
//                                     style: mainStyle(14.0, FontWeight.w200,
//                                         textHeight: 1),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           fallback: (context) => DefaultLoader(
//                             customWidth: 120.w,
//                             customHeight: 20.w,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 2.0),
//                           child: Container(
//                             color: Colors.grey,
//                             width: 1.w,
//                             height: 20.w,
//                           ),
//                         ),
//                         hideRemoveCauseYouAreInCheckOut
//                             ? const SizedBox()
//                             : ConditionalBuilder(
//                                 condition: cartCubit.currentRemovingItemId !=
//                                     cartItem.id.toString(),
//                                 builder: (context) => SizedBox(
//                                   width: 60.w,
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       cartCubit
//                                           .removeItem(cartItem.id.toString());
//                                     },
//                                     child: SizedBox(
//                                       child: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: [
//                                           SizedBox(
//                                             width: 18.w,
//                                             height: 18.w,
//                                             child: Padding(
//                                               padding: EdgeInsets.all(1.0.sp),
//                                               child: SvgPicture.asset(
//                                                 'assets/images/public/icons8_trash_can_1.svg',
//                                               ),
//                                             ),
//                                           ),
//                                           Text(
//                                             localizationStrings.remove,
//                                             style: mainStyle(
//                                                 12.0, FontWeight.w200,
//                                                 textHeight: 1),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 fallback: (context) => DefaultLoader(
//                                   customWidth: 60.w,
//                                   customHeight: 20.w,
//                                 ),
//                               )
//                       ],
//                     ),
//                   ],
//                 ),
//         ],
//       ),
//     );
//   }
// }

class SortByElement extends StatelessWidget {
  const SortByElement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Sort by: ',
          style: mainStyle(13.0, FontWeight.w200),
        ),
        Text(
          'Selected one',
          style: mainStyle(13.0, FontWeight.w900),
        ),
      ],
    );
  }
}

class DefaultLoader extends StatelessWidget {
  const DefaultLoader({Key? key, this.customWidth, this.customHeight})
      : super(key: key);
  final double? customWidth;
  final double? customHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: customWidth ?? 55.w,
      height: customHeight ?? MediaQuery.of(context).size.height * 0.2,
      child: Image.asset(
        'assets/images/public/clearance.gif',
        height: customHeight ?? MediaQuery.of(context).size.height * 0.2,
      ),
    );
  }
}

class DefaultColoredLoader extends StatelessWidget {
  const DefaultColoredLoader({Key? key, this.customWidth, this.customHeight})
      : super(key: key);
  final double? customWidth;
  final double? customHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: customWidth ?? 55.w,
      height: customHeight ?? 20.h,
      child: Image.asset(
        'assets/images/public/clearance.gif',
      ),
    );
  }
}
