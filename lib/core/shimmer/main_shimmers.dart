import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/shared_widgets/shared_widgets.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/dimensions.dart';

class ShimmerContainerWidget extends StatelessWidget {
  const ShimmerContainerWidget(
      {Key? key, this.height, this.width, this.decoration, this.child})
      : super(key: key);

  final height;
  final width;
  final decoration;
  final child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Color(0xffcccccc).withOpacity(0.5),
        highlightColor: Color(0xfffefefe),
        child: DefaultContainer(
          height: height,
          width: width,
          radius: 5.0,
          borderColor: Colors.transparent,
          backColor: Color(0xffcccccc),
          childWidget: child,
        ));
  }
}

class ScrollableFilterCatShimmer extends StatelessWidget {
  const ScrollableFilterCatShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 56.h,
        ),
        Row(
          children: [
            const SizedBox(
              width: defaultHorizontalPadding * 2.5,
            ),
            ShimmerContainerWidget(
              height: 25.h,
              width: 75.w,
            ),
          ],
        ),
        SizedBox(
          height: 13.4.h,
        ),
        SizedBox(
          height: 91.h,
          child: Center(
            child: Row(
              children: [
                const SizedBox(
                  width: defaultHorizontalPadding * 2.5,
                ),
                Expanded(
                  child: Center(
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        // shrinkWrap: true,
                        itemCount: 6,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) => SizedBox(
                              width: 10.w,
                            ),
                        itemBuilder: (context, index) =>
                            // buildArticleItem(model.data, context),
                            Column(
                              children: [
                                ShimmerContainerWidget(
                                  width: 63.h,
                                  height: 63.h,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                ShimmerContainerWidget(
                                  height: 15.h,
                                  width: 63.h,
                                )
                              ],
                            )),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 7.4.h,
        ),
      ],
    );
  }
}

class GridViewShimmer extends StatelessWidget {
  const GridViewShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      // childAspectRatio: viewType == 'grid' ? ((SizeConfig.screenWidth!>=350)? 7/8:5/7) : 6 / 2,
      childAspectRatio: 9.w / 13.5.w,
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 5.h,
      crossAxisSpacing: 5.w,
      children: List.generate(
          6,
          (index) => Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    const Expanded(child: ShimmerContainerWidget()),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ShimmerContainerWidget(
                              height: 10.h,
                              width: 75.w,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            ShimmerContainerWidget(
                              height: 10.h,
                              width: 35.w,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ShimmerContainerWidget(
                              height: 10.h,
                              width: 25.w,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            ShimmerContainerWidget(
                              height: 10.h,
                              width: 60.w,
                            ),
                          ],
                        ),
                      ],
                    )),
                    //
                  ],
                ),
              ) //getProductObjectAsList
          ),
    );
  }
}

class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          ShimmerContainerWidget(
            height: 246.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          ShimmerContainerWidget(
            height: 25.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          ShimmerContainerWidget(
            height: 5.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          ShimmerContainerWidget(
            height: 10.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          ShimmerContainerWidget(
            height: 25.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          ShimmerContainerWidget(
            height: 10.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          ShimmerContainerWidget(
            height: 246.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          ShimmerContainerWidget(
            height: 25.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          ShimmerContainerWidget(
            height: 5.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          ShimmerContainerWidget(
            height: 246.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          ShimmerContainerWidget(
            height: 25.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          ShimmerContainerWidget(
            height: 5.h,
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}
