import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

// import 'package:image_picker/image_picker.dart';
import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/models/api_models/orders-model.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/cubit/account_cubit.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cart_screen.dart';
import '../../../../../core/error_screens/errors_screens.dart';
import '../../../../../core/error_screens/show_error_message.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../../core/styles_colors/styles_colors.dart';
import '../../../../../models/local_models/account_items_model.dart';
import '../../../../../models/local_models/local_models.dart';
import '../account_shared_widgets/account_shared_widgets.dart';
import '../cubit/account_state.dart';

class MyOrdersView extends StatefulWidget {
  const MyOrdersView({Key? key}) : super(key: key);
  static String routeName = 'myOrdersView';

  @override
  State<MyOrdersView> createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // // TODO: implement initState
    // logg(widget.selectedTabId.toString());
    // _tabController = TabController(
    //     length: 5, vsync: this, initialIndex: widget.selectedTabId); //changed
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var accountCubit = AccountCubit.get(context)
      ..changeCurrentOrderDetailsViewId('0');
      accountCubit.getOrders();

    List<AccountItemsModel> ordersMainItems = [
      AccountItemsModel(
          id: 0,
          apiOrderStatus: 'pending',
          svgImagePath: 'assets/images/account/my_orders/confirming.svg',
          title: localizationStrings!.pending),
      AccountItemsModel(
          id: 1,
          apiOrderStatus: 'confirmed',
          svgImagePath: 'assets/images/account/my_orders/preparing.svg',
          title: localizationStrings.confirmed),
      AccountItemsModel(
          id: 2,
          apiOrderStatus: 'processing',
          svgImagePath: 'assets/images/public/add_to_cart.svg',
          title: localizationStrings.preparing),
      AccountItemsModel(
          id: 3,
          apiOrderStatus: 'delivered',
          svgImagePath: 'assets/images/account/my_orders/shipped.svg',
          title: localizationStrings.delivered),
      AccountItemsModel(
          id: 4,
          apiOrderStatus: 'returned',
          svgImagePath: 'assets/images/account/my_orders/refund.svg',
          title: localizationStrings.returned),
    ];

