import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/main_cubits/cubit_main.dart';
import 'package:clearance/core/styles_colors/styles_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/cache/cache.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../categories/sub_sub_category_layout/sub_sub_category_layout.dart';
import '../../product_details/product_details_layout.dart';

class NotificationItem extends StatelessWidget {
   NotificationItem({Key? key, required this.index}) : super(key: key);

  final int index;
  final List images=[
    'assets/images/basket.svg',
    'assets/images/notification_order.svg',
    'assets/images/favorite.svg',
  ];
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        switch(index) {
          case 0 :
            MainCubit.get(context).navigateToTap(3);
            break;
          case 1 :
            navigateToWithoutNavBar(
                context,
                SubSubCategoryLayout(
                    cateId: "169",
                    token: getCachedToken()),
                SubSubCategoryLayout.routeName);
            break;
          case 2 :
            navigateToWithoutNavBar(
                context,
                const ProductDetailsLayout(
                    productId: "2662"),
                ProductDetailsLayout.routeName);
            break;
        }
        },
      child: Container(
        color: mainBackgroundColor,
        padding: EdgeInsets.symmetric(vertical:  18.h, horizontal: 22.w),
        child: Row(
          children: [
            Container(
                height: 50.h,
                width: 50.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor
                ),
                child: Center(child: SvgPicture.asset(images[index] ,color:index != 1 ? mainBackgroundColor : null,height: 30.h,width: 25.h, ))),
            8.horizontalSpace,
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                       'Your Order',
                      style:mainStyle(14, FontWeight.w400)),
                  Text(
                       'Your order is with the driver',
                      style:mainStyle(14, FontWeight.w400)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                         '12:25 PM',
                        style:mainStyle(14, FontWeight.w400),
                      ),
                      Text(
                         'Today',
                          style:mainStyle(14, FontWeight.w400)
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
