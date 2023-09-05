import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:clearance/core/constants/dimensions.dart';
import 'package:clearance/core/shimmer/main_shimmers.dart';
import 'package:clearance/modules/main_layout/sub_layouts/categories/cubit/states_categories.dart';

import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../categories/cubit/cubit_categories.dart';

class MainHomeBodyWithFilter extends StatelessWidget {
  const MainHomeBodyWithFilter({
    Key? key,
    required this.selectedCategoryId,
    required this.token,
  }) : super(key: key);

  final String? selectedCategoryId;
  final String? token;

  @override
  Widget build(BuildContext context) {
    logg(selectedCategoryId!);
    var categoriesCubit = CategoriesCubit.get(context);
    categoriesCubit.getFilteredCategoryProducts(selectedCategoryId!,token);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:defaultHorizontalPadding),
      child: BlocConsumer<CategoriesCubit, CategoriesStates>(
        listener: (context, state) {},
        builder: (context, state) => ConditionalBuilder(
            condition: state is! LoadingFilteredCategoryProductsState,
            builder: (context) => ConditionalBuilder(
                  condition:
                      categoriesCubit.filteredProductByCategory!.isNotEmpty,
                  builder: (context) =>
                      Padding(
                        padding:  EdgeInsets.all(12.0.sp),
                        child: ProductsGridView(
                          isInHome: false,
                          towByTowJustTitle: false,
                          crossAxisCount: 2,
                          productsList: categoriesCubit.filteredProductByCategory!,
                        ),
                      ),
                  fallback: (context) => const Text('No Products'),
                ),
            fallback: (context) => GridViewShimmer()),
      ),
    );
  }
}
