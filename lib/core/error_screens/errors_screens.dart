import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:clearance/core/styles_colors/styles_colors.dart';

import '../constants/startup_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyError extends StatelessWidget {
  const EmptyError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        // AssetLottie('assets/images/json/empty.json'),
        Lottie.asset('assets/images/json/empty.json',
        height: 100.h),
        SizedBox(height: 5.h,),

        Text(localizationStrings!.emptyList,style: mainStyle(15.0, FontWeight.w700,color:  primaryColor),)
      ],
    );
  }
}


class ImageLoadingError extends StatelessWidget {
  const ImageLoadingError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
      Image.asset(
        'assets/images/public/imageErrorLoading.png',
        // fit: BoxFit.contain,
        // height: 35.h,
      ),
    );
  }
}