    // List<OrdersListModel> ordersList = [
    //   OrdersListModel(
    //     id: 1,
    //     title: 'نظارات شمسية',
    //     imagePath: 'url',
    //     color: 'أسود',
    //     quantity: '2',
    //     price: '180 درهم',
    //   ),
    //   OrdersListModel(
    //     id: 2,
    //     title: 'مصفف الشعر',
    //     imagePath: 'url',
    //     color: 'أسود',
    //     quantity: '1',
    //     price: '100 درهم',
    //   ),
    //   OrdersListModel(
    //     id: 3,
    //     title: 'قفاذات اليدين',
    //     imagePath: 'url',
    //     color: 'أسود',
    //     quantity: '5',
    //     price: '300 درهم',
    //   ),
    // ];

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: const DefaultAppBarWithOnlyBackButton(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: AccountItemContainer(
                  title: localizationStrings.orders,
                  svgPath: 'assets/images/account/List order_Icon.svg',
                ),
              ),
              Expanded(
                child: BlocConsumer<AccountCubit, AccountStates>(
                  listener: (context, state) {
                    if (state is ErrorLoadingDataState) {
                      showTopModalSheetErrorMessage(
                          context, localizationStrings.something_went_wrong);
                    }
                  },
                  builder: (context, state) {
                      if (state is ErrorLoadingDataState) {
                        return Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.refresh,
                              color: primaryColor,
                            ),
                            onPressed: (){
                              accountCubit..changeCurrentOrderDetailsViewId('0')..getOrders();
                            },
                          ),
                        );
                      }
                      if(state is LoadingOrdersState){
                        return Center(
                            child: DefaultLoader(
                              customHeight: 0.1.sh,
                            ));
                      }
                      return SingleChildScrollView(
                        child: OrdersListView(
                            ordersList: accountCubit.ordersModel!.data!
                            // !.where((element) => element.orderStatus=='test').toList()
                            ,
                            //send filtered content
                            localizationStrings: localizationStrings),
                      );
                      // if (accountCubit.currentOrderList == null) {
                      //   accountCubit.applyOrdersListFilter(
                      //       ordersMainItems[widget.selectedTabId].apiOrderStatus);
                      // }
                      //
                      // return Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: defaultHorizontalPadding * 1.2,
                      //   ),
                      //   child: DefaultTabController(
                      //     length: ordersMainItems.length,
                      //     child: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: <Widget>[
                      //         DefaultContainer(
                      //           backColor: Colors.white,
                      //           borderColor: mainRedColorAux,
                      //           height: 60.w,
                      //           width: 1.sw,
                      //           childWidget: TabBar(
                      //               onTap: (index) {
                      //                 accountCubit.applyOrdersListFilter(
                      //                     ordersMainItems[index].apiOrderStatus);
                      //               },
                      //               controller: _tabController,
                      //
                      //               isScrollable: true,
                      //               indicatorColor: mainRedColorAux,
                      //               // labelPadding:
                      //               //     EdgeInsets.symmetric(horizontal: 8.0.w),
                      //               tabs: ordersMainItems
                      //                   .map((e) => OrderTab(
                      //                         svgAssetLink: e.svgImagePath,
                      //                         title: e.title,
                      //                       ))
                      //                   .toList()
                      //               //
                      //               // [
                      //               //   OrderTab(),
                      //               //   Tab(
                      //               //       child: Text(
                      //               //     'Shipping',
                      //               //     style: mainStyle(
                      //               //       14.0,
                      //               //       FontWeight.w600,
                      //               //     ),
                      //               //   )),
                      //               //   Tab(
                      //               //       child: Text(
                      //               //     'Delivered',
                      //               //     style: mainStyle(
                      //               //       14.0,
                      //               //       FontWeight.w600,
                      //               //     ),
                      //               //   )),
                      //               // ],
                      //               ),
                      //         ),
                      //         Expanded(
                      //           child: TabBarView(
                      //               children: ordersMainItems.map((e) {
                      //             return OrdersListView(
                      //                 ordersList: accountCubit.currentOrderList!
                      //                 // !.where((element) => element.orderStatus=='test').toList()
                      //
                      //                 ,
                      //                 //send filtered content
                      //                 localizationStrings: localizationStrings);
                      //           }).toList()
                      //               // [
                      //               //   OrdersListView(
                      //               //       demoOrdersList: ordersList,
                      //               //       localizationStrings: localizationStrings),
                      //               //   OrdersListView(
                      //               //       demoOrdersList: ordersList,
                      //               //       localizationStrings: localizationStrings),
                      //               //   OrdersListView(
                      //               //       demoOrdersList: ordersList,
                      //               //       localizationStrings: localizationStrings),
                      //               // ]
                      //               ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                ),
            ],
          ),
        ));
  }
}

class OrderTab extends StatelessWidget {
  const OrderTab({
    Key? key,
    required this.svgAssetLink,
    required this.title,
  }) : super(key: key);

  final String svgAssetLink;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      child: Tab(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: CircleAvatar(
              radius: 50.w,
              backgroundColor: mainCatGreyColor.withOpacity(0.5),
              child: SvgPicture.asset(
                svgAssetLink,
              ),
            ),
          ),
          Text(
            title,
            maxLines: 1,
            style: mainStyle(
              12.0,
              FontWeight.w400,
            ),
          ),
        ],
      )),
    );
  }
}

class OrdersListView extends StatelessWidget {
  const OrdersListView({
    Key? key,
    required this.ordersList,
    required this.localizationStrings,
  }) : super(key: key);

  final List<OrderItemModel> ordersList;
  final AppLocalizations? localizationStrings;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var accountCubit = AccountCubit.get(context);
    List<OrderItemModel>? ordersList = accountCubit.ordersModel!.data;

