import 'dart:io';

import 'package:clearance/core/error_screens/show_error_message.dart';
import 'package:clearance/modules/auth_screens/guest_verification_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert' as convert;
import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/main_cubits/cubit_main.dart';
import 'package:clearance/core/main_cubits/states_main.dart';
import 'package:clearance/core/main_functions/main_funcs.dart';
import 'package:clearance/core/shared_widgets/shared_widgets.dart';
import 'package:clearance/core/styles_colors/styles_colors.dart';
import 'package:clearance/models/local_models/local_models.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cubit/cart_cubit.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cubit/cart_state.dart';
import 'package:clearance/modules/main_layout/sub_layouts/main_payment/cubit/states_payment.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

import '../../../../core/cache/cache.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/error_screens/errors_screens.dart';
import '../../../../models/api_models/addresses_model.dart';
import '../../../../models/api_models/starting_setting_model.dart';
import '../../../auth_screens/cubit/cubit_auth.dart';
import '../account/cubit/account_cubit.dart';
import '../account/sub_account/add_new_address.dart';
import '../account/sub_account/addresses.dart';
import '../cart/cart_screen.dart';
import 'cubit/cubit_payment.dart';

class PaymentMainLayout extends StatelessWidget {
  const PaymentMainLayout({Key? key}) : super(key: key);
  static String routeName = 'PaymentMainLayoutRoute';

