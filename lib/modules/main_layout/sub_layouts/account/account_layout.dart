import 'package:clearance/core/error_screens/show_error_message.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/cubit/account_state.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/sub_account/join_us_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:clearance/core/constants/dimensions.dart';
import 'package:clearance/core/main_functions/main_funcs.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/sub_account/addresses.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/sub_account/balance_view.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/sub_account/faq_screen.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/sub_account/favourite_view.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/sub_account/my_account.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/sub_account/my_coupouns_view.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/sub_account/my_orders.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/sub_account/recently_viewed.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/sub_account/settings_view.dart';
import '../../../../core/constants/startup_settings.dart';
import '../../../../core/main_cubits/cubit_main.dart';
import '../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../models/local_models/account_items_model.dart';
import '../../../auth_screens/sign_in_screen.dart';
import 'account_shared_widgets/account_shared_widgets.dart';
import 'cubit/account_cubit.dart';

class AccountLayout extends StatefulWidget {
  const AccountLayout({Key? key}) : super(key: key);

  @override
  State<AccountLayout> createState() => _AccountLayoutState();
}

class _AccountLayoutState extends State<AccountLayout> {
  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    List<AccountItemsModel> mainListAccountItems = [
      AccountItemsModel(
          id: 1,
          svgImagePath: 'assets/images/account/Profil_Icon.svg',
          title: localizationStrings!.myAccount, apiOrderStatus: ''),
      AccountItemsModel(
          id: 16,
          svgImagePath: 'assets/images/account/List order_Icon.svg',
          title: localizationStrings.orders, apiOrderStatus: ''),

    ];
    List<AccountItemsModel> headerMainItems = [

      AccountItemsModel(
          id: 22,
          svgImagePath: 'assets/images/account/Location_Icon.svg',
          title: localizationStrings.address, apiOrderStatus: ''),

    ];
    return BlocBuilder<AccountCubit, AccountStates>(

      builder: (context, state) {
        String? token = MainCubit.get(context).token;
        return Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0.h),
            child: const UserInfoAndNotificationAppBar(),
          ),


          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(

              children: [
                SizedBox(height: 10.h,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultHorizontalPadding * 2),
                  child: Column(
                    children: [
                      ListView.separated(
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: mainListAccountItems.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            GestureDetector(
                              onTap: () {
                                switch (mainListAccountItems[index].id) {
                                  case 1:
                                    token == null ?
                                    navigateToWithNavBar(
                                        context, const JoinUsScreen(),
                                        JoinUsScreen.routeName) :
                                    navigateToWithNavBar(
                                        context, const MyAccount(),
                                        MyAccount.routeName);
                                    break;
                                  case 16:
                                    token == null ?
                                    navigateToWithNavBar(
                                        context, const JoinUsScreen(),
                                        JoinUsScreen.routeName) :
                                    navigateToWithNavBar(
                                        context, const MyOrdersView(),
                                        MyOrdersView.routeName);
                                    break;
                                  case 4:
                                    token == null ?
                                    showTopModalSheetErrorLoginRequired(context) :
                                    navigateToWithNavBar(
                                        context, const FavouriteView(),
                                        FavouriteView.routeName);
                                    break;

                                  case 7:
                                    token == null ?
                                    showTopModalSheetErrorLoginRequired(context) :
                                    navigateToWithNavBar(
                                        context,
                                        const RecentlyViewedView(),
                                        RecentlyViewedView.routeName);
                                    break;


                                  case 9:
                                    token == null ?
                                    showTopModalSheetErrorLoginRequired(context) :
                                    navigateToWithNavBar(
                                        context, const FaqScreen(),
                                        FaqScreen.routeName);
                                    break;
                                }
                              },
                              child: AccountItemContainer(
                                svgPath: mainListAccountItems[index]
                                    .svgImagePath,
                                title: mainListAccountItems[index].title,
                              ),
                            ),


                        scrollDirection: Axis.vertical,
                        separatorBuilder: (context, index) =>
                            SizedBox(
                              height: 11.h,
                            ),
                      ),
                      SizedBox(height: 10.h,),
                      const FaqContainer(),
                      SizedBox(height: 20.h,),
                    ],
                  ),
                ),
                const Padding(
                  padding:  EdgeInsets.symmetric(
                      horizontal: defaultHorizontalPadding * 2),
                  child:  ContactUs(),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultHorizontalPadding * 2),
                  child:

                  ListView.separated(

                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: headerMainItems.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        GestureDetector(
                          onTap: () {
                            switch (headerMainItems[index].id) {
                              case 22:
                                navigateToWithNavBar(
                                    context, const AddressesView(),
                                    AddressesView.routeName);
                                break;
                              case 21:
                                navigateToWithNavBar(
                                    context, const WalletView(),
                                    WalletView.routeName);
                                break;
                              case 23:
                                navigateToWithNavBar(
                                    context,
                                    const MyCoupounsView(),
                                    MyCoupounsView.routeName);
                                break;
                              case 27:
                                navigateToWithNavBar(
                                    context, const SettingsView(),
                                    SettingsView.routeName);
                                break;
                              case 10:
                                navigateToWithoutNavBar(context,
                                    const SignInScreen(),
                                    SignInScreen.routeName);
                                break;
                            }
                          },
                          child: AccountItemContainer(
                            svgPath: headerMainItems[index].svgImagePath,
                            title: headerMainItems[index].title,
                          ),
                        ),


                    scrollDirection: Axis.vertical,
                    separatorBuilder: (context, index) =>
                        SizedBox(
                          height: 11.h,
                        ),
                  )
                  ,

                ),
                SizedBox(
                    height: 20.h
                ),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: defaultHorizontalPadding * 2),
              child:ChangeLanguage(),),
                SizedBox(height: 20.h),
                const Padding(
                  padding:  EdgeInsets.symmetric(
                      horizontal: defaultHorizontalPadding * 2),
                  child:  AboutApp(),
                ),
                if(showFeedBack!)...{
                  SizedBox(height: 20.h),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: defaultHorizontalPadding * 2),
                    child: FeedBack(),
                  ),
                },
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

