import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clearance/core/cache/cache.dart';
import 'package:clearance/core/main_cubits/cubit_main.dart';
import 'package:clearance/models/api_models/banners_model.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cart_screen.dart';
import 'package:clearance/modules/main_layout/sub_layouts/categories/sub_sub_category_layout/sub_sub_category_layout.dart';
import 'package:clearance/modules/main_layout/sub_layouts/product_details/product_details_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/main_functions/main_funcs.dart';
import 'package:clearance/models/api_models/config_model.dart' as config;

import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../../models/api_models/home_Section_model.dart';
import '../../brand_products/brand_products_layout.dart';
import '../../categories/category_detailed_layout/category_detailed_layout.dart';

class HomeBannersSlider extends StatelessWidget {
  const HomeBannersSlider({Key? key, required this.banners}) : super(key: key);
  final List<BannerItem> banners;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 170.h,
        initialPage: 0,
        pauseAutoPlayOnTouch: true,
        viewportFraction: 1,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(seconds: 1),
        autoPlayCurve: Curves.fastOutSlowIn,
        scrollDirection: Axis.horizontal,
      ),
      items: banners.map((e) {
        return GestureDetector(
          onTap: () {
            logg('resource type: ' + e.resourceType!);
            e.resourceType == 'category'
                ? navigateToWithoutNavBar(
                    context,
                    SubSubCategoryLayout(
                      cateId: e.resourceId!.toString(),
                      token: getCachedToken(),
                    ),
                    CategoryDetailedLayout.routeName)
                : e.resourceType == 'product'
                    ? navigateToWithoutNavBar(
                        context,
                        ProductDetailsLayout(
                            productId: e.resourceId.toString()),
                        ProductDetailsLayout.routeName)
                    : e.resourceType == 'brand'
                        ? navigateToWithNavBar(
                            context,
                BrandProductsLayout(
                    resourceType: e.resourceType.toString(),
                    resourceId: e.resourceId.toString()),
                BrandProductsLayout.routeName)
                        : logg(e.resourceId!.toString());
          },
          child: CachedNetworkImage(
            imageUrl: e.photo!,
            placeholder: (context, url) => const DefaultLoader(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        );
      }).toList(),
    );
  }
}

class HomeCategoriesBody extends StatefulWidget {
   HomeCategoriesBody({Key? key, required this.homeGroups ,this.frontColor ,this.backColor})
      : super(key: key);
  final List<Section> homeGroups;
  final Color? frontColor;
  final Color? backColor;

  @override
  State<HomeCategoriesBody> createState() => _HomeCategoriesBodyState();
}

class _HomeCategoriesBodyState extends State<HomeCategoriesBody> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.homeGroups.length,
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return widget.homeGroups[index].resourceType == 'banner'
              ? BannerView(
                  banner1: widget.homeGroups[index].hsBanner,
                  banner2: widget.homeGroups[index].hsBanner2,
                )
              : widget.homeGroups[index].resourceType == 'offers'
                  ? HomeOffers(
                      offerBackColor: widget.homeGroups[index].color == '#000000' ||
                              widget.homeGroups[index].color == '#ffffff' ||
                              widget.homeGroups[index].color == null
                          ? primaryColor
                          : HexColor(widget.homeGroups[index].color!),
                      offerStyle: 'towByTowWithBack',
                      style: widget.homeGroups[index].productsStyle.toString(),
                      title: widget.homeGroups[index].title!,
                      titleIcon: widget.homeGroups[index].photo!,
                      offersList: widget.homeGroups[index].hsOffers!,
                    )
                  : widget.homeGroups[index].homeSectionType.toString() == '2'
                      ? HomeProductsHorizontalView(
                          title: widget.homeGroups[index].title!,
                          titleIcon: widget.homeGroups[index].photo!,
                          productsList: widget.homeGroups[index].hsProducts!)
                      : widget.homeGroups[index].homeSectionType.toString() == '3'
                          ? HomeProductsGridThreePerLine(
                              title: widget.homeGroups[index].title!,
                              titleIcon: widget.homeGroups[index].photo!,
                              productsList: widget.homeGroups[index].hsProducts!,
                            )
                          : widget.homeGroups[index].homeSectionType.toString() == '4'
                              ? HomeProductsGridFourPerLine(
                                  title: widget.homeGroups[index].title!,
                                  titleIcon: widget.homeGroups[index].photo!,
                                  productsList: widget.homeGroups[index].hsProducts!,
                                )
                              : HomeProductsGridView(
                                  title: widget.homeGroups[index].title!,
                                  backColor:widget.backColor,
                                  frontColor:widget.frontColor,
                                  titleIcon: widget.homeGroups[index].photo!,
                                  productsList: widget.homeGroups[index].hsProducts!,
                                );
        });
  }
}

class BannerView extends StatelessWidget {
  const BannerView({
    Key? key,
    required this.banner1,
    required this.banner2,
  }) : super(key: key);

  final HsBanner? banner1;
  final HsBanner? banner2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: banner1 != null
          ? Row(
            children: [
              GestureDetector(
                  onTap: () {
                    banner1!.resourceType == 'category'
                        ? navigateToWithoutNavBar(
                            context,
                            SubSubCategoryLayout(
                              cateId: banner1!.resourceId!.toString(),
                              token: getCachedToken(),
                            ),
                            CategoryDetailedLayout.routeName)
                        : banner1!.resourceType == 'product'
                            ? navigateToWithoutNavBar(
                                context,
                                ProductDetailsLayout(
                                    productId: banner1!.resourceId.toString()),
                                ProductDetailsLayout.routeName)
                            : banner1!.resourceType == 'brand'
                        ? navigateToWithNavBar(
                        context,
                        BrandProductsLayout(
                            resourceType: banner1!.resourceType.toString(),
                            resourceId: banner1!.resourceId.toString()),
                        BrandProductsLayout.routeName)
                        : logg(banner1!.resourceId!.toString());
                  },
                  child: DefaultImage(
                      withoutRadius: true,
                      width: banner2!=null ? 0.5.sw-10.r: 1.sw-10.r,
                      borderColor: banner1!.photo == null
                          ? newSoftGreyColor
                          : Colors.transparent,
                      height: 0.2.sh,
                      backGroundImageUrl: banner1!.photo),
                ),
              if (banner2!=null) GestureDetector(
                  onTap: () {
                    banner2!.resourceType == 'category'
                        ? navigateToWithoutNavBar(
                            context,
                            SubSubCategoryLayout(
                              cateId: banner2!.resourceId!.toString(),
                              token: getCachedToken(),
                            ),
                            CategoryDetailedLayout.routeName)
                        : banner2!.resourceType == 'product'
                            ? navigateToWithoutNavBar(
                                context,
                                ProductDetailsLayout(
                                    productId: banner2!.resourceId.toString()),
                                ProductDetailsLayout.routeName)
                            : banner2!.resourceType == 'brand'
                        ? navigateToWithNavBar(
                        context,
                        BrandProductsLayout(
                            resourceType: banner2!.resourceType.toString(),
                            resourceId: banner2!.resourceId.toString()),
                        BrandProductsLayout.routeName)
                        : logg(banner2!.resourceId!.toString());
                  },
                  child: DefaultImage(
                      withoutRadius: true,
                      width: 0.5.sw,
                      borderColor: banner2!.photo == null
                          ? newSoftGreyColor
                          : Colors.transparent,
                      height: 0.2.sh,
                      backGroundImageUrl: banner2!.photo),
                ) else const SizedBox.shrink(),
            ],
          )
          : const SizedBox(),
    );
  }
}
