import 'package:clearance/core/error_screens/show_error_message.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/cubit/account_cubit.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/cubit/account_state.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/sub_account/feed_back_screen.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/sub_account/requestAndResponseDetailsLayout.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:clearance/models/local_models/account_items_model.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cart_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../appMainInitial.dart';
import '../../../../../core/common/helper_function.dart';
import '../../../../../core/constants/startup_settings.dart';
import '../../../../../core/constants/dimensions.dart';
import '../../../../../core/main_cubits/cubit_main.dart';
import '../../../../../core/main_cubits/states_main.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../../core/styles_colors/styles_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../models/api_models/config_model.dart' show Faq;
import '../sub_account/my_orders.dart';

class SubAccountLayoutsHeader extends StatelessWidget {
  const SubAccountLayoutsHeader({
    Key? key,
    required this.localizationStrings,
    this.backButton,
  }) : super(key: key);

  final localizationStrings;
  final bool? backButton;

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    String? token = mainCubit.token;
    String? name = mainCubit.name;
    String? email = mainCubit.email;

    return Stack(
      children: [
        Container(
          color: mainBackgroundColor,
          height: 0.3.sh,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 40.h,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.account_circle,
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
                isUserSignedIn(token)
                    ? Text(
                        name!,
                        style:
                            mainStyle(18.0, FontWeight.w800, color: titleColor),
                      )
                    : Text(
                        'Join us',
                        style:
                            mainStyle(18.0, FontWeight.w800, color: titleColor),
                      ),
                SizedBox(
                  height: 18.h,
                ),
                isUserSignedIn(token)
                    ? Text(email!,
                        style: mainStyle(16.0, FontWeight.w300,
                            color: Colors.grey))
                    : TextButton(
                        onPressed: () {},
                        child: Text('Sign in',
                            style: mainStyle(14.0, FontWeight.w300,
                                color: Colors.grey)),
                      ),
                SizedBox(
                  height: 14.h,
                ),
              ],
            ),
          ),
        ),
        if (backButton == null || backButton == true)
          Align(
            alignment: AlignmentDirectional.topStart,
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child:
                  DefaultBackButton(localizationStrings: localizationStrings),
            ),
          )
      ],
    );
  }
}

class MainAccountHeader extends StatelessWidget {
  const MainAccountHeader({
    Key? key,
    required this.localizationStrings,
  }) : super(key: key);

  final localizationStrings;

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    var accountCubit = AccountCubit.get(context);

    String? token = mainCubit.token;
    List<AccountItemsModel> ordersMainItems = [
      AccountItemsModel(
          id: 0,
          apiOrderStatus: 'pending',
          svgImagePath: 'assets/images/account/my_orders/confirming.svg',
          title: localizationStrings!.pending),
      AccountItemsModel(
          id: 1,
          apiOrderStatus: 'confirmed',
          svgImagePath: 'assets/images/account/my_orders/preparing.svg',
          title: localizationStrings.confirmed),
      AccountItemsModel(
          id: 2,
          apiOrderStatus: 'processing',
          svgImagePath: 'assets/images/public/add_to_cart.svg',
          title: localizationStrings.preparing),
      AccountItemsModel(
          id: 3,
          apiOrderStatus: 'delivered',
          svgImagePath: 'assets/images/account/my_orders/shipped.svg',
          title: localizationStrings.delivered),
      AccountItemsModel(
          id: 4,
          apiOrderStatus: 'returned',
          svgImagePath: 'assets/images/account/my_orders/refund.svg',
          title: localizationStrings.returned),
    ];

    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) => ConditionalBuilder(
        condition: true,
        builder: (context) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultHorizontalPadding * 2),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 13.w,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: SvgPicture.asset(
                                'assets/images/account/List order_Icon.svg'),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            localizationStrings.orders,
                            style: mainStyle(14.0, FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 13.h,
                  ),
                  DefaultContainer(
                    height: 90.w,
                    borderColor: Colors.transparent,
                    childWidget: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0.w, vertical: 3.h),
                      child: Center(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: ordersMainItems.length,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) => SizedBox(
                            width: 8.w,
                          ),
                          itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                token == null
                                    ? showTopModalSheetErrorLoginRequired(
                                        context)
                                    : accountCubit.applyOrdersListFilter(
                                        ordersMainItems[index].apiOrderStatus);
                                navigateToWithNavBar(context, MyOrdersView(),
                                    MyOrdersView.routeName);
                              },
                              child: OrderTab(
                                svgAssetLink:
                                    ordersMainItems[index].svgImagePath,
                                title: ordersMainItems[index].title,
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
        fallback: (context) => DefaultLoader(),
      ),
    );
  }
}

