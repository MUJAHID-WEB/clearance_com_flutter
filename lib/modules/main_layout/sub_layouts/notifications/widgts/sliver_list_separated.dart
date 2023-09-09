import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

SliverMultiBoxAdaptorWidget sliverListSeparated({
  required final IndexedWidgetBuilder itemBuilder,
  required final Widget separator,
  required int childCount,
  final bool addAutomaticKeepAlives = true,
  final bool addRepaintBoundaries = true,
  final bool addSemanticIndexes = true,
  final ChildIndexGetter? findChildIndexCallback,
  final int semanticIndexOffset = 0,
}) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
        final int itemIndex = index ~/ 2;
        final Widget widget;
        if (index.isEven) {
          widget = itemBuilder(context, itemIndex);
        } else {
          widget = separator;
        }
        return widget;
      },

      childCount: math.max(0, childCount * 2 - 1),
      semanticIndexCallback: (Widget _, int index) {
        return index.isEven ? index ~/ 2 : null;
      },
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries:addRepaintBoundaries ,
      addSemanticIndexes: addSemanticIndexes,
      findChildIndexCallback: findChildIndexCallback,
      semanticIndexOffset: semanticIndexOffset,
    ),
  );
}
