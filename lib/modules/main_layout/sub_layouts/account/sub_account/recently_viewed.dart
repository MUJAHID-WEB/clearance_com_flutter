import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:clearance/models/api_models/home_Section_model.dart';
import '../../../../../core/constants/dimensions.dart';
import '../../../../../core/error_screens/errors_screens.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../account_shared_widgets/account_shared_widgets.dart';

class RecentlyViewedView extends StatelessWidget {
  const RecentlyViewedView({Key? key}) : super(key: key);
  static String routeName = 'recentlyViewedView';

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);

    List<Product> recentlyViewedList = [
      Product(
        id: 1,
        name: 'testFav',
        thumbnail: 'url',

        details: '180 AED',

      ),

    ];
    return Scaffold(
        appBar: PreferredSize(

          preferredSize: Size.fromHeight(56.0.h),
          child: const DefaultAppBarWithOnlyBackButton(),
        ),
        body: Padding(
      padding: EdgeInsets.only(bottom: 0.05.sh),
      child: Column(
        children: [
          
          Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultHorizontalPadding.w, vertical: 10.h),
                child: Column(
                  children: [
                    AccountItemContainer(
                      title: localizationStrings!.recentlyViewed,
                      svgPath: 'assets/images/account/recently viewed.svg',
                    ),

                    SizedBox(
                      height: 15.h,
                    ),

                    
                    Expanded(
                      child: RecentlyViewedList(
                          demoRecentlyViewedList: recentlyViewedList,
                          localizationStrings: localizationStrings),
                    ),
                  ],
                )),
          ),
        ],
      ),
    ));
  }
}

class RecentlyViewedList extends StatelessWidget {
  const RecentlyViewedList({
    Key? key,
    required this.demoRecentlyViewedList,
    required this.localizationStrings,
  }) : super(key: key);

  final List<Product> demoRecentlyViewedList;
  final AppLocalizations? localizationStrings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ConditionalBuilder(
        condition: demoRecentlyViewedList.isNotEmpty,
        builder: (context) => ProductsGridView(isInHome: false,
            towByTowJustTitle: false,
            crossAxisCount: 2,
            productsList: demoRecentlyViewedList),

        fallback: (context) => const EmptyError(),
      ),
    );
  }
}



