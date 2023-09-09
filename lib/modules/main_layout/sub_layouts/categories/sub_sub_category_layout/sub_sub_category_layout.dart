import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:clearance/core/constants/dimensions.dart';
import 'package:clearance/core/shared_widgets/shared_widgets.dart';
import 'package:clearance/modules/main_layout/sub_layouts/categories/cubit/cubit_categories.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../../core/constants/startup_settings.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/styles_colors/styles_colors.dart';
import '../../../../../models/api_models/product_filtered_by_cate.dart';
import '../../cart/cart_screen.dart';
import '../cubit/states_categories.dart';

class SubSubCategoryLayout extends StatefulWidget {
  const SubSubCategoryLayout({
    Key? key,
    required this.cateId,
    required this.token,
  }) : super(key: key);
  static String routeName = 'subSubCategoryLayout';

  final String cateId;
  final String? token;

  @override
  State<SubSubCategoryLayout> createState() => _SubSubCategoryLayoutState();
}

class _SubSubCategoryLayoutState extends State<SubSubCategoryLayout> {

  final subSubScrollCont = ScrollController();

  @override
  void initState() {
    
    super.initState();
    subSubScrollCont.addListener(pagination);
  }

  void pagination() {
    if (subSubScrollCont.position.pixels >=
        subSubScrollCont.position.maxScrollExtent/1.1 &&
        CategoriesCubit.get(context).state is! LoadingFilteredCategoryProductsState &&
        CategoriesCubit.get(context).productsFilteredByCateModel!.data!.totalSize !=
            CategoriesCubit.get(context).filteredProductByCategory!.length) {
      logg('productsScrollController.position.pixels>='
          'productsScrollController.position.maxScrollExtent/1.5');
      logg('totalsize: '+CategoriesCubit.get(context).productsFilteredByCateModel!.data!.totalSize.toString() );
      logg('current product list length: '+CategoriesCubit.get(context).filteredProductByCategory!.length.toString());
    CategoriesCubit.get(context).getFilteredCategoryProducts(widget.cateId, widget.token,pagination: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    logg(widget.cateId);
    var categoriesCubit = CategoriesCubit.get(context)
      ..updateCurrentCateId(widget.cateId)
      ..resetFilters();
    categoriesCubit.getFilteredCategoryProducts(widget.cateId, widget.token);
    var localizationStrings = AppLocalizations.of(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: SearchAppBar(customCateId: widget.cateId, isBackButtonEnabled: true),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultHorizontalPadding * 2),
            child: BlocConsumer<CategoriesCubit, CategoriesStates>(
              listener: (context, state) {},
              builder: (context, state) {
                logg('cate state changed');
                return Stack(
                  children: [
                    SizedBox(
                      height: 1.sh,
                      child:  ConditionalBuilder(
                        condition: categoriesCubit
                            .productsFilteredByCateModel!=null,
                        builder: (context) =>
                            SingleChildScrollView(
                              controller: subSubScrollCont,
                              child: ProductsGridView(
                                isInHome: false,
                                crossAxisCount: 2,
                                towByTowJustTitle: false,
                                isInProductView:true,
                                productsList:
                                categoriesCubit
                                    .filteredProductByCategory!,
                              ),
                            ),
                        fallback: (context) =>
                            const Center(child: DefaultLoader()),
                      ),
                    ),
                    
                    Positioned(
                      bottom: 10.h,
                      child: SizedBox(
                        width: 1.sw,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            DefaultContainer(
                              backColor: primaryColor,
                              borderColor: Colors.transparent,
                              radius: 10.0.sp,
                              width: 0.6.sw,
                              height: 45.h,
                              childWidget: categoriesCubit.productsFilteredByCateModel != null
                                  ? Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        buildSortByModalBottom(
                                            context, categoriesCubit);
                                      },
                                      child: DefaultContainer(
                                        backColor: primaryColor,
                                        borderColor: Colors.transparent,
                                        radius: 25.0.sp,
                                        height: 45.h,
                                        childWidget: Center(
                                          child: Text(
                                            localizationStrings!.sortBy,
                                            style: mainStyle(
                                                16.0, FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        buildFiltersModalBottom(
                                            context, categoriesCubit);
                                      },
                                      child: DefaultContainer(
                                        backColor: primaryColor,
                                        borderColor: Colors.transparent,
                                        radius: 25.0.sp,
                                        height: 45.h,
                                        childWidget: Center(
                                          child: Text(
                                            localizationStrings.filters,
                                            style: mainStyle(
                                                16.0, FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  DefaultLoader(),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    state is LoadingFilteredCategoryProductsState?
                    Positioned(
                        bottom: 55.h,
                        child: SizedBox(
                            width: 1.sw,
                            child:  Center(child: CircularProgressIndicator(
                              color: primaryColor,
                            )))):const SizedBox()
                  ],
                );
              },
            )));
  }

  buildFiltersModalBottom(BuildContext context,
      CategoriesCubit categoriesCubit) async {
    var localizationStrings = AppLocalizations.of(context);

    showMaterialModalBottomSheet(
      context: context,
      builder: (context) =>
          BlocBuilder<CategoriesCubit, CategoriesStates>(
            // listener: (context, state) {
            //   if (state is LoadingFiltersDataState) {
            //     showDialog<String>(
            //         context: context,
            //         useRootNavigator: false,
            //         barrierDismissible: false,
            //         barrierColor: Colors.white.withOpacity(0),
            //
            //         builder: (BuildContext context) =>
            //         BackdropFilter(
            //           filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            //           child: const Center(child: CircularProgressIndicator()),
            //         ));
            //   }
            // },
            builder: (context, state) {
              if(state is LoadingFilteredCategoryProductsState){
                return const SizedBox.shrink();
              }
              return SizedBox(
                height: 500.h,
                child: Column(
                  children: [
                    SizedBox(
                      height: 35.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localizationStrings!.filters,
                          style: mainStyle(22.0, FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 35.h,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (ctx, index) =>
                                   GestureDetector(
                                      onTap: () async {
                                        if (categoriesCubit.productsFilteredByCateModel!.data!
                                            .toJson()
                                            .keys
                                            .toList()[index]
                                            .toString() ==
                                            'prices') {
                                          logg('prices');
                                          await FilterListDialog.display<Price>(
                                             ctx,
                                            barrierDismissible: false,
                                            listData: categoriesCubit
                                                .productsFilteredByCateModel!.data!.prices!,
                                            selectedListData:
                                            categoriesCubit.selectedPricesList,
                                            onItemSearch: (price, query) {
                                              return price.text!
                                                  .toLowerCase()
                                                  .contains(query.toLowerCase());
                                            },
                                            themeData: FilterListThemeData(
                                                ctx,
                                                choiceChipTheme: ChoiceChipThemeData(
                                                    selectedBackgroundColor: primaryColor,
                                                    selectedTextStyle: TextStyle(
                                                      color: mainBackgroundColor,
                                                    )
                                                ),
                                                controlButtonBarTheme:  ControlButtonBarThemeData(
                                                    ctx,
                                                    buttonSpacing: 10.w,
                                                    controlButtonTheme: ControlButtonThemeData(
                                                        primaryButtonTextStyle: TextStyle(
                                                            color: mainBackgroundColor
                                                        ),
                                                        primaryButtonBackgroundColor: primaryColor,
                                                        textStyle: TextStyle(
                                                            color: mainBackgroundColor
                                                        ),
                                                        backgroundColor: primaryColor
                                                    )
                                                )
                                            ),
                                            hideSelectedTextCount: true,
                                            controlButtons: [
                                              ControlButtonType.All,
                                              ControlButtonType.Reset
                                            ],
                                            choiceChipLabel: (price) => price!.text,

                                            validateSelectedItem: (list, val) =>
                                                list!.contains(val),
                                            onApplyButtonClick: (list) {
                                              categoriesCubit
                                                  .addSelectedListToPriceList(
                                                  list!);
                                              logg(categoriesCubit
                                                  .selectedPricesList
                                                  .toString());
                                              categoriesCubit
                                                  .getFilteredCategoryProducts(
                                                  widget.cateId,
                                                  categoriesCubit
                                                      .token,
                                                  brands: categoriesCubit
                                                      .selectedBrandsList,
                                                  prices: categoriesCubit
                                                      .selectedPricesList,
                                                  attributes:
                                                  categoriesCubit
                                                      .selectedAttributeObjectList,
                                                  colors: categoriesCubit
                                                      .selectedColorsList);
                                              Navigator.of(context).pop();

                                            },
                                          );
                                        }
                                        if (categoriesCubit.productsFilteredByCateModel!.data!
                                            .toJson()
                                            .keys
                                            .toList()[index]
                                            .toString() ==
                                            'attributes') {
                                          logg('attributes');
                                        } else
                                        if (categoriesCubit.productsFilteredByCateModel!.data!
                                            .toJson()
                                            .keys
                                            .toList()[index]
                                            .toString() ==
                                            'brands') {
                                          logg('brands filters');
                                          await FilterListDialog.display<Brand>(
                                             ctx,
                                            barrierDismissible: false,
                                            listData: categoriesCubit
                                                .productsFilteredByCateModel!.data!.brands!,
                                            selectedListData:
                                            categoriesCubit.selectedBrandsList,
                                            onItemSearch: (brand, query) {
                                              return brand.name!
                                                  .toLowerCase()
                                                  .contains(query.toLowerCase());
                                            },
                                            hideSelectedTextCount: true,
                                            themeData: FilterListThemeData(
                                                ctx,
                                                choiceChipTheme: ChoiceChipThemeData(
                                                    selectedBackgroundColor: primaryColor,
                                                    selectedTextStyle: TextStyle(
                                                      color: mainBackgroundColor,
                                                    )
                                                ),
                                                controlButtonBarTheme:  ControlButtonBarThemeData(
                                                    ctx,
                                                    buttonSpacing: 10.w,
                                                    controlButtonTheme: ControlButtonThemeData(
                                                        primaryButtonTextStyle: TextStyle(
                                                            color: mainBackgroundColor
                                                        ),
                                                        primaryButtonBackgroundColor: primaryColor,
                                                        textStyle: TextStyle(
                                                            color: mainBackgroundColor
                                                        ),
                                                        backgroundColor: primaryColor
                                                    )
                                                )
                                            ),
                                            controlButtons: [
                                              ControlButtonType.All,
                                              ControlButtonType.Reset
                                            ],

                                            choiceChipLabel: (brand) => brand!.name,

                                            validateSelectedItem: (list, val) =>
                                                list!.contains(val),
                                            onApplyButtonClick: (list) {
                                              categoriesCubit
                                                  .addSelectedListToBrandList(
                                                  list!);
                                              logg(categoriesCubit
                                                  .selectedBrandsList
                                                  .toString());
                                              categoriesCubit
                                                  .getFilteredCategoryProducts(
                                                  widget.cateId,
                                                  categoriesCubit
                                                      .token,
                                                  brands: categoriesCubit
                                                      .selectedBrandsList,
                                                  prices: categoriesCubit
                                                      .selectedPricesList,
                                                  attributes:
                                                  categoriesCubit
                                                      .selectedAttributeObjectList,
                                                  colors: categoriesCubit
                                                      .selectedColorsList);
                                              Navigator.of(context).pop();

                                            },
                                          );
                                        } else
                                        if (categoriesCubit.productsFilteredByCateModel!.data!
                                            .toJson()
                                            .keys
                                            .toList()[index]
                                            .toString() ==
                                            'colors') {
                                          await FilterListDialog.display<String>(
                                            ctx,
                                            // choiceChipColor: (color) => color,
                                            barrierDismissible: false,
                                            hideSelectedTextCount: true,
                                            headlineText: localizationStrings
                                                .selectColor,
                                            height: 500,
                                            listData: categoriesCubit
                                                .productsFilteredByCateModel!.data!.colors!,

                                            selectedListData:
                                            categoriesCubit.selectedColorsList,
                                            themeData: FilterListThemeData(
                                                ctx,
                                                choiceChipTheme: ChoiceChipThemeData(
                                                    selectedBackgroundColor: primaryColor,
                                                    selectedTextStyle: TextStyle(
                                                      color: mainBackgroundColor,
                                                    )
                                                ),
                                                controlButtonBarTheme:  ControlButtonBarThemeData(
                                                    ctx,
                                                    buttonSpacing: 10.w,
                                                    controlButtonTheme: ControlButtonThemeData(
                                                        primaryButtonTextStyle: TextStyle(
                                                            color: mainBackgroundColor
                                                        ),
                                                        primaryButtonBackgroundColor: primaryColor,
                                                        textStyle: TextStyle(
                                                            color: mainBackgroundColor
                                                        ),
                                                        backgroundColor: primaryColor
                                                    )
                                                )
                                            ),
                                            controlButtons: [
                                              ControlButtonType.All,
                                              ControlButtonType.Reset
                                            ],


                                            choiceChipLabel: (color) => color,

                                            validateSelectedItem: (list, val) =>
                                                list!.contains(val),
                                            onItemSearch: (color, query) {
                                              return color
                                                  .toLowerCase()
                                                  .contains(query.toLowerCase());
                                            },
                                            onApplyButtonClick: (list) {
                                              categoriesCubit
                                                  .addSelectedListToMainList(
                                                  list!);
                                              categoriesCubit
                                                  .getFilteredCategoryProducts(
                                                  widget.cateId,
                                                  categoriesCubit
                                                      .token,
                                                  brands: categoriesCubit
                                                      .selectedBrandsList,
                                                  prices: categoriesCubit
                                                      .selectedPricesList,
                                                  attributes:
                                                  categoriesCubit
                                                      .selectedAttributeObjectList,
                                                  colors: categoriesCubit
                                                      .selectedColorsList);
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        }
                                      },
                                      child:
                                      (categoriesCubit.productsFilteredByCateModel!.data!
                                          .toJson()
                                          .keys
                                          .toList()[index]
                                          .toString() ==
                                          'brands'&&categoriesCubit.productsFilteredByCateModel!.data!.brands!.isNotEmpty)
                                          ?

                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          DefaultContainer(
                                            height: 35.h,


                                            backColor:
                                            mainGreyColor.withOpacity(0.2),
                                            borderColor: Colors.transparent,
                                            radius: 7.0.sp,
                                            childWidget: Center(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [

                                                    Text(
                                                      localizationStrings.brands,
                                                      style: mainStyle(16.0,
                                                          FontWeight.w600),

                                                    ),

                                                    Icon(Icons
                                                        .arrow_drop_down_sharp),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          categoriesCubit
                                              .selectedBrandsList.isNotEmpty
                                              ? SizedBox(
                                            height: 40.h,
                                            child: ListView.separated(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                Axis.horizontal,
                                                itemBuilder:
                                                    (context, index) =>
                                                    DecoratedBox(
                                                      decoration: BoxDecoration(
                                                          color:
                                                          subCategoriesColor,
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              16.0)),
                                                      child: Center(
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                              10.w,
                                                            ),
                                                            Text(
                                                              categoriesCubit
                                                                  .selectedBrandsList[index]
                                                                  .name
                                                                  .toString(),
                                                              style: mainStyle(
                                                                  14.0,
                                                                  FontWeight
                                                                      .w200),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                              10.w,
                                                            ),
                                                            SizedBox(
                                                              width:
                                                              5.w,
                                                            ),
                                                            GestureDetector(
                                                              onTap:
                                                                  () {
                                                                categoriesCubit
                                                                    .removeSelectedItemFromBrandList(
                                                                    index);
                                                                categoriesCubit
                                                                    .getFilteredCategoryProducts(
                                                                    widget.cateId,
                                                                    categoriesCubit
                                                                        .token,
                                                                    brands: categoriesCubit
                                                                        .selectedBrandsList,
                                                                    prices: categoriesCubit
                                                                        .selectedPricesList,
                                                                    attributes:
                                                                    categoriesCubit
                                                                        .selectedAttributeObjectList,
                                                                    colors: categoriesCubit
                                                                        .selectedColorsList);
                                                                Navigator.pop(context);
                                                              },
                                                              child:
                                                              Icon(
                                                                Icons
                                                                    .highlight_remove,
                                                                color:
                                                                mainGreyColor,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                              5.w,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                separatorBuilder:
                                                    (context, index) =>
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                itemCount: categoriesCubit
                                                    .selectedBrandsList
                                                    .length),
                                          )
                                              : Center(child: Text(localizationStrings.noFilter))
                                        ],
                                      )
                                          : (categoriesCubit.productsFilteredByCateModel!.data!
                                          .toJson()
                                          .keys
                                          .toList()[index]
                                          .toString() ==
                                          'colors'&&categoriesCubit.productsFilteredByCateModel!.data!.colors!.isNotEmpty)
                                          ?



                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          DefaultContainer(
                                            height: 35.h,


                                            backColor: mainGreyColor
                                                .withOpacity(0.2),
                                            borderColor: Colors.transparent,
                                            radius: 7.0.sp,
                                            childWidget: Center(
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [

                                                    Text(
                                                      localizationStrings.color,







                                                      style: mainStyle(16.0,
                                                          FontWeight.w600),

                                                    ),

                                                    Icon(Icons
                                                        .arrow_drop_down_sharp),



                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          categoriesCubit.selectedColorsList
                                              .isNotEmpty
                                              ? SizedBox(
                                            height: 40.h,
                                            child: ListView.separated(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                Axis.horizontal,
                                                itemBuilder:
                                                    (context,
                                                    index) =>
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          3.0),
                                                      child:
                                                      DecoratedBox(
                                                        decoration: BoxDecoration(
                                                            color: HexColor(
                                                                categoriesCubit
                                                                    .selectedColorsList[
                                                                index]),
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                16.0)),
                                                        child:
                                                        Center(
                                                          child:
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 10.w,
                                                              ),
                                                              Text(
                                                                categoriesCubit
                                                                    .selectedColorsList[index]
                                                                    .toString(),
                                                                style: mainStyle(
                                                                    14.0,
                                                                    FontWeight
                                                                        .w200),
                                                              ),
                                                              SizedBox(
                                                                width: 10.w,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  categoriesCubit
                                                                      .removeSelectedItemFromColorList(
                                                                      index);
                                                                  categoriesCubit
                                                                      .getFilteredCategoryProducts(
                                                                      widget.cateId,
                                                                      categoriesCubit
                                                                          .token,
                                                                      brands: categoriesCubit
                                                                          .selectedBrandsList,
                                                                      prices: categoriesCubit
                                                                          .selectedPricesList,
                                                                      attributes:
                                                                      categoriesCubit
                                                                          .selectedAttributeObjectList,
                                                                      colors: categoriesCubit
                                                                          .selectedColorsList);
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .highlight_remove,
                                                                  color: mainGreyColor,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5.w,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                separatorBuilder:
                                                    (context,
                                                    index) =>const
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                itemCount: categoriesCubit
                                                    .selectedColorsList
                                                    .length),
                                          )
                                              : Text('')
                                        ],
                                      )
                                          : (categoriesCubit.productsFilteredByCateModel!.data!
                                          .toJson()
                                          .keys
                                          .toList()[index]
                                          .toString() ==
                                          'attributes'&&categoriesCubit.productsFilteredByCateModel!.data!.attributes!.isNotEmpty)
                                          ? Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          ListView
                                              .separated(
                                              scrollDirection:
                                              Axis
                                                  .vertical,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (context, index) =>
                                                  GestureDetector(
                                                    onTap: () async {
                                                      logg('test');
                                                      await FilterListDialog.display<String>(
                                                         context,
                                                        barrierDismissible: false,
                                                        listData: categoriesCubit
                                                            .productsFilteredByCateModel!
                                                            .data!
                                                            .attributes![index]
                                                            .options!,
                                                        selectedListData:
                                                        categoriesCubit
                                                            .selectedAttributeObjectList
                                                            .firstWhere((
                                                            element) =>
                                                        element.id ==
                                                            categoriesCubit
                                                                .productsFilteredByCateModel!
                                                                .data!
                                                                .attributes![index]
                                                                .id,
                                                            orElse: () =>
                                                                Attribute(
                                                                    id: -15,
                                                                    name: 'empty attr',
                                                                    options: null))
                                                            .options ??
                                                            [],
                                                        onItemSearch: (
                                                            option,
                                                            query) {
                                                          return option
                                                              .toLowerCase()
                                                              .contains(
                                                              query
                                                                  .toLowerCase());
                                                        },
                                                        themeData: FilterListThemeData(
                                                            ctx,
                                                            choiceChipTheme: ChoiceChipThemeData(
                                                                selectedBackgroundColor: primaryColor,
                                                                selectedTextStyle: TextStyle(
                                                                  color: mainBackgroundColor,
                                                                )
                                                            ),
                                                            controlButtonBarTheme:  ControlButtonBarThemeData(
                                                                ctx,
                                                                buttonSpacing: 10.w,
                                                                controlButtonTheme: ControlButtonThemeData(
                                                                    primaryButtonTextStyle: TextStyle(
                                                                        color: mainBackgroundColor
                                                                    ),
                                                                    primaryButtonBackgroundColor: primaryColor,
                                                                    textStyle: TextStyle(
                                                                        color: mainBackgroundColor
                                                                    ),
                                                                    backgroundColor: primaryColor
                                                                )
                                                            )
                                                        ),
                                                        controlButtons: [
                                                          ControlButtonType.All,
                                                          ControlButtonType.Reset
                                                        ],
                                                        hideSelectedTextCount: true,
                                                        choiceChipLabel: (size) => size,

                                                        validateSelectedItem: (list, val) {
                                                          return list!.contains(val);
                                                        },
                                                        // tileLabel: (
                                                        //     option) => option,
                                                        // emptySearchChild: Center(
                                                        //     child: Text(
                                                        //         localizationStrings
                                                        //             .noResultFound)),
                                                        // searchFieldHint: localizationStrings
                                                        //     .search,
                                                        onApplyButtonClick: (
                                                            list) {
                                                          logg(
                                                              'testt: ' +
                                                                  list
                                                                      .toString());
                                                          categoriesCubit
                                                              .addSelectedAttribute(
                                                              Attribute(
                                                                id: categoriesCubit
                                                                    .productsFilteredByCateModel!
                                                                    .data!
                                                                    .attributes![index]
                                                                    .id,
                                                                name: categoriesCubit
                                                                    .productsFilteredByCateModel!
                                                                    .data!
                                                                    .attributes![index]
                                                                    .name,
                                                                options: list,
                                                              ));
                                                          categoriesCubit
                                                              .getFilteredCategoryProducts(
                                                              widget.cateId,
                                                              categoriesCubit
                                                                  .token,
                                                              brands: categoriesCubit
                                                                  .selectedBrandsList,
                                                              prices: categoriesCubit
                                                                  .selectedPricesList,
                                                              attributes:
                                                              categoriesCubit
                                                                  .selectedAttributeObjectList,
                                                              colors: categoriesCubit
                                                                  .selectedColorsList);
                                                          Navigator.of(context).pop();
                                                        },
                                                      );
                                                    },
                                                    child:

                                                    Column(
                                                      children: [
                                                        DefaultContainer(
                                                          height: 35.h,
                                                          backColor: mainGreyColor
                                                              .withOpacity(0.2),
                                                          borderColor:
                                                          Colors.transparent,
                                                          radius: 7.0.sp,
                                                          childWidget: Center(
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                  8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                                children: [

                                                                  Text( categoriesCubit
                                                                      .productsFilteredByCateModel!
                                                                      .data!
                                                                      .attributes![index]
                                                                      .name!,
                                                                    style: mainStyle(
                                                                        16.0,
                                                                        FontWeight
                                                                            .w600),

                                                                  ),

                                                                  Icon(Icons
                                                                      .arrow_drop_down_sharp),



                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              separatorBuilder:
                                                  (context, index) =>
                                                  Container(
                                                    height: 20.h,
                                                    width: 10.w,
                                                    color: Colors
                                                        .transparent,
                                                  ),
                                              itemCount: categoriesCubit
                                                  .productsFilteredByCateModel!
                                                  .data!
                                                  .attributes!
                                                  .length),
                                          categoriesCubit
                                              .selectedAttributeObjectList
                                              .isNotEmpty
                                              ? ListView.separated(
                                              scrollDirection:
                                              Axis.vertical,
                                              shrinkWrap: true,
                                              physics:
                                              NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (context,
                                                  index) =>
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      SizedBox(
                                                        height:
                                                        10.h,
                                                      ),
                                                      SizedBox(
                                                        height:
                                                        50.h,
                                                        child: ListView.separated(
                                                            scrollDirection: Axis
                                                                .horizontal,
                                                            itemBuilder: (context,
                                                                innerIndex) =>
                                                                DecoratedBox(
                                                                  decoration: BoxDecoration(
                                                                      color: subCategoriesColor,
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          16.0)),
                                                                  child: Center(
                                                                    child: Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width: 10
                                                                              .w,
                                                                        ),
                                                                        Text(
                                                                          categoriesCubit
                                                                              .selectedAttributeObjectList[index]
                                                                              .options![innerIndex]
                                                                              .toString(),
                                                                          style: mainStyle(
                                                                              14.0,
                                                                              FontWeight
                                                                                  .w200),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 10
                                                                              .w,
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            categoriesCubit
                                                                                .removeSelectedOptionFromAttributesList(
                                                                                index,
                                                                                innerIndex);
                                                                            categoriesCubit
                                                                                .getFilteredCategoryProducts(
                                                                                widget.cateId,
                                                                                categoriesCubit
                                                                                    .token,
                                                                                brands: categoriesCubit
                                                                                    .selectedBrandsList,
                                                                                prices: categoriesCubit
                                                                                    .selectedPricesList,
                                                                                attributes:
                                                                                categoriesCubit
                                                                                    .selectedAttributeObjectList,
                                                                                colors: categoriesCubit
                                                                                    .selectedColorsList);
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Icon(
                                                                            Icons
                                                                                .highlight_remove,
                                                                            color: mainGreyColor,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 5
                                                                              .w,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                            separatorBuilder: (_,
                                                                index) =>
                                                                SizedBox(
                                                                  width: 5.w,
                                                                ),
                                                            itemCount: categoriesCubit
                                                                .selectedAttributeObjectList[index]
                                                                .options!.length),
                                                      )
                                                    ],
                                                  ),
                                              separatorBuilder:
                                                  (_, index) =>
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                              itemCount: categoriesCubit
                                                  .selectedAttributeObjectList
                                                  .length)
                                              : Center(child: Text(localizationStrings.noFilter))
                                        ],
                                      )
                                          : (categoriesCubit
                                          .productsFilteredByCateModel!.data!
                                          .toJson()
                                          .keys
                                          .toList()[index]
                                          .toString() ==
                                          'prices'&&categoriesCubit.productsFilteredByCateModel!.data!.prices!.isNotEmpty)
                                          ? Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          DefaultContainer(
                                            height: 35.h,


                                            backColor: mainGreyColor
                                                .withOpacity(0.2),
                                            borderColor:
                                            Colors.transparent,
                                            radius: 7.0.sp,
                                            childWidget: Center(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .symmetric(
                                                    horizontal:
                                                    8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [

                                                    Text(
                                                      localizationStrings.price,








                                                      style: mainStyle(
                                                          16.0,
                                                          FontWeight
                                                              .w600),

                                                    ),

                                                    Icon(Icons
                                                        .arrow_drop_down_sharp),



                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          categoriesCubit
                                              .selectedPricesList
                                              .isNotEmpty
                                              ? SizedBox(
                                            height: 40.h,
                                            child: ListView
                                                .separated(
                                                shrinkWrap:
                                                true,
                                                scrollDirection:
                                                Axis
                                                    .horizontal,
                                                itemBuilder:
                                                    (context, index) =>
                                                    DecoratedBox(
                                                      decoration: BoxDecoration(
                                                          color: subCategoriesColor,
                                                          borderRadius: BorderRadius
                                                              .circular(16.0)),
                                                      child: Center(
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 10.w,
                                                            ),
                                                            Text(
                                                              categoriesCubit
                                                                  .selectedPricesList[index]
                                                                  .text
                                                                  .toString(),
                                                              style: mainStyle(
                                                                  14.0, FontWeight
                                                                  .w200),
                                                            ),
                                                            SizedBox(
                                                              width: 10.w,
                                                            ),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                categoriesCubit
                                                                    .removeSelectedItemFromPriceList(
                                                                    index);
                                                                categoriesCubit
                                                                    .getFilteredCategoryProducts(
                                                                    widget.cateId,
                                                                    categoriesCubit
                                                                        .token,
                                                                    brands: categoriesCubit
                                                                        .selectedBrandsList,
                                                                    prices: categoriesCubit
                                                                        .selectedPricesList,
                                                                    attributes:
                                                                    categoriesCubit
                                                                        .selectedAttributeObjectList,
                                                                    colors: categoriesCubit
                                                                        .selectedColorsList);
                                                                Navigator.pop(context);
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .highlight_remove,
                                                                color: mainGreyColor,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                separatorBuilder:
                                                    (context, index) =>
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                itemCount: categoriesCubit
                                                    .selectedPricesList
                                                    .length),
                                          )
                                              : Center(child: Text(localizationStrings.noFilter))
                                        ],
                                      )
                                          : SizedBox()
                                  ),

                            separatorBuilder: (context, index) =>
                                Container(
                                  height: 20.h,
                                  width: 10.w,
                                  color: Colors.transparent,
                                ),
                            itemCount:
                            categoriesCubit.productsFilteredByCateModel!.data!.toJson().length,
                            scrollDirection: Axis.vertical),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: 4.0 * defaultHorizontalPadding),
                    //   child: DefaultButton(
                    //       title: localizationStrings.apply,
                    //       onClick: () {
                    //         Navigator.pop(context);
                    //         return categoriesCubit.getFilteredCategoryProducts(
                    //               widget.cateId, categoriesCubit.token,
                    //               brands: categoriesCubit.selectedBrandsList,
                    //               prices: categoriesCubit.selectedPricesList,
                    //               attributes:
                    //               categoriesCubit.selectedAttributeObjectList,
                    //               colors: categoriesCubit.selectedColorsList);
                    //       }),
                    // ),
                    SizedBox(
                      height: 35.h,
                    ),
                  ],
                ),
              );
              }
          ),
    );
  }

  buildSortByModalBottom(BuildContext context,
      CategoriesCubit categoriesCubit) async {
    var localizationStrings = AppLocalizations.of(context);
    var categoriesCubit = CategoriesCubit.get(context);

    showMaterialModalBottomSheet(
      context: context,
      builder: (context) =>
          BlocConsumer<CategoriesCubit, CategoriesStates>(
            listener: (context, state) {
            },
            builder: (context, state) {
              return Container(
                height: 400,
                child:
                
                
                Padding(
                  padding: EdgeInsets.all(18.0.sp),
                  child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          GestureDetector(
                            onTap: () {
                              categoriesCubit.changeSelectedSortByKeyValue(
                                  categoriesCubit.sortByValues(context)[index]
                                      .key);
                              Navigator.pop(context);
                            },
                            child: DefaultContainer(
                              backColor: newSoftGreyColor,
                              borderColor: categoriesCubit.selectedSortByKey ==
                                  categoriesCubit.sortByValues(context)[index]
                                      .key
                                  ? newSoftGreyColorAux
                                  : Colors.transparent,
                              childWidget: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.0 * defaultHorizontalPadding),
                                child: Center(
                                  child: Text(
                                    categoriesCubit
                                        .sortByValues(context)[index]
                                        .displayValue,
                                    style: mainStyle(16.0, FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: categoriesCubit
                          .sortByValues(context)
                          .length),
                ),
              );
            },
          ),
    );
  }
}
