import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cart_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/dimensions.dart';
import '../../../../core/main_functions/main_funcs.dart';
import '../../../../core/shared_widgets/shared_widgets.dart';
import 'brand_products/brand_products_cubit.dart';
class BrandProductsLayout extends StatefulWidget {
  const BrandProductsLayout(
      {Key? key, required this.resourceId, required this.resourceType})
      : super(key: key);
  static String routeName = 'BrandProducts';
  final String resourceId;
  final String resourceType;

  @override
  State<BrandProductsLayout> createState() => _BrandProductsLayoutState();
}

class _BrandProductsLayoutState extends State<BrandProductsLayout> {
  final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(pagination);
    super.initState();
  }

  void pagination() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent / 1.1 &&
        BrandProductsCubit.get(context).state is! LoadingBrandProductsState &&
        BrandProductsCubit.get(context).brandProductsModel!.totalSize !=
            BrandProductsCubit.get(context).products.length) {
      logg('productsScrollController.position.pixels>='
          'productsScrollController.position.maxScrollExtent/1.5');
      logg('totalsize: ' +
          BrandProductsCubit.get(context)
              .brandProductsModel!
              .totalSize
              .toString());
      logg('current product list length: ' +
          BrandProductsCubit.get(context).products.length.toString());
      BrandProductsCubit.get(context).getBrandProducts(
          resourceId: widget.resourceId, resourceType: widget.resourceType);
    }
  }

  @override
  Widget build(BuildContext context) {
    var brandProductsCubit = BrandProductsCubit.get(context)
      ..getBrandProducts(
          resourceId: widget.resourceId, resourceType: widget.resourceType);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: const DefaultAppBarWithOnlyBackButton(),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultHorizontalPadding * 2),
            child: BlocConsumer<BrandProductsCubit, BrandProductsState>(
                listener: (context, state) {},
                builder: (context, state) {
                  logg('brand products state changed');
                  return Stack(
                    children: [
                      SizedBox(
                        height: 1.sh,
                        child: ConditionalBuilder(
                          condition: brandProductsCubit.brandProductsModel != null,
                          builder: (context) => SingleChildScrollView(
                            controller: scrollController,
                            child: ProductsGridView(
                              isInHome: false,
                              crossAxisCount: 2,
                              towByTowJustTitle: false,
                              isInProductView: true,
                              productsList: brandProductsCubit.products,
                            ),
                          ),
                          fallback: (context) =>
                              const Center(child: DefaultLoader()),
                        ),
                      ),
                      state is LoadingBrandProductsState?
                      Positioned(
                          bottom: 30.h,
                          child: SizedBox(
                              width: 1.sw,
                              child:  Center(child: CircularProgressIndicator(
                                color: primaryColor,
                              )))):const SizedBox.shrink()
                    ],
                  );
                })));
  }
}
