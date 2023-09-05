import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clearance/core/constants/countries.dart';
import 'package:clearance/core/error_screens/show_error_message.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/cubit/account_state.dart';
import 'package:clearance/modules/main_layout/sub_layouts/product_details/add_to_cart_bottom_sheet_layout.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:math' as math;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:clearance/core/cache/cache.dart';
import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/constants/dimensions.dart';
import 'package:clearance/core/main_cubits/cubit_main.dart';
import 'package:clearance/core/main_cubits/states_main.dart';
import 'package:clearance/models/api_models/home_Section_model.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/cubit/account_cubit.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cart_screen.dart';
import 'package:clearance/modules/main_layout/sub_layouts/product_details/cubit/cubit_product_details.dart';

import '../../models/api_models/categories_model.dart';
import '../../models/api_models/search_uto_complete_model.dart';
import '../../modules/auth_screens/cubit/cubit_auth.dart';
import '../../modules/auth_screens/sign_in_screen.dart';
import '../../modules/main_layout/sub_layouts/account/sub_account/my_account.dart';
import '../../modules/main_layout/sub_layouts/categories/sub_sub_category_layout/sub_sub_category_layout.dart';
import '../../modules/main_layout/sub_layouts/product_details/product_details_layout.dart';
import '../error_screens/errors_screens.dart';
import '../main_cubits/search_cubit.dart';
import '../main_cubits/search_states.dart';
import '../main_functions/main_funcs.dart';
import '../styles_colors/styles_colors.dart';

class DefaultBackButton extends StatelessWidget {
  const DefaultBackButton({
    Key? key,
    required this.localizationStrings,
  }) : super(key: key);

  final AppLocalizations? localizationStrings;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: changeSvgColor("assets/images/public/Group 301.svg"),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SizedBox(
              height: 35.h,
              width: 35.h,
              child: localizationStrings!.language == 'English'
                  ? Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.rotationY(math.pi),
                      child: SvgPicture.string(
                        snapshot.data!,
                        fit: BoxFit.contain,
                      ),
                    )
                  : SvgPicture.string(
                      snapshot.data!,
                      fit: BoxFit.contain,
                    ),
            ),
          );
        });
  }
}

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.onClick,
    required this.title,
    this.titleColor,
    this.titleSize,
    this.borderColors,
    this.customHeight,
    this.backColor,
  }) : super(key: key);

  final Function()? onClick;
  final String title;
  final Color? titleColor;
  final double? titleSize;
  final Color? borderColors;
  final Color? backColor;
  final double? customHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: customHeight ?? 41.h,
        decoration: BoxDecoration(
          color: backColor ?? Colors.white,
          borderRadius: BorderRadius.circular(2.0),
          border: Border.all(width: 1.0, color: borderColors ?? primaryColor),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: mainStyle(titleSize ?? 16.0, FontWeight.w700,
                  color: titleColor ?? primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}

class DefaultInputField extends StatelessWidget {
  const DefaultInputField({
    Key? key,
    required this.label,
    this.controller,
    this.validate,
    this.inputFormatter,
    this.keyboardType,
    this.textInputAction,
  }) : super(key: key);

  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final List<TextInputFormatter>? inputFormatter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text(
            label,
            style: mainStyle(
              15.0,
              FontWeight.w300,
            ),
          ),
        ),
        SizedBox(
          height: 9.h,
        ),
        TextFormField(
          inputFormatters: inputFormatter,
          keyboardType: keyboardType,
          controller: controller,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.h),
            // icon: Icon(Icons.send),
            // hintText: 'Hint Text',
            // helperText: 'Helper Text',
            // counterText: '0 characters',

            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xffa4c4f4), width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),

            enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xffa4c4f4), width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),
          ),
          validator: validate,
          // height: 41.h,
          // decoration: BoxDecoration(
          //   color: const Color(0xffffffff),
          //   borderRadius: BorderRadius.circular(10.0),
          //   border: Border.all(width: 1.0, color: const Color(0xffa4c4f4)),
          // ),
        ),
      ],
    );
  }
}

class SimpleLoginInputField extends StatelessWidget {
  const SimpleLoginInputField({
    Key? key,
    this.hintText,
    this.suffix,
    this.onSubmit,
    this.onSuffixPressed,
    this.obscureText,
    this.maxLines,
    this.suffixColor,
    this.validate,
    this.controller,
    this.withoutBorders,
    this.hintStyle,
    this.inputFormatter,
    this.keyboardType,
    this.textInputAction,
  }) : super(key: key);

  final String? hintText;
  final bool? obscureText;
  final int? maxLines;
  final IconData? suffix;
  final Color? suffixColor;
  final String? Function(String?)? validate;
  final Function(String)? onSubmit;
  final Function()? onSuffixPressed;
  final TextEditingController? controller;
  final bool? withoutBorders;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatter;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: mainStyle(16.0, FontWeight.w300),
      obscureText: obscureText ?? false,
      textInputAction: textInputAction,
      maxLines: obscureText != null ? 1 : maxLines,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10.h),
        // icon: Icon(Icons.send),
        hintText: hintText,

        hintStyle: hintStyle ?? mainStyle(14.0, FontWeight.w300),
        // helperText: 'Helper Text',
        // counterText: '0 characters',
        border: (withoutBorders != null) ? InputBorder.none : null,
        focusedBorder: (withoutBorders != null)
            ? null
            : OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),

        enabledBorder: (withoutBorders != null)
            ? null
            : OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xffa4c4f4), width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),

        suffixIcon: suffix != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0.sp),
                child: IconButton(
                  onPressed: onSuffixPressed,
                  icon: Icon(
                    suffix,
                    color: suffixColor,
                    size: 28.sp,
                  ),
                ),
              )
            : null,
      ),
      validator: validate,
      onFieldSubmitted: onSubmit,
      controller: controller,
      inputFormatters: inputFormatter,
      keyboardType: keyboardType,
    );
  }
}

class DefaultProductItem extends StatelessWidget {
  const DefaultProductItem({
    Key? key,
    required this.productItem,
    required this.moreThan2Cross,
     this.backColor,
     this.frontColor,
    required this.isRelatedSoNavigateAndFinish,
  }) : super(key: key);
  final Product productItem;
  final Color? backColor;
  final Color? frontColor;
  final bool moreThan2Cross;
  final bool isRelatedSoNavigateAndFinish;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return GestureDetector(
      onTap: () {
        logg('item slug:' + productItem.slug.toString());
        ProductDetailsCubit.get(context).changeFirstRunVal(true);
        isRelatedSoNavigateAndFinish
            ? navigateToAndFinish(
                context,
                ProductDetailsLayout(
                  // productSlug: productItem.slug.toString(),
                  productId: productItem.id.toString(),
                ))
            : navigateToWithNavBar(
                context,
                ProductDetailsLayout(
                  // productSlug: productItem.slug.toString(),
                  productId: productItem.id.toString(),
                ),
                ProductDetailsLayout.routeName);
      },
      child: Stack(
        children: [
          DefaultContainer(
            borderColor: Colors.grey.withOpacity(0.2),
            backColor: backColor ?? Colors.transparent,
            radius:backColor !=null ? 5.sp :  0.0,
            childWidget: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 3.w),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: DefaultContainer(
                      // backColor: Colors.red,
                      width: double.infinity,
                      borderColor: backColor ?? Colors.transparent,
                      childWidget: Stack(
                        children: [
                          DefaultImage(
                            height: double.infinity,
                            width: double.infinity,
                            placeholderScale: 15,
                            radius: 5.sp,
                            boxFit: BoxFit.cover,
                            borderColor:backColor ?? Colors.transparent,
                            backColor:backColor ?? Colors.transparent,
                            backGroundImageUrl: productItem.thumbnail,
                          ),
                          (moreThan2Cross == true)
                              ? const SizedBox()
                              : Positioned(
                                  top: 5.0,
                                  right: 15.0,
                                  child: CircleAvatar(
                                    radius: 12.h,
                                    backgroundColor: Colors.white,
                                    child: GhLikeButton(
                                      initialLikeStatus:
                                          productItem.isFavourite,
                                      productId: productItem.id.toString(),
                                      size: 15.0,
                                    ),
                                  ))
                        ],
                      ),
                    ),
                  ),
                  (moreThan2Cross == true)
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: SizedBox(
                            // height: 35.h,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productItem.name!,
                                  style: mainStyle(12.0, FontWeight.w600,
                                      color: frontColor ?? Colors.black),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        productItem.offerPrice! <
                                                productItem.price!
                                            ? Text(
                                                productItem.priceFormatted!
                                                    .toString(),
                                                style: mainStyle(
                                                    10.0.w, FontWeight.w600,
                                                    fontFamily: 'poppins',
                                                    decorationThickness: 1.5,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    color:frontColor ??  Colors.grey),
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        SizedBox()
                                        // Text(
                                        //   'text',
                                        //   style: mainStyle(
                                        //     16.0,
                                        //     FontWeight.w900,
                                        //     color: mainBlueColor,
                                        //   ),
                                        //   maxLines: 1,
                                        //   overflow: TextOverflow.ellipsis,
                                        // ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          productItem.offerPriceFormatted!
                                              .toString(),
                                          style: mainStyle(
                                              10.w, FontWeight.w600,
                                              fontFamily: 'poppins',
                                              color: frontColor ??  primaryColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        // Row(
                                        //   crossAxisAlignment: CrossAxisAlignment.end,
                                        //   children: [
                                        //     Text(
                                        //       productItem.rating!.overallRating
                                        //           .toString(),
                                        //       style: mainStyle(14.0, FontWeight.w900,
                                        //           color: mainRedColorAux),
                                        //     ),
                                        //     SizedBox(
                                        //       width: 2.w,
                                        //     ),
                                        //     SvgPicture.asset(
                                        //       'assets/images/public/icons8_star.svg',
                                        //       height: 15.h,
                                        //     ),
                                        //     SizedBox(
                                        //       width: 5.w,
                                        //     ),
                                        //     Text(
                                        //       '(' +
                                        //           productItem.rating!.totalRating
                                        //               .toString() +
                                        //           ')',
                                        //       style: mainStyle(11.0, FontWeight.w600,
                                        //           color: Colors.grey),
                                        //     ),
                                        //   ],
                                        // )
                                      ],
                                    ),
                                    const Spacer(),
                                    InkWell(
                                        onTap: () {
                                          buildShowModalBottomSheet(context,
                                              isDismissible: false,
                                              body:
                                              AddToCartBottomSheetContent(
                                                productId: productItem.id.toString(),
                                              ));
                                        },
                                        child:  Icon(
                                            CupertinoIcons.shopping_cart,color: frontColor,))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            child: FormattedOfferPercent(
                newPrice: productItem.offerPriceFormatted!,
                price: productItem.priceFormatted!),
          ),
          if (productItem.flashDealDetails != null)
            Positioned(
              top: 0.0,
              right: 1.0,
              child: FlashDealItemTimer(
                startDate: productItem.flashDealDetails!.startDate!,
                endDate: productItem.flashDealDetails!.endDate!,
              ),
            ),
        ],
      ),
    );
  }
}