    List<AccountItemsModel> ordersMainItems = [
      AccountItemsModel(
          id: 0,
          apiOrderStatus: 'pending',
          svgImagePath: 'assets/images/account/my_orders/confirming.svg',
          title: localizationStrings!.pending),
      AccountItemsModel(
          id: 1,
          apiOrderStatus: 'confirmed',
          svgImagePath: 'assets/images/account/my_orders/preparing.svg',
          title: localizationStrings.confirmed),
      AccountItemsModel(
          id: 2,
          apiOrderStatus: 'processing',
          svgImagePath: 'assets/images/public/add_to_cart.svg',
          title: localizationStrings.preparing),
      AccountItemsModel(
          id: 3,
          apiOrderStatus: 'delivered',
          svgImagePath: 'assets/images/account/my_orders/shipped.svg',
          title: localizationStrings.delivered),
      // AccountItemsModel(
      //     id: 4,
      //     apiOrderStatus: 'returned',
      //     svgImagePath: 'assets/images/account/my_orders/refund.svg',
      //     title: localizationStrings.returned),
    ];
    return BlocConsumer<AccountCubit, AccountStates>(
      listener: (context, state) {},
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ConditionalBuilder(
          condition: ordersList!.isNotEmpty,
          builder: (context) => ListView.separated(
            itemCount: ordersList.length,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => Container(
              color: index.isOdd ? Colors.grey.withOpacity(0.1) : Colors.white,
              child: Row(
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    // width: 180.w,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            Text(
                              localizationStrings.orderSummary,
                              style: mainStyle(16.0, FontWeight.w600),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            TableTwoValues(
                                mainKey: localizationStrings.orderAmount,
                                value:
                                    ordersList[index].orderAmount?.toString() ??
                                        '--'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                   Expanded(
                                     child: TableTwoValues(
                                        mainKey: localizationStrings.orderUniqueId,
                                        value:
                                            ordersList[index].orderGroupId ?? '--'),
                                   ),
                                SizedBox(width: 3.w,),
                                IconButton(
                                  color: Colors.transparent,
                                  onPressed: () {
                                    if (ordersList != null) {
                                      Clipboard.setData(ClipboardData(
                                          text: ordersList[index].orderGroupId ?? ""));
                                      makeToastError(
                                          message: localizationStrings?.lbl_copy ?? "");
                                    }
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    color: primaryColor,
                                    size: 15.w,
                                  ),
                                ),
                                // IconButton(
                                //   color: Colors.transparent,
                                //   onPressed: () {
                                //     Clipboard.setData(ClipboardData(
                                //         text: ordersList[index].orderGroupId));
                                //     makeToastError(
                                //         message: localizationStrings.lbl_copy);
                                //   },
                                //   icon: Icon(
                                //     Icons.copy,
                                //     color: primaryColor,
                                //     size: 15.w,
                                //   ),
                                // ),
                              ],
                            ),
                            // TableTwoValues(
                            //     mainKey: localizationStrings.paymentMethod2,
                            //     value: ordersList[index].paymentMethod ?? '--'),
                            // TableTwoValues(
                            //     mainKey: localizationStrings.paymentStatus,
                            //     value: ordersList[index].paymentStatus ?? '--'),
                            // TableTwoValues(
                            //     mainKey: 'Discount amount:',
                            //     value: ordersList[index]
                            //             .discountAmount
                            //             ?.toString() ??
                            //         '--'),
                            // TableTwoValues(
                            //     mainKey: 'Shipping cost:',
                            //     value:
                            //         ordersList[index].shippingCost?.toString() ??
                            //             '--'),

                            ordersList[index].id.toString() ==
                                    accountCubit.currentOrderDetailsViewId
                                ? Column(
                                    //view details
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // shipping addresses
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 28.0),
                                        child: Divider(
                                          color: primaryColor,
                                        ),
                                      ),
                                      ConditionalBuilder(
                                        condition: ordersList[index]
                                                .shippingAddressData !=
                                            null,
                                        builder: (context) => Column(
                                          children: [
                                            Text(
                                              localizationStrings
                                                  .shippingDetails,
                                              style: mainStyle(
                                                  16.0, FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            TableTwoValues(
                                                mainKey: localizationStrings
                                                    .shippingContact,
                                                value: ordersList[index]
                                                        .shippingAddressData!
                                                        .contactPersonName ??
                                                    '--'),
                                            TableTwoValues(
                                                mainKey: localizationStrings
                                                    .shippingAddress,
                                                value: ordersList[index]
                                                        .shippingAddressData!
                                                        .address ??
                                                    '--'),
                                            TableTwoValues(
                                                mainKey: localizationStrings
                                                    .shippingContactNum,
                                                value: ordersList[index]
                                                        .shippingAddressData!
                                                        .phone ??
                                                    '--'),
                                          ],
                                        ),
                                        fallback: (context) => SizedBox(),
                                      ),

                                      // end shipping addresses

                                      // order products
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 28.0),
                                        child: Divider(
                                          color: primaryColor,
                                        ),
                                      ),

                                      Text(
                                        localizationStrings.shippingOrdered,
                                        style: mainStyle(16.0, FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      ListView.separated(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context,
                                                  innerIndex) =>
                                              OrderProductItem(
                                                  isAvailableToEvaluate:
                                                      ordersList[index]
                                                              .orderStatus ==
                                                          'delivered',
                                                  orderProductDetail:
                                                      ordersList[index]
                                                              .details![
                                                          innerIndex]),
                                          separatorBuilder:
                                              (context, innerIndex) =>
                                                  Divider(),
                                          itemCount: ordersList[index]
                                              .details!
                                              .length),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 28.0),
                                        child: Divider(
                                          color: primaryColor,
                                        ),
                                      ),

                                      // ListView.separated(
                                      //   itemBuilder: itemBuilder,
                                      //   separatorBuilder: separatorBuilder,
                                      //   itemCount: itemCount,
                                      // )
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),

                        // Row(
                        //   children: [
                        //     Text(ordersList[index].orderStatus.toString()),
                        //     // Text(ordersMainItems[index]
                        //     //     .apiOrderStatus
                        //     //     .toString()),
                        //   ],
                        // ),
                        DefaultContainer(
                          height: 60.w,
                          borderColor: Colors.transparent,
                          childWidget: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0.w, vertical: 3.h),
                            child: Center(
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                // shrinkWrap: true,
                                itemCount: ordersMainItems.length,
                                scrollDirection: Axis.horizontal,

                                separatorBuilder: (context, index) => Center(
                                  child: SizedBox(
                                    width: 18.w,
                                    child: Center(
                                      child: Text(
                                        '-->',
                                        style: mainStyle(16.0, FontWeight.w900,
                                            color: primaryColor),
                                      ),
                                    ),
                                  ),
                                ),

                                itemBuilder: (context, innerIndex) =>
                                    // buildArticleItem(model.data, context),
                                    GestureDetector(
                                        onTap: () {
                                          // navigateToWithNavBar(
                                          //     context,
                                          //     MyOrdersView(
                                          //         selectedTabId:
                                          //         ordersMainItems[index]
                                          //             .id),
                                          //     MyOrdersView.routeName);
                                        },
                                        child: NewOrderTab(
                                            svgAssetLink:
                                                ordersMainItems[innerIndex]
                                                    .svgImagePath,
                                            title: ordersMainItems[innerIndex]
                                                .title,
                                            isSelected:
                                                ordersMainItems[innerIndex]
                                                        .apiOrderStatus
                                                        .toString() ==
                                                    ordersList[index]
                                                        .orderStatus
                                                        .toString())
                                        // MainAccountHeaderItem(
                                        //   title: ordersMainItems[index].title,
                                        //   imagePath: ordersMainItems[index].svgImagePath,
                                        // ),
                                        ),
                              ),
                            ),
                          ),
                        ),
                        ordersList[index].orderStatus == 'canceled'
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(localizationStrings
                                    .order_cancelled_by_seller),
                              )
                            : const SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  if (ordersList[index].id.toString() !=
                                      accountCubit.currentOrderDetailsViewId) {
                                    accountCubit
                                        .changeCurrentOrderDetailsViewId(
                                            ordersList[index].id.toString());
                                  } else {
                                    logg('er log');
                                    accountCubit
                                        .changeCurrentOrderDetailsViewId('0');
                                  }
                                },
                                child: Text(
                                  ordersList[index].id.toString() !=
                                          accountCubit.currentOrderDetailsViewId
                                      ? localizationStrings.viewDetails
                                      : localizationStrings.hideDetails,
                                  style: mainStyle(16.0, FontWeight.w600,
                                      color: ordersList[index].id.toString() !=
                                              accountCubit
                                                  .currentOrderDetailsViewId
                                          ? primaryColor
                                          : Colors.red),
                                )),
                            // TextButton(
                            //     onPressed: () {
                            //       accountCubit
                            //           .changeCurrentOrderDetailsViewId('0');
                            //     },
                            //     child: Text('Hide details')),
                            ordersList[index].orderStatus == 'pending'
                                ? TextButton(
                                    onPressed: () {
                                      myAlertDialog(context, 'Cancel order',
                                          alertDialogContent: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 25.h,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          accountCubit
                                                              .cancelOrder(
                                                                  ordersList[
                                                                          index]
                                                                      .id
                                                                      .toString())
                                                              .then((value) =>
                                                                  Navigator.pop(
                                                                      context));
                                                        },
                                                        child: DefaultContainer(
                                                          height: 50.h,
                                                          borderColor:
                                                              Colors.red,
                                                          childWidget: Center(
                                                            child: Text('Yes'),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: DefaultContainer(
                                                          borderColor:
                                                              Colors.green,
                                                          height: 50.h,
                                                          childWidget: Center(
                                                            child: Text('No'),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ));
                                    },
                                    child: Text(
                                      localizationStrings.cancelOrder,
                                      style: mainStyle(16.0, FontWeight.w600,
                                          color: primaryColor),
                                    ))
                                : SizedBox(),

                            ordersList[index].orderStatus == 'delivered'
                                ? TextButton(
                                    onPressed: () {
                                      myAlertDialog(context, 'In progress',
                                          alertDialogContent: null);
                                    },
                                    child: DefaultContainer(
                                      borderColor: Colors.grey.withOpacity(0.5),
                                      childWidget: Padding(
                                        padding: EdgeInsets.all(6.0.sp),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              localizationStrings.returnRequest,
                                              style: mainStyle(
                                                  16.0, FontWeight.w600,
                                                  color: primaryColor),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            SvgPicture.asset(
                                                'assets/images/public/Group 306.svg')
                                          ],
                                        ),
                                      ),
                                    ))
                                : const SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                ],
              ),
            ),
            //
            //
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) => SizedBox(
              height: 0.h,
            ),
          ),
          fallback: (context) => const EmptyError(),
        ),
      ),
    );
  }
}