  @override
  Widget build(BuildContext context) {
    var cartCubit = CartCubit.get(context)
      ..disableCouponStillAvailable();
    var paymentCubit = PaymentCubit.get(context);
    var mainCubit = MainCubit.get(context);
    var localizationStrings = AppLocalizations.of(context);
    var notesController = TextEditingController();
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: const DefaultAppBarWithOnlyBackButton(),
        ),
        body: BlocConsumer<PaymentCubit, PaymentsStates>(
          listener: (context, state) {
            if (state is ErrorPlacingOrderStateInPayment) {
              showTopModalSheetErrorMessage(context,state.error.toString());
            }
            if (state is ErrorSendingPaymentData &&
                state.error != 'user-not-verified') {
              showTopModalSheetErrorMessage(context,state.error.toString());
            }
            if (state is SuccessfullyOrderPlacedInPaymen) {
              showTopModalSheet<String>(context, Builder(builder: (context) {
                return Container(
                  color: Colors.white.withOpacity(0.8),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 25.w,
                                    width: 25.w,
                                    child: Lottie.asset(
                                        'assets/images/public/lf30_editor_c6ebyow8.json',
                                        width: 50.w,
                                        height: 50.w),
                                  ),
                                  SizedBox(
                                    width: 25.w,
                                  ),
                                  Text(
                                    localizationStrings!
                                        .yourOrderPlacedSuccessfully,
                                    style: mainStyle(15.0, FontWeight.w600),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30.h,),
                              SizedBox(
                                width: 0.6.sw,
                                child: DefaultButton(
                                  title: localizationStrings.find_more_deals,
                                  onClick: () {
                                    Navigator.pop(context);
                                    mainCubit.navigateToTap(0);
                                  },),
                              )
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CacheHelper.getData(key: 'rectangularCurvedLogoUrl') == null
                            ? Image.asset(
                          'assets/icons/clearance2.png',
                          height: 0.15.sh,
                          width: 0.5.sw,
                        )
                            : Image.file(
                          File(CacheHelper.getData(
                              key: 'rectangularCurvedLogoUrl')),
                          height: 0.15.sh,
                          width: 0.5.sw,
                        ),
                      )
                    ],
                  ),
                );
              }));
            }
          },
          builder: (context, state) {
            return BlocBuilder<CartCubit, CartStates>(
              builder: (context, state) =>
              cartCubit.cartModel == null
                  ? const Center(child: DefaultLoader())
                  : ConditionalBuilder(
                condition: cartCubit.cartModel!.data!.cart!.isNotEmpty,
                builder: (context) =>
                    Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    const PaymentMethods(),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Divider(
                                      height: 10.h,
                                    ),
                                    BlocBuilder<MainCubit, MainStates>(
                                      builder: (context, state) =>
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 30.0.w),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 15.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      localizationStrings!
                                                          .shippingTo,
                                                      style: mainStyle(
                                                          16.0,
                                                          FontWeight.w700),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          buildShowModalBottomSheet(
                                                              context,
                                                              body: Container(
                                                                color:
                                                                Colors.white,
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                        20.0.w),
                                                                    child: Column(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                      children: <
                                                                          Widget>[
                                                                        ConditionalBuilder(
                                                                          condition:
                                                                          mainCubit
                                                                              .addressesModel !=
                                                                              null,
                                                                          builder:
                                                                              (
                                                                              context) {
                                                                            List<
                                                                                Address>
                                                                            addresses =
                                                                            mainCubit
                                                                                .addressesModel!
                                                                                .data!;
                                                                            return addresses
                                                                                .isNotEmpty
                                                                                ? ConditionalBuilder(
                                                                              condition: mainCubit
                                                                                  .addressesModel!
                                                                                  .data!
                                                                                  .isNotEmpty,
                                                                              builder: (
                                                                                  context) =>
                                                                                  Expanded(
                                                                                    child: SingleChildScrollView(
                                                                                      child: Column(
                                                                                        children: [
                                                                                          ListView
                                                                                              .separated(
                                                                                            itemCount: addresses
                                                                                                .length,
                                                                                            shrinkWrap: true,
                                                                                            physics: const NeverScrollableScrollPhysics(),
                                                                                            itemBuilder: (
                                                                                                context,
                                                                                                index) =>
                                                                                                AddressItem(
                                                                                                    notInAddressListJustForView: true,
                                                                                                    inBottomModalSheet: true,
                                                                                                    localizationStrings: localizationStrings,
                                                                                                    address: addresses[index]),
                                                                                            scrollDirection: Axis
                                                                                                .vertical,
                                                                                            separatorBuilder: (
                                                                                                context,
                                                                                                index) =>
                                                                                                Container(
                                                                                                  color: Colors
                                                                                                      .grey,
                                                                                                  height: 1
                                                                                                      .h,
                                                                                                ),
                                                                                          ),
                                                                                          Container(
                                                                                            height: 1
                                                                                                .h,
                                                                                            color: Colors
                                                                                                .grey,
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                              fallback: (
                                                                                  context) => const EmptyError(),
                                                                            )
                                                                                : const EmptyError();
                                                                          },
                                                                          fallback:
                                                                              (
                                                                              _) =>
                                                                          const DefaultLoader(),
                                                                        ),
                                                                        state is RemovingAddressState
                                                                            ? const LinearProgressIndicator()
                                                                            : const SizedBox(),
                                                                        SizedBox(
                                                                          height:
                                                                          12.h,
                                                                        ),
                                                                        DefaultButton(
                                                                            onClick:
                                                                                () {
                                                                              navigateToWithNavBar(
                                                                                  context,
                                                                                  const AddNewAddress(),
                                                                                  AddNewAddress
                                                                                      .routeName);
                                                                            },
                                                                            title:
                                                                            localizationStrings
                                                                                .addNewAddress),
                                                                        SizedBox(
                                                                          height:
                                                                          25.h,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ));
                                                        },
                                                        child: Text(
                                                          localizationStrings
                                                              .changeAddress,
                                                          style: mainStyle(12.0,
                                                              FontWeight.w600,
                                                              color:
                                                              primaryColor),
                                                        ))
                                                  ],
                                                ),
                                                mainCubit
                                                    .getDefaultShippingAddressItemValues()!
                                                    .id !=
                                                    0
                                                    ? AddressItem(
                                                  address: mainCubit
                                                      .getDefaultShippingAddressItemValues()!,
                                                  localizationStrings:
                                                  localizationStrings,
                                                  inBottomModalSheet: false,
                                                  notInAddressListJustForView:
                                                  true,
                                                )
                                                    : Text(
                                                  localizationStrings
                                                      .pleaseAddDefaultAddress,
                                                  style: mainStyle(14.0,
                                                      FontWeight.w300),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                              ],
                                            ),
                                          ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Divider(
                                      height: 5.h,
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
                                      child: SimpleLoginInputField(
                                        controller: notesController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        hintText: localizationStrings!.lbl_note,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.h,
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
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  BlocBuilder<CartCubit, CartStates>(
                                    builder: (context, state) {
                                      return  OrderSummary(
                                        viewCoupon: false,
                                        inPaymentScreen: true,
                                      );
                                    },
                                  ),
                                  BlocConsumer<PaymentCubit, PaymentsStates>(
                                    listener: (previous, current) {
                                      if (current is ErrorSendingPaymentData) {
                                        if (current.error ==
                                            'user-not-verified') {
                                          navigateToWithoutNavBar(
                                              context,
                                              Builder(
                                                  builder: (ctx) =>
                                                  const GuestVerificationScreen()),
                                              GuestVerificationScreen
                                                  .routeName);
                                          return;
                                        }
                                      }
                                    },
                                    builder: (_, state) {
                                      return GestureDetector(
                                        onTap: () {
                                          paymentTransaction(
                                              paymentCubit, localizationStrings,
                                              notesController.text,
                                              mainCubit, context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                              defaultHorizontalPadding *
                                                  3),
                                          child:
                                          state is PlacingOrderStateInPayment ||
                                              state
                                              is GettingPaymentLik
                                              ? DefaultLoader(
                                            customHeight: 50.h,
                                          )
                                              : DefaultContainer(
                                              height: 50.h,
                                              width: double.infinity,
                                              borderColor:
                                              primaryColor,
                                              backColor:
                                              primaryColor,
                                              childWidget: Center(
                                                child: Text(
                                                  localizationStrings.placeOrder,
                                                  style: mainStyle(
                                                      16.0,
                                                      FontWeight.w600,
                                                      color: Colors
                                                          .white),
                                                ),
                                              )),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                fallback: (_) =>
                    Column(
                      children: [
                        SizedBox(
                          height: 65.h,
                        ),
                        const Center(child: EmptyError()),
                      ],
                    ),
              ),
            );
          },
        ));
  }

  paymentTransaction(PaymentCubit paymentCubit, localizationStrings,String note,
      MainCubit mainCubit, context) {
    logg(
        'paymentCubit.selectedPaymentId+=' +
            paymentCubit
                .selectedPaymentId
                .toString());
    logg('shipping address selected. navigating to place order');
    if ((AuthCubit
        .get(context)
        .userInfoModel!
        .data!
        .isVerifiedEmail == 1 || AuthCubit
        .get(context)
        .userInfoModel!
        .data!
        .isVerifiedPhone == 1 || AuthCubit
        .get(context).verifiedNow) &&
        mainCubit.getDefaultShippingAddressItemValues()!.id == 0) {
      chooseAddress(mainCubit, localizationStrings, context);
      return;
    }
    if (paymentCubit.selectedPaymentId == '3') {
      logg('paymentCubit.selectedPaymentId is 3');
      paymentCubit
          .placeOrder(
          mainCubit.getDefaultShippingAddressItemValues()!.id.toString(), note,
          context)
          .then((value) =>
          AccountCubit.get(context).getOrders().then((value) =>
              AccountCubit.get(context).applyOrdersListFilter('pending')));
    } else if (paymentCubit.selectedPaymentId == '2') {
      logg('paymentCubit.selectedPaymentId is 2');
      paymentCubit.getPaymentLinkAndRedirect(
          paymentMethod: 'telr', context: context);
    } else if (paymentCubit.selectedPaymentId == '1') {
      logg('paymentCubit.selectedPaymentId is 2');
      paymentCubit.getPaymentLinkAndRedirect(
          paymentMethod: 'postpay', context: context);
    } else {
      logg('another payment method');
      showTopModalSheetErrorMessage(
          context, localizationStrings.select_payment_method);
    }
  }

  chooseAddress(MainCubit mainCubit, localizationStrings, context) {
    logg(mainCubit
        .defaultShippingAddressId
        .toString());
    if (mainCubit.getDefaultShippingAddressItemValues()!.id == 0) {
      logg('please add default shipping address');
      logg('address:\n');
      logg(mainCubit.addressesModel.toString());
      logg(mainCubit.addressesModel?.data?.toString() ?? 'No addresses');
      buildShowModalBottomSheet(context,
          body: Container(
            color: Colors.white,
            child: BlocBuilder<MainCubit, MainStates>(
                builder: (context, state) {
                  if (state is AddressesLoadingState) {
                    return const Center(
                      child: DefaultLoader(),
                    );
                  }
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 8.h, 14.h, 0),
                              child: Text(
                                  'X',
                                style: mainStyle(18, FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                          child: ConditionalBuilder(
                            condition: mainCubit.addressesModel != null,
                            builder: (context) {
                              List<Address> addresses =
                              mainCubit.addressesModel!.data!;
                              return ConditionalBuilder(
                                condition:
                                mainCubit.addressesModel!.data!.isNotEmpty,
                                builder: (context) =>
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ListView.separated(
                                            itemCount: addresses.length,
                                            shrinkWrap: true,
                                            physics:
                                            const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                AddressItem(
                                                    notInAddressListJustForView: true,
                                                    inBottomModalSheet: true,
                                                    localizationStrings:
                                                    localizationStrings!,
                                                    address: addresses[index]),
                                            scrollDirection: Axis.vertical,
                                            separatorBuilder: (context,
                                                index) =>
                                                Container(
                                                  color: Colors.grey,
                                                  height: 1.h,
                                                ),
                                          ),
                                          Container(
                                            height: 1.h,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    ),
                                fallback: (context) =>
                                const Center(child: EmptyError()),
                              );
                            },
                            fallback: (_) => const DefaultLoader(),
                          ),
                        ),
                        state is RemovingAddressState
                            ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                              child: const LinearProgressIndicator(),
                            )
                            : const SizedBox(),
                        SizedBox(
                          height: 12.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                          child: DefaultButton(
                              onClick: () {
                                navigateToWithNavBar(
                                    context, const AddNewAddress(),
                                    AddNewAddress.routeName);
                              },
                              title: localizationStrings!.addNewAddress),
                        ),
                        SizedBox(
                          height: 25.h,
                        )
                      ],
                    );
                }
            ),
          ));
    }
  }
}

class DeliveryMethods extends StatelessWidget {
  const DeliveryMethods({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var paymentCubit = PaymentCubit.get(context);
    var localizationStrings = AppLocalizations.of(context);

    return BlocBuilder<PaymentCubit, PaymentsStates>(
      builder: (context, state) =>
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                child: Text(
                  localizationStrings!.deliveryMethod,
                  style: mainStyle(16.0, FontWeight.w700),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      DeliveryMethodItem(
                        id: paymentCubit.deliveryMethods[index].id.toString(),
                        isSelected: paymentCubit.deliveryMethods[index]
                            .isSelected,
                        title: paymentCubit.deliveryMethods[index].title,
                        subTitle: paymentCubit.deliveryMethods[index].subTitle,
                      ),
                  separatorBuilder: (context, index) =>
                      SizedBox(
                        height: 10.h,
                      ),
                  itemCount: paymentCubit.deliveryMethods.length)
            ],
          ),
    );
  }
}

