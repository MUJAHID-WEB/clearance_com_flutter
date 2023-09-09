import 'package:clearance/core/shared_widgets/shared_widgets.dart';
import 'package:clearance/modules/main_layout/sub_layouts/notifications/widgts/notification_item.dart';
import 'package:clearance/modules/main_layout/sub_layouts/notifications/widgts/sliver_list_separated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/styles_colors/styles_colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: DefaultAppBarWithTitleAndBackButton(
            title: localizationStrings!.lbl_notification,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  return CustomScrollView(
                    slivers: [
                      sliverListSeparated(
                        itemBuilder: (_, index) =>
                            NotificationItem(index: index),
                        separator: Divider(
                          height: 0,
                          indent: 30.w,
                          endIndent: 30.w,
                        ),
                        childCount: 3,
                      )
                    ],
                  );
                },
              ),
            ),
            18.verticalSpace,
          ],
        ));
  }
}
