import 'dart:io';

import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/shared_widgets/shared_widgets.dart';
import 'package:clearance/modules/auth_screens/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../styles_colors/styles_colors.dart';

showTopModalSheetErrorMessage(BuildContext context, String message) {
  var localizationStrings = AppLocalizations.of(context);
  showTopModalSheet<String>(
    context,
    Builder(builder: (context) {
      return IntrinsicHeight(
        child: Container(
          margin: EdgeInsets.only(top: 20.h),
          color: Colors.white.withOpacity(0.8),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize:MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).viewPadding.top/2+5.h,
              ),
              Expanded(
                child: Text(
                  message,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: mainStyle(16, FontWeight.w600),
                  maxLines: 10,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: DefaultButton(
                    title: localizationStrings!.ok,
                    onClick: () {
                      Navigator.of(context).pop();
                    },
                    backColor: primaryColor,
                    borderColors: Colors.transparent,
                    titleColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      );
    }),
  );
}

Future<void> buildShowModalBottomSheet(BuildContext context,
    {required Widget body, bool isDismissible = true}) {
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: isDismissible,
    builder: (BuildContext context) {
      return body;
    },
  );
}

showVersionDialog(context) async {
  var localizationStrings = AppLocalizations.of(context);
  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      String title = localizationStrings!.update_app_title;
      String message = localizationStrings.update_app_description;
      String btnLabel = localizationStrings.update_app_button;
      return WillPopScope(
          onWillPop: () => Future.value(false),
          child: Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text(title),
                  content: Text(message),
                  actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 15.0),
                        child: DefaultButton(
                          title: btnLabel,
                          backColor: Colors.transparent,
                          onClick: () => _launchURL(),
                        ),
                      )
                    ])
              : AlertDialog(
                  title: Text(title),
                  content: Text(message),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DefaultButton(
                        title: btnLabel,
                        onClick: () => _launchURL(),
                      ),
                    ),
                  ],
                ));
    },
  );
}

_launchURL() {
  StoreRedirect.redirect(
    androidAppId: 'ae.clearance.app',
    iOSAppId: '1637100307',
  );
}

showTopModalSheetErrorLoginRequired(BuildContext context) {
  var localizationStrings = AppLocalizations.of(context);
  showTopModalSheet<String>(
    context,
    Builder(builder: (context) {
      return Container(
        margin: EdgeInsets.only(top: 20.h),
        color: Colors.white.withOpacity(0.8),
        height: 120.h,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Text(
              localizationStrings!.loginRequired,
              style: mainStyle(16, FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0).copyWith(left: 15,right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4.w,
                    child: DefaultButton(
                      title: localizationStrings.cancel,
                      onClick: () {
                        Navigator.of(context).pop();
                      },
                      backColor: primaryColor,
                      borderColors: Colors.transparent,
                      titleColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4.w,
                    child: DefaultButton(
                      title: localizationStrings.login,
                      onClick: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignInScreen()));
                      },
                      backColor: primaryColor,
                      borderColors: Colors.transparent,
                      titleColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }),
  );
}

void makeToastError({required String message}) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: primaryColor,
    textColor: mainBackgroundColor,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM
  );
}
