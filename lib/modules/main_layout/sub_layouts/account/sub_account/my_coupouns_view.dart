import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../../../../core/constants/startup_settings.dart';
import '../../../../../core/error_screens/errors_screens.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../../core/styles_colors/styles_colors.dart';
import '../../../../../models/local_models/local_models.dart';
import '../account_shared_widgets/account_shared_widgets.dart';

class MyCoupounsView extends StatelessWidget {
  const MyCoupounsView({Key? key}) : super(key: key);
  static String routeName = 'myCoupounsView';

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);

    List<CoupounsLocalModel> coupounsList = [
      CoupounsLocalModel(
        id: 1,
        title: 'Eid coupon',
        discountType: 'const',
        endDate: '20/5/2022',

        details: '180 AED',
        status: 'not used'
      ),
      CoupounsLocalModel(
        id: 1,
        title: 'Ramadan',
        discountType: 'percentage',
        endDate: '20/5/2022',

        details: '50 % discount',
          status: 'not active'
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
                    padding:
                    EdgeInsets.symmetric(horizontal: 26.0.w, vertical: 10.h),
                    child: Column(
                      children: [
                        AccountItemContainer(
                          title: localizationStrings!.myCoupons,
                          svgPath: 'assets/images/account/icons8_membership_card.svg',
                        ),

                        SizedBox(
                          height: 15.h,
                        ),
                        SizedBox(
                          height: 45.h,
                          child: Row(
                            children: [
                              SizedBox(
                                
                                width: 200.w,


                                
                                child:
                                TextField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.h),
                                    
                                    hintText: 'Enter coupon code',

                                    

                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        const BorderSide(color: Color(0xffa4c4f4), width: 2.0),
                                        borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),

                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                        const BorderSide(color: Color(0xffa4c4f4), width: 1.0),
                                        borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),
                                  ),
                                ),
                              )
                           ,
                              SizedBox(width: 10.w,),
                              DefaultContainer(
                                height: 41.h,
                                width: 112.w,
                                backColor: primaryColor,
                                borderColor: primaryColor,
                                childWidget: Center(
                                  child: Text('change',
                                  style: mainStyle(16.0, FontWeight.w700,color: Colors.white),),
                                ),
                              )
                            ],
                          ),
                        ),
                        
                        Expanded(child:
                          MyCoupounsList(
                              demoOrdersList: coupounsList,
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

class MyCoupounsList extends StatelessWidget {
  const MyCoupounsList({
    Key? key,
    required this.demoOrdersList,
    required this.localizationStrings,
  }) : super(key: key);

  final List<CoupounsLocalModel>  demoOrdersList;
  final AppLocalizations? localizationStrings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ConditionalBuilder(
        condition: demoOrdersList.isNotEmpty,
        builder: (context) => ListView.separated(
          itemCount: demoOrdersList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) =>
          
          
          Row(
            children: [
              Container(
                width: 78.h,
                height: 78.h,
                
                decoration: BoxDecoration(
                  

                  borderRadius: BorderRadius.circular(10.0),
                ),
                child:
                demoOrdersList[index].discountType=='const'?
                Center(
                  child: SvgPicture.asset('assets/images/account/const aed discount.svg'),
                ):
                Center(
                  child: SvgPicture.asset('assets/images/account/percentage discount.svg'),
                )
                ,
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
                      demoOrdersList[index].title,
                      style: mainStyle(14.0, FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Text(
                          'End date: ',
                          style: mainStyle(13.0, FontWeight.w700),
                        ),
                        Text(
                          demoOrdersList[index].endDate,
                          style: mainStyle(13.0, FontWeight.w300),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      demoOrdersList[index].details,
                      style: mainStyle(14.0, FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      defaultAlertDialog(context, 'asdasd',alertDialogContent: null);
                    },
                    child: Padding(
                      padding:  EdgeInsets.symmetric(vertical: 2.0.h),
                      child: Container(
                        width: 37.w,
                        height: 37.h,
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(10.0),
                          border:
                          Border.all(width: 0.5, color: const Color(0xffa4c4f4)),
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
                  Text(demoOrdersList[index].status,
                  style: mainStyle(14.0, FontWeight.w700,color: primaryColor),)

                ],
              )
            ],
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
