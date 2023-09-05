import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../styles_colors/styles_colors.dart';

void logg(String logVal) {
  log(logVal);
}

void logRequestedUrl(String logText) {
  
  log(logText);

  
}

Future<void> navigateTo(BuildContext context, page) async {
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.fade,
      child: page,
      duration: const Duration(milliseconds: 400),
    ),
  );
}

Future<void> navigateToAndFinish(BuildContext context, page) async {
  Navigator.pushReplacement(
    context,
    PageTransition(
      type: PageTransitionType.bottomToTop,
      child: page,
      duration: const Duration(milliseconds: 0),
    ),
  );
}

Future<void> navigateToAndFinishUntil(BuildContext context, page) async {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      ModalRoute.withName("/Home"));
}

Future<void> navigateToWithNavBar(
    BuildContext context, Widget page, routeName) async {
  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
    context,
    settings: RouteSettings(name: routeName),
    screen: page,
    withNavBar: true,
    pageTransitionAnimation: PageTransitionAnimation.fade,
  );
}

Future<void> navigateToWithoutNavBar(
    BuildContext context, Widget page, routeName) async {
  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
    context,
    settings: RouteSettings(name: routeName),
    screen: page,
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.fade,
  );
}

Future<void> defaultAlertDialog(BuildContext context, String title,
    {Widget? alertDialogContent,
    bool? dismissible,
    Color? alertDialogBackColor}) async {
  await showDialog<String>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: dismissible ?? true,
      barrierColor: Colors.white.withOpacity(0),
      
      builder: (BuildContext context) =>
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: AlertDialog(
              backgroundColor: alertDialogBackColor ?? null,
              title: Center(
                  child: Text(
                title,
                style: mainStyle(
                  18.0,
                  FontWeight.w200,
                ),
              )),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0.r))),
              content: alertDialogContent,
            ),
          ));
  
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

String? getErrorMessageFromErrorJsonResponse(dynamic error) {
  if (error.response == null) {
    return 'Check your internet connection';
  } else {
    return (json.decode(error.response.toString())["message"]).toString();
  }
}


Future<void> myAlertDialog(BuildContext context, String title,
    {Widget? alertDialogContent,
      bool? dismissible,
      Color? alertDialogBackColor}) async {
  await showDialog<String>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: dismissible ?? true,
      barrierColor: Colors.white.withOpacity(0),

      builder: (BuildContext context) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: AlertDialog(
                    backgroundColor: alertDialogBackColor ?? null,
                    title: Center(
                        child: Text(
                          title,
                          style: mainStyle(
                            18.0,
                            FontWeight.w200,
                          ),
                        )),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18.0.r))),
                    content: alertDialogContent,
                  ),
                ));

}


bool isUserSignedIn(String? token) {
  if (token != null) {
    return true;
  }
  return false;
}
void pushNewScreenLayout(BuildContext context, page, bool withNavBar) {
  logg('pushNewScreenLayout');
  PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: page,
    withNavBar: withNavBar, 
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
}