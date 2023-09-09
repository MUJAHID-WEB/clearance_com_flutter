import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/shared_widgets/shared_widgets.dart';
import 'package:clearance/core/styles_colors/styles_colors.dart';
import 'package:clearance/models/api_models/categories_model.dart';
import 'package:clearance/modules/main_layout/sub_layouts/categories/cubit/cubit_categories.dart';
import 'package:clearance/modules/main_layout/sub_layouts/categories/cubit/states_categories.dart';

import '../../../../../models/api_models/detailed_category.dart';
import '../../home/widgets/home_widgets.dart';

class CategoryDetailedLayout extends StatelessWidget {
  const CategoryDetailedLayout({Key? key, required this.categoryId})
      : super(key: key);
  static String routeName = 'categoryDetailedLayout';

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    var catCubit = CategoriesCubit.get(context)
      ..getDetailedCategoryById(categoryId);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultAppBarWithOnlyBackButton(transparent: true),
      ),
      body: BlocConsumer<CategoriesCubit, CategoriesStates>(
        listener: (context, state) {},
        builder: (context, state) => ConditionalBuilder(
          condition: catCubit.detailedCategoryModel != null,
          builder: (context) => DetailedCatMainBody(
            detailedCategoriesModel: catCubit.detailedCategoryModel!,
          ),
          fallback: (context) =>
              Center(child: const CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class DetailedCatMainBody extends StatelessWidget {
  const DetailedCatMainBody({Key? key, required this.detailedCategoriesModel})
      : super(key: key);

  final DetailedCategoriesModel detailedCategoriesModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: detailedCategoriesModel.data!.isGift == 1 ? giftBackColor : null,
      child: SingleChildScrollView(
        child: Column(
          children: [
            DefaultImage(
              height: 190.h,
              withoutRadius: true,
              backColor: Colors.grey,
              backGroundImageUrl: detailedCategoriesModel.data!.banner!,
              borderColor: Colors.transparent,
            ),
            SizedBox(
              height: 11.h,
            ),
            ConditionalBuilder(
              condition: detailedCategoriesModel.data!.childes != null,
              builder: (context) => DetailedCategoryBody(
                isGift: detailedCategoriesModel.data!.isGift == 1,
                detailedCategoriesModel: detailedCategoriesModel,
              ),
              fallback: (context) => Text('no details'),
            ),
          ],
        ),
      ),
    );
  }
}


































class DetailedCategoryBody extends StatelessWidget {
  const DetailedCategoryBody(
      {Key? key, required this.isGift,
        required this.detailedCategoriesModel,
      })
      : super(key: key);

  final bool isGift;
  final DetailedCategoriesModel detailedCategoriesModel;

  @override
  Widget build(BuildContext context) {
    List<Data> childes = detailedCategoriesModel.data!.childes!;
    return Column(
      children: [
        DefaultContainer(
          height: 110.h,
          borderColor: Colors.transparent,
          childWidget: ListView.separated(
            itemCount: childes.length,
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
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
                        width: 60.h,
                        height: 60.h,
                        borderColor: isGift ? categoryHeaderColor : null,
                        childWidget: Image.network(childes[index].icon!),
                      ),
                    ],
                  ),
                  Text(
                    childes[index].name!,
                    style: mainStyle(13.0, FontWeight.w400),
                  )
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 20.w,
              );
            },
          ),
        ),
        ListView.builder(
            itemCount: childes.length,
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return childes[index].productsStyle == '2'
                  ? 
                  HomeProductsHorizontalView(
                      isGift: isGift,
                      viewInCategoriesLayout: true,
                      title: childes[index].name!,
                      titleIcon: childes[index].icon!,
                      productsList: childes[index].products!)
                  : childes[index].productsStyle == '3'
                      ? 
                      HomeProductsGridThreePerLine(
                          isGift: isGift,
                          viewInCategoriesLayout: true,
                          title: childes[index].name!,
                          titleIcon: childes[index].icon!,
                          productsList: childes[index].products!)
                      
                      
                      
                      
                      
                      
                      : 

              CategoriesProductsGridView(
                          isGift: isGift,
                          viewInCategoriesLayout: true,
                          title: childes[index].name!,
                          titleIcon: childes[index].icon!,
                          productsList: childes[index].products!);
            }),
      ],
    );
  }
}