class DeliveryMethodItem extends StatelessWidget {
  const DeliveryMethodItem({
    Key? key,
    required this.id,
    required this.isSelected,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  final String id;
  final bool isSelected;
  final String? title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    var paymentCubit = PaymentCubit.get(context);
    return GestureDetector(
      onTap: () => paymentCubit.changeDeliveryMethodId(id),
      child: Container(
        color: Colors.transparent,
        child: Row(children: [
          SizedBox(
            width: 20.w,
          ),
          SizedBox(
            height: 56.h,
            width: 20.w,
            child: Center(
              child: SvgPicture.asset(
                isSelected
                    ? 'assets/images/public/Rectangle selected.svg'
                    : 'assets/images/public/Rectangle unselected.svg',
                width: 10.w,
                height: 12.w,
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title!, style: mainStyle(16.0, FontWeight.w600)),
                Text(
                  subTitle ?? '',
                  style: mainStyle(14.0, FontWeight.w400),
                  maxLines: 3,
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var paymentCubit = PaymentCubit.get(context);
    var localizationStrings = AppLocalizations.of(context);
    var cartCubit = CartCubit.get(context);
    StartingSettings setting = StartingSettings.fromJson(
        convert.jsonDecode(CacheHelper.getData(key: 'StartingSettings')));
    List<PaymentMethod?> paymentMethods = [
      // PaymentMethod(
      //     id: 1,
      //     title: localizationStrings!.postPay,
      //     subTitle: Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: [
      //         Image.asset(
      //           'assets/images/public/postpay.png',
      //           height: 25.h,
      //         )
      //       ],
      //     )),
      PaymentMethod(
          id: showPaymentUsingCards ?? true ? 2 : 0,
          title: localizationStrings!.payWithYourCard,
          subTitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/public/telr.png',
                height: 25.h,
              )
            ],
          )),
      PaymentMethod(
          id: showCashPayment ?? true ? 3 : 0,
          title: localizationStrings.payCash,
          subTitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset(
                'assets/images/public/cod.png',
                height: 25.h,
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                cartCubit.cartModel!.data!.codCost.toString() +
                    ' ' +
                    localizationStrings.aedTollsApplied,
                style: mainStyle(14.0, FontWeight.w200),
              ),
            ],
          ))
    ];

    return BlocBuilder<PaymentCubit, PaymentsStates>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: Text(
                localizationStrings.paymentMethod,
                style: mainStyle(16.0, FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) =>
                    BlocBuilder<CartCubit, CartStates>(
                      builder: (context, state) {
                        return paymentMethods[index]!.id != 0
                            ? PaymentMethodItem(
                          id: paymentMethods[index]!.id.toString(),
                          isSelected: paymentCubit.selectedPaymentId ==
                              paymentMethods[index]!.id.toString(),
                          title: paymentMethods[index]!.title,
                          subTitleWidget: paymentMethods[index]!.subTitle,
                          isVisible: cartCubit.cartModel!.data!.hasCod!,
                        )
                            : const SizedBox.shrink();
                      },
                    ),
                separatorBuilder: (context, index) =>
                    SizedBox(
                      height: 7.h,
                    ),
                itemCount: paymentMethods.length)
          ],
        );
      },
    );
  }
}

