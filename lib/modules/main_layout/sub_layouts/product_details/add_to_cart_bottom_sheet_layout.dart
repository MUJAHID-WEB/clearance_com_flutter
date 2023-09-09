import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/shared_widgets/shared_widgets.dart';
import 'package:clearance/models/api_models/product_required_information_for_shopping_model.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cart_screen.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cubit/cart_cubit.dart';
import 'package:clearance/modules/main_layout/sub_layouts/product_details/cubit/required_product_details_cubit.dart';
import 'package:clearance/modules/main_layout/sub_layouts/product_details/product_details_layout.dart';
import 'package:clearance/modules/main_layout/sub_layouts/product_details/widgets/product_details_widgets.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import '../../../../core/cache/cache.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/error_screens/show_error_message.dart';
import '../../../../core/main_cubits/cubit_main.dart';
import '../../../../core/main_functions/main_funcs.dart';
import '../../../../core/styles_colors/styles_colors.dart';

class AddToCartBottomSheetContent extends StatefulWidget {
  const AddToCartBottomSheetContent({required this.productId, Key? key})
      : super(key: key);
  final String productId;

  @override
  State<AddToCartBottomSheetContent> createState() =>
      _AddToCartBottomSheetContentState();
}

class _AddToCartBottomSheetContentState
    extends State<AddToCartBottomSheetContent> {

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var productDetailsCubit = RequiredProductDetailsCubit.get(context)
      ..resetQtyRequired();
    var mainCubit = MainCubit.get(context);
    productDetailsCubit
      ..resetSelectedChoicesRequired()
      ..getRequiredProductInformation(context, widget.productId);
    return BlocConsumer<RequiredProductDetailsCubit,
        RequiredProductDetailsState>(
        listener: (consumerContext, state) {
          if(state is ErrorLoadingDataState){
            productDetailsCubit
              ..resetSelectedChoicesRequired()
              ..getRequiredProductInformation(context, widget.productId);
          }
      if (state is PleaseChooseSizeState) {
        showTopModalSheetErrorMessage(
            context, localizationStrings!.please_choose_size);
      } else if (state is SuccessAddingToCartState) {
        if (state.msg == 'أضيف بنجاح!' || state.msg == 'Successfully added!') {
          showTopModalSheet<String>(
            context,
            Builder(builder: (context) {
              return Container(
                margin: EdgeInsets.only(top: 20.h),
                color: Colors.white.withOpacity(0.8),
                height: 150.h,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 25.w,
                            ),
                            SizedBox(
                              height: 25.w,
                              width: 25.w,
                              child: Lottie.asset(
                                  'assets/images/public/lf30_editor_c6ebyow8.json',
                                  width: 25.w,
                                  height: 25.w),
                            ),
                            SizedBox(
                              width: 25.w,
                            ),
                            Expanded(
                              child: Text(
                                productDetailsCubit
                                        .productRequiredModel!.data!.name
                                        .toString() +
                                    ' - ' +
                                    localizationStrings!.addedSuccessfully,
                                style: mainStyle(15.0, FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: DefaultButton(
                              title: localizationStrings.continueShopping,
                              onClick: () => Navigator.of(context)..pop(),
                              backColor: primaryColor,
                              borderColors: Colors.transparent,
                              titleColor: Colors.white,
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: DefaultButton(
                              title: localizationStrings.checkOut,
                              onClick: () {
                                Navigator.of(context).pop();
                                CartCubit.get(context)
                                  ..getCartDetails(
                                    updateAllList: true,
                                  )
                                  ..disableCouponStillAvailable();
                                mainCubit
                                    .navigateToTap(showNotifications! ? 3 : 2);
                              },
                              backColor: primaryColor,
                              borderColors: Colors.transparent,
                              titleColor: Colors.white,
                            ),
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          ).then((value) => Navigator.pop(context));
        } else {
          showTopModalSheetErrorMessage(context, state.msg ?? '--');
        }
      }
    }, builder: (context, state) {
      return ConditionalBuilder(
        condition: productDetailsCubit.productRequiredModel != null,
        builder: (context) {
          int? availableQty = productDetailsCubit.updatedVariationRequired !=
                  null
              ? productDetailsCubit.updatedVariationRequired!.qty
              : productDetailsCubit.productRequiredModel!.data!.currentStock;
          productDetailsCubit.productRequiredModel!.data!.variation!
              .sort((a, b) => a.price!.compareTo(b.price!));
          String? minPriceOffer;
          String? maxPriceOffer;
          String? maxPrice;
          for (var element
              in productDetailsCubit.productRequiredModel!.data!.variation!) {
            if (element.qty != 0 && minPriceOffer == null) {
              minPriceOffer = element.offerPriceFormated!;
            } else if (element.qty != 0 && minPriceOffer != null) {
              maxPriceOffer = element.offerPriceFormated!;
              maxPrice = element.priceFormated;
            }
          }
          return Stack(alignment: Alignment.center, children: [
            Positioned(
              left: 0,
              top: 0,
              child: Transform.translate(
                offset: Offset((defaultHorizontalPadding * 2).w, -60.w),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                      ..pop()
                      ..push(MaterialPageRoute(
                          builder: (_) => ProductDetailsLayout(
                              productId:
                              productDetailsCubit.productRequiredModel!.data!.id.toString())));
                  },
                  child: SizedBox(
                    width: 100.w,
                    height: 120.w,
                    child: DefaultImage(
                      backColor: mainBackgroundColor,
                      backGroundImageUrl:  productDetailsCubit.productRequiredModel!.data!.image!,
                      boxFit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Transform.translate(
                  offset: Offset(-defaultHorizontalPadding.w, -12.5.w),
                  child: SizedBox(
                    width: 25.w,
                    height: 25.w,
                    child: Container(
                      decoration: BoxDecoration(
                          color: primaryColor, shape: BoxShape.circle),
                      child: Center(
                        child: Text('X',
                            style: mainStyle(14.w, FontWeight.bold,
                                fontFamily: 'poppins',
                                color: mainBackgroundColor)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (defaultHorizontalPadding * 2).w,
                ).copyWith(top: 70.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                              ..pop()
                              ..push(MaterialPageRoute(
                                  builder: (_) => ProductDetailsLayout(
                                      productId:  productDetailsCubit.productRequiredModel!.data!.id
                                          .toString())));
                          },
                          child: Text(
                            productDetailsCubit.productRequiredModel!.data!.name.toString(),
                            style: mainStyle(22.0, FontWeight.w900),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              if (maxPriceOffer == null ||
                                  minPriceOffer == maxPriceOffer) ...{
                                FormattedPrice(
                                    price: productDetailsCubit
                                            .skuLisRequired!.isNotEmpty
                                        ? minPriceOffer!
                                        : productDetailsCubit
                                            .productRequiredModel!
                                            .data!
                                            .offerPriceFormatted!),
                              } else ...{
                                FormattedPrice(price: minPriceOffer! + '-'),
                                FormattedPrice(price: maxPriceOffer),
                              },
                              SizedBox(
                                width: 10.w,
                              ),
                              if (productDetailsCubit
                                  .skuLisRequired!.isNotEmpty)
                                if (productDetailsCubit
                                        .updatedVariationRequired!.offerPrice! <
                                    productDetailsCubit
                                        .updatedVariationRequired!.price!)
                                  (maxPriceOffer != null &&
                                          maxPriceOffer != minPriceOffer)
                                      ? FormattedOfferPercent(
                                          newPrice: maxPriceOffer,
                                          price: maxPrice!,
                                        )
                                      : FormattedPriceOld(
                                          newPrice: productDetailsCubit
                                              .updatedVariationRequired!
                                              .offerPriceFormated!,
                                          price: productDetailsCubit
                                              .updatedVariationRequired!
                                              .priceFormated!),
                              SizedBox(
                                width: 15.w,
                              ),
                            ],
                          ),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizationStrings!.includesTax,
                          style: mainStyle(14.0, FontWeight.w600,
                              color: includingTaxColor),
                        ),
                        Divider(
                            thickness: 3.h,
                            color: Colors.grey.withOpacity(0.1)),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    BlocBuilder<RequiredProductDetailsCubit,
                        RequiredProductDetailsState>(
                      builder: (context, state) => ChoiceOptions(
                          choiceOptions:
                          productDetailsCubit.productRequiredModel!.data!.choiceOptions,
                          required: true),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    BlocBuilder<RequiredProductDetailsCubit,
                        RequiredProductDetailsState>(
                      builder: (context, state) => QuantitySection(
                          availableQuantity:  productDetailsCubit.productRequiredModel!
                                      .data!.flashDealDetails !=
                                  null
                              ?  productDetailsCubit.productRequiredModel!
                                  .data!.flashDealMaxAllowedQuantity
                                  .toString()
                              : productDetailsCubit.updatedVariationRequired !=
                                      null
                                  ? productDetailsCubit
                                      .updatedVariationRequired!.qty
                                      .toString()
                                  : productDetailsCubit
                                      .productRequiredModel!.data!.currentStock
                                      .toString(),
                          required: true),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    productDetailsCubit.productRequiredModel!.data!.colors == null
                        ? const SizedBox()
                        : BlocBuilder<RequiredProductDetailsCubit,
                            RequiredProductDetailsState>(
                            builder: (context, state) => ColorOptions(
                              colorOptions:  productDetailsCubit.productRequiredModel!.data!.colors,
                            ),
                          ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (availableQty! > 0) {
                          if ( productDetailsCubit.productRequiredModel!.data!.flashDealDetails !=
                              null) {
                            int quantity = 0;
                            for (var element in CartCubit.get(context)
                                .cartModel!
                                .data!
                                .cart!) {
                              if (element.id ==
                                  productDetailsCubit.productRequiredModel!.data!.id) {
                                quantity += element.quantity!;
                              }
                            }
                            quantity += productDetailsCubit
                                .currentProductQuantityRequired;
                            if (quantity > availableQty) {
                              showTopModalSheetErrorMessage(
                                  context,
                                  localizationStrings
                                      .flash_deal_max_quantity_reached);
                              return;
                            }
                          }
                          logg('add to cart');
                          getCachedToken() == null
                              ? showTopModalSheetErrorLoginRequired(context)
                              : productDetailsCubit.addToCart(
                                  context: context,
                                  productId: widget.productId.toString(),
                                  quantity: productDetailsCubit
                                      .currentProductQuantityRequired
                                      .toString(),
                                );
                        }
                      },
                      child: Container(
                        width: state is AddingToCartState && !state.buyNowButton
                            ? 1.sw
                            : 1.sw,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color:
                              state is AddingToCartState && !state.buyNowButton
                                  ? Colors.transparent
                                  : availableQty! > 0
                                      ? primaryColor
                                      : titleColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(
                              state is AddingToCartState && !state.buyNowButton
                                  ? 55.sp
                                  : 10.0.sp),
                          border: Border.all(
                              width: 1.0,
                              color: state is AddingToCartState &&
                                      !state.buyNowButton
                                  ? Colors.transparent
                                  : availableQty! > 0
                                      ? primaryColor
                                      : titleColor.withOpacity(0.8)),
                        ),
                        child: Center(
                          child:
                              state is AddingToCartState && !state.buyNowButton
                                  ? DefaultLoader(
                                      customWidth: 42.w,
                                      customHeight: 42.w,
                                    )
                                  : Text(
                                      availableQty! > 0
                                          ? localizationStrings.addToCart
                                          : 'Out of stock',
                                      style: mainStyle(20.0, FontWeight.w900,
                                          color: Colors.white),
                                    ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                )),
          ]);
        },
        fallback: (BuildContext context) => const Center(
          child: DefaultLoader(),
        ),
      );
    });
  }
}
