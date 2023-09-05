import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/main_cubits/states_main.dart';
import 'package:clearance/core/shared_widgets/shared_widgets.dart';
import 'package:restart_app/restart_app.dart';
import '../../../../../core/cache/cache.dart';
import '../../../../../core/main_cubits/cubit_main.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../l10n/l10n.dart';
import '../account_shared_widgets/account_shared_widgets.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);
  static String routeName = 'settingsView';

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
var mainCubit=MainCubit.get(context);
    return Scaffold(
        appBar: PreferredSize(

          preferredSize: Size.fromHeight(56.0.h),
          child: const DefaultAppBarWithOnlyBackButton(),
        ),
        body: Padding(
      padding: EdgeInsets.only(bottom: 0.02.sh),
      child: Column(
        children: [
          
          Expanded(
            child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 26.0.w, vertical: 10.h),
                child: Column(
                  children: [
                    AccountItemContainer(
                      title: localizationStrings!.setting,
                      svgPath: 'assets/images/account/settings.svg',
                    ),

                    
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 25.h,
                          ),
                          const SettingRow(
                            svgPath:
                                'assets/images/account/icons8_globe_earth.svg',
                            title: 'Country',
                            selectedValue: 'UAE',
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                           GestureDetector(
                             onTap: (){
                               defaultAlertDialog(context,'Language',
                                   dismissible: true,
                                   alertDialogContent: Column(
                                 mainAxisSize: MainAxisSize.min,

                                 children: L10n.all.map((locale) => BlocConsumer<MainCubit,MainStates>(
                                   listener: (context, state) {},
                                   builder: (context,state)=>
                                    Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: GestureDetector(
                                       onTap: (){
                                         logg('ssssss: '+mainCubit.appLocale.toString());
                                         logg(locale.toString());
                                         mainCubit.setLocale(locale,context,false);
                                       },
                                       child: DefaultContainer(
                                           height: 25.h,
                                           backColor: mainCubit.appLocale.toString()==
                                           locale.toString()?primaryColor:Colors.white,
                                           borderColor: primaryColor,
                                           width: double.infinity,
                                           childWidget: Center(child: Text(locale.languageCode))),
                                     ),
                                   ),
                                 )).toList(),
                               ));
                             },
                             child: SettingRow(
                              svgPath:
                                  'assets/images/account/icons8_language.svg',
                              title: 'Language',
                              selectedValue: localizationStrings.language,
                          ),
                           ),
                          SizedBox(
                            height: 25.h,
                          ),
                          const SettingRow(
                            svgPath:
                                'assets/images/account/icons8_drag_gender_neutral.svg',
                            title: 'Gender',
                            selectedValue: 'Male',
                          ),
                          
                          
                          
                          
                          
                          
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultButton(
              title: localizationStrings.resetAppPref,
              titleColor: const Color(0xffE10000),
              borderColors: const Color(0xffE10000),
              onClick: (){
                logg('cache cleared');
                clearAllCache();
                Restart.restartApp(webOrigin: '[your main route]');
              },
            ),
          ),
        ],
      ),
    ));
  }
}

class SettingRow extends StatelessWidget {
  const SettingRow({
    Key? key,
    required this.svgPath,
    required this.title,
    required this.selectedValue,
  }) : super(key: key);

  final String svgPath;
  final String title;
  final String selectedValue;

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 230.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(svgPath),
              SizedBox(
                width: 10.w,
              ),
              Text(title)
            ],
          ),
        ),
        Text('> $selectedValue')
      ],
    );
  }
}
