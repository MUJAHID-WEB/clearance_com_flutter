import 'package:clearance/core/cache/cache.dart';
import 'package:clearance/modules/main_layout/sub_layouts/main_payment/cubit/cubit_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/main_cubits/cubit_main.dart';
import 'package:clearance/core/main_cubits/states_main.dart';
import 'package:clearance/models/api_models/addresses_model.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/sub_account/add_new_address.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cart_screen.dart';
import '../../../../../core/error_screens/errors_screens.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../../core/styles_colors/styles_colors.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../account_shared_widgets/account_shared_widgets.dart';

class AddressesView extends StatelessWidget {
  const AddressesView({Key? key}) : super(key: key);
  static String routeName = 'addressesView';

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var mainCubit = MainCubit.get(context);
    
    if(mainCubit.addressesModel==null){
      mainCubit.getAddresses();
    }
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: const DefaultAppBarWithOnlyBackButton(),
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: 0.05.sh),
          child: BlocConsumer<MainCubit, MainStates>(
            listener: (context, state) {},
            builder: (context, state) => Column(
              children: [
                
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 26.0.w, vertical: 10.h),
                      child: Column(
                        children: [
                          AccountItemContainer(
                            title: localizationStrings!.addresses,
                            svgPath: 'assets/images/account/Location_Icon.svg',
                          ),
                          ConditionalBuilder(
                            condition: mainCubit.addressesModel != null,
                            builder: (context) {
                              List<Address> addresses =
                                  mainCubit.addressesModel!.data!;
                              return addresses.isNotEmpty
                                  ? Expanded(
                                      child: ConditionalBuilder(
                                        condition: mainCubit
                                            .addressesModel!.data!.isNotEmpty,
                                        builder: (context) =>
                                            SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              ListView.separated(
                                                itemCount: addresses.length,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) =>
                                                    AddressItem(
                                                        notInAddressListJustForView:
                                                            false,
                                                        inBottomModalSheet:
                                                            false,
                                                        localizationStrings:
                                                            localizationStrings,
                                                        address:
                                                            addresses[index]),
                                                
                                                
                                                scrollDirection: Axis.vertical,
                                                separatorBuilder:
                                                    (context, index) =>
                                                        Container(
                                                  color: Colors.grey,
                                                  height: 1.h,
                                                ),
                                              ),
                                              Container(
                                                height: 1.h,
                                                color: Colors.grey,
                                              )
                                            ],
                                          ),
                                        ),
                                        fallback: (context) =>
                                            const EmptyError(),
                                      ),
                                    )
                                  : const EmptyError();
                            },
                            fallback: (_) => DefaultLoader(),
                          ),
                          state is RemovingAddressState
                              ? const LinearProgressIndicator()
                              : const SizedBox.shrink(),
                          DefaultButton(
                              onClick: () {
                                navigateToWithNavBar(
                                    context,
                                    const AddNewAddress(),
                                    AddNewAddress.routeName);
                              },
                              title: localizationStrings.addNewAddress)
                        ],
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}

class AddressItem extends StatelessWidget {
  const AddressItem({
    Key? key,
    required this.localizationStrings,
    required this.address,
    required this.notInAddressListJustForView,
    required this.inBottomModalSheet,
  }) : super(key: key);

  final AppLocalizations localizationStrings;
  final Address address;

  
  final bool notInAddressListJustForView;
  final bool inBottomModalSheet;

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return SizedBox(
      height: 100.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 0.6.sw,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: 100.w,
                                child: Text(
                                  localizationStrings.name,
                                  style: mainStyle(
                                    14.0,
                                    FontWeight.w600,
                                  ),
                                )),
                            Text(
                              address.contactPersonName!,
                              style: mainStyle(
                                14.0,
                                FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: 100.w,
                                child: Text(
                                  localizationStrings.phone,
                                  style: mainStyle(
                                    14.0,
                                    FontWeight.w600,
                                  ),
                                )),
                            Text(
                             address.phone!,
                              textDirection: TextDirection.ltr,
                              style: mainStyle(
                                14.0,
                                FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: 100.w,
                                child: Text(
                                  localizationStrings.address,
                                  style: mainStyle(
                                    14.0,
                                    FontWeight.w600,
                                  ),
                                )),
                            Text(
                              address.address!,
                              style: mainStyle(
                                14.0,
                                FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
                inBottomModalSheet
                    ? Expanded(
                        child: BlocConsumer<MainCubit, MainStates>(
                          listener: (context, state) {
                            
                          },
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                address.isDefault == 1
                                    ? Text(localizationStrings.defaultAddress,
                                        style: mainStyle(14.0, FontWeight.w600,
                                            color: primaryColor))
                                    : (state is ChangingDefaultAddresses &&
                                            mainCubit
                                                    .defaultShippingAddressId ==
                                                address.id.toString())
                                        ? DefaultLoader()
                                        : GestureDetector(
                                            onTap: () {
                                              mainCubit.changeDefaultAddressId(
                                                  address.id.toString());
                                              saveCachePhoneNumber(address.phone);
                                              CartCubit.get(context)
                                                  .getCartDetails(
                                                      updateAllList: true)
                                                  .then((value) => PaymentCubit
                                                          .get(context)
                                                      .initSelectedPaymentId()
                                                      .then((value) =>
                                                          Navigator.pop(
                                                              context)));
                                            },
                                            child: Container(
                                              
                                              child: Row(
                                                children: [
                                                  
                                                  DefaultButton(
                                                    title: localizationStrings
                                                        .setDefault,
                                                    titleSize: 12.0,
                                                    
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                              ],
                            );
                          },
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
          notInAddressListJustForView
              ? SizedBox()
              : BlocConsumer<MainCubit, MainStates>(
                  listener: (context, state) {
                    
                  },
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        address.isDefault == 1
                            ? Text(localizationStrings.defaultAddress,
                                style: mainStyle(14.0, FontWeight.w600,
                                    color: primaryColor))
                            : (state is ChangingDefaultAddresses &&
                                    mainCubit.defaultShippingAddressId ==
                                        address.id.toString())
                                ? DefaultLoader()
                                : GestureDetector(
                                    onTap: () {
                                      mainCubit.changeDefaultAddressId(
                                          address.id.toString());
                                      CartCubit.get(context)
                                          .getCartDetails(updateAllList: true)
                                          .then((value) =>
                                              PaymentCubit.get(context)
                                                  .initSelectedPaymentId()
                                                  .then((value) =>
                                                      Navigator.pop(context)));
                                    },
                                    child: Container(
                                      color: Colors.grey.withOpacity(0.2),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            
                                            height: 20.h,
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          Text(
                                            localizationStrings.setDefault,
                                            style: mainStyle(
                                                12.0, FontWeight.w200),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                        SizedBox(
                          width: 15.w,
                        ),
                        GestureDetector(
                          onTap: () =>
                              mainCubit.removeAddress(address.id.toString()),
                          child: Container(
                            color: Colors.grey.withOpacity(0.2),
                            child: Row(
                              children: [
                                SizedBox(
                                  
                                  height: 20.h,
                                  child: Padding(
                                    padding: EdgeInsets.all(1.0.sp),
                                    child: SvgPicture.asset(
                                      'assets/images/public/icons8_trash_can_1.svg',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  localizationStrings.remove,
                                  style: mainStyle(12.0, FontWeight.w200),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    );
  }
}
