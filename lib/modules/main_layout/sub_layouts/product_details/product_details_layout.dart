import 'dart:io';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clearance/core/error_screens/show_error_message.dart';
import 'package:clearance/modules/main_layout/main_layout.dart';
import 'package:clearance/modules/main_layout/sub_layouts/home/main_home.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/constants/dimensions.dart';
import 'package:clearance/core/main_cubits/cubit_main.dart';
import 'package:clearance/core/shared_widgets/shared_widgets.dart';
import 'package:clearance/core/shimmer/main_shimmers.dart';
import 'package:clearance/core/styles_colors/styles_colors.dart';
import 'package:clearance/models/api_models/product_details_model.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cart_screen.dart';
import 'package:clearance/modules/main_layout/sub_layouts/product_details/cubit/cubit_product_details.dart';
import 'package:clearance/modules/main_layout/sub_layouts/product_details/cubit/states_product_details.dart';
import 'package:clearance/modules/main_layout/sub_layouts/product_details/widgets/product_details_widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import '../../../../core/cache/cache.dart';
import '../../../../core/main_functions/main_funcs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../models/local_models/local_models.dart';
import '../cart/cubit/cart_cubit.dart';

class ProductDetailsLayout extends StatelessWidget {
  const ProductDetailsLayout({Key? key, required this.productId})
      : super(key: key);
  static String routeName = 'productDetails';

  final String productId;