class EnjoyFreeShippingWidget extends StatelessWidget {
  const EnjoyFreeShippingWidget({required this.restValue, Key? key})
      : super(key: key);
  final String restValue;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.all(5.r),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width:1.sw-70.w,
            child: Wrap(
              children: [
                Text(
                  localizationStrings!.lbl_add,
                  style: mainStyle(15.w, FontWeight.w500),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Text(
                  restValue,
                  style: mainStyle(17.w, FontWeight.bold),
                ),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  localizationStrings.enjoy_free_shipping,
                  style: mainStyle(15.w, FontWeight.w500),
                ),
                Text(
                  localizationStrings.free_shipping,
                  style: mainStyle(15.w, FontWeight.w500,color: priceColor),
                ),
                SizedBox(
                  width: 4.w,
                ),
              ],
            ),
          ),
          ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(
                width:50.w,
                child: DefaultButton(
                  title: localizationStrings.lbl_add,
                  titleSize: 12.w,
                  backColor: primaryColor,
                  borderColors: primaryColor,
                  titleColor: mainBackgroundColor,
                  onClick: (){
                    MainCubit.get(context).navigateToTap(0);
                  },
                ),
              ))
        ],
      ),
    );
  }
}

class FlashDealItemTimer extends StatefulWidget {
  const FlashDealItemTimer(
      {required this.startDate, required this.endDate, Key? key})
      : super(key: key);

  final String startDate;
  final String endDate;

  @override
  State<FlashDealItemTimer> createState() => _FlashDealItemTimerState();
}

class _FlashDealItemTimerState extends State<FlashDealItemTimer> {
  late CountdownTimerController controller;
  late int endTime;

  onEnd() {
    controller.disposeTimer();
  }

  @override
  void initState() {
    List<String> data = widget.endDate.split('/');
    print(data);
    endTime = DateTime.now().millisecondsSinceEpoch +
        1000 *
            (DateTime(int.parse(data[2]), int.parse(data[0]),
                    int.parse(data[1]) + 1)
                .difference(DateTime.now())
                .inSeconds);
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
    controller.start();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.sp), color: flashDealBackColor),
      child: Padding(
          padding: EdgeInsets.only(left: 3.sp, right: 3.sp, top: 3.sp),
          child: CountdownTimer(
            widgetBuilder: (_, remainingTime) {
              return Text(
                '${remainingTime?.days ?? '00'}:${remainingTime?.hours ?? '00'}:${remainingTime?.min ?? '00'}:${remainingTime?.sec ?? '00'}',
                style: mainStyle(14.0.h, FontWeight.w200,
                    color: flashDealForeColor),
              );
            },
            controller: controller,
            onEnd: onEnd,
            endTime: endTime,
            endWidget: const SizedBox(),
          )),
    );
  }
}

class JustTitleProductItem extends StatelessWidget {
  const JustTitleProductItem(
      {Key? key, required this.productItem, required this.moreThan2Cross})
      : super(key: key);
  final Product productItem;

  final bool moreThan2Cross;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return GestureDetector(
      onTap: () {
        logg('item slug:' + productItem.slug.toString());
        ProductDetailsCubit.get(context).changeFirstRunVal(true);
        navigateToWithNavBar(
            context,
            ProductDetailsLayout(
              // productSlug: productItem.slug.toString(),
              productId: productItem.id.toString(),
            ),
            ProductDetailsLayout.routeName);
      },
      child: DefaultContainer(
        borderColor: primaryColor.withOpacity(0.3),
        childWidget: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: DefaultImage(
                height: 0.41.sw,
                width: double.infinity,
                placeholderScale: 15,
                borderColor: Colors.transparent,
                boxFit: BoxFit.contain,
                backColor: Colors.transparent,
                backGroundImageUrl: productItem.thumbnail,
                // withoutRadius: true,
                radius: 7.sp,
              ),
            ),
            // Stack(
            //   children: [
            //     SizedBox(
            //       height: 0.42.sw,
            //       child: Stack(
            //         children: [
            //           Stack(
            //             children: [
            //               DefaultImage(
            //                 height:  0.40.sw,
            //                 width: double.infinity,
            //                 placeholderScale: 15,
            //                 borderColor: Colors.transparent,
            //                 backColor: Colors.transparent,
            //                 backGroundImageUrl: productItem.thumbnail,
            //               ),
            //               Positioned(
            //                   top: 0.0,
            //                   left: locale.languageCode != 'en' ? 16.0.w : null,
            //                   right: locale.languageCode == 'en' ? 16.0.w : null,
            //                   // left: locale.languageCode == 'ar'
            //                   //     ? 16.0.w
            //                   //     : 125.0.w,
            //                   child: Stack(
            //                     children: [
            //                       SvgPicture.asset(
            //                         locale.languageCode == 'ar'
            //                             ? 'assets/images/public/Group 302.svg'
            //                             : 'assets/images/public/Group 303.svg',
            //                         height: 22.h,
            //                       ),
            //                     ],
            //                   ))
            //             ],
            //           ),
            //           (moreThan2Cross == true)
            //               ? const SizedBox()
            //               : Positioned(
            //               bottom: 0.0,
            //               left: 15.0,
            //               child: CircleAvatar(
            //                 radius: 8.h,
            //                 backgroundColor: Colors.white,
            //                 child: SvgPicture.asset(
            //                   'assets/images/public/empty_star.svg',
            //                   height: 10.h,
            //                 ),
            //               ))
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 8.0.sp, vertical: 10.sp),
              child: Text(
                productItem.name!,
                style: mainStyle(14.0, FontWeight.w300, color: Colors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneInputField extends StatelessWidget {
  PhoneInputField(
      {Key? key,
      required this.label,
      this.fromProfile = false,
      this.phoneController,
      this.onInputChanged})
      : super(key: key);

  final String label;
  final bool fromProfile;
  final TextEditingController? phoneController;
  final void Function(PhoneNumber number)? onInputChanged;
  final ValueNotifier<bool> isValidate = ValueNotifier(true);
  final ValueNotifier<bool> isFocused = ValueNotifier(false);
  PhoneNumber phone = PhoneNumber();

  @override
  Widget build(BuildContext context) {
    var accountCubit = AccountCubit.get(context);
    String? locale = getCachedLocal();
    var authCubit = AuthCubit.get(context);
    logg('user phone :\t ${authCubit.userInfoModel?.data?.phone?.toString()}');
    logg(
        'user dial code :\t ${authCubit.userInfoModel?.data?.dialCode?.toString()}');
    phoneController!.text = fromProfile
        ? (double.tryParse(authCubit.userInfoModel!.data!.phone!) == null
            ? ''
            : authCubit.userInfoModel?.data?.phone?.substring(
                    authCubit.userInfoModel?.data?.dialCode?.length ?? 4) ??
                '')
        : (getCachedPhoneNumber() ?? '');
    logg('cached phone :' + (getCachedPhoneNumber() ?? ''));
    var localizationStrings = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text(
            label,
            style: mainStyle(15.0, FontWeight.w300),
          ),
        ),
        SizedBox(
          height: 9.h,
        ),
        ValueListenableBuilder<bool>(
            valueListenable: isFocused,
            builder: (context, focus, _) {
              return ValueListenableBuilder<bool>(
                  valueListenable: isValidate,
                  builder: (context, validate, _) {
                    return InkWell(
                      onFocusChange: (focus) {
                        isFocused.value = focus;
                      },
                      child: DefaultContainer(
                        borderColor:
                            validate ? const Color(0xffa4c4f4) : primaryColor,
                        radius: 11.0.sp,
                        borderWidth: focus ? 2.0 : 1.0,
                        childWidget: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2 * defaultHorizontalPadding),
                          child: InternationalPhoneNumberInput(
                            textFieldController: phoneController,
                            hintText: localizationStrings!.enterPhoneNumber,
                            onFieldSubmitted: (String? val) {
                              // accountCubit.updatePhoneNum(val!);
                            },
                            keyboardType: TextInputType.number,
                            inputDecoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            formatInput: true,
                            validator: (String? val) {
                              logg('validator value ' +
                                  val!.replaceAll(RegExp(r"\s+"), ""));
                              if (val.isEmpty) {
                                isValidate.value = false;
                                return localizationStrings.fields_required;
                              } else if (double.tryParse(
                                      val.replaceAll(RegExp(r'[^0-9]'), '')) ==
                                  null) {
                                isValidate.value = false;
                                return localizationStrings.invalid_phone;
                              }
                              String dialCode = fromProfile
                                  ? (phone.dialCode ?? '+971')
                                  : getCachedPhoneDialCode() ?? '';
                              Country country = countries.firstWhere(
                                  (element) => element.dialCode == dialCode);
                              if ((country.minLength - 1) >
                                  (val.replaceAll(RegExp(r'[^0-9]'), ''))
                                      .length) {
                                isValidate.value = false;
                                return localizationStrings.phone_short;
                              } else if (country.maxLength <
                                  (val.replaceAll(RegExp(r'[^0-9]'), ''))
                                      .length) {
                                isValidate.value = false;
                                return localizationStrings.phone_long;
                              }
                              isValidate.value = true;
                              return null;
                            },
                            onInputChanged: onInputChanged == null
                                ? (PhoneNumber value) {
                                    // PhoneNumber.getRegionInfoFromPhoneNumber(String phoneNumber, [String isoCode])
                                    logg('phone: ' + value.toString());
                                    accountCubit.updatePhoneNum(value);
                                    int sz = value.dialCode!.length;
                                    saveCachePhoneCode(value.isoCode);
                                    saveCachePhoneDialCode(value.dialCode);
                                    saveCachePhoneNumber(
                                        value.phoneNumber!.substring(sz));
                                  }
                                : (PhoneNumber value) {
                                    onInputChanged!.call(value);
                                    phone = value;
                                  },
                            locale: locale,
                            initialValue: PhoneNumber(
                                isoCode: fromProfile
                                    ? (double.tryParse(authCubit.userInfoModel
                                                    ?.data?.phone ??
                                                'random') ==
                                            null)
                                        ? 'AE'
                                        : countries
                                            .firstWhere((element) =>
                                                element.dialCode ==
                                                (authCubit.userInfoModel?.data
                                                        ?.dialCode ??
                                                    authCubit.userInfoModel
                                                        ?.data?.phone
                                                        ?.substring(0, 4) ??
                                                    '+971'))
                                            .code
                                    : (getCachedPhoneCode() ?? 'AE')),
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,

                              showFlags: true,

                              leadingPadding: 0.0,

                              trailingSpace: false,

                              // useEmoji : false,

                              setSelectorButtonAsPrefixIcon: false,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }),
        SizedBox(
          height: 15.h,
        ),

//         IntlPhoneField(
//       // isArabic: true,
// dropdownIconPosition: IconPosition.leading,
//      pickerDialogStyle: PickerDialogStyle(
//
//      ),
//           decoration: InputDecoration(
//             contentPadding: EdgeInsets.all(10.h),
//             // icon: Icon(Icons.send),
//             // hintText: 'Hint Text',
//             // helperText: 'Helper Text',
//             // counterText: '0 characters',
//
//             focusedBorder: OutlineInputBorder(
//                 borderSide:
//                     const BorderSide(color: Color(0xffa4c4f4), width: 2.0),
//                 borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),
//
//             enabledBorder: OutlineInputBorder(
//                 borderSide:
//                     const BorderSide(color: Color(0xffa4c4f4), width: 1.0),
//                 borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),
//           ),
//           initialCountryCode: 'AE',
//           onChanged: (phone) {
//             logg(phone.completeNumber);
//           },
//         )
      ],
    );
  }
}

class CustomBackAppBar extends StatelessWidget {
  const CustomBackAppBar({
    Key? key,
    required this.localizationStrings,
  }) : super(key: key);

  final localizationStrings;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: DefaultBackButton(localizationStrings: localizationStrings),
        ),
      ],
    );
  }
}

