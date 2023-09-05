import 'package:flutter/cupertino.dart';

class L10n{

  static final all=[
    const Locale('en'),
    const Locale('ar'),
  ];

  // static String getFlag(String code){
  //
  //
  //   int flagOffset = 0x1F1E6;
  //   int asciiOffset = 0x41;
  //
  //   String country = "US";
  //
  //   int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
  //   int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;
  //
  //   ///
  //   ///
  //   ///
  //
  //   switch(code){
  //     case 'ar':
  //       return "&#127462";
  //     case 'en':
  //       return  String.fromCharCode(secondChar);
  //     default:
  //       return '&#127468 &#127463';
  //
  //   }
  // }
}