  @override
  Widget build(BuildContext context) {
    logg('product id layout build');
    var localizationStrings = AppLocalizations.of(context);
    var mainCubit = MainCubit.get(context);
    var productDetailsCubit = ProductDetailsCubit.get(context);
    ScreenshotController screenshotController = ScreenshotController();
    logg('product details body layout build');
    productDetailsCubit
      ..resetSelectedChoices()
      ..getProductDetails(
        context,
        productId,
      );
    productDetailsCubit.changeFirstRunVal(false);
    ProductDetailsModel? detailsData;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: const DefaultAppBarWithOnlyBackButton(transparent: true),
        ),
        body: BlocConsumer<ProductDetailsCubit, ProductDetailsStates>(
            buildWhen: (previous, current) => current is! QuantityChangedState,
            listener: (consumerContext, state) {
              if(state is ErrorLoadingDataState){
                productDetailsCubit
                  ..resetSelectedChoices()
                  ..getProductDetails(
                    context,
                    productId,
                  );
              }
              if (state is PleaseChooseSizeState) {
                ChoiceOption option = detailsData!.data!.choiceOptions!
                    .firstWhere((element) =>
                        (element.title!.toLowerCase().contains("size") ||
                            element.title == "القياس"));
                int index = detailsData!.data!.choiceOptions!.indexOf(option);
                showModalBottomSheet(
                    context: context,
                    builder: (context) =>
                        BlocConsumer<ProductDetailsCubit, ProductDetailsStates>(
                          listenWhen: (previous, current) =>
                              previous is ChoiceChangedState &&
                              current is ChoiceChangedState,
                          listener: (context, state) {
                            if (state is ChoiceChangedState) {
                              Navigator.pop(context);
                            }
                          },
                          builder: (context, state) {
                            return SizedBox(
                              width: 1.sw,
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: 10.w, top: 10.h, bottom: 5.h),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      localizationStrings!.please_choose_size +
                                          ' :',
                                      style: mainStyle(
                                        16,
                                        FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50.h,
                                      child: ListView.separated(
                                        itemCount: option.options!.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, optionsIndex) {
                                          return GestureDetector(
                                            onTap: () {
                                              logg('choice name :' +
                                                  option.name!);
                                              productDetailsCubit
                                                  .addSelectedChoice(
                                                      context,
                                                      index,
                                                      option.title!,
                                                      option.name!,
                                                      option.options![
                                                          optionsIndex]);
                                            },
                                            child: Container(
                                              width: 50.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                    width: productDetailsCubit
                                                                .selectedChoices
                                                                .firstWhere((element) => element.choiceName == option.name!,
                                                                    orElse: () => SelectedChoice(
                                                                        id: 0,
                                                                        choiceVal:
                                                                            '',
                                                                        choiceName:
                                                                            ''))
                                                                .choiceVal ==
                                                            option.options![
                                                                optionsIndex]
                                                        ? 3.0
                                                        : 1.0,
                                                    color: productDetailsCubit
                                                                .selectedChoices
                                                                .firstWhere((element) => element.choiceName == option.name!,
                                                                    orElse: () =>
                                                                        SelectedChoice(id: 0, choiceVal: '', choiceName: ''))
                                                                .choiceVal ==
                                                            option.options![optionsIndex]
                                                        ? primaryColor
                                                        : mainGreyColor),
                                              ),
                                              child: Center(
                                                child: Text(
                                                    option
                                                        .options![optionsIndex],
                                                    style: mainStyle(
                                                        14.w, FontWeight.w500),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return SizedBox(
                                            width: 10.w,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ));
                // showTopModalSheetErrorMessage(
                //     context, localizationStrings!.please_choose_size);
              }
              if (state is SuccessAddingToCartState && state.moveToPayment) {
                mainCubit.navigateToTap(showNotifications! ? 3 : 2);
              } else if (state is SuccessAddingToCartState) {
                if (state.msg == 'أضيف بنجاح!' ||
                    state.msg == 'Successfully added!') {
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
                                                .productDetailsModel!.data!.name
                                                .toString() +
                                            ' - ' +
                                            localizationStrings!
                                                .addedSuccessfully,
                                        style: mainStyle(15.0, FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: DefaultButton(
                                      title:
                                          localizationStrings.continueShopping,
                                      onClick: () {
                                        navigateToAndFinishUntil(
                                            context, const MainLayout());
                                      },
                                      backColor: primaryColor,
                                      borderColors: Colors.transparent,
                                      titleColor: Colors.white,
                                    ),
                                  )),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: DefaultButton(
                                      title: localizationStrings.checkOut,
                                      onClick: () {
                                        Navigator.of(context).pop();
                                        CartCubit.get(context)
                                          ..getCartDetails(
                                            updateAllList: true,
                                          )
                                          ..disableCouponStillAvailable();
                                        mainCubit.navigateToTap(
                                            showNotifications! ? 3 : 2);
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
                  );
                } else {
                  showTopModalSheetErrorMessage(context, state.msg ?? '--');
                }
              }
            },
            builder: (consumerContext, state) {
              return ConditionalBuilder(
                condition: productDetailsCubit.productDetailsModel != null,
                builder: (bodyContext) {
                  detailsData = productDetailsCubit.productDetailsModel!;
                  int? availableQty =
                      (productDetailsCubit.updatedVariation != null)
                          ? productDetailsCubit.updatedVariation!.qty
                          : productDetailsCubit
                              .productDetailsModel!.data!.currentStock;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 5.0.h),
                    child: Stack(
                      children: [
                        Screenshot(
                            controller: screenshotController,
                            child: Container(
                                color: Colors.white,
                                child: ProductDetailsBody(
                                    productId: productId,
                                    screenshotController:
                                        screenshotController))),
                        Positioned(
                          bottom: 10.h,
                          child: Container(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.sw,
                            height: 45.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (availableQty! > 0) {
                                              if (detailsData!
                                                      .data!.flashDealDetails !=
                                                  null) {
                                                int quantity = 0;
                                                for (var element
                                                    in CartCubit.get(context)
                                                        .cartModel!
                                                        .data!
                                                        .cart!) {
                                                  if (element.id ==
                                                      detailsData!.data!.id) {
                                                    quantity +=
                                                        element.quantity!;
                                                  }
                                                }
                                                quantity += productDetailsCubit
                                                    .currentProductQuantity;
                                                if (quantity > availableQty) {
                                                  showTopModalSheetErrorMessage(
                                                      context,
                                                      localizationStrings!
                                                          .flash_deal_max_quantity_reached);
                                                  return;
                                                }
                                              }
                                              logg('add to cart');
                                              getCachedToken() == null
                                                  ? showTopModalSheetErrorLoginRequired(
                                                      context)
                                                  : productDetailsCubit
                                                      .addToCart(
                                                      context: context,
                                                      productId:
                                                          productDetailsCubit
                                                              .productDetailsModel!
                                                              .data!
                                                              .id
                                                              .toString(),
                                                      quantity: productDetailsCubit
                                                          .currentProductQuantity
                                                          .toString(),
                                                    );
                                            }
                                          },
                                          child: Container(
                                            width: state is AddingToCartState &&
                                                    !state.buyNowButton
                                                ? 45.w
                                                : 170.w,
                                            height: 60.h,
                                            decoration: BoxDecoration(
                                              color:
                                                  state is AddingToCartState &&
                                                          !state.buyNowButton
                                                      ? Colors.transparent
                                                      : availableQty! > 0
                                                          ? primaryColor
                                                          : titleColor
                                                              .withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(
                                                  state is AddingToCartState &&
                                                          !state.buyNowButton
                                                      ? 55.sp
                                                      : 10.0.sp),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      state is AddingToCartState &&
                                                              !state
                                                                  .buyNowButton
                                                          ? Colors.transparent
                                                          : availableQty! > 0
                                                              ? primaryColor
                                                              : titleColor
                                                                  .withOpacity(
                                                                      0.8)),
                                            ),
                                            child: Center(
                                              child:
                                                  state is AddingToCartState &&
                                                          !state.buyNowButton
                                                      ? DefaultColoredLoader(
                                                          customWidth: 42.w,
                                                          customHeight: 42.w,
                                                        )
                                                      : Text(
                                                          availableQty! > 0
                                                              ? localizationStrings!
                                                                  .addToCart
                                                              : 'Out of stock',
                                                          style: mainStyle(20.0,
                                                              FontWeight.w900,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (availableQty! > 0) {
                                              if (detailsData!
                                                      .data!.flashDealDetails !=
                                                  null) {
                                                int quantity = 0;
                                                for (var element
                                                    in CartCubit.get(context)
                                                        .cartModel!
                                                        .data!
                                                        .cart!) {
                                                  if (element.id ==
                                                      detailsData!.data!.id) {
                                                    quantity +=
                                                        element.quantity!;
                                                  }
                                                }
                                                quantity += productDetailsCubit
                                                    .currentProductQuantity;
                                                if (quantity > availableQty) {
                                                  showTopModalSheetErrorMessage(
                                                      context,
                                                      localizationStrings!
                                                          .flash_deal_max_quantity_reached);
                                                  return;
                                                }
                                              }
                                              logg('add to cart');
                                              getCachedToken() == null
                                                  ? showTopModalSheetErrorLoginRequired(
                                                      context)
                                                  : productDetailsCubit
                                                      .addToCart(
                                                      context: context,
                                                      buyNow: true,
                                                      productId:
                                                          productDetailsCubit
                                                              .productDetailsModel!
                                                              .data!
                                                              .id
                                                              .toString(),
                                                      quantity: productDetailsCubit
                                                          .currentProductQuantity
                                                          .toString(),
                                                    );
                                            }
                                          },
                                          child: Container(
                                            width: state is AddingToCartState &&
                                                    state.buyNowButton
                                                ? 45.w
                                                : 170.w,
                                            height: 60.h,
                                            decoration: BoxDecoration(
                                              color:
                                                  state is AddingToCartState &&
                                                          state.buyNowButton
                                                      ? Colors.transparent
                                                      : availableQty! > 0
                                                          ? buyNowButtonColor
                                                          : titleColor
                                                              .withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(
                                                  state is AddingToCartState &&
                                                          state.buyNowButton
                                                      ? 55.sp
                                                      : 10.0.sp),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      state is AddingToCartState &&
                                                              state.buyNowButton
                                                          ? Colors.transparent
                                                          : availableQty! > 0
                                                              ? buyNowButtonColor
                                                              : titleColor
                                                                  .withOpacity(
                                                                      0.8)),
                                            ),
                                            child: Center(
                                              child:
                                                  state is AddingToCartState &&
                                                          state.buyNowButton
                                                      ? DefaultColoredLoader(
                                                          customWidth: 42.w,
                                                          customHeight: 42.w,
                                                        )
                                                      : Text(
                                                          availableQty! > 0
                                                              ? localizationStrings!
                                                                  .buyNow
                                                              : 'Out of stock',
                                                          style: mainStyle(20.0,
                                                              FontWeight.w900,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                fallback: (bodyContext) => const ProductDetailsShimmer(),
              );
            }));
  }
}

class ProductDetailsBody extends StatelessWidget {
  const ProductDetailsBody({
    required this.productId,
    required this.screenshotController,
    Key? key,
  }) : super(
          key: key,
        );
  final String productId;
  final ScreenshotController screenshotController;

  @override
  Widget build(BuildContext context) {
    var productDetailsCubit = ProductDetailsCubit.get(context)..resetQty();
    var localizationStrings = AppLocalizations.of(context);
    Data detailsData = productDetailsCubit.productDetailsModel!.data!;
    productDetailsCubit.productDetailsModel!.data!.variation!
        .sort((a, b) => a.offerPrice!.compareTo(b.offerPrice!));
    String? minPriceOffer;
    String? maxPriceOffer;
    String? maxPrice;
    for (var element
        in productDetailsCubit.productDetailsModel!.data!.variation!) {
      if (element.qty != 0 && minPriceOffer == null) {
        minPriceOffer = element.offerPriceFormated!;
      } else if (element.qty != 0 && minPriceOffer != null) {
        maxPriceOffer = element.offerPriceFormated!;
        maxPrice = element.priceFormated;
      }
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 35.h,
          ),
          Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 0.5.sh,
                  enlargeCenterPage: false,
                  scrollPhysics: const BouncingScrollPhysics(),
                  initialPage: 0,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                ),
                items: detailsData.images!
                    .map((e) => SizedBox(
                          child: Stack(
                            children: [
                              SizedBox(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: DefaultImage(
                                    customImageCacheHeight: 800,
                                    boxFit: BoxFit.fitHeight,
                                    borderColor: Colors.transparent,
                                    backColor: Colors.transparent,
                                    backGroundImageUrl: e.toString(),
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: DefaultContainer(
                                    height: 35.w,
                                    width: 75.w,
                                    radius: 35.sp,
                                    borderColor: Colors.transparent,
                                    backColor: Colors.grey.withOpacity(0.3),
                                    childWidget: Center(
                                      child: Text(
                                        (detailsData.images!.indexOf(e) + 1)
                                                .toString() +
                                            '/' +
                                            detailsData.images!.length
                                                .toString(),
                                        style: mainStyle(16.0, FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ))
                    .toList(),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Builder(builder: (context) {
                  return GestureDetector(
                    onTap: () async {
                      await screenshotController
                          .capture()
                          .then((Uint8List? bytes) async {
                        final directory =
                            await getApplicationDocumentsDirectory();
                        final image = File('${directory.path}/clearance.JPG');
                        image.writeAsBytesSync(bytes!);
                        await Share.shareFiles([image.path],
                            text:
                                'https://www.clearance.ae/product/${detailsData.slug}');
                      }).catchError((error) {
                        logg(error.toString());
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.sp),
                      child: DefaultContainer(
                        width: 50.w,
                        height: 50.h,
                        backColor: shareButtonColor,
                        radius: 10.r,
                        borderColor: shareButtonColor,
                        childWidget: const Center(
                          child: Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              if (detailsData.flashDealDetails != null)
                Positioned(
                  top: 3.0,
                  right: 3.0,
                  child: FlashDealItemTimer(
                    startDate: detailsData.flashDealDetails!.startDate!,
                    endDate: detailsData.flashDealDetails!.endDate!,
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultHorizontalPadding * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detailsData.name.toString(),
                      style: mainStyle(22.0, FontWeight.w900),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      detailsData.brand!.name.toString(),
                      style: mainStyle(20.0, FontWeight.w900),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: (defaultHorizontalPadding * 2).w,
                    vertical: defaultHorizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    double.parse(
                                detailsData.rating!.overallRating!.toString()) >
                            0
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RatingBarIndicator(
                                rating: double.parse(detailsData
                                    .rating!.overallRating!
                                    .toString()),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: primaryColor,
                                ),
                                itemCount: 5,
                                itemSize: 20.0.sp,
                                direction: Axis.horizontal,
                              ),
                              Text('(' +
                                  detailsData.rating!.totalRating.toString() +
                                  ')'),
                            ],
                          )
                        : const SizedBox(),
                    SizedBox(
                      width: double.parse(detailsData.rating!.overallRating!
                                  .toString()) >
                              0
                          ? 15.w
                          : 0,
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
                                  price: productDetailsCubit.skuLis!.isNotEmpty
                                      ? minPriceOffer!
                                      : productDetailsCubit.productDetailsModel!
                                          .data!.offerPriceFormatted!),
                            } else ...{
                              FormattedPrice(price: minPriceOffer! + '-'),
                              FormattedPrice(price: maxPriceOffer),
                            },
                            SizedBox(
                              width: 10.w,
                            ),
                            if (productDetailsCubit.skuLis!.isNotEmpty)
                              if (productDetailsCubit
                                      .updatedVariation!.offerPrice! <
                                  productDetailsCubit.updatedVariation!.price!)
                                (maxPriceOffer != null &&
                                        maxPriceOffer != minPriceOffer)
                                    ? FormattedOfferPercent(
                                        newPrice: maxPriceOffer,
                                        price: maxPrice!,
                                      )
                                    : FormattedPriceOld(
                                        newPrice: productDetailsCubit
                                            .updatedVariation!
                                            .offerPriceFormated!,
                                        price: productDetailsCubit
                                            .updatedVariation!.priceFormated!),
                            SizedBox(
                              width: 15.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizationStrings!.includesTax,
                          style: mainStyle(14.0, FontWeight.w600,
                              color: includingTaxColor),
                        ),
                        DefaultContainer(
                          width: 35.h,
                          height: 35.h,
                          backColor: Colors.white.withOpacity(0.5),
                          borderColor: primaryColor,
                          childWidget: Center(
                              child: GhLikeButton(
                            initialLikeStatus: detailsData.isFavourite!,
                            productId: productId,
                            size: 20.sp,
                          )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Divider(
                        thickness: 3.h, color: Colors.grey.withOpacity(0.1)),
                    ShippingOfferSection(
                        localizationStrings: localizationStrings),
                    Divider(
                        thickness: 3.h, color: Colors.grey.withOpacity(0.1)),
                    SizedBox(
                      height: 15.h,
                    ),
                    RichText(
                      text: TextSpan(
                        text: '',
                        style: mainStyle(14.0, FontWeight.w200),
                        children: <TextSpan>[
                          TextSpan(
                            text: localizationStrings.modelNum,
                            style: mainStyle(16.0, FontWeight.w400),
                          ),
                          TextSpan(
                            text: '  ',
                            style: mainStyle(14.0, FontWeight.w200),
                          ),
                          TextSpan(
                            text: detailsData.model ?? '--',
                            style: mainStyle(14.0, FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    BlocBuilder<ProductDetailsCubit, ProductDetailsStates>(
                      builder: (context, state) => ChoiceOptions(
                        choiceOptions: detailsData.choiceOptions,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    BlocBuilder<ProductDetailsCubit, ProductDetailsStates>(
                      builder: (context, state) => QuantitySection(
                          availableQuantity:
                              detailsData.flashDealDetails != null
                                  ? detailsData.flashDealMaxAllowedQuantity
                                      .toString()
                                  : productDetailsCubit.updatedVariation != null
                                      ? min(
                                              productDetailsCubit
                                                  .updatedVariation!.qty!,
                                              10)
                                          .toString()
                                      : productDetailsCubit.productDetailsModel!
                                          .data!.currentStock
                                          .toString()),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    detailsData.colors == null
                        ? SizedBox()
                        : BlocBuilder<ProductDetailsCubit,
                            ProductDetailsStates>(
                            builder: (context, state) => ColorOptions(
                              colorOptions: detailsData.colors,
                            ),
                          ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        detailsData.shop == null
                            ? const SizedBox()
                            : RichText(
                                text: TextSpan(
                                  text: 'This item sold by: ',
                                  style: mainStyle(13.0, FontWeight.w200),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: detailsData.shop!.name ??
                                          'unknown seller',
                                      style: mainStyle(12.0, FontWeight.w600,
                                          color: primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(
                          width: 13.w,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(thickness: 3.h, color: Colors.grey.withOpacity(0.1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ApplicationFeature(
                      title: localizationStrings.genuine,
                      imageUrl: 'original',
                    ),
                    ApplicationFeature(
                      title: localizationStrings.quality,
                      imageUrl: 'badge',
                    ),
                    ApplicationFeature(
                      title: localizationStrings.secure_payment,
                      imageUrl: 'secure-payment',
                    ),
                  ],
                ),
              ),
              Divider(thickness: 3.h, color: Colors.grey.withOpacity(0.1)),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultHorizontalPadding * 2,
                    vertical: defaultHorizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (detailsData.details != null && !Platform.isWindows)
                      ProductDetailsSection(
                        title: localizationStrings.mainFeatures,
                        body: detailsData.details!,
                      ),
                    if (detailsData.description != null && !Platform.isWindows)
                      ProductDetailsSection(
                        title: localizationStrings.description,
                        body: detailsData.description!,
                      ),
                    ProductEvaluateSection(
                      overAllRating:
                          detailsData.rating!.overallRating!.toString(),
                      totalRating: detailsData.rating!.totalRating!.toString(),
                    ),
                    if (detailsData.features != null && !Platform.isWindows)
                      ProductDetailsSection(
                        title: localizationStrings.specifications,
                        body: detailsData.features!,
                      ),
                    SizedBox(
                      height: 15.h,
                    ),
                    if (detailsData.similarProducts != null)
                      SimilarProduct(
                          similarProducts: detailsData.similarProducts!),
                    if (detailsData.relatedProducts != null)
                      RelatedProducts(
                        relatedProducts: detailsData.relatedProducts!,
                      ),
                    SizedBox(
                      height: 55.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ApplicationFeature extends StatelessWidget {
  const ApplicationFeature(
      {required this.title, required this.imageUrl, Key? key})
      : super(key: key);
  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Image.asset(
        'assets/images/$imageUrl.png',
        fit: BoxFit.contain,
        width: 60.w,
        height: 60.h,
      ),
      SizedBox(
        height: 10.h,
      ),
      Text(
        title,
        textAlign: TextAlign.center,
      )
    ]);
  }
}

class ShippingOfferSection extends StatelessWidget {
  const ShippingOfferSection({required this.localizationStrings, Key? key})
      : super(key: key);
  final AppLocalizations localizationStrings;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/delivery.png',
          height: 80.h,
          fit: BoxFit.contain,
          width: 60.w,
        ),
        SizedBox(
          width: 15.w,
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width - 190.w),
          child: Column(
            children: [
              Text(
                localizationStrings.delivery_description1,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 15.h,
              ),
              RichText(
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(children: [
                    TextSpan(
                        text: localizationStrings.delivery_description2,
                        style: mainStyle(14, FontWeight.w500)),
                    TextSpan(
                      text: 'Extra10',
                      style: mainStyle(16.0, FontWeight.bold),
                    ),
                  ]))
            ],
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        if (DateTime.now().hour >= (closedHour ?? 14))
          Flexible(
            child: Text(
              localizationStrings.receive_it_tomorrow,
              style: mainStyle(16.0, FontWeight.w500, color: priceColor),
              textAlign: TextAlign.start,
            ),
          ),
      ],
    );
  }
}

class ProductDetailsSection extends StatelessWidget {
  const ProductDetailsSection({
    Key? key,
    required this.body,
    required this.title,
  }) : super(key: key);
  final String body;
  final String title;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTitle(
          title: title,
        ),
        SizedBox(
          height: 2.h,
        ),
        Html(
          data: body,
        ),
      ],
    );
  }
}

class ProductEvaluateSection extends StatelessWidget {
  const ProductEvaluateSection({
    Key? key,
    required this.overAllRating,
    required this.totalRating,
  }) : super(key: key);
  final String overAllRating;
  final String totalRating;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        double.parse(overAllRating) > 0
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  RatingBarIndicator(
                    rating: double.parse(overAllRating),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: primaryColor,
                    ),
                    itemCount: 5,
                    itemSize: 20.0.sp,
                    direction: Axis.horizontal,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(localizationStrings!.basedOn +
                      totalRating +
                      ' ' +
                      localizationStrings.reviews),
                ],
              )
            : SizedBox(
                width: 10,
              ),
        SizedBox(
          height: 15.h,
        ),
        Text(
          localizationStrings!.howToAddReview,
          style: mainStyle(16.0, FontWeight.w600),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          localizationStrings.howToAddReviewAnswer,
          style: mainStyle(14.0, FontWeight.w400),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          localizationStrings.youCanAddReviewAfter,
          style: mainStyle(16.0, FontWeight.w600),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          localizationStrings.weUseOurCustomers,
          style: mainStyle(14.0, FontWeight.w400),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
