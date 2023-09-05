import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/main_cubits/cubit_main.dart';
import 'package:clearance/core/styles_colors/styles_colors.dart';
import 'package:clearance/models/api_models/home_Section_model.dart';
import 'package:clearance/modules/main_layout/sub_layouts/home/main_home.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/constants/networkConstants.dart';
import '../../../../core/error_screens/errors_screens.dart';
import '../../../../core/main_functions/main_funcs.dart';
import '../../../../core/shared_widgets/shared_widgets.dart';
import '../../../auth_screens/cubit/cubit_auth.dart';
import '../categories/sub_sub_category_layout/sub_sub_category_layout.dart';

class CollectionLayout extends StatefulWidget {
  const CollectionLayout(
      {Key? key, required this.index, required this.homeSection})
      : super(key: key);

  final HomeSectionItem homeSection;
  final int index;

  @override
  State<CollectionLayout> createState() => _CollectionLayoutState();
}

class _CollectionLayoutState extends State<CollectionLayout> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    var localizationString = AppLocalizations.of(context);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(4.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          10.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(vertical: 7.h),
            margin: EdgeInsets.symmetric(horizontal: 5.sp),
            decoration: BoxDecoration(
                color: Color(
                  int.parse(widget.homeSection.backColor ?? "0xffCC3333"),
                ),
                borderRadius: BorderRadius.circular(14.r)),
            child: Center(
              child: Text(widget.homeSection.category!,
                  style: mainStyle(16, FontWeight.bold,
                      color: mainBackgroundColor)),
            ),
          ),
          10.verticalSpace,
          ConditionalBuilder(
            condition: widget.homeSection.subCategories!.isNotEmpty,
            builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: widget.homeSection.subCategories!.length <= 4
                        ? 150
                        : 280.w,
                    child: GridView.count(
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount:
                          widget.homeSection.subCategories!.length <= 4 ? 1 : 2,
                      childAspectRatio:
                          widget.homeSection.subCategories!.length <= 4
                              ? 130.w / 85.w
                              : 110.w / 75.w,
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      mainAxisSpacing: 1.h,
                      crossAxisSpacing: 1.w,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                          widget.homeSection.subCategories!.length,
                          (index) => GestureDetector(
                                onTap: () async {
                                  logg('save event');
                                  await FirebaseAnalytics.instance.logEvent(
                                      name: 'enter_category',
                                      parameters: {
                                        'id':AuthCubit.get(context).userInfoModel!.data!.id,
                                        'category_id': widget.homeSection
                                            .subCategories![index].id,
                                        'category_name': widget.homeSection
                                            .subCategories![index].name,
                                        'server': baseLink.contains('www')
                                            ? 'production'
                                            : 'staging',
                                        'server_url': baseLink
                                      });
                                  navigateToWithNavBar(
                                      context,
                                      SubSubCategoryLayout(
                                          cateId: widget.homeSection
                                              .subCategories![index].id!
                                              .toString(),
                                          token: mainCubit.token),
                                      SubSubCategoryLayout.routeName);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: DefaultContainer(
                                    width: 75.h,
                                    borderColor: Colors.transparent,
                                    childWidget: DefaultImage(
                                      height: 100.w,
                                      width: 100.w,
                                      borderColor: Colors.transparent,
                                      backGroundImageUrl: widget.homeSection
                                          .subCategories![index].icon,
                                      boxFit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              )),
                    )),
              ],
            ),
            fallback: (context) => const EmptyError(),
          ),
          10.verticalSpace,
          CollectionItem(
              sections: widget.homeSection.sections,
              backColor:
                  Color(int.parse(widget.homeSection.backColor ?? "0xffCC3333")),
            frontColor:
            Color(int.parse(widget.homeSection.frontColor ?? "0xffffffff")),
          ),
          DefaultButton(
            title: localizationString!.showMore,
            onClick: (){
              mainCubit.changeCurrentSelectedHomeSection(widget.index , fromTop: false);
            },
            titleColor: Color(
              int.parse(widget.homeSection.backColor ?? "0xffCC3333"),
            ),
            borderColors: Color(
              int.parse(widget.homeSection.backColor ?? "0xffCC3333"),
            ),
          )
        ],
      ),
    );
  }
}

class CollectionItem extends StatelessWidget {
  const CollectionItem({Key? key, required this.sections, required this.backColor , required this.frontColor})
      : super(key: key);
  final List<Section>? sections;
  final Color backColor;
  final Color frontColor;

  @override
  Widget build(BuildContext context) {
    return HomeSectionsMainView(
      homeGroups: sections!,
      backColor: backColor,
      frontColor: frontColor,
    );
  }
}