class DefaultContainer extends StatelessWidget {
  const DefaultContainer(
      {Key? key,
      this.width,
      this.height,
      this.backColor,
      this.borderColor,
      this.childWidget,
      this.borderWidth,
      // this.backGroundImageUrl,
      this.radius,
      this.withoutRadius})
      : super(key: key);

  final double? width;
  final double? borderWidth;
  final double? height;
  final Color? backColor;
  final Color? borderColor;
  final Widget? childWidget;

  // final String? backGroundImageUrl;
  final bool? withoutRadius;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      // padding: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.circular(
            withoutRadius != null ? 0.0 : radius ?? 2.0.sp),
        border: Border.all(
            width: borderWidth ?? 1.0, color: borderColor ?? Colors.black),
      ),
      child: childWidget,
    );
  }
}

class DefaultImage extends StatelessWidget {
  const DefaultImage(
      {Key? key,
      this.width,
      this.height,
      this.backColor,
      this.borderColor,
      this.backGroundImageUrl,
      this.radius,
      this.placeholderScale,
      this.boxFit,
      this.customImageCacheHeight,
      this.withoutRadius})
      : super(key: key);

  final double? width;
  final double? height;
  final Color? backColor;
  final Color? borderColor;
  final String? backGroundImageUrl;
  final bool? withoutRadius;
  final double? radius;
  final double? placeholderScale;
  final BoxFit? boxFit;
  final int? customImageCacheHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        // padding: EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.circular(
              withoutRadius != null ? 0.0 : radius ?? 5.0.sp),
          border: Border.all(width: 1.0, color: borderColor ?? Colors.black),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              withoutRadius != null ? 0.0 : radius ?? 5.0.sp),
          child:
              // Text(backGroundImageUrl!)
              ///
              // Image.network(
              //   backGroundImageUrl!,
              //   errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) => Text('error'),
              // )
              ///
              CachedNetworkImage(
            imageUrl: backGroundImageUrl!,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: boxFit ?? BoxFit.cover,
                  // colorFilter:
                  // ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                ),
              ),
            ),
            placeholder: (context, url) => Center(child: DefaultLoader()),
            memCacheHeight: customImageCacheHeight ?? 200,
            errorWidget: (context, url, error) =>
                Center(child: ImageLoadingError()),
          ),

          ///
          ///
          ///commented this cache because error image not working
          //     Padding(
          //   padding: const EdgeInsets.all(1.0),
          //   child: FadeInImage.assetNetwork(
          //     placeholder: 'assets/images/public/clearance2.gif',
          //     image: backGroundImageUrl!,
          //
          //     placeholderScale: placeholderScale ?? 8,
          //
          //     ///
          //     ///
          //     /// those 2 lines solved full memory issue
          //     ///
          //     imageCacheHeight: customImageCacheHeight ?? 700,
          //     placeholderCacheHeight: 20,
          //
          //     ///
          //     ///
          //     ///
          //     ///
          //     placeholderFit: BoxFit.scaleDown,
          //     fit: boxFit ?? BoxFit.cover,
          //
          //     imageErrorBuilder: (context, error, stackTrace) {
          //       logg('image build error : ' + error.toString());
          //       return const ImageLoadingError();
          //     },
          //   ),
          // ),

          ///
          ///
          // FadeInImage.assetNetwork(
          //
          //   placeholder: 'assets/images/public/madleenLoader.gif',
          //   image: backGroundImageUrl!,
          //   placeholderScale: placeholderScale ?? 8,
          //   placeholderFit: BoxFit.scaleDown,
          //   fit: boxFit ?? BoxFit.cover,
          //   imageErrorBuilder: (context, error, stackTrace) => Transform(
          //       alignment: Alignment.bottomCenter,
          //       transform: Matrix4.rotationY(math.pi),
          //       child: const ImageLoadingError()),
          // ),
        ));
  }
}

// class SearchBar extends StatelessWidget {
//   const SearchBar({
//     Key? key,
//     this.backButton,
//   }) : super(key: key);
//   final bool? backButton;
//
//   @override
//   Widget build(BuildContext context) {
//     var localizationStrings = AppLocalizations.of(context);
//
//     return Container(
//       height: 65.h,
//       decoration: BoxDecoration(
//         color: mainBackgroundColor,
//         borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(11.0.sp),
//             bottomRight: Radius.circular(11.0.sp)),
//         border: Border.all(width: 1.0, color: mainBackgroundColor),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           if (backButton != null)
//             DefaultBackButton(localizationStrings: localizationStrings),
//           Padding(
//             padding: const EdgeInsets.all(2.0),
//             child: DefaultContainer(
//               width: 315,
//               height: 40.h,
//               borderColor: Colors.transparent,
//               childWidget: Stack(
//                 children: [
//                   DefaultContainer(
//                     width: 299,
//                     height: 37.5.h,
//                     backColor: Colors.white,
//                     borderColor: Colors.transparent,
//                     childWidget: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           width: 10.w,
//                         ),
//                         Text(
//                           'Search',
//                           style: mainStyle(14.0, FontWeight.w600,
//                               color: Colors.grey),
//                         ),
//                         const SizedBox(
//                           width: 55,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CircleAvatar(
//                         radius: 30.h,
//                         backgroundColor: mainGreenColor,
//                         child: Center(
//                           child: SvgPicture.asset(
//                               'assets/images/public/search.svg'),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class GhLikeButton extends StatelessWidget {
  const GhLikeButton({
    Key? key,
    required this.initialLikeStatus,
    required this.productId,
    this.size,
  }) : super(key: key);

  final bool? initialLikeStatus;
  final String productId;
  final double? size;

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return LikeButton(
      // extract it to public one
      likeCountPadding: const EdgeInsets.all(0.0),

      padding: const EdgeInsets.all(0.0),
      isLiked: initialLikeStatus ?? false,
      size: size ?? 25.sp,
      bubblesColor: BubblesColor(
          dotPrimaryColor: primaryColor,
          dotSecondaryColor: newSoftGreyColorAux),
      circleColor: CircleColor(start: primaryColor, end: primaryColor),
      likeBuilder: (bool isLiked) {
        return isLiked
            ? Icon(
                Icons.favorite,
                color: primaryColor,
                size: size ?? 30.sp,
              )
            // Icon(
            //         Icons.favorite,
            //         color: Colors.red,
            //       )
            : Icon(
                Icons.favorite_border,
                color: primaryColor,
                size: size ?? 30.sp,
              );
      },
      onTap: (bool isLiked) async {
        if (getCachedToken() == null) {
          showTopModalSheetErrorLoginRequired(context);
          return null;
        } else {
          isLiked
              ? mainCubit.removeProductFromWishList(productId , context)
              : mainCubit.addProductToWishList(productId , context);
          return !isLiked;
        }
      },
    );
  }
}

class ScrollableFilterCategories extends StatelessWidget {
  const ScrollableFilterCategories({
    Key? key,
    required this.categoriesModel,
    // required this.selectedCategoryId,
  }) : super(key: key);

  // final List<category_config.CategoriesHome> filterCategories;
  // final String selectedCategoryId;
  final CategoriesModel categoriesModel;

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    var localizationStrings = AppLocalizations.of(context);

