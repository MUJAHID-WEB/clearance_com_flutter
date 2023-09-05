import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/styles_colors/styles_colors.dart';
import 'package:clearance/modules/auth_screens/cubit/cubit_auth.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/cubit/account_cubit.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/cubit/account_state.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/sub_account/favourite_view.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cubit/cart_state.dart';
import 'package:clearance/modules/main_layout/sub_layouts/notifications/pages/notifications_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/account_layout.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cart_screen.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cubit/cart_cubit.dart';
import 'package:clearance/modules/main_layout/sub_layouts/categories/categories_scroll_layout.dart';
import 'package:clearance/modules/main_layout/sub_layouts/home/main_home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../core/cache/cache.dart';
import '../../core/constants/networkConstants.dart';
import '../../core/main_cubits/cubit_main.dart';
import '../../core/main_cubits/states_main.dart';
import '../../core/main_functions/main_funcs.dart';
import '../../core/network/dio_helper.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);
  static String routeName = 'mainLayout';

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  PersistentTabController? _controller;

  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((value) async {
      logg('token fcm : $value');
      await MainDioHelper.postData(
          url: storeFcmToken,
          token: getCachedToken(),
          data: {
            "device_token": value,
            "auth_token": getCachedToken(),
            "user_id": AuthCubit.get(context).userInfoModel!.data!.id
          }).then((value) {
        logg('response ${value.data}');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CartCubit.get(context).getCartDetails(updateAllList: true);
    var mainCubit = MainCubit.get(context)
      ..getMainCacheUserData()
      ..initial(isLogout: false , context: context);
    mainCubit.getMainCacheUserData();
    if (!mainCubit.cacheGot) {
      mainCubit.getMainCacheUserData();
    }
    _controller = PersistentTabController(initialIndex: 0);
    mainCubit.moveToHomeTap = (int index) {
      _controller!.jumpToTab(index);
    };
    if (mainCubit.token != null) {
      AccountCubit.get(context).getWishListProducts();
    }
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) => PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(context, mainCubit.selectedTab),
        navBarHeight: 50.h,
        onItemSelected: (index) {
          logg('screen index: ' + index.toString());
          if (index == 0) {
            mainCubit.changeSelectedCategoryId('0');
          }
          if (index == (showNotifications! ? 3 :2 )) {
            CartCubit.get(context)
              ..getCartDetails(
                updateAllList: true,
              )
              ..disableCouponStillAvailable();
          }
          if (index == (showNotifications! ? 4 :3 )) {
            AccountCubit.get(context).getWishListProducts();
          }
        },
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5.0.sp),
                topLeft: Radius.circular(5.0.sp)),
            colorBehindNavBar: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: primaryColor,
                blurRadius: 1,
              ),
            ],
            adjustScreenBottomPaddingOnCurve: true),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: false,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }

  List<Widget> _buildScreens() {
    var list = [
      const MainHomeScreen(),
      const CategoriesScrollLayout(),
      const NotificationsPage(),
      const CartScreen(),
      const FavouriteView(),
      const AccountLayout(),
    ];
    if(!(showNotifications ?? true)){
      list.removeAt(2);
    }
    return list;
  }
}

List<PersistentBottomNavBarItem> _navBarsItems(
    BuildContext context, String selectedTab) {
  var localizationStrings = AppLocalizations.of(context);
  var list = [
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.home),
      title: (localizationStrings!.home),
      iconSize: 20.h,
      textStyle: mainStyle(12.0, FontWeight.w200),
      activeColorPrimary: primaryColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.rectangle_3_offgrid_fill),
      iconSize: 20.h,
      textStyle: mainStyle(12.0, FontWeight.w200),
      title: (localizationStrings.categories),
      activeColorPrimary: primaryColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.notifications_none_outlined),
      iconSize: 20.h,
      textStyle: mainStyle(10.0, FontWeight.w200),
      title: (localizationStrings.lbl_notification),
      activeColorPrimary: primaryColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: BlocBuilder<CartCubit, CartStates>(
          buildWhen: (previous, current) => current is CartLoadedSuccessState,
          builder: (context, state) {
            return badges.Badge(
              position: badges.BadgePosition.topStart(start: -5,top: -5),
              showBadge: (CartCubit.get(context)
                  .cartModel
                  ?.data
                  ?.cart
                  ?.length ?? 0) >0,
              badgeContent: Text(
                  CartCubit.get(context)
                          .cartModel
                          ?.data
                          ?.cart
                          ?.length
                          .toString() ??
                      '0',
                  style: mainStyle(8, FontWeight.bold,
                      fontFamily: 'poppins', color: mainBackgroundColor)),
              child: const Icon(CupertinoIcons.shopping_cart),
              badgeStyle:  const badges.BadgeStyle(
                padding: EdgeInsets.all(3),
                  shape: badges.BadgeShape.circle, badgeColor: Colors.red),
            );
          }),
      title: (localizationStrings.cart),
      iconSize: 20.h,
      textStyle: mainStyle(12.0, FontWeight.w200),
      activeColorPrimary: primaryColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: BlocBuilder<AccountCubit, AccountStates>(
          buildWhen: (previous, current) => current is WishListDataSuccessState,
          builder: (context, state) {
            return badges.Badge(
              position: badges.BadgePosition.topStart(start: -5,top: -5),
              showBadge: (AccountCubit.get(context).wishListProducts?.length ?? 0) > 0,
              badgeContent: Text(
                  AccountCubit.get(context)
                          .wishListProducts
                          ?.length
                          .toString() ??
                      '0',
                  style: mainStyle(8, FontWeight.bold,
                      fontFamily: 'poppins', color: mainBackgroundColor)),
              child: const Icon(CupertinoIcons.suit_heart_fill),
              badgeStyle:  const badges.BadgeStyle(
                  padding: EdgeInsets.all(3),
                  shape: badges.BadgeShape.circle, badgeColor: Colors.red),
            );
          }),
      title: (localizationStrings.favourite),
      iconSize: 20.h,
      textStyle: mainStyle(12.0, FontWeight.w200),
      activeColorPrimary: primaryColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.profile_circled),
      title: (localizationStrings.account),
      iconSize: 20.h,
      textStyle: mainStyle(12.0, FontWeight.w200),
      activeColorPrimary: primaryColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
  ];
  if(!(showNotifications ?? true)){
    list.removeAt(2);
  }
  return list;
}
