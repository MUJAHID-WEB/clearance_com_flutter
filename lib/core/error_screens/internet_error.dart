import 'package:clearance/core/constants/startup_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


import '../../appMainInitial.dart';
import '../../modules/main_layout/main_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main_cubits/cubit_main.dart';
import '../main_cubits/states_main.dart';
import '../main_functions/main_funcs.dart';
import '../styles_colors/styles_colors.dart';

class InternetConnectionError extends StatelessWidget {
  const InternetConnectionError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    var localizationStrings = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/public/Group 324.svg'),
          SizedBox(
            height: 45.h,
          ),
          BlocConsumer<MainCubit, MainStates>(
            listener: (context, state) {
              
            },
            builder: (context, state) {
              return
                
                
                TextButton(
                    onPressed: () {
                      mainCubit.checkConnectivity().then((value) {
                        if (value == true) {
                          logg('true');

                          
                          navigateToAndFinishUntil(context, RouteEngine());
                        } else {
                          logg('error in connection');
                        }
                        return;
                      }); 
                    },
                    child: Text(
                      localizationStrings!.noInternetConnection+'\n'+
                          localizationStrings.tryAgain,
                      style: mainStyle(20.0, FontWeight.w600,
                          color: primaryColor),
                      textAlign: TextAlign.center,
                    ));
            },
          )
        ],
      ),
    );
  }
}