    return DefaultContainer(
      backColor: Colors.white,
      borderColor: mainBackgroundColor,
      width: double.infinity,
      childWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 13.4.h,
          ),
          SizedBox(
            height: 250.w,
            child: Center(
              child: Row(
                children: [
                  const SizedBox(
                    width: defaultHorizontalPadding * 2.5,
                  ),
                  Expanded(
                    child: Center(
                        child: GridView.count(
                      physics: BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      // childAspectRatio: viewType == 'grid' ? ((SizeConfig.screenWidth!>=350)? 7/8:5/7) : 6 / 2,
                      childAspectRatio: 110.w / 100.w,
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 5.h,
                      crossAxisSpacing: 5.w,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                          categoriesModel.data!.length,
                          (index) => GestureDetector(
                                onTap: () {
                                  navigateToWithNavBar(
                                      context,
                                      SubSubCategoryLayout(
                                          cateId: categoriesModel
                                              .data![index].id!
                                              .toString(),
                                          token: mainCubit.token),
                                      SubSubCategoryLayout.routeName);
                                  // if (categoriesModel![index].id.toString() ==
                                  //     mainCubit.selectedHomeCategoryFilter) {
                                  //   mainCubit.changeSelectedCategoryId('0');
                                  // } else {
                                  //   mainCubit.changeSelectedCategoryId(
                                  //       categoriesModel![index].id.toString());
                                  // }
                                  // saveCacheSelectedHomeCategoryId(filterCategories[index].id.toString());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: DefaultContainer(
                                    width: 75.h,
                                    borderColor: Colors.transparent,
                                    childWidget: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Center(
                                              child: CircleAvatar(
                                                radius: 35.sp,
                                                backgroundColor: primaryColor,
                                              ),
                                            ),
                                            Center(
                                              child: CircleAvatar(
                                                radius: 42.sp,
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: Image.network(
                                                  categoriesModel
                                                      .data![index].icon
                                                      .toString(),
                                                  fit: BoxFit.contain,
                                                  colorBlendMode:
                                                      BlendMode.colorBurn,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }

                                                    return SizedBox(
                                                      width: 80.w,
                                                      height: 50.h,
                                                      child:
                                                          const DefaultLoader(),
                                                    );
                                                    // You can use LinearProgressIndicator or CircularProgressIndicator instead
                                                  },
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      const ImageLoadingError(),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            categoriesModel.data![index].name!,
                                            maxLines: 1,
                                            style: mainStyle(
                                                14.0, FontWeight.w200,
                                                color: Colors.black),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ) //getProductObjectAsList
                          ),
                    )

                        // ListView.separated(
                        //   shrinkWrap: true,
                        //   physics: const BouncingScrollPhysics(),
                        //   // shrinkWrap: true,
                        //   itemCount: filterCategories.length,
                        //   scrollDirection: Axis.horizontal,
                        //
                        //   separatorBuilder: (context, index) => SizedBox(
                        //     width: 10.w,
                        //   ),
                        //
                        //   itemBuilder: (context, index) =>
                        //       // buildArticleItem(model.data, context),
                        //       GestureDetector(
                        //     onTap: () {
                        //       if (filterCategories[index].id.toString() ==
                        //           mainCubit.selectedHomeCategoryFilter) {
                        //         mainCubit.changeSelectedCategoryId('0');
                        //       } else {
                        //         mainCubit.changeSelectedCategoryId(
                        //             filterCategories[index].id.toString());
                        //       }
                        //       // saveCacheSelectedHomeCategoryId(filterCategories[index].id.toString());
                        //     },
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(1.0),
                        //       child: DefaultContainer(
                        //         width: 63.h,
                        //         borderColor: selectedCategoryId ==
                        //                 filterCategories[index].id.toString()
                        //             ? Colors.blue.withOpacity(0.6)
                        //             : Colors.transparent,
                        //         childWidget: Column(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             DefaultContainer(
                        //               height: 62.h,
                        //               width: double.infinity,
                        //               backColor: Colors.white,
                        //               borderColor: Colors.transparent,
                        //               childWidget: Padding(
                        //                 padding: EdgeInsets.all(2.0.sp),
                        //                 child: Image.network(
                        //                   filterCategories[index].icon.toString(),
                        //                   fit: BoxFit.contain,
                        //                   loadingBuilder:
                        //                       (context, child, loadingProgress) {
                        //                     if (loadingProgress == null) {
                        //                       return child;
                        //                     }
                        //
                        //                     return SizedBox(
                        //                       width: 80.w,
                        //                       height: 50.h,
                        //                       child: const DefaultLoader(),
                        //                     );
                        //                     // You can use LinearProgressIndicator or CircularProgressIndicator instead
                        //                   },
                        //                   errorBuilder:
                        //                       (context, error, stackTrace) =>
                        //                           const ImageLoadingError(),
                        //                 ),
                        //               ),
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.all(3.0),
                        //               child: Text(
                        //                 filterCategories[index].name!,
                        //                 maxLines: 1,
                        //                 style: mainStyle(14.0, FontWeight.w200,
                        //                     color: Colors.black),
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 7.4.h,
          ),
        ],
      ),
    );
  }
}

class ProductsGridView extends StatelessWidget {
  const ProductsGridView({
    Key? key,
    required this.productsList,
    required this.crossAxisCount,
    required this.isInHome,
    required this.towByTowJustTitle,
    this.isInProductView,
    this.showNoProductsMessage=true,
    this.backColor,
    this.frontColor,
  }) : super(key: key);

  final List<Product> productsList;
  final int crossAxisCount;
  final bool isInHome;
  final bool showNoProductsMessage;
  final Color? backColor;
  final Color? frontColor;
  final bool towByTowJustTitle;
  final bool? isInProductView;

  @override
  Widget build(BuildContext context) {
    logg('length '+productsList.length.toString());
    logg('cross count '+crossAxisCount.toString());
    logg(isInHome.toString());
    return ConditionalBuilder(
      condition: productsList.isNotEmpty,
      builder: (context) => Column(
        children: [
          GridView.count(
            physics: isInHome
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            crossAxisCount: crossAxisCount,
            // childAspectRatio: viewType == 'grid' ? ((SizeConfig.screenWidth!>=350)? 7/8:5/7) : 6 / 2,
            childAspectRatio: (towByTowJustTitle)
                ? 9.w / 12.w
                : crossAxisCount == 4
                    ? 9.w / 9.w
                    : crossAxisCount == 3
                        ? 9.w / 9.w
                        : crossAxisCount == 2
                            ? 9.w / 15.w
                            : 9.w / 16.w,
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4.h,
            crossAxisSpacing: 5.w,

            children: List.generate(
                isInHome
                    ? crossAxisCount == 3
                        ? productsList.length < 9
                            ? productsList.length
                            : 9
                        : crossAxisCount == 2 && productsList.length>=4
                            ? 4
                            : productsList.length
                    : productsList.length,
                (index) => towByTowJustTitle
                    ? JustTitleProductItem(
                        productItem: productsList[index],
                        moreThan2Cross: crossAxisCount > 2 ? true : false,
                      )
                    : DefaultProductItem(
                        productItem: productsList[index],
                        backColor:backColor,
                        frontColor:frontColor,
                        isRelatedSoNavigateAndFinish: false,
                        moreThan2Cross: crossAxisCount > 2 ? true : false,
                      ) //getProductObjectAsList
                ),
          ),
          (isInProductView != null && isInProductView!)
              ? SizedBox(
                  height: 0.08.sh,
                )
              : SizedBox()
        ],
      ),
      fallback: (context) => showNoProductsMessage ? SizedBox(
        height: 115.h,
        child: const Center(
          child: Text('No products added'),
        ),
      ) : const SizedBox.shrink(),
    );
  }
}

class HomeProductsGridView extends StatelessWidget {
  const HomeProductsGridView({
    Key? key,
    required this.title,
    this.backColor,
    this.frontColor,
    required this.titleIcon,
    required this.productsList,
    this.viewInCategoriesLayout,
    this.isGift,
  }) : super(key: key);
  final bool? viewInCategoriesLayout;
  final bool? isGift;
  final Color? backColor;
  final Color? frontColor;
  final String title;
  final String titleIcon;
  final List<Product> productsList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding * 2),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          viewInCategoriesLayout != null
              ? CategoriesGroupHeader(
                  title: title,
                  titleIcon: titleIcon,
                  isGift: isGift!,
                )
              : DefaultGroupHeader(
                  title: title,
                  titleIcon: titleIcon,
                ),
          SizedBox(
            height: 11.h,
          ),
          ProductsGridView(
            isInHome: true,
            backColor:backColor,
            frontColor:frontColor,
            towByTowJustTitle: false,
            productsList: productsList,
            crossAxisCount: 2,
          )
        ],
      ),
    );
  }
}

class CategoriesProductsGridView extends StatelessWidget {
  const CategoriesProductsGridView({
    Key? key,
    required this.title,
    required this.titleIcon,
    required this.productsList,
    this.viewInCategoriesLayout,
    this.isGift,
  }) : super(key: key);
  final bool? viewInCategoriesLayout;
  final bool? isGift;
  final String title;
  final String titleIcon;
  final List<Product> productsList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding * 2),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          viewInCategoriesLayout != null
              ? CategoriesGroupHeader(
                  title: title,
                  titleIcon: titleIcon,
                  isGift: isGift!,
                )
              : DefaultGroupHeader(
                  title: title,
                  titleIcon: titleIcon,
                ),
          SizedBox(
            height: 11.h,
          ),
          ProductsGridView(
            isInHome: true,
            towByTowJustTitle: false,
            productsList: productsList,
            crossAxisCount: 2,
          )
        ],
      ),
    );
  }
}

class HomeProductsGridThreePerLine extends StatelessWidget {
  const HomeProductsGridThreePerLine({
    Key? key,
    required this.title,
    required this.titleIcon,
    required this.productsList,
    this.viewInCategoriesLayout,
    this.isGift,
  }) : super(key: key);

  final String title;
  final String titleIcon;
  final List<Product> productsList;
  final bool? viewInCategoriesLayout;
  final bool? isGift;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding * 2),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          viewInCategoriesLayout != null
              ? CategoriesGroupHeader(
                  title: title,
                  titleIcon: titleIcon,
                  isGift: isGift!,
                )
              : DefaultGroupHeader(
                  title: title,
                  titleIcon: titleIcon,
                ),
          SizedBox(
            height: 11.h,
          ),
          ProductsGridView(
            isInHome: true,
            towByTowJustTitle: false,
            productsList: productsList,
            crossAxisCount: 3,
          )
        ],
      ),
    );
  }
}

class HomeOffers extends StatelessWidget {
  const HomeOffers({
    Key? key,
    required this.title,
    required this.titleIcon,
    required this.offersList,
    required this.offerStyle,
    required this.style,
    required this.offerBackColor,
  }) : super(key: key);

