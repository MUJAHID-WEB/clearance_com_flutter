import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle mainStyle(double size, weight,
    {Color? color,TextDecoration? decoration, FontStyle? fontStyle, String? fontFamily,double? textHeight,double? decorationThickness}) {
  return TextStyle(
    fontFamily: fontFamily ?? 'Tajawal',
    fontSize: size.sp,
    fontWeight: weight,
    color: color??Colors.black,
    decoration: decoration,
    fontStyle: fontStyle,
    height:textHeight?? 1.2,
    decorationThickness: decorationThickness
    // wordSpacing: 4.0

  );


}
