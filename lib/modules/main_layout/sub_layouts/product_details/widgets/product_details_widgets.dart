import 'package:clearance/core/error_screens/show_error_message.dart';
import 'package:clearance/models/api_models/config_model.dart';
import 'package:clearance/modules/main_layout/sub_layouts/product_details/cubit/required_product_details_cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:clearance/modules/main_layout/sub_layouts/product_details/cubit/states_product_details.dart';

import '../../../../../core/constants/startup_settings.dart';
import '../../../../../core/constants/dimensions.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../../core/styles_colors/styles_colors.dart';
import '../../../../../models/api_models/home_Section_model.dart';
import '../../../../../models/api_models/product_details_model.dart';
import '../../../../../models/local_models/local_models.dart';
import '../cubit/cubit_product_details.dart';

class ChoiceOptions extends StatelessWidget {
  const ChoiceOptions({
    Key? key,
    required this.choiceOptions,
    this.required=false
  }) : super(key: key);
  final List<ChoiceOption>? choiceOptions;
  final bool required;

  @override
  Widget build(BuildContext context) {
    var productDetailsCubit = ProductDetailsCubit.get(context);
    var productDetailsCubitRequired = RequiredProductDetailsCubit.get(context);
    return ConditionalBuilder(
        condition: choiceOptions != null,
        builder: (context) => ListView.separated(
          itemCount: choiceOptions!.length,
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.0),
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 100.w,
                    child: Text(choiceOptions![index].title! + ': ')),
                SizedBox(
                  height: 50.h,
                  child: ListView.separated(
                    itemCount: choiceOptions![index].options!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, optionsIndex) {
                      return GestureDetector(
                        onTap: () {
                          logg('choice name :' + choiceOptions![index].name!);
                          if(required){
                            productDetailsCubitRequired.addSelectedChoiceRequired(
                                context,
                                index,
                                choiceOptions![index].title!,
                                choiceOptions![index].name!,
                                choiceOptions![index].options![optionsIndex]);
                            return;
                          }
                          productDetailsCubit.addSelectedChoice(
                              context,
                              index,
                              choiceOptions![index].title!,
                              choiceOptions![index].name!,
                              choiceOptions![index].options![optionsIndex]);
                        },
                        child: Container(
                          width: 50.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                width: (required ? productDetailsCubitRequired.selectedChoicesRequired : productDetailsCubit.selectedChoices)
                                    .firstWhere(
                                        (element) =>
                                    element.choiceName ==
                                        choiceOptions![index].name!,
                                    orElse: () => SelectedChoice(
                                        id: 0,
                                        choiceVal: '',
                                        choiceName: ''))
                                    .choiceVal ==
                                    choiceOptions![index]
                                        .options![optionsIndex]
                                    ? 3.0 : 1.0,
                                color: (required ? productDetailsCubitRequired.selectedChoicesRequired : productDetailsCubit.selectedChoices).firstWhere(
                                                (element) =>
                                                    element.choiceName ==
                                                    choiceOptions![index].name!,
                                                orElse: () => SelectedChoice(
                                                    id: 0,
                                                    choiceVal: '',
                                                    choiceName: ''))
                                            .choiceVal ==
                                        choiceOptions![index]
                                            .options![optionsIndex]
                                    ? primaryColor
                                    : mainGreyColor),
                          ),
                          child: Center(
                            child: Text(
                                choiceOptions![index].options![optionsIndex] , style: mainStyle(14.w, FontWeight.w500),textAlign: TextAlign.center
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: 10.w,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 7.h,
            );
          },
        ),
        fallback: (context) => const SizedBox(),
    );
  }
}

class QuantitySection extends StatelessWidget {
  const QuantitySection({Key? key, required this.availableQuantity , this.required=false})
      : super(key: key);