  final String title;
  final String titleIcon;
  final String offerStyle;
  final String style;
  final Color offerBackColor;
  final List<dynamic> offersList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(
        //   height: 10.h,
        // ),
        // DefaultGroupHeader(
        //   title: title,
        //   titleIcon: titleIcon,
        // ),
        // SizedBox(
        //   height: 11.h,
        // ),
        offerStyle == 'horizontal'
            ? Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultHorizontalPadding * 2, vertical: 10.h),
                child: SizedBox(
                  height: 100.h,
                  // child: ListView.separated(
                  //   itemCount: offersList.length,
                  //   shrinkWrap: true,
                  //   itemBuilder: (context, index) =>
                  //       //
                  //       //
                  //       OfferItem(offer: offersList[index]),
                  //   //
                  //   //
                  //   scrollDirection: Axis.horizontal,
                  //   separatorBuilder: (context, index) => SizedBox(
                  //     width: 7.w,
                  //   ),
                  // ),
                ),
              )
            : offerStyle == 'towByTowWithBack'
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        // horizontal: defaultHorizontalPadding * 2,
                        vertical: 10.h),
                    child: Container(
                      color: offerBackColor,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultHorizontalPadding * 2,
                            vertical: 10.h),
                        child: Column(
                          children: [
                            Text(
                              title,
                              style: mainStyle(16.0, FontWeight.w800),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            // GridView.count(
                            //   physics: NeverScrollableScrollPhysics(),
                            //   crossAxisCount: 2,
                            //
                            //   // childAspectRatio: viewType == 'grid' ? ((SizeConfig.screenWidth!>=350)? 7/8:5/7) : 6 / 2,
                            //   childAspectRatio: 15.w / 9.w,
                            //   padding: const EdgeInsets.all(0),
                            //   shrinkWrap: true,
                            //   // physics: const NeverScrollableScrollPhysics(),
                            //   mainAxisSpacing: 5.h,
                            //   crossAxisSpacing: 5.w,
                            //   children: List.generate(
                            //     offersList.length,
                            //     (index) => OfferItem(
                            //         offer: offersList[
                            //             index]), //getProductObjectAsList
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    child: Center(
                      child: Text('style undefined'),
                    ),
                  )
      ],
    );
  }
}

// class OfferItem extends StatelessWidget {
//   const OfferItem({
//     Key? key,
//     required this.offer,
//   }) : super(key: key);
//
//   final HsOffer offer;
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultImage(
//       width: 72.w,
//       borderColor: Colors.transparent,
//       backGroundImageUrl: offer.photo,
//     )
//
//         //   DefaultContainer(
//         //   width: 155.w,
//         //   borderColor: softBlueColor,
//         //   childWidget: Padding(
//         //     padding: EdgeInsets.all(4.0.sp),
//         //     child: Row(
//         //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         //       children: [
//         //         DefaultContainer(
//         //           width: 72.w,
//         //           borderColor: Colors.transparent,
//         //           backGroundImageUrl: offer.photo,
//         //         ),
//         //         SizedBox(
//         //           width: 5.w,
//         //         ),
//         //         Expanded(
//         //           child: Text(
//         //             offer.title!,
//         //             textAlign: TextAlign.center,
//         //             style: mainStyle(16.0, FontWeight.w900),
//         //           ),
//         //         )
//         //       ],
//         //     ),
//         //   ),
//         // )
//         ;
//   }
// }

class HomeProductsGridFourPerLine extends StatelessWidget {
  const HomeProductsGridFourPerLine({
    Key? key,
    required this.title,
    required this.titleIcon,
    required this.productsList,
    this.viewInCategoriesLayout,
    this.isGift,
  }) : super(key: key);

  final String title;
  final String titleIcon;
  final List<Product> productsList;
  final bool? viewInCategoriesLayout;
  final bool? isGift;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        viewInCategoriesLayout != null
            ? CategoriesGroupHeader(
                title: title,
                titleIcon: titleIcon,
                isGift: isGift!,
              )
            : DefaultGroupHeader(
                title: title,
                titleIcon: titleIcon,
              ),
        SizedBox(
          height: 11.h,
        ),
        ProductsGridView(
          isInHome: true,
          towByTowJustTitle: false,
          productsList: productsList,
          crossAxisCount: 4,
        )
      ],
    );
  }
}

class HomeProductsHorizontalView extends StatelessWidget {
  const HomeProductsHorizontalView({
    Key? key,
    required this.title,
    required this.titleIcon,
    required this.productsList,
    this.viewInCategoriesLayout,
    this.isGift,
  }) : super(key: key);

  final bool? viewInCategoriesLayout;
  final bool? isGift;
  final String title;
  final String titleIcon;
  final List<Product> productsList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultHorizontalPadding * 2),
          child: viewInCategoriesLayout != null
              ? CategoriesGroupHeader(
                  title: title,
                  titleIcon: titleIcon,
                  isGift: isGift!,
                )
              : DefaultGroupHeader(
                  title: title,
                  titleIcon: titleIcon,
                ),
        ),
        SizedBox(height: 11.h),
        SizedBox(
          height: 0.31.sw,
          // width: 80.w,
          child: ConditionalBuilder(
            condition: productsList.isNotEmpty,
            builder: (context) => Row(
              children: [
                SizedBox(
                  width: defaultHorizontalPadding * 2,
                ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    // shrinkWrap: true,
                    itemCount: productsList.length,
                    scrollDirection: Axis.horizontal,

                    separatorBuilder: (context, index) => SizedBox(
                      width: 5.w,
                    ),

                    itemBuilder: (context, index) =>
                        // buildArticleItem(model.data, context),
                        GestureDetector(
                      onTap: () {
                        logg(
                            'item slug:' + productsList[index].slug.toString());
                        ProductDetailsCubit.get(context)
                            .changeFirstRunVal(true);

                        navigateToWithNavBar(
                            context,
                            ProductDetailsLayout(
                              // productSlug: productsList[index].slug.toString(),
                              productId: productsList[index].id.toString(),
                            ),
                            ProductDetailsLayout.routeName);
                      },
                      child: SizedBox(
                        // width: 85.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DefaultImage(
                              // height: 85.h,
                              width: 0.21.sw,
                              height: 0.21.sw,
                              borderColor: Colors.transparent,
                              backGroundImageUrl: productsList[index].thumbnail,
                              placeholderScale: 18,
                            ),
                            SizedBox(
                              width: 0.21.sw,
                              child: Center(
                                child: Text(
                                  productsList[index].name!,
                                  style: mainStyle(14.0, FontWeight.w200,
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            fallback: (context) => const Center(
              child: Text('No products added'),
            ),
          ),
        ),
      ],
    );
  }
}

class DefaultGroupHeader extends StatelessWidget {
  const DefaultGroupHeader({
    Key? key,
    required this.title,
    required this.titleIcon,
  }) : super(key: key);

  final String title;
  final String titleIcon;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    return DefaultContainer(
      height: 30.h,
      backColor: Colors.white,
      borderColor: Colors.transparent,
      childWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 5.h,
                width: 5.h,
              ),
              SizedBox(
                height: 20.h,
                width: 20.h,
                // child: Image.network(titleIcon),
              ),
              SizedBox(
                height: 5.h,
                width: 5.h,
              ),
              Text(
                title,
                style: mainStyle(18.0, FontWeight.w700),
              ),
            ],
          ),
          // Text(
          //   localizationStrings!.viewAll,
          //   style: mainStyle(14.0, FontWeight.w700),
          // ),
          // Text('View all')
        ],
      ),
    );
  }
}

class CategoriesGroupHeader extends StatelessWidget {
  const CategoriesGroupHeader({
    Key? key,
    required this.title,
    required this.titleIcon,
    required this.isGift,
  }) : super(key: key);

  final String title;
  final String titleIcon;
  final bool isGift;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
          child: isGift
              ? SvgPicture.asset(
                  'assets/images/public/gift.svg',
                  fit: BoxFit.fill,
                )
              : null,
        ),
        DefaultContainer(
          height: 32.h,
          width: double.infinity,
          backColor: isGift ? categoryHeaderColor : Colors.transparent,
          borderColor: Colors.transparent,
          childWidget: Center(
              child: Text(
            title,
            style: mainStyle(14.0, FontWeight.w800,
                color: isGift ? Colors.white : Colors.black),
          )),
        ),
      ],
    );
  }
}

class MyTitle extends StatelessWidget {
  const MyTitle({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: mainStyle(16.0, FontWeight.w800),
    );
  }
}