class NewOrderTab extends StatelessWidget {
  const NewOrderTab({
    Key? key,
    required this.svgAssetLink,
    required this.title,
    required this.isSelected,
  }) : super(key: key);

  final String svgAssetLink;
  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      child: DefaultContainer(
        borderColor: isSelected ? primaryColor : Colors.transparent,
        backColor:
            isSelected ? primaryColor.withOpacity(0.03) : Colors.transparent,
        childWidget: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              svgAssetLink,
            ),
            Text(
              title,
              maxLines: 1,
              style: mainStyle(
                12.0,
                FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderProductItem extends StatelessWidget {
  const OrderProductItem(
      {Key? key,
      required this.orderProductDetail,
      required this.isAvailableToEvaluate})
      : super(key: key);
  final OrderDetail orderProductDetail;

  final bool isAvailableToEvaluate;

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var commentController = TextEditingController();
    return Column(
      children: [
        Row(
          children: [
            // SizedBox(
            //   width: 10.w,
            // ),
            Expanded(
              // width: 180.w,
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderProductDetail.productDetails!.name.toString(),
                      style: mainStyle(14.0, FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      orderProductDetail.variant!,
                      style: mainStyle(14.0, FontWeight.w200),
                    ),
/*
                          to view variant details key + value
                          if (variations != null)

                            SizedBox(
                              height: 30.h,
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: variations.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(0.0),
                                  itemBuilder: (context, index) => Row(
                                        children: [
                                          // Text(variations!.keys.toList()[index].toString()+': ',
                                          // style: mainStyle(14.0, FontWeight.w600),),
                                          // const Text(': '),

                                          Text(variations!.values.toList()[index].toString(),
                                          style: mainStyle(14.0, FontWeight.w400),),
                                        ],
                                      ), separatorBuilder: (BuildContext context, int index) {
                                    return Text('_'); },),
                            ),
*/

                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Text(
                          localizationStrings!.price + ': '.toString(),
                          style: mainStyle(14.0, FontWeight.w600),
                        ),
                        Text(
                          orderProductDetail.productDetails!.price.toString(),
                          textAlign: TextAlign.center,
                          style: mainStyle(14.0, FontWeight.w600,
                              fontFamily: 'poppins',
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          orderProductDetail.productDetails!.offerPrice
                              .toString(),
                          style: mainStyle(14.0, FontWeight.w600,
                              fontFamily: 'poppins'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    // Text(
                    //   '  localizationStrings.soldBy' +
                    //       '0',
                    //   style: mainStyle(14.0, FontWeight.w200),
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            DefaultImage(
              backGroundImageUrl: orderProductDetail.productDetails!.thumbnail,
              width: 80.w,
              height: 90.w,
              borderColor: Colors.transparent,
            ),
          ],
        ),
        isAvailableToEvaluate
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        var accountCubit = AccountCubit.get(context);
                        accountCubit.resetSelectedImages();
                        accountCubit.setCurrentEvaluatingProductId(
                            orderProductDetail.productDetails!.id.toString());
                        // final ImagePicker imagePicker=ImagePicker();
                        defaultAlertDialog(context, 'Add your review',
                            alertDialogContent:
                                BlocConsumer<AccountCubit, AccountStates>(
                              listener: (context, state) {},
                              builder: (context, state) =>
                                  SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    RatingBar.builder(
                                      initialRating: 3,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        accountCubit.setNewRating(rating);
                                      },
                                    ),
                                    SizedBox(
                                      height: 25.h,
                                    ),
                                    DefaultContainer(
                                        height: 120.h,
                                        borderColor:
                                            primaryColor.withOpacity(0.5),
                                        childWidget: TextFormField(
                                          controller: commentController,
                                          style:
                                              mainStyle(16.0, FontWeight.w300),
                                          obscureText: false,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.all(10.h),
                                            // icon: Icon(Icons.send),
                                            hintText:
                                                'We are looking to hearing from you..',

                                            hintStyle: mainStyle(
                                                14.0, FontWeight.w300),
                                            // helperText: 'Helper Text',
                                            // counterText: '0 characters',
                                            border: InputBorder.none,
                                          ),
                                        )),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    // ConditionalBuilder(
                                    //   condition:
                                    //       accountCubit.imageFiles!.isNotEmpty,
                                    //   builder: (context) => SizedBox(
                                    //     // color: Colors.grey.withOpacity(0.5),
                                    //     height: 120.w,
                                    //     width: 200.w,
                                    //     child: ListView.separated(
                                    //       physics: BouncingScrollPhysics(),
                                    //       itemCount:
                                    //           accountCubit.imageFiles!.length,
                                    //       scrollDirection: Axis.horizontal,
                                    //       shrinkWrap: true,
                                    //       itemBuilder: (context, index) =>
                                    //           Column(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.spaceEvenly,
                                    //         children: [
                                    //           DefaultContainer(
                                    //             height: 90.w,
                                    //             width: 90.w,
                                    //             borderColor: Colors.transparent,
                                    //             childWidget: Image.file(
                                    //                 File(accountCubit
                                    //                     .imageFiles![index]
                                    //                     .path),
                                    //                 fit: BoxFit.cover),
                                    //           ),
                                    //           GestureDetector(
                                    //             onTap: () {
                                    //               accountCubit.removePic(index);
                                    //             },
                                    //             child: DefaultContainer(
                                    //               borderColor:
                                    //                   Colors.transparent,
                                    //               height: 25.h,
                                    //               childWidget: Row(
                                    //                 mainAxisAlignment:
                                    //                     MainAxisAlignment
                                    //                         .spaceEvenly,
                                    //                 crossAxisAlignment:
                                    //                     CrossAxisAlignment.end,
                                    //                 children: [
                                    //                   Icon(
                                    //                     Icons.delete,
                                    //                     color: Colors.red,
                                    //                   ),
                                    //                   Text(
                                    //                     'Remove',
                                    //                     style: mainStyle(14.0,
                                    //                         FontWeight.w200),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //           )
                                    //         ],
                                    //       ),
                                    //       separatorBuilder: (context, index) =>
                                    //           SizedBox(),
                                    //     ),
                                    //   ),
                                    //   fallback: (_) => const SizedBox(),
                                    // ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        accountCubit.openImages();
                                      },
                                      child: DefaultContainer(
                                        borderColor:
                                            primaryColor.withOpacity(0.5),
                                        height: 35.h,
                                        childWidget: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Upload pictures',
                                              style: mainStyle(
                                                  12.0, FontWeight.w400),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            SvgPicture.asset(
                                                'assets/images/public/icons8_upload_to_cloud.svg')
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    DefaultButton(
                                        onClick: () {
                                          accountCubit.sendAndSaveReview(
                                              commentController.text);
                                        },
                                        title: 'Save review',
                                        backColor: primaryColor,
                                        borderColors: Colors.transparent,
                                        customHeight: 35.h,
                                        titleColor: Colors.white),
                                    // RatingBarIndicator(
                                    //   rating: 4.0,
                                    //   itemBuilder: (context, index) => Icon(
                                    //     Icons.star,
                                    //     color: mainGreenColor,
                                    //   ),
                                    //   itemCount: 5,
                                    //   itemSize: 20.0.sp,
                                    //   direction: Axis.horizontal,
                                    // )
                                  ],
                                ),
                              ),
                            ));
                      },
                      child: Text(
                        'Add your review for this product',
                        style: mainStyle(14.0, FontWeight.w600,
                            color: primaryColor),
                      ))
                ],
              )
            : SizedBox()
      ],
    );
  }
}
