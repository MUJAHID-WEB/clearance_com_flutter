import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/constants/startup_settings.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../../core/styles_colors/styles_colors.dart';
import '../account_shared_widgets/account_shared_widgets.dart';

class WalletView extends StatelessWidget {
  const WalletView({Key? key}) : super(key: key);
  static String routeName = 'balanceView';

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);

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
                          title: localizationStrings!.balance,
                          svgPath: 'assets/images/account/Card_icon.svg',
                        ),

                        
                        Expanded(child:
                 Column(
                   children: [
                     SizedBox(height: 25.h,),
                     DefaultContainer(
                       backColor: primaryColor,
                       borderColor: primaryColor,
                       height: 58.h,
                       width: double.infinity,
                       childWidget: Center(child: Text('150.00 AED',
                       style: mainStyle(28.0, FontWeight.w800,
                       color: Colors.white),)),
                     )
                   ],
                 ),

                        ),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}