class FormattedDate extends StatelessWidget {
  const FormattedDate({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Text(
      dateTime.year.toString() +
          '/' +
          dateTime.month.toString() +
          '/' +
          dateTime.day.toString() +
          '   ' +
          dateTime.hour.toString() +
          ':' +
          dateTime.minute.toString(),
      style: mainStyle(14.0, FontWeight.w400),
    );
  }
}

// AppBars
class UserInfoAndNotificationAppBar extends StatefulWidget {
  const UserInfoAndNotificationAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<UserInfoAndNotificationAppBar> createState() =>
      _UserInfoAndNotificationAppBarState();
}

class _UserInfoAndNotificationAppBarState
    extends State<UserInfoAndNotificationAppBar> {
  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    String? token = MainCubit.get(context).token;
    String? name = MainCubit.get(context).name;
    logg('logVal\n' + (token ?? 'token'));
    logg('logVal\n' + (name ?? 'name'));
    return BlocBuilder<AccountCubit, AccountStates>(
      builder: (context, state) {
        return AppBar(
          backgroundColor: newSoftGreyColorAux,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(17.sp),
            ),
          ),
          elevation: 0,
          leadingWidth: 75.w,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  isUserSignedIn(token)
                      ? navigateToWithNavBar(
                          context, const MyAccount(), MyAccount.routeName)
                      : showTopModalSheetErrorLoginRequired(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0.sp),
                  child: CircleAvatar(
                    radius: 17.h,
                    backgroundColor: Colors.transparent,
                    child: SvgPicture.asset(
                        'assets/images/account/icons8_test_account.svg'),
                  ),
                ),
              ),
            ],
          ),
          title: isUserSignedIn(token)
              ? Text(
                  token != null ? getCachedName()! : 'guest',
                  style: mainStyle(18.0, FontWeight.w800, color: titleColor),
                )
              : TextButton(
                  onPressed: () {
                    pushNewScreenLayout(context, SignInScreen(), false);
                  },
                  child: Text(
                    localizationStrings!.joinUs,
                    style: mainStyle(18.0, FontWeight.w800, color: titleColor),
                  ),
                ),
          // actions: [
          //   // Padding(
          //   //   padding: EdgeInsets.symmetric(horizontal: 31.0.w),
          //   //   child: SvgPicture.asset(
          //   //     'assets/images/public/icons8_notification.svg',
          //   //     height: 19.5.h,
          //   //   ),
          //   // )
          // ],
          // backgroundColor: Colors.blue,
        );
      },
    );
  }
}

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({
    Key? key,
    this.customCateId,
    required this.isBackButtonEnabled,
    this.onSearch
  }) : super(key: key);
  final String? customCateId;
  final bool isBackButtonEnabled;
  final void Function()? onSearch;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var searchCubit = SearchCubit.get(context);
    return AppBar(
      backgroundColor: newSoftGreyColorAux,
      systemOverlayStyle: SystemUiOverlayStyle.light,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(17.sp),
        ),
      ),
      elevation: 0,
      leadingWidth: isBackButtonEnabled ? 50.w : null,
      leading: isBackButtonEnabled
          ? Row(
              children: [
                SizedBox(
                  width: 7.w,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                  child: DefaultBackButton(
                      localizationStrings: localizationStrings),
                ),
              ],
            )
          : null,
      title: GestureDetector(
        onTap: onSearch ?? () {
          // searchCubit.toggleViewSearchFilters(false);
          // navigateToWithNavBar(context, GhSearchPage(), GhSearchPage.routeName);
          showSearch(
            context: context,
            delegate: CustomSearchDelegate(
                customCateId: customCateId, context: context),
          );
        },
        child: DefaultContainer(
          // width: isBackButtonEnabled ? 275.w : 315.w,
          height: 40.h,
          borderColor: Colors.transparent,
          childWidget: Stack(
            children: [
              DefaultContainer(
                // width: isBackButtonEnabled ? 245.w : 299.w,
                height: 37.5.h,
                radius: 25.sp,
                backColor: Colors.white.withOpacity(0.6),
                borderColor: Colors.transparent,
                childWidget: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 15.w,
                    ),
                    Text(
                      localizationStrings!.search,
                      style:
                          mainStyle(14.0, FontWeight.w600, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 55,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: localizationStrings.language == 'English' ? 0.0 : null,
                left: localizationStrings.language == 'English' ? 0.0 : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 18.h,
                      backgroundColor: primaryColor,
                      child: Center(
                        child:
                            SvgPicture.asset('assets/images/public/search.svg'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      // backgroundColor: Colors.blue,
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final String? customCateId;

  CustomSearchDelegate({this.customCateId, required this.context});

  StreamController? controller;

  BuildContext? context;

  void pagination() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent / 1.1 &&
        SearchCubit.get(context).state is! LoadingSearchResults &&
        SearchCubit.get(context).filteredProductsModel!.data!.totalSize !=
            SearchCubit.get(context).products.length) {
      logg('productsScrollController.position.pixels>='
          'productsScrollController.position.maxScrollExtent/1.5');
      logg('totalsize: ' +
          SearchCubit.get(context).filteredProductsModel!.data!.totalSize.toString());
      logg('current product list length: ' +
          SearchCubit.get(context).products.length.toString());
      SearchCubit.get(context).getSearchResults(query, customCateId ?? '');
    }
  }
  final scrollController = ScrollController();
  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme

    return super.appBarTheme(context);
  }
  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => '....';

  @override
  // TODO: implement updateSuggestionsFunction
  Function()? get updateSuggestionsFunction {
    logg('test');
    var searchCubit = SearchCubit.get(context);
    searchCubit.updateSuggestion(query);
    // return super.updateSuggestionsFunction;
  }

  //
  // @override
  // set updateSuggestionsFunction(Function? _updateSuggestionsFunction) {
  //   // TODO: implement updateSuggestionsFunction
  //   super.updateSuggestionsFunction = _updateSuggestionsFunction;
  //   var searchCubit=SearchCubit.get(context);
  //   searchCubit.updateSuggestion(query);
  // }

  @override
  // TODO: implement searchFieldStyle
  TextStyle? get searchFieldStyle => mainStyle(16.0, FontWeight.w400);

  @override
  // TODO: implement inputTextStyle
  TextStyle? get inputTextStyle => mainStyle(16.0, FontWeight.w600);

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      query.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
              },
            )
          : const SizedBox.shrink(),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return Padding(
      padding: EdgeInsets.all(14.0.sp),
      child:
          DefaultBackButton(localizationStrings: AppLocalizations.of(context)),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var searchCubit = SearchCubit.get(context);
    scrollController.addListener(pagination);
    // TODO: implement buildResults
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              localizationStrings!.searchTermMustBeLonger,
            ),
          )
        ],
      );
    }

    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using

    /*
The Bloc will then handle the searching and add the results to the searchResults stream.
        */

    // InheritedBlocs.of(context)
    //     .searchBloc
    //     .searchTerm
    //     .add(query);

    !searchCubit.inSearchProcess
        ? searchCubit.getSearchResults(query, customCateId ?? '')
        : null;

    return BlocConsumer<SearchCubit, SearchStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        // return searchCubit.inSearchProcess
        //     ? const Center(
        //         child: DefaultLoader(),
        //       )
        //     :
        return    Stack(
              children: [
                ConditionalBuilder(
                    condition: searchCubit.filteredProductsModel != null,
                    builder: (context) => (searchCubit
                            .filteredProductsModel!.data!.products!.isNotEmpty)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultHorizontalPadding * 3,
                                vertical: defaultHorizontalPadding * 3),
                            child: SingleChildScrollView(
                            controller: scrollController,
                              child: ProductsGridView(
                                isInHome: false,
                                crossAxisCount: 2,
                                towByTowJustTitle: false,
                                productsList: searchCubit.products,
                              ),
                            ),
                          )
                        : const Center(child: EmptyError()),
                    fallback: (context) => const DefaultLoader(),
                  ),
                state is LoadingSearchResults
                    ? Positioned(
                    bottom: 30.h,
                    child: SizedBox(
                        width: 1.sw,
                        child: Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ))))
                    : const SizedBox.shrink()
              ],
            );
      },
    );
  }

  //
  // final List<String> sampleResult =
  //     List<String>.generate(10, (index) => 'Result ${index + 1}');

  @override
  Widget buildSuggestions(BuildContext context) {
    var searchCubit = SearchCubit.get(context);
    var localizationStrings = AppLocalizations.of(context);
    // TODO: implement buildSuggestions
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.

    return BlocConsumer<SearchCubit, SearchStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final List<SearchAutoCompleteItem> _suggestions = searchCubit
            .suggestions
            .where((element) =>
                element.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return Column(
          children: [
            state is UpdatingSuggestions
                ? LinearProgressIndicator(
                    minHeight: 4.h,
                  )
                : SizedBox(
                    height: 4.h,
                  ),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (content, index) => ListTile(
                  onTap: () {
                    query = _suggestions[index].name!;
                    // Make your API call to get the result
                    // Here I'm using a sample result
                    // controller!.add(sampleResult);
                    showResults(context);
                  },
                  title:
                      // Html(
                      //   // customTextAlign: localizationStrings!.language == 'English'
                      //   //     ? (_) => TextAlign.left
                      //   //     : (_) => TextAlign.right,
                      //   data: _suggestions[index].name!,
                      // ),
                      Column(
                    children: [
                      //       Text(_suggestions[index].name!,
                      // style: mainStyle(14.0, FontWeight.w200)),
                      ///
                      ///
                      ///
                      Html(
                        // customTextAlign: localizationStrings!.language == 'English'
                        //     ? (_) => TextAlign.left
                        //     : (_) => TextAlign.right,
                        data: _suggestions[index].result!,

                        style: {
                          // p tag with text_size
                          "b": Style(
                            fontSize: FontSize(15.sp),
                            fontFamily: 'Tajawal',
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            
                            //padding: EdgeInsets.all(6),
                            // backgroundColor: Colors.grey,
                          ),
                          "i": Style(
                            fontSize: FontSize(15.sp),
                            fontFamily: 'Tajawal',
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            //padding: EdgeInsets.all(6),
                            // backgroundColor: Colors.grey,
                          ),
                          "div": Style(
                            fontSize: FontSize(13),
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.w200,
                            //padding: EdgeInsets.all(6),
                            // backgroundColor: Colors.grey,
                          ),
                        },
                        // // tagsList: [],
                        //   style: {
                        //     // tables will have the below background color
                        //     "b": Style(
                        //       backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                        //     ),
                        //     // some other granular customizations are also possible
                        //     "tr": Style(
                        //       border: Border(bottom: BorderSide(color: Colors.grey)),
                        //     ),
                        //     "th": Style(
                        //       padding: EdgeInsets.all(6),
                        //       backgroundColor: Colors.grey,
                        //     ),
                        //     "td": Style(
                        //       padding: EdgeInsets.all(6),
                        //       alignment: Alignment.topLeft,
                        //     ),
                        //     // text that renders h1 elements will be red
                        //     "h1": Style(color: Colors.red),
                        //   }
                      ),

                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      // //       Text(_suggestions[index].name!,
                      // // style: mainStyle(14.0, FontWeight.w200)),
                      //           Container(
                      //             height: 50,
                      //               width: 50,
                      //
                      //           ),
                      //
                      //     Text(_suggestions[index].category!,
                      // style: mainStyle(12.0, FontWeight.w600,color: mainGreenColor),
                      //
                      //       ),
                      //         ],
                      //       ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);

    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        switch (mainCubit.currentAppBarWidget) {
          case 'defaultBack':
            return const DefaultAppBarWithOnlyBackButton();
          case 'userInfo':
            return const UserInfoAndNotificationAppBar();
          default:
            return const SizedBox();
        }
      },
    );
  }
}

class DefaultAppBarWithOnlyBackButton extends StatelessWidget {
  const DefaultAppBarWithOnlyBackButton({
    Key? key,
    this.transparent,
  }) : super(key: key);
  final bool? transparent;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var mainCubit = MainCubit.get(context);
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.sp),
        ),
      ),
      elevation: 0,
      leadingWidth: 50.w,
      leading: Row(
        children: [
          SizedBox(
            width: 7.w,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0.w),
            child: DefaultBackButton(localizationStrings: localizationStrings),
          ),
        ],
      ),
      // title: isUserSignedIn(token)
      //     ? Text(
      //   name!,
      //   style: mainStyle(18.0, FontWeight.w800, color: titleColor),
      // )
      //     : Text(
      //   'Join us',
      //   style: mainStyle(18.0, FontWeight.w800, color: titleColor),
      // ),
      // actions: [
      //   Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 31.0.w),
      //     child: SvgPicture.asset(
      //       'assets/images/public/icons8_notification.svg',
      //       height: 19.5.h,
      //     ),
      //   )
      // ],
      backgroundColor:
          transparent != null ? Colors.transparent : newSoftGreyColorAux,
    );
  }
}

