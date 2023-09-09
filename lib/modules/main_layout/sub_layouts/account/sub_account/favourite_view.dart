import 'package:clearance/modules/main_layout/sub_layouts/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:clearance/models/api_models/home_Section_model.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../../../../core/error_screens/errors_screens.dart';
import '../../../../../core/main_cubits/cubit_main.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../../core/styles_colors/styles_colors.dart';
import '../../product_details/product_details_layout.dart';
import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';

class FavouriteView extends StatelessWidget {
  const FavouriteView({Key? key}) : super(key: key);
  static String routeName = 'favouriteView';

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var accountCubit = AccountCubit.get(context);

    var mainCubit = MainCubit.get(context);

    String? token = mainCubit.token;
    if (token != null) accountCubit.getWishListProducts();

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: const UserInfoAndNotificationAppBar(),
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 26.0.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        token == null
                            ? SizedBox(
                                height: 400.h,
                                child: const Center(child: Text('Login to view ')))
                            : BlocConsumer<AccountCubit, AccountStates>(
                                listener: (context, state) {},
                                builder: (context, state) => ConditionalBuilder(
                                  condition: state is! LoadingWishListDataState,
                                  builder: (context) => Expanded(
                                    child: (accountCubit.wishListProducts?.isNotEmpty ?? false)
                                        ? FavsListView(
                                            wishListProducts:
                                                accountCubit.wishListProducts!,
                                            localizationStrings:
                                                localizationStrings)
                                        : const Center(child: EmptyError()),
                                  ),
                                  fallback: (context) => SizedBox(
                                    height: 0.6.sh,
                                    child: const Center(child: DefaultLoader()),
                                  ),
                                ),
                              ),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}

class FavsListView extends StatelessWidget {
  const FavsListView({
    Key? key,
    required this.wishListProducts,
    required this.localizationStrings,
  }) : super(key: key);

  final List<Product> wishListProducts;
  final AppLocalizations? localizationStrings;

  @override
  Widget build(BuildContext context) {
    var accountCubit = AccountCubit.get(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ConditionalBuilder(
        condition: wishListProducts.isNotEmpty,
        builder: (context) => ListView.separated(
          itemCount: wishListProducts.length,
          shrinkWrap: true,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: ProductDetailsLayout(
                    productId: wishListProducts[index].id.toString(),
                  ));
              
            },
            child: Row(
              children: [
                DefaultImage(
                  width: 78.h,
                  height: 78.h,
                  borderColor: Colors.transparent,
                  backGroundImageUrl: wishListProducts[index].thumbnail!,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wishListProducts[index].name!,
                        style: mainStyle(14.0, FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        wishListProducts[index].priceFormatted!,
                        style: mainStyle(14.0, FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        accountCubit.removeFromFav(
                            wishListProducts[index].id.toString());
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0.h),
                        child: Container(
                          width: 37.w,
                          height: 37.h,
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                width: 0.5, color: const Color(0xffa4c4f4)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(9.0.sp),
                            child: SvgPicture.asset(
                              'assets/images/public/icons8_trash_can_1.svg',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) => SizedBox(
            height: 11.h,
          ),
        ),
        fallback: (context) => const EmptyError(),
      ),
    );
  }
}
