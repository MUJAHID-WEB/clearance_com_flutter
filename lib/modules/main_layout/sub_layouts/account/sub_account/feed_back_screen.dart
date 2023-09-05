import 'package:clearance/modules/main_layout/sub_layouts/account/account_shared_widgets/account_shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/cache/cache.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/constants/startup_settings.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../../core/styles_colors/styles_colors.dart';

class FeedBackScreen extends StatelessWidget {
  FeedBackScreen({Key? key}) : super(key: key);
  static String routeName = 'FeedBackScreen';
  List<Map<String, dynamic>> data = getRequestsData();
  List<Map<String, dynamic>> searchedData = [];
  ValueNotifier<bool> rebuild = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    searchedData.addAll(data);
    var localizationStrings = AppLocalizations.of(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: SearchRequestsAppBar(
            onSearch: (String searchText) {
              if (searchText.isEmpty) {
                searchedData.addAll(data);
                rebuild.value = !rebuild.value;
                return;
              }
              searchedData.clear();
              for (var element in data) {
                String text = "";
                element.forEach((key, value) {
                  if (value != null) {
                    text +=
                        (key.toLowerCase() + value.toString().toLowerCase());
                  }
                });
                if (text.trim().contains(searchText.toLowerCase())) {
                  searchedData.add(element);
                }
              }
              rebuild.value = !rebuild.value;
            },
          )),
      body: Stack(
        children: [
          ValueListenableBuilder<bool>(
              valueListenable: rebuild,
              builder: (context, rebuildValue, _) {
                return ListView.separated(
                  padding: const EdgeInsets.all(0),
                  itemCount: searchedData.length,
                  itemBuilder: (context, index) => Stack(
                    children: [
                      RequestAndResponseCard(
                        data: searchedData[index],
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: InkWell(
                          onTap: () {
                            removeRequestFromCache(searchedData[index]);
                            searchedData.remove(searchedData[index]);
                            rebuild.value = !rebuild.value;
                          },
                          child: Transform.translate(
                            offset: Offset(-10.w, 0),
                            child: SizedBox(
                              width: 25.w,
                              height: 25.w,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: primaryColor, shape: BoxShape.circle),
                                child: Center(
                                  child: Text('X',
                                      style: mainStyle(14.w, FontWeight.bold,
                                          fontFamily: 'poppins',
                                          color: mainBackgroundColor)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 11.h,
                  ),
                );
              }),
          Transform.translate(
            offset: Offset(0,-20.h),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15.0.w),
                child: DefaultButton(
                    title: localizationStrings!.lbl_clearAll,
                    borderColors: primaryColor,
                    onClick: () {
                      clearAllRequests();
                      searchedData.clear();
                      rebuild.value = !rebuild.value;
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