class PaymentMethodItem extends StatelessWidget {
  const PaymentMethodItem({
    Key? key,
    this.id,
    required this.isSelected,
    required this.isVisible,
    this.title,
    this.subTitleWidget,
  }) : super(key: key);

  final String? id;
  final bool isSelected;
  final bool isVisible;
  final String? title;
  final Widget? subTitleWidget;

  @override
  Widget build(BuildContext context) {
    var paymentCubit = PaymentCubit.get(context);
    if (isVisible && id == 3.toString()) {
      return GestureDetector(
        onTap: () {
          logg('changing pay  method');
          paymentCubit.changeSelectedPaymentMethodId(id.toString());
        },
        child: Container(
          color: mainGreyColor.withOpacity(0.1),
          child: Row(
            children: [
              SizedBox(
                width: 20.w,
              ),
              SizedBox(
                height: 56.h,
                width: 20.w,
                child: Center(
                  child: SvgPicture.asset(
                    isSelected
                        ? 'assets/images/public/icons8_checked_radio_button.svg'
                        : 'assets/images/public/icons8_unchecked_radio_button.svg',
                    width: 10.w,
                    height: 12.w,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: mainStyle(16.0, FontWeight.w600),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  subTitleWidget != null ? subTitleWidget! : const SizedBox()
                ],
              )
            ],
          ),
        ),
      );
    } else if (id == 2.toString()) {
      return GestureDetector(
        onTap: () {
          logg('changing pay  method');
          paymentCubit.changeSelectedPaymentMethodId(id.toString());
        },
        child: Container(
          color: mainGreyColor.withOpacity(0.1),
          child: Row(
            children: [
              SizedBox(
                width: 20.w,
              ),
              SizedBox(
                height: 56.h,
                width: 20.w,
                child: Center(
                  child: SvgPicture.asset(
                    isSelected
                        ? 'assets/images/public/icons8_checked_radio_button.svg'
                        : 'assets/images/public/icons8_unchecked_radio_button.svg',
                    width: 10.w,
                    height: 12.w,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: mainStyle(16.0, FontWeight.w600),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  subTitleWidget != null ? subTitleWidget! : const SizedBox()
                ],
              )
            ],
          ),
        ),
      );
    } else if (id == 1.toString()) {
      return GestureDetector(
        onTap: () {
          logg('changing pay  method');
          paymentCubit.changeSelectedPaymentMethodId(id.toString());
        },
        child: Container(
          color: mainGreyColor.withOpacity(0.1),
          child: Row(
            children: [
              SizedBox(
                width: 20.w,
              ),
              SizedBox(
                height: 56.h,
                width: 20.w,
                child: Center(
                  child: SvgPicture.asset(
                    isSelected
                        ? 'assets/images/public/icons8_checked_radio_button.svg'
                        : 'assets/images/public/icons8_unchecked_radio_button.svg',
                    width: 10.w,
                    height: 12.w,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: mainStyle(16.0, FontWeight.w600),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  subTitleWidget != null ? subTitleWidget! : const SizedBox()
                ],
              )
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