class MainAccountHeaderItem extends StatelessWidget {
  const MainAccountHeaderItem({
    Key? key,
    required this.imagePath,
    required this.title,
  }) : super(key: key);

  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: 60.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 8.h,
          ),
          Expanded(
            child: SizedBox(
                height: 25.w,
                width: 25.w,
                child: Padding(
                  padding: EdgeInsets.all(2.0.sp),
                  child: SvgPicture.asset(
                    imagePath,
                    height: 25.w,
                    width: 25.w,
                  ),
                )),
          ),
          SizedBox(
            height: 3.h,
          ),
          SizedBox(
              width: 56.w,
              child: Center(
                  child: Text(
                title,
                style: mainStyle(12.0, FontWeight.w400),
                maxLines: 1,
                textAlign: TextAlign.center,
              )))
        ],
      ),
    );
  }
}

class SearchRequestsAppBar extends StatefulWidget {
  SearchRequestsAppBar({Key? key, required this.onSearch}) : super(key: key);

  final void Function(String text) onSearch;

  @override
  State<SearchRequestsAppBar> createState() => _SearchRequestsAppBarState();
}

class _SearchRequestsAppBarState extends State<SearchRequestsAppBar> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    searchController.addListener(() {
      widget.onSearch.call(searchController.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    return AppBar(
      backgroundColor: newSoftGreyColorAux,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(17.sp),
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
      title: DefaultContainer(
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
              childWidget: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.w)
                      .copyWith(bottom: 10.h),
                  child: TextFormField(
                    cursorColor: primaryColor,
                    controller: searchController,
                    decoration: const InputDecoration(
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: localizationStrings!.language == 'English' ? 0.0 : null,
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
    );
  }
}

class RequestAndResponseCard extends StatelessWidget {
  const RequestAndResponseCard({Key? key, required this.data})
      : super(key: key);
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    var localizationString = AppLocalizations.of(context);
    return IntrinsicHeight(
      child: Container(
        margin: EdgeInsets.all(12.sp),
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: mainBackgroundColor,
          border: Border.all(color: primaryColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.verticalSpace,
            Expanded(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'URL: ',
                      style: mainStyle(16.0, FontWeight.w700),
                    ),
                    TextSpan(
                      text: data['url'],
                      style:
                          mainStyle(16.0, FontWeight.w400, color: primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            4.verticalSpace,
            Expanded(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Request: ',
                      style: mainStyle(16.0, FontWeight.w700),
                    ),
                    TextSpan(
                      text: data['request'],
                      style:
                          mainStyle(16.0, FontWeight.w400, color: primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            4.verticalSpace,
            Expanded(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Header: ',
                      style: mainStyle(16.0, FontWeight.w700),
                    ),
                    TextSpan(
                      text: data['headers'].toString(),
                      style:
                      mainStyle(16.0, FontWeight.w400, color: primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            if (data['query'] != null) ...{
              4.verticalSpace,
              Expanded(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'query: ',
                        style: mainStyle(16.0, FontWeight.w700),
                      ),
                      TextSpan(
                        text: data['query'].toString(),
                        style:
                            mainStyle(16.0, FontWeight.w400, color: primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            },
            if (data['body'] != null) ...{
              4.verticalSpace,
              Expanded(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'body: ',
                        style: mainStyle(16.0, FontWeight.w700),
                      ),
                      TextSpan(
                        text: data['body'].toString(),
                        style:
                            mainStyle(16.0, FontWeight.w400, color: primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            },
            4.verticalSpace,
            Expanded(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Response: ',
                      style: mainStyle(16.0, FontWeight.w700),
                    ),
                    TextSpan(
                      text: data['response'].toString(),
                      style:
                          mainStyle(16.0, FontWeight.w400, color: primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            8.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 0.4.sw,
                    child: DefaultButton(
                        title: localizationString!.lbl_share,
                        borderColors: primaryColor,
                        onClick: () async {
                          String text = "";
                          data.forEach((key, value) {
                            if (value != null) {
                              text+=(key.toUpperCase() + ': ' + value.toString());
                              text += '\n';
                            }
                          });
                          logg(text);
                          await Share.share(text);
                        })),
                15.horizontalSpace,
                SizedBox(
                    width: 0.4.sw,
                    child: DefaultButton(
                      title: localizationString.viewMore,
                      borderColors: primaryColor,
                      onClick: () {
                        navigateToWithNavBar(
                            context,
                            RequestAndResponseDetailsLayout(
                              data: data,
                            ),
                            RequestAndResponseDetailsLayout.routeName);
                      },
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  final ValueNotifier<bool> isShowed = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    return Container(
      height: 65.h,
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        border: Border.all(width: 1.0, color: primaryColor),
      ),
      child: ValueListenableBuilder<bool>(
          valueListenable: isShowed,
          builder: (context, showed, child) {
            return InkWell(
              onTap: () {
                isShowed.value = !isShowed.value;
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 30.w,
                  ),
                  SizedBox(
                    width: 28.w,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: FutureBuilder(
                          future: changeSvgColor(
                              'assets/images/account/icons8_help.svg'),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox.shrink();
                            }
                            return SvgPicture.string(snapshot.data!);
                          }),
                    ),
                  ),
                  SizedBox(
                    width: 26.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              localizationStrings!.about_app,
                              style: mainStyle(15.0, FontWeight.w800,
                                  color: primaryColor),
                            ),
                            Icon(showed
                                ? Icons.keyboard_arrow_down_sharp
                                : localizationStrings.localeName == 'en'
                                    ? Icons.keyboard_arrow_right_rounded
                                    : Icons.keyboard_arrow_left_rounded)
                          ],
                        ),
                      ),
                      showed
                          ? Text(
                              '${localizationStrings.version}1.2.4',
                              style: mainStyle(15.0, FontWeight.w800,
                                  color: primaryColor),
                            )
                          : const SizedBox()
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class ContactUsContent extends StatelessWidget {
  const ContactUsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var accountCubit = AccountCubit.get(context);
    return BlocConsumer<AccountCubit, AccountStates>(
      listener: (context, state) {
        if (state is FailureContactUsDataState) {
          Navigator.of(context).pop();
          showTopModalSheetErrorMessage(
              context, localizationStrings!.something_went_wrong);
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: accountCubit.contactUsModel != null,
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              10.verticalSpace,
              Text(
                localizationStrings!.contact_us,
                style: mainStyle(18, FontWeight.w500),
              ),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(
                    flex: 2,
                  ),
                  InkWell(
                      onTap: () async {
                        launchUrl(
                          Uri.parse(
                              'https://wa.me/${accountCubit.contactUsModel!.data!.whatsAppPhone}'),
                          mode: LaunchMode.externalApplication
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: SvgPicture.asset('assets/images/whatsapp.svg',
                            height: 40.h),
                      )),
                  const Spacer(
                    flex: 2,
                  ),
                  FutureBuilder(
                      future: changeSvgColor('assets/images/call_mark.svg'),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox.shrink();
                        }
                        return InkWell(
                            onTap: () {
                              HelperFunctions.urlLauncherApplication(
                                  "tel: ${accountCubit.contactUsModel!.data!.phone}");
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: SvgPicture.string(snapshot.data!,
                                  height: 40.h),
                            ));
                      }),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
              20.verticalSpace,
              Container(
                padding: EdgeInsets.all(4.sp),
                child: Text(
                  accountCubit.contactUsModel!.data!.messageContactUs
                      .toString(),
                  style: mainStyle(14, FontWeight.w500, color: primaryColor),
                ),
              ),
              10.verticalSpace,
            ],
          ),
          fallback: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Center(
                child: DefaultLoader(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    return InkWell(
      onTap: () {
        AccountCubit.get(context).getContactUsInformation();
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return const ContactUsContent();
            });
      },
      child: Container(
        height: 65.h,
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          border: Border.all(width: 1.0, color: primaryColor),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30.w,
            ),
            SizedBox(
              width: 28.w,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: FutureBuilder(
                    future: changeSvgColor('assets/images/support.svg'),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }
                      return SvgPicture.string(snapshot.data!);
                    }),
              ),
            ),
            SizedBox(
              width: 26.w,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localizationStrings!.contact_us,
                    style:
                        mainStyle(15.0, FontWeight.w800, color: primaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedBack extends StatefulWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    return InkWell(
      onTap: () {
        navigateToWithNavBar(
            context, FeedBackScreen(), FeedBackScreen.routeName);
      },
      child: Container(
        height: 65.h,
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          border: Border.all(width: 1.0, color: primaryColor),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30.w,
            ),
            SizedBox(
              width: 28.w,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: FutureBuilder(
                    future:
                        changeSvgColor('assets/images/account/icons8_help.svg'),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }
                      return SvgPicture.string(snapshot.data!);
                    }),
              ),
            ),
            SizedBox(
              width: 26.w,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localizationStrings!.feed_back,
                    style:
                        mainStyle(15.0, FontWeight.w800, color: primaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeLanguage extends StatelessWidget {
  const ChangeLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    return InkWell(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
          context,
          screen: const FirstStartChooseDefaultLangScreen(),
          settings: const RouteSettings(name: '/'),
          withNavBar: false,
        );
      },
      child: Container(
        height: 65.h,
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(2.0.sp),
          border: Border.all(width: 1.0, color: primaryColor),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30.w,
            ),
            SizedBox(
                width: 28.w,
                child: Icon(
                  Icons.language_rounded,
                  color: primaryColor,
                  size: 20.h,
                )),
            SizedBox(
              width: 26.w,
            ),
            Text(
              localizationStrings!.change_language,
              style: mainStyle(15.0, FontWeight.w800, color: titleColor),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountItemContainer extends StatelessWidget {
  const AccountItemContainer({
    Key? key,
    required this.svgPath,
    required this.title,
  }) : super(key: key);

  final String svgPath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: changeSvgColor(svgPath),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return Container(
            height: 65.h,
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(2.0.sp),
              border: Border.all(width: 1.0, color: primaryColor),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 30.w,
                ),
                SizedBox(
                    width: 28.w,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: SvgPicture.string(snapshot.data!),
                    )),
                SizedBox(
                  width: 26.w,
                ),
                Text(
                  title,
                  style: mainStyle(15.0, FontWeight.w800, color: titleColor),
                ),
              ],
            ),
          );
        });
  }
}

class FaqContainer extends StatelessWidget {
  const FaqContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var mainCubit = MainCubit.get(context);

    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: mainCubit.configModel != null,
          builder: (context) {
            List<Faq> faqs = mainCubit.configModel!.data!.faq!;
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(11.0.sp),
                border: Border.all(width: 1.0, color: primaryColor),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 21.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 30.w,
                      ),
                      SizedBox(
                        width: 28.w,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: FutureBuilder(
                              future: changeSvgColor(
                                  'assets/images/account/icons8_help.svg'),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (!snapshot.hasData)
                                  return const SizedBox.shrink();
                                return SvgPicture.string(snapshot.data!);
                              }),
                        ),
                      ),
                      SizedBox(
                        width: 26.w,
                      ),
                      Text(
                        localizationStrings!.faq,
                        style:
                            mainStyle(15.0, FontWeight.w800, color: titleColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.0.w),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: faqs.length,
                      scrollDirection: Axis.vertical,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 16.h,
                      ),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          mainCubit.currentViewFaqAnswerId ==
                                  faqs[index].id.toString()
                              ? mainCubit.changeSelectedFaqViewAnswer('-15')
                              : mainCubit.changeSelectedFaqViewAnswer(
                                  faqs[index].id!.toString());
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  faqs[index].question!,
                                  style: mainStyle(15.0, FontWeight.w500),
                                )),
                                Icon(mainCubit.currentViewFaqAnswerId ==
                                        faqs[index].id.toString()
                                    ? Icons.keyboard_arrow_down_sharp
                                    : localizationStrings.localeName == 'en'
                                        ? Icons.keyboard_arrow_right_rounded
                                        : Icons.keyboard_arrow_left_rounded)
                              ],
                            ),
                            mainCubit.currentViewFaqAnswerId ==
                                    faqs[index].id.toString()
                                ? Text(
                                    faqs[index].answer!,
                                    style: mainStyle(14.0, FontWeight.w400,
                                        color: primaryColor),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 21.h,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                ],
              ),
            );
          },
          fallback: (context) => SizedBox(),
        );
      },
    );
  }
}

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    var mainCubit = MainCubit.get(context);
    mainCubit.initialLocale(locale);

    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) => DropdownButtonHideUnderline(
          child: DropdownButton<Locale>(
        alignment: Alignment.center,
        isExpanded: true,
        items: L10n.all.map(
          (locale) {
            return DropdownMenuItem(
              child: Center(child: Text(locale.languageCode)),
              value: locale,
            );
          },
        ).toList(),
        value: mainCubit.appLocale!,
        onChanged: (value) {
          mainCubit.setLocale(value!, context, false);
        },
      )),
    );
  }
}
