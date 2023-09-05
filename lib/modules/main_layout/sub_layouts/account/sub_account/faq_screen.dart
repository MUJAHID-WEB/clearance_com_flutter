import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/sub_account/add_new_address.dart';
import '../../../../../core/error_screens/errors_screens.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../../core/styles_colors/styles_colors.dart';
import '../../../../../models/local_models/local_models.dart';
import '../account_shared_widgets/account_shared_widgets.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({Key? key}) : super(key: key);
  static String routeName = 'faqScreenView';

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);

    List<ShortAddress> demoShortAddresses = [
      ShortAddress(id: 1, name: 'test', phone: '0545520188', address: 'dubai'),
      ShortAddress(id: 2, name: 'test', phone: '0545520188', address: 'dubai')
    ];
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(bottom: 0.05.sh),
      child: Column(
        children: [
          SubAccountLayoutsHeader(localizationStrings: localizationStrings),

          Expanded(
            child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 26.0.w, vertical: 10.h),
                child: Column(
                  children: [
                    AccountItemContainer(
                      title: localizationStrings!.addresses,
                      svgPath: 'assets/images/account/Location_Icon.svg',
                    ),
                    Expanded(
                      child: ConditionalBuilder(
                        condition: demoShortAddresses.isNotEmpty,
                        builder: (context) => ListView.separated(
                          itemCount: demoShortAddresses.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) =>
                              
                              
                              SizedBox(
                            height: 100.h,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: 100.w,
                                                child: Text(
                                                 localizationStrings.name,
                                                  style: mainStyle(
                                                      15.0,
                                                      FontWeight.w600,
                                                      ),
                                                )),
                                            Text(
                                              demoShortAddresses[index].name,
                                              style: mainStyle(
                                                  14.0,
                                                  FontWeight.w300,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: 100.w,
                                                child: Text(
                                                  localizationStrings.phone,
                                                  style: mainStyle(
                                                      15.0,
                                                      FontWeight.w600,
                                                      ),
                                                )),
                                            Text(
                                              demoShortAddresses[index].phone,
                                              style: mainStyle(
                                                  14.0,
                                                  FontWeight.w300,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: 100.w,
                                                child: Text(
                                                 localizationStrings.address,
                                                  style: mainStyle(
                                                      15.0,
                                                      FontWeight.w600,
                                                      ),
                                                )),
                                            Text(
                                              demoShortAddresses[index].address,
                                              style: mainStyle(
                                                  14.0,
                                                  FontWeight.w300,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                                Container(
                                  height: 37.h,
                                  width: 37.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        width: 0.5,
                                        color: const Color(0xffa4c4f4)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                        'assets/images/public/icons8_trash_can_1.svg'),
                                  ),
                                ),
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
                    ),
                    DefaultButton(
                        onClick: (){
                          navigateToWithNavBar(
                              context,const AddNewAddress(),AddNewAddress.routeName
                          );
                        },
                        title: localizationStrings.addNewAddress)
                  ],
                )),
          ),
        ],
      ),
    ));
  }
}