class DefaultAppBarWithTitleAndBackButton extends StatelessWidget {
  const DefaultAppBarWithTitleAndBackButton({
    Key? key,
    this.transparent,
    required this.title
  }) : super(key: key);
  final bool? transparent;
  final String title;

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.sp),
        ),
      ),
      elevation: 0,
      leadingWidth: 50.w,
      title: Row(
        children: [
          Text(title,
            style: mainStyle(18.0, FontWeight.w800, color: titleColor),
          ),
        ],
      ),
      // title: isUserSignedIn(token)
      //     ? Text(
      //   name!,
      //   style: mainStyle(18.0, FontWeight.w800, color: titleColor),
      // )
      //     : Text(
      //   'Join us',
      //   style: mainStyle(18.0, FontWeight.w800, color: titleColor),
      // ),
      // actions: [
      //   Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 31.0.w),
      //     child: SvgPicture.asset(
      //       'assets/images/public/icons8_notification.svg',
      //       height: 19.5.h,
      //     ),
      //   )
      // ],
      backgroundColor:
      transparent != null ? Colors.transparent : newSoftGreyColorAux,
    );
  }
}

class FlashDealsAppBar extends StatelessWidget {
  const FlashDealsAppBar({
    Key? key,
    this.transparent,
  }) : super(key: key);
  final bool? transparent;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var mainCubit = MainCubit.get(context);
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.sp),
        ),
      ),
      elevation: 0,
      leadingWidth: 50.w,
      leading: Row(
        children: [
          SizedBox(
            width: 7.w,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0.w),
            child: DefaultBackButton(localizationStrings: localizationStrings),
          ),
        ],
      ),
      title: Row(
        children: [
          Text(
            localizationStrings!.flash_deal,
            style: mainStyle(18.0, FontWeight.w800, color: titleColor),
          ),
          Image.asset(
            'assets/images/thunder.gif',
            height: 40.h,
            width: 40.w,
          )
        ],
      ),
      // title: isUserSignedIn(token)
      //     ? Text(
      //   name!,
      //   style: mainStyle(18.0, FontWeight.w800, color: titleColor),
      // )
      //     : Text(
      //   'Join us',
      //   style: mainStyle(18.0, FontWeight.w800, color: titleColor),
      // ),
      // actions: [
      //   Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 31.0.w),
      //     child: SvgPicture.asset(
      //       'assets/images/public/icons8_notification.svg',
      //       height: 19.5.h,
      //     ),
      //   )
      // ],
      backgroundColor:
          transparent != null ? Colors.transparent : newSoftGreyColorAux,
    );
  }
}

///
/*
class UserInfoAndNotificationAppBar extends StatelessWidget {
  const UserInfoAndNotificationAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    String? token = mainCubit.token;
    String? name = mainCubit.name;
    return AppBar(
      backgroundColor: newSoftGreyColorAux.withOpacity(0.3),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(17.sp),
        ),
      ),
      elevation: 0,
      leadingWidth: 75.w,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: CircleAvatar(
              radius: 17.h,
              backgroundColor: Colors.transparent,
              child: Image.asset('assets/icons/mainIcon.png'),
            ),
          ),
        ],
      ),
      title: isUserSignedIn(token)
          ? Text(
              'Welcome  ' + name!,
              style: mainStyle(18.0, FontWeight.w800, color: titleColor),
            )
          : TextButton(
              onPressed: () {
                navigateTo(context, SignInScreen());
              },
              child: Text(
                'Join us',
                style: mainStyle(18.0, FontWeight.w800, color: titleColor),
              ),
            ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 31.0.w),
          child: SvgPicture.asset(
            'assets/images/public/icons8_notification.svg',
            height: 19.5.h,
          ),
        )
      ],
      // backgroundColor: Colors.blue,
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final String? customCateId;

  CustomSearchDelegate({this.customCateId, required this.context});

  StreamController? controller;

  BuildContext? context;

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme

    return super.appBarTheme(context);
  }

  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => '....';

  @override
  // TODO: implement updateSuggestionsFunction
  Function()? get updateSuggestionsFunction {
    logg('test');
    var searchCubit = SearchCubit.get(context);
    searchCubit.updateSuggestion(query);
    return super.updateSuggestionsFunction;
  }

  //
  // @override
  // set updateSuggestionsFunction(Function? _updateSuggestionsFunction) {
  //   // TODO: implement updateSuggestionsFunction
  //   super.updateSuggestionsFunction = _updateSuggestionsFunction;
  //   var searchCubit=SearchCubit.get(context);
  //   searchCubit.updateSuggestion(query);
  // }

  @override
  // TODO: implement searchFieldStyle
  TextStyle? get searchFieldStyle => mainStyle(16.0, FontWeight.w400);

  @override
  // TODO: implement inputTextStyle
  TextStyle? get inputTextStyle => mainStyle(16.0, FontWeight.w600);

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return Padding(
      padding: EdgeInsets.all(14.0.sp),
      child:
          DefaultBackButton(localizationStrings: AppLocalizations.of(context)),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var searchCubit = SearchCubit.get(context);
    // TODO: implement buildResults
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              localizationStrings!.searchTermMustBeLonger,
            ),
          )
        ],
      );
    }

    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using

    /*
The Bloc will then handle the searching and add the results to the searchResults stream.
        */

    // InheritedBlocs.of(context)
    //     .searchBloc
    //     .searchTerm
    //     .add(query);

    !searchCubit.inSearchProcess
        ? searchCubit.getSearchResults(query, customCateId ?? '')
        : null;

    return BlocConsumer<SearchCubit, SearchStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return searchCubit.inSearchProcess
            ? const Center(
                child: DefaultLoader(),
              )
            : ConditionalBuilder(
                condition: searchCubit.filteredProductsModel != null ||
                    searchCubit.inSearchProcess,
                builder: (context) => (searchCubit
                        .filteredProductsModel!.data!.products!.isNotEmpty)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultHorizontalPadding * 3,
                            vertical: defaultHorizontalPadding * 3),
                        child: SingleChildScrollView(
                          child: ProductsGridView(
                            isInHome: false,
                            crossAxisCount: 2,
                            towByTowJustTitle: false,
                            productsList: searchCubit
                                .filteredProductsModel!.data!.products!,
                          ),
                        ),
                      )
                    : Center(child: EmptyError()),
                fallback: (context) => DefaultLoader(),
              );
      },
    );
  }

  //
  // final List<String> sampleResult =
  //     List<String>.generate(10, (index) => 'Result ${index + 1}');

  @override
  Widget buildSuggestions(BuildContext context) {
    var searchCubit = SearchCubit.get(context);
    var localizationStrings = AppLocalizations.of(context);
    // TODO: implement buildSuggestions
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.

    return BlocConsumer<SearchCubit, SearchStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final List<SearchAutoCompleteItem> _suggestions = searchCubit
            .suggestions
            .where((element) =>
                element.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return Column(
          children: [
            state is UpdatingSuggestions
                ? LinearProgressIndicator(
                    minHeight: 4.h,
                  )
                : SizedBox(
                    height: 4.h,
                  ),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (content, index) => ListTile(
                  onTap: () {
                    query = _suggestions[index].name!;
                    // Make your API call to get the result
                    // Here I'm using a sample result
                    // controller!.add(sampleResult);
                    showResults(context);
                  },
                  title:
                      // Html(
                      //   // customTextAlign: localizationStrings!.language == 'English'
                      //   //     ? (_) => TextAlign.left
                      //   //     : (_) => TextAlign.right,
                      //   data: _suggestions[index].name!,
                      // ),
                      Column(
                    children: [
                      //       Text(_suggestions[index].name!,
                      // style: mainStyle(14.0, FontWeight.w200)),
                      ///
                      ///
                      ///
                      Html(
                        // customTextAlign: localizationStrings!.language == 'English'
                        //     ? (_) => TextAlign.left
                        //     : (_) => TextAlign.right,
                        data: _suggestions[index].result!,

                        style: {
                          // p tag with text_size
                          "b": Style(
                            fontSize: FontSize(15.sp),
                            fontFamily: 'Tajawal',
                            color: mainRedColor,
                            fontWeight: FontWeight.w600,
                            padding: EdgeInsets.all(6),
                            // backgroundColor: Colors.grey,
                          ),
                          "i": Style(
                            fontSize: FontSize(15.sp),
                            fontFamily: 'Tajawal',
                            color: mainRedColor,
                            fontWeight: FontWeight.w600,
                            padding: EdgeInsets.all(6),
                            // backgroundColor: Colors.grey,
                          ),
                          "div": Style(
                            fontSize: FontSize(13),
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.w200,
                            padding: EdgeInsets.all(6),
                            // backgroundColor: Colors.grey,
                          ),
                        },
                        // // tagsList: [],
                        //   style: {
                        //     // tables will have the below background color
                        //     "b": Style(
                        //       backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                        //     ),
                        //     // some other granular customizations are also possible
                        //     "tr": Style(
                        //       border: Border(bottom: BorderSide(color: Colors.grey)),
                        //     ),
                        //     "th": Style(
                        //       padding: EdgeInsets.all(6),
                        //       backgroundColor: Colors.grey,
                        //     ),
                        //     "td": Style(
                        //       padding: EdgeInsets.all(6),
                        //       alignment: Alignment.topLeft,
                        //     ),
                        //     // text that renders h1 elements will be red
                        //     "h1": Style(color: Colors.red),
                        //   }
                      ),

                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      // //       Text(_suggestions[index].name!,
                      // // style: mainStyle(14.0, FontWeight.w200)),
                      //           Container(
                      //             height: 50,
                      //               width: 50,
                      //
                      //           ),
                      //
                      //     Text(_suggestions[index].category!,
                      // style: mainStyle(12.0, FontWeight.w600,color: mainGreenColor),
                      //
                      //       ),
                      //         ],
                      //       ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({
    required this.customCateId,
    required this.isBackButtonEnabled,
    Key? key,
  }) : super(key: key);
  final String? customCateId;
  final bool isBackButtonEnabled;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    return AppBar(
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(2.sp),
        ),
      ),
      elevation: 0,
      leading: isBackButtonEnabled
          ? Padding(
              padding: EdgeInsets.all(12.0.sp),
              child:
                  DefaultBackButton(localizationStrings: localizationStrings),
            )
          : null,
      title: GestureDetector(
        onTap: () {
          showSearch(
            context: context,
            delegate: CustomSearchDelegate(
                customCateId: customCateId, context: context),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: DefaultContainer(
                  width: 315.w,
                  height: 40.h,
                  borderColor: Colors.transparent,
                  childWidget: Stack(
                    children: [
                      DefaultContainer(
                        width: 299.w,
                        height: 37.5.h,
                        radius: 25.sp,
                        backColor: Colors.white.withOpacity(0.6),
                        borderColor: Colors.black.withOpacity(0.2),
                        childWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 15.w,
                            ),
                            SvgPicture.asset(
                              'assets/images/public/search.svg',
                              color: mainRedColor,
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Text(
                              localizationStrings!.search,
                              style: mainStyle(12.0, FontWeight.w300,
                                  color: Colors.black),
                            ),
                            // const SizedBox(
                            //   width: 55,
                            // ),
                            //
                            // SizedBox(
                            //   width: 15.w,
                            // ),
                          ],
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     CircleAvatar(
                      //       radius: 30.h,
                      //       backgroundColor: mainRedColorAux,
                      //       child: Center(
                      //         child: SvgPicture.asset(
                      //             'assets/images/public/search.svg'),
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
            ),
            Icon(
              CupertinoIcons.bell,
              color: mainRedColor,
            )
          ],
        ),
      ),

      // backgroundColor: Colors.blue,
    );
  }
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);

    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        switch (mainCubit.currentAppBarWidget) {
          case 'defaultBack':
            return DefaultAppBarWithOnlyBackButton();
          case 'userInfo':
            return UserInfoAndNotificationAppBar();
          default:
            return SizedBox();
        }
      },
    );
  }
}

