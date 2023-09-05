import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/main_cubits/cubit_main.dart';
import 'package:clearance/core/shimmer/main_shimmers.dart';
import 'package:clearance/models/api_models/categories_model.dart';
import 'package:clearance/modules/main_layout/sub_layouts/categories/cubit/states_categories.dart';
import 'package:clearance/modules/main_layout/sub_layouts/categories/sub_sub_category_layout/sub_sub_category_layout.dart';

import '../../../../core/constants/networkConstants.dart';
import '../../../../core/error_screens/errors_screens.dart';
import '../../../../core/main_functions/main_funcs.dart';
import '../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../core/styles_colors/styles_colors.dart';
import '../../../auth_screens/cubit/cubit_auth.dart';
import 'cubit/cubit_categories.dart';

class CategoriesScrollLayout extends StatefulWidget {
  const CategoriesScrollLayout({Key? key}) : super(key: key);

  @override
  State<CategoriesScrollLayout> createState() => _CategoriesScrollLayoutState();
}

class _CategoriesScrollLayoutState extends State<CategoriesScrollLayout> {
  
  

  bool firstRun = true;

  
  
  
  
  
  
  
  
  
  
  
  

  @override
  Widget build(BuildContext context) {
    var categoriesCubit = CategoriesCubit.get(context);
    var mainCubit = MainCubit.get(context);
    if (firstRun) {
      categoriesCubit.loadCategories();
      logg('categories layout first run');
      firstRun = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const SearchAppBar(customCateId: null, isBackButtonEnabled: false),
      ),
      body: BlocConsumer<CategoriesCubit, CategoriesStates>(
        listener: (context, state) {},
        builder: (context, state) => RefreshIndicator(
          color: mainBackgroundColor,
          backgroundColor: primaryColor,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            categoriesCubit.loadCategories();
          },
          child: ConditionalBuilder(
            condition: categoriesCubit.categoriesModel != null,
            builder: (context) => Column(
              children: [
                SizedBox(
                  height: 50.h,
                  child: ListView.builder(
                      shrinkWrap: false,
                      itemCount: categoriesCubit.categoriesModel!.data!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            
                            categoriesCubit.resetCurrentSubIndex();
                            categoriesCubit.changeCurrentMainCatIndex(index);
                          },
                          child: Container(
                              height: 40.h,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color:
                                    categoriesCubit.currentMainCatIndex
                                                .toString() ==
                                            index.toString()
                                        ?
                                    primaryColor
                                        :Colors.transparent
                                        ,
                                    width: 2.h

                                  )
                                ),
                                color:
                                
                                
                                
                                
                                Colors.white
                                    
                                
                                
                                
                                
                                
                                
                                
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Center(
                                  child: Text(
                                    categoriesCubit
                                        .categoriesModel!.data![index].name!,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    style: mainStyle(
                                        15.0,
                                        categoriesCubit.currentMainCatIndex
                                                    .toString() ==
                                                index.toString()
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                        color: Colors.black,
                                        textHeight: 1),
                                  ),
                                ),
                              )

                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              ),
                        );
                      }),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                            decoration: BoxDecoration(
                              color: newSoftGreyColorAux,
                              
                              
                              
                              
                              
                              
                              
                              
                            ),
                            child: ListView.builder(
                                shrinkWrap: false,
                                itemCount: categoriesCubit
                                    .categoriesModel!.data![
                                        categoriesCubit.currentMainCatIndex]
                                    .childes!
                                    .length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      
                                      categoriesCubit
                                          .changeCurrentSubIndex(index);
                                    },
                                    child: Container(
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                          color: categoriesCubit
                                                      .selectedSubIndex
                                                      .toString() ==
                                                  index.toString()
                                              ? Colors.white
                                              : newSoftGreyColorAux,
                                        ),
                                        child: Center(
                                          child: Text(
                                            categoriesCubit
                                                .categoriesModel!.data![
                                                    categoriesCubit
                                                        .currentMainCatIndex]
                                                .childes![index]
                                                .name!,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                            style: mainStyle(
                                                15.0,
                                                categoriesCubit.selectedSubIndex
                                                            .toString() ==
                                                        index.toString()
                                                    ? FontWeight.w700
                                                    : FontWeight.w400,
                                                color: Colors.black,
                                                textHeight: 1),
                                          ),
                                        )),
                                  );
                                })),
                      ),
                      Expanded(
                        flex: 3,
                        child: buildSubCategoryItems(
                            categoriesCubit,
                            categoriesCubit.currentMainCatIndex,
                            categoriesCubit.selectedSubIndex,
                            mainCubit.token),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            fallback: (context) => Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                            decoration: BoxDecoration(
                              color: newSoftGreyColorAux,
                              
                              
                              
                              
                              
                              
                              
                              
                            ),
                            child: ListView.builder(
                                shrinkWrap: false,
                                itemCount: 15,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        color: index == 0
                                            ? Colors.white
                                            : newSoftGreyColorAux,
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                      ),
                                      child: Center(
                                        child: ShimmerContainerWidget(
                                          height: 10.h,
                                          width: 35.h,
                                        ),
                                      ));
                                })),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.count(
                            crossAxisCount: 3,
                            
                            childAspectRatio: 60.w / 100.w,
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 7.h,
                            crossAxisSpacing: 4.w,
                            children: List.generate(
                              15,
                              (subCategoryItemIndex) => Column(
                                children: const [
                                  Expanded(flex: 2, child: SizedBox()),
                                  Expanded(
                                      flex: 5, child: ShimmerContainerWidget()),
                                  Expanded(flex: 1, child: SizedBox()),
                                ],
                              ), 
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSubCategoryItems(CategoriesCubit categoriesCubit,
      int mainCategoryIndex, int subIndex, String? token) {

    final scrollController = ScrollController();
    WidgetsFlutterBinding.ensureInitialized();
    return ConditionalBuilder(
      condition: categoriesCubit.categoriesModel!.data![mainCategoryIndex].childes!=null,
      builder:(context) {
      if(  categoriesCubit.categoriesModel!.data![mainCategoryIndex].childes!.isNotEmpty) {
          CategoryItemModel subSubCategoryList = categoriesCubit
              .categoriesModel!.data![mainCategoryIndex].childes![subIndex];
          return GridView.count(
            crossAxisCount: 3,
            controller: scrollController,
            
            childAspectRatio: 60.w / 90.w,
            padding: EdgeInsets.all(5.sp),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            mainAxisSpacing: 7.h,
            crossAxisSpacing: 6.w,
            children: List.generate(
                subSubCategoryList.childes!.length,
                (subCategoryItemIndex) => SubCategoryItem(
                      categoryItem:
                          subSubCategoryList.childes![subCategoryItemIndex],
                      token: token,
                    ) 
                ),
          );
        }
      else {
        return const EmptyError();
      }
      },
      fallback: (context)=>const EmptyError(),
    );
  }
}

class SubCategoryItem extends StatelessWidget {
  const SubCategoryItem({
    Key? key,
    required this.categoryItem,
    required this.token,
  }) : super(key: key);
  final CategoryItemModel categoryItem;
  final String? token;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        logg('save event');
        await FirebaseAnalytics.instance.logEvent(name: 'enter_category',parameters:{
          'id':AuthCubit.get(context).userInfoModel!.data!.id,
          'category_id':categoryItem.id,
          'category_name':categoryItem.name,
          'server':baseLink.contains('www') ? 'production':'staging',
          'server_url':baseLink
        });
        navigateToWithoutNavBar(
            context,
            SubSubCategoryLayout(
                cateId: categoryItem.id!.toString(), token: token),
            SubSubCategoryLayout.routeName);
      },
      child: DefaultContainer(
        withoutRadius: true,
        
        borderColor: Colors.transparent,
        childWidget: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: DefaultImage(
                    placeholderScale: 15,
                    withoutRadius: true,
                    backGroundImageUrl: categoryItem.icon,
                    borderColor: Colors.transparent,
                  ),
                )),

            
          ],
        ),
      ),
    );
  }
}