  final String? availableQuantity;
  final bool required;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var productDetailsCubit = ProductDetailsCubit.get(context);
    var productDetailsCubitRequired = RequiredProductDetailsCubit.get(context);
    return Row(
        children: [
          SizedBox(width: 100.w, child: Text(localizationStrings!.quantity)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if(required){
                      if (productDetailsCubitRequired.currentProductQuantityRequired <
                          int.parse(availableQuantity ?? '0')) {
                        productDetailsCubitRequired.increaseQtyRequired();
                      }else{
                        showTopModalSheetErrorMessage(context, localizationStrings.max_quantity_reached,);
                      }
                      return ;
                    }
                    if (productDetailsCubit.currentProductQuantity <
                        int.parse(availableQuantity ?? '0')) {
                      productDetailsCubit.increaseQty();
                    }else{
                      showTopModalSheetErrorMessage(context, localizationStrings.max_quantity_reached,);
                    }
                  },
                  child: CircleAvatar(
                    radius: 12.sp,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 11.sp,
                      backgroundColor: Colors.white,
                      child: Center(
                          child: Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 14.0.sp,
                      )),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                SizedBox(
                  width: 30.w,
                  child: Center(
                    child: Text(
                      required ? productDetailsCubitRequired.currentProductQuantityRequired.toString() :productDetailsCubit.currentProductQuantity.toString(),
                      style: mainStyle(18.0, FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: () {
                    if(required){
                      if (productDetailsCubitRequired.currentProductQuantityRequired > 1) {
                        productDetailsCubitRequired.decreaseQtyRequired();
                      }
                      return;
                    }
                    if (productDetailsCubit.currentProductQuantity > 1) {
                      productDetailsCubit.decreaseQty();
                    }
                  },
                  child: CircleAvatar(
                    radius: 12.sp,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 11.sp,
                      backgroundColor: Colors.white,
                      child: Center(
                          child: Icon(
                        Icons.remove,
                        color: Colors.black,
                        size: 14.0.sp,
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(localizationStrings.leftQuantity),
              Text(availableQuantity ?? '--')
            ],
          )
        ],
    );
  }
}

class ColorOptions extends StatelessWidget {
  const ColorOptions({
    Key? key,
    required this.colorOptions,
    this.required=false,
  }) : super(key: key);
  final List<Color>? colorOptions;
  final bool required;

  @override
  Widget build(BuildContext context) {
    var productDetailCubit = ProductDetailsCubit.get(context);
    var productDetailsCubitRequired = RequiredProductDetailsCubit.get(context);
    var selectedColor= required ? productDetailsCubitRequired.selectedColorRequired :productDetailCubit.selectedColor;
    return  ConditionalBuilder(
        condition: colorOptions!.isNotEmpty,
        builder: (context) => Row(
          children: [
            SizedBox(width: 100.w, child: const Text('Color: ')),
            Expanded(
              child: SizedBox(
                height: 25.h,
                child: ListView.separated(
                  itemCount: colorOptions!.length,
                  shrinkWrap: true,
                  
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      if(required){
                        productDetailsCubitRequired.changeSelectedColorRequired(
                            context, colorOptions![index].code.toString());
                        return;
                      }
                      productDetailCubit.changeSelectedColor(
                          context, colorOptions![index].code.toString());
                    },
                    child: Padding(
                      padding: colorOptions![index].code == selectedColor
                          ? const EdgeInsets.all(0.0)
                          : EdgeInsets.symmetric(vertical: 5.0.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: HexColor(colorOptions![index].code.toString()),
                          borderRadius: BorderRadius.circular(2.0.sp),
                          border: Border.all(
                              width: 1.0,
                              color: colorOptions![index].code ==
                                  selectedColor
                                  ? Colors.black
                                  : HexColor(colorOptions![index].code.toString())),
                        ),
                        width: colorOptions![index].code ==
                            selectedColor
                            ? 25.h
                            : 15.h,
                        
                        
                      ),
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 10.w,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        fallback: (context) => const SizedBox(),
    );
  }
}

class PublicFeatures extends StatelessWidget {
  const PublicFeatures({
    Key? key,
    required this.sellerName,
    required this.sellerEvaluate,
  }) : super(key: key);
  final String sellerName;
  final double sellerEvaluate;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);

    List<PublicFeature> publicFeatures = [
      PublicFeature(
        id: 1,
        image: 'assets/images/product_details/solds_by.svg',
        title: localizationStrings!.soldBy,
        fixTitle: sellerName,
        subTitle: localizationStrings.sellerPositiveEvaluation,
        sellerEvaluate: sellerEvaluate,
      ),
      PublicFeature(
        id: 1,
        image: 'assets/images/product_details/free refund.svg',
        title: localizationStrings.freeRefund,
        subTitle: localizationStrings.forSpecificProducts,
      ),
      PublicFeature(
        id: 1,
        image: 'assets/images/product_details/reliable_shipping.svg',
        title: localizationStrings.reliableShipping,
        subTitle: localizationStrings.freeExpressShipping,
      ),
      PublicFeature(
        id: 1,
        image: 'assets/images/product_details/deliver_at_your_door.svg',
        title: localizationStrings.deliverAtYourDoor,
        subTitle: localizationStrings.leaveYourOrderAtYourDoor,
      )
    ];
    return Container(
      color: mainBackgroundColor,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 15.h),
          child: ListView.separated(
            itemCount: publicFeatures.length,
            shrinkWrap: true,
            
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => Row(
              children: [
                SvgPicture.asset(publicFeatures[index].image,
                    width: 23.h, fit: BoxFit.fill),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: publicFeatures[index].title,
                        style: mainStyle(
                          14.0,
                          FontWeight.w700,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' ',
                            style: mainStyle(16.0, FontWeight.w400),
                          ),
                          TextSpan(
                            text: publicFeatures[index].fixTitle,
                            style: mainStyle(16.0, FontWeight.w900,
                                color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      
                      children: [
                        Text(publicFeatures[index].subTitle,
                            style: mainStyle(
                              14.0,
                              FontWeight.w700,
                            )),
                        SizedBox(
                          width: 15.w,
                        ),
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        publicFeatures[index].sellerEvaluate != null
                            ? RatingBarIndicator(
                                
                                rating: publicFeatures[index].sellerEvaluate!,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: primaryColor,
                                ),
                                itemCount: 5,
                                itemSize: 20.0.sp,
                                direction: Axis.horizontal,
                              )
                            :SizedBox(),
                      ],
                    ),
                  ],
                )
              ],
            ),
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 14.h,
              );
            },
          ),
        ),
      ),
    );
  }
}


















































































































