class DefaultAppBarWithOnlyBackButton extends StatelessWidget {
  const DefaultAppBarWithOnlyBackButton({
    Key? key,
    this.transparent,
  }) : super(key: key);
  final bool? transparent;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var mainCubit = MainCubit.get(context);
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.sp),
        ),
      ),
      elevation: 0,
      leadingWidth: 75.w,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: CircleAvatar(
              radius: 17.h,
              backgroundColor: Colors.transparent,
              child:
                  DefaultBackButton(localizationStrings: localizationStrings),
            ),
          ),
        ],
      ),
      // title: isUserSignedIn(token)
      //     ? Text(
      //   name!,
      //   style: mainStyle(18.0, FontWeight.w800, color: titleColor),
      // )
      //     : Text(
      //   'Join us',
      //   style: mainStyle(18.0, FontWeight.w800, color: titleColor),
      // ),
      // actions: [
      //   Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 31.0.w),
      //     child: SvgPicture.asset(
      //       'assets/images/public/icons8_notification.svg',
      //       height: 19.5.h,
      //     ),
      //   )
      // ],
      backgroundColor:
          transparent != null ? Colors.transparent : newSoftGreyColorAux,
    );
  }
}
*/

///
///////////

Widget defaultFormField({
  TextEditingController? controller,
  TextInputType? type,
  TextInputAction? textInputAction,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? onEditingComplete,
  Function()? onTap,
  bool isPassword = false,
  String? Function(String?)? validate,
  String? label,
  String? prefixText,
  String? suffixText,
  double? labelSize,
  double? hintSize,
  Color? prefixColor,
  Color? suffixColor,
  IconData? prefix,
  IconData? suffix,
  Function()? suffixPressed,
  bool isClickable = true,
  bool centerText = false,
  bool justNumbers = false,
  InputDecoration? decoration,
  String? hint,
  bool? readOnly,
}) {
  return TextFormField(
    readOnly: readOnly != null,
    textAlign: centerText ? TextAlign.center : TextAlign.start,
    inputFormatters: justNumbers
        ? <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
          ]
        : null,
    controller: controller,
    keyboardType: type,
    textInputAction: textInputAction,
    obscureText: isPassword,
    enabled: isClickable,
    onFieldSubmitted: onSubmit,
    onChanged: onChange,
    onTap: onTap,
    onEditingComplete: onEditingComplete,
    validator: validate,
    decoration: decoration ??
        InputDecoration(
          labelText: label,
          hintText: hint,
          prefixText: prefixText,
          suffixText: suffixText,
          hintStyle: mainStyle(
            hintSize ?? 14.0,
            FontWeight.w200,
          ),
          labelStyle: mainStyle(labelSize ?? 14.0, FontWeight.w200),
          prefixIcon: prefix != null
              ? Icon(
                  prefix,
                  color: prefixColor,
                )
              : null,
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: suffixPressed,
                  icon: Icon(
                    suffix,
                    color: suffixColor,
                    size: 28.sp,
                  ),
                )
              : null,
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2.0)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2.0)),
        ),
    // maxLines: null,
  );
}

class FormattedPrice extends StatelessWidget {
  const FormattedPrice({
    Key? key,
    required this.price,
  }) : super(key: key);

  final String price;

  @override
  Widget build(BuildContext context) {
    price.replaceAll(',', '');
    return RichText(
      text: TextSpan(
        text: '',
        style: mainStyle(14.0, FontWeight.w200),
        children: <TextSpan>[
          TextSpan(
            text: price.split(' ')[0],
            style: mainStyle(18.0, FontWeight.w900, color: priceColor,fontFamily: 'poppins'),
          ),
          TextSpan(
            text: ' ',
            style: mainStyle(18.0, FontWeight.w200),
          ),
          TextSpan(
            text: price.split(' ')[1],
            style: mainStyle(18.0, FontWeight.w400, color: priceColor),
          ),
        ],
      ),
    );
  }
}

class FormattedPriceOld extends StatelessWidget {
   FormattedPriceOld({
    Key? key,
    required this.price,
    required this.newPrice,
  }) : super(key: key);

   String price;
   String newPrice;

  @override
  Widget build(BuildContext context) {
    price= price.replaceAll(',', '');
    newPrice= newPrice.replaceAll(',', '');
    int percent = ((double.parse(price.split(' ')[0]) -
                double.parse(newPrice.split(' ')[0])) /
            double.parse(price.split(' ')[0]) *
            100)
        .toInt();
    return Container(
      padding: EdgeInsets.all(3.sp),
      color: getBackgroundColor(percent),
      child: Row(
        children: [
          Text(
            '${price.split(' ')[0]}  ${price.split(' ')[1]}',
            style: mainStyle(18.0, FontWeight.w200,
                color: getForegroundColor(percent),
                fontFamily: 'poppins',
                decoration: TextDecoration.lineThrough,
                decorationThickness: 1.5),
          ),
          Text(
            '($percent% ${AppLocalizations.of(context)!.discount_off})',
            style: mainStyle(14.0, FontWeight.w200,
                color: getForegroundColor(percent)),
          ),
        ],
      ),
    );
  }

  Color getBackgroundColor(int percent) {
    if (percent >= 90) return firstOfferBackColor;
    if (percent >= 75) return secondOfferBackColor;
    if (percent >= 40) return thirdOfferBackColor;
    return fourthOfferBackColor;
  }

  Color getForegroundColor(int percent) {
    if (percent >= 90) return firstOfferForeColor;
    if (percent >= 75) return secondOfferForeColor;
    if (percent >= 40) return thirdOfferForeColor;
    return fourthOfferForeColor;
  }
}

class FormattedOfferPercent extends StatelessWidget {
   FormattedOfferPercent({
    Key? key,
    required this.price,
    required this.newPrice,
  }) : super(key: key);

   String price;
   String newPrice;

  @override
  Widget build(BuildContext context) {
    price=price.replaceAll(',', '');
    newPrice=newPrice.replaceAll(',', '');
    int percent = ((double.parse(price.split(' ')[0]) -
                double.parse(newPrice.split(' ')[0])) /
            double.parse(price.split(' ')[0]) *
            100)
        .toInt();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.sp),
        color: getBackgroundColor(percent),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 3.sp, right: 3.sp, top: 3.sp),
        child: Text(
          '($percent% ${AppLocalizations.of(context)!.discount_off})',
          style: mainStyle(14.0.h, FontWeight.w200,
              color: getForegroundColor(percent)),
        ),
      ),
    );
  }

  Color getBackgroundColor(int percent) {
    if (percent >= 90) return firstOfferBackColor;
    if (percent >= 75) return secondOfferBackColor;
    if (percent >= 40) return thirdOfferBackColor;
    return fourthOfferBackColor;
  }

  Color getForegroundColor(int percent) {
    if (percent >= 90) return firstOfferForeColor;
    if (percent >= 75) return secondOfferForeColor;
    if (percent >= 40) return thirdOfferForeColor;
    return fourthOfferForeColor;
  }
}

class SuccessfullyPaidScreen extends StatelessWidget {
  const SuccessfullyPaidScreen({
    Key? key,
    required this.successMsg,
    required this.iconColor,
    required this.productId,
  }) : super(key: key);

  final String successMsg;
  final String iconColor;
  final String? productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: 0.9.sh,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 120.h,
                child: Lottie.asset(iconColor == 'normal'
                    ? 'assets/images/success upcoming.json'
                    : (iconColor == 'red')
                        ? 'assets/images/success upcoming.json'
                        : 'assets/images/success upcoming.json'),
              ),
              // Image.asset('assets/images/done_image.json'),
              // SvgPicture.asset(
              //   'assets/images/error/nodata.svg',
              //   fit: BoxFit.contain,
              //
              //   // color: Colors.black,
              //   height: 120.h,
              // ),
              SizedBox(
                height: 25.h,
              ),
              // TextButton(
              //     onPressed: () {
              //       if(  productId!=null) {
              //         Navigator.of(context)
              //           ..pop()
              //           ..pop()
              //           ..pop()
              //           ..pop();
              //       }
              //       else{
              //         navigateToAndFinishUntil(context,
              //
              //             const ApparelMainScreen()
              //
              //         );
              //       }
              //
              //       // Navigator.pushAndRemoveUntil(
              //       //     context,
              //       //     MaterialPageRoute(
              //       //         builder: (context) => MainLayout()
              //       //     ),
              //       //     ModalRoute.withName("/Home")
              //       // );
              //
              //       // navigateToAndFinish(context, MainLayout());
              //     },
              //     child:
              //     RichText(
              //       text: TextSpan(
              //         text: 'Congrats\n\n',
              //         style: mainStyle(16.0, FontWeight.w700,),
              //         children: <TextSpan>[
              //
              //           TextSpan(text:successMsg,
              //             style: mainStyle(16.0, FontWeight.w200),),
              //           TextSpan(
              //             text:
              //             productId==null?
              //             '\n\nClick to return to apparels screen'
              //                 :
              //             '\n\nClick to return to product screen',
              //             style: mainStyle(14.0, FontWeight.w600,
              //                 decoration: TextDecoration.underline),
              //           ),
              //         ],
              //       ),
              //       textAlign: TextAlign.center,
              //     )
              //   // Text(
              //   //   successMsg + '\n Click to go Home',
              //   //   textAlign: TextAlign.center,
              //   //   style: mainStyle(
              //   //       14.0,
              //   //       FontWeight.w200,
              //   //       (iconColor == 'red')
              //   //           ? const Color(0xffF90909)
              //   //           : const Color(0xff006414)),
              //   // ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
