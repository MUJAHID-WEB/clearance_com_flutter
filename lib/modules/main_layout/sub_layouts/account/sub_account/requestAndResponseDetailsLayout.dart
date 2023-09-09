
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/constants/startup_settings.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/styles_colors/styles_colors.dart';

class RequestAndResponseDetailsLayout extends StatelessWidget {
  const RequestAndResponseDetailsLayout({Key? key , required this.data}) : super(key: key);
  final Map<String, dynamic> data;
  static String routeName='RequestAndResponseDetailsLayout';
  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultAppBarWithTitleAndBackButton(title: localizationStrings!.request_details),
      ),
      body:Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.all(8.0.sp),
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start ,
                children: [
                  SelectableText.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'URL: ',
                          style: mainStyle(16.0, FontWeight.w700),
                        ),
                        TextSpan(
                          text: data['url']+'\n',
                          style: mainStyle(16.0, FontWeight.w400,
                              color: primaryColor),
                        ),
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Request: ',
                              style: mainStyle(16.0, FontWeight.w700),
                            ),
                            TextSpan(
                              text: data['request']+'\n',
                              style: mainStyle(16.0, FontWeight.w400,
                                  color: primaryColor),
                            ),
                          ],
                        ),

                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Header: ',
                              style: mainStyle(16.0, FontWeight.w700),
                            ),
                            TextSpan(
                              text: data['headers'].toString(),
                              style: mainStyle(16.0, FontWeight.w400,
                                  color: primaryColor),
                            ),
                          ],
                        ),
                        if(data['query']!=null)...{
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'query: ',
                                style: mainStyle(16.0, FontWeight.w700),
                              ),
                              TextSpan(
                                text: data['query'].toString()+'\n',
                                style: mainStyle(16.0, FontWeight.w400,
                                    color: primaryColor),
                              ),
                            ],
                          ),
                        },
                        if(data['body']!=null)...{
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'body: ',
                                style: mainStyle(16.0, FontWeight.w700),
                              ),
                              TextSpan(
                                text: data['body'].toString()+'\n',
                                style: mainStyle(16.0, FontWeight.w400,
                                    color: primaryColor),
                              ),
                            ],
                          ),
                        },
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Response: ',
                              style: mainStyle(16.0, FontWeight.w700),
                            ),
                            TextSpan(
                              text: data['response'].toString(),
                              style: mainStyle(16.0, FontWeight.w400,
                                  color: primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                      toolbarOptions: const ToolbarOptions(copy: true, selectAll: false ,),
                  ),
                  20.verticalSpace
                ],
              ),
            ),
            ),
          Transform.translate(
            offset: Offset(0,-20.h),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15.0.w),
                child: DefaultButton(
                    title: localizationStrings.lbl_share,
                    borderColors: primaryColor,
                    onClick: () async{
                      String text="";
                      data.forEach((key, value) {
                        if(value != null) {
                          text +=
                          (key.toUpperCase() + ': ' + value.toString());
                          text += '\n';
                        }
                      });
                      logg(text);
                      await Share.share(text);
                    }),
              ),
            ),
          ),
        ],
      ),);
  }
}