class SimilarProduct extends StatelessWidget {
  const SimilarProduct({Key? key, required this.similarProducts})
      : super(key: key);

  final List<Product> similarProducts;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.h,
        ),
        MyTitle(title: localizationStrings!.similarProducts),
        SizedBox(
          height: 5.h,
        ),
        ConditionalBuilder(
          condition: similarProducts.isNotEmpty,
          builder: (context) =>
              HorizontalProductsListView(products: similarProducts),
          fallback: (context) => Center(
            child: Text(localizationStrings.noSimilarProducts),
          ),
        ),
      ],
    );
  }
}










































































































































































class RelatedProducts extends StatelessWidget {
  const RelatedProducts({Key? key, required this.relatedProducts})
      : super(key: key);
  final List<Product> relatedProducts;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.h,
        ),
        MyTitle(title: localizationStrings!.relatedProducts),
        SizedBox(
          height: 5.h,
        ),
        ConditionalBuilder(
          condition: relatedProducts.isNotEmpty,
          builder: (context) =>
              HorizontalProductsListView(products: relatedProducts),
          fallback: (context) => Center(
            child: Text(localizationStrings.noRelatedProducts),
          ),
        ),
      ],
    );
  }
}

class HorizontalProductsListView extends StatelessWidget {
  const HorizontalProductsListView({
    Key? key,
    required this.products,
  }) : super(key: key);

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.55.sw,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        
        itemCount: products.length,
        scrollDirection: Axis.horizontal,

        separatorBuilder: (context, index) => SizedBox(
          width: 5.w,
        ),

        itemBuilder: (context, index) =>
            

            SizedBox(
                width: 0.42.sw,
                child: DefaultProductItem(
                  moreThan2Cross: false,
                  isRelatedSoNavigateAndFinish: true,
                  productItem: products[index],
                )),
      ),
    );
  }
}
