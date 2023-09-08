import 'package:clearance/core/cache/cache.dart';
import 'package:clearance/core/main_cubits/cubit_main.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/styles_colors/styles_colors.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/cubit/account_cubit.dart';

import '../../../../../core/constants/dimensions.dart';
import '../../../../../core/error_screens/show_error_message.dart';
import '../../../../../core/main_functions/main_funcs.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../cart/cart_screen.dart';
import '../cubit/account_state.dart';
import 'my_account.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({Key? key}) : super(key: key);

  static String routeName = 'addNewAddress';

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  var formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var accountCubit = AccountCubit.get(context);
    var mainCubit = MainCubit.get(context);

    var fullNameCont = TextEditingController();
    var address = TextEditingController();
    var address2 = TextEditingController();
    var phone = TextEditingController();
    var email = TextEditingController();
    var countryController = TextEditingController();
    countryController.text = 'United Arab Emirates';
    var stateCont = TextEditingController();
    var city = TextEditingController();
    List<String> countryListIsoS = [];
    bool isSelected = false;
    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: const DefaultAppBarWithOnlyBackButton(transparent: true),
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.only(bottom: 0.05.sh),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              SizedBox(
                height: 15.h,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 26.0.w, vertical: 10.h),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizationStrings!.addNewAddress,
                                style: mainStyle(
                                  16.0,
                                  FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              DefaultInputField(
                                label: localizationStrings.fullName,
                                controller: fullNameCont,
                                textInputAction: TextInputAction.next,
                                validate: (String? val) {
                                  if (val!.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              DefaultInputField(
                                label: localizationStrings.email,
                                controller: email,
                                textInputAction: TextInputAction.next,
                                validate: (String? val) {
                                  if (val!.isEmpty) {
                                    return 'Please enter your Email';
                                  }
                                  if (!val
                                      .contains('@')) {
                                    return 'invalid Email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              DefaultInputField(
                                label: localizationStrings.address,
                                controller: address,
                                textInputAction: TextInputAction.next,
                                validate: (String? val) {
                                  if (val!.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },

                              ),

                              SizedBox(
                                height: 10.h,
                              ),
                              PhoneInputField(
                                  label: localizationStrings.phone,
                                  phoneController: phone),

                              SizedBox(
                                height: 10.h,
                              ),

                              Text(
                                'Country',
                                style: mainStyle(
                                  14.0,
                                  FontWeight.w200,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              DefaultContainer(
                                borderColor: const Color(0xffa4c4f4),
                                radius: 11.0.sp,
                                // childWidget: Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 2*defaultHorizontalPadding),
                                //   child: CountryPickerDropdown(
                                //     initialValue: 'AE',
                                //     isExpanded: true,
                                //     dropdownColor: Colors.white,
                                //     itemBuilder: _buildDropdownItem,
                                //     itemFilter: (c) {
                                //       return mainCubit
                                //           .configModel!.data!.countries!
                                //           .map((e) => e.iso)
                                //           .contains(c.isoCode);
                                //     },
                                //     sortComparator: (Country a, Country b) =>
                                //         a.isoCode.compareTo(b.isoCode),
                                //     onValuePicked: (Country country) {
                                //       logg(country.name);
                                //       countryController.text = country.name;
                                //       logg('new controller name:' +
                                //           countryController.text);
                                //     },
                                //   ),
                                // ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              DefaultInputField(
                                label: localizationStrings.city,
                                textInputAction: TextInputAction.done,
                                controller: city,
                                validate: (String? val) {
                                  if (val!.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                localizationStrings.addressType,
                                style: mainStyle(
                                  15.0,
                                  FontWeight.w300,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              BlocConsumer<AccountCubit, AccountStates>(
                                listener: (context, state) {},
                                builder: (context, state) => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => accountCubit
                                              .changeAddressType('home'),
                                          child: MaleFemaleContainer(
                                            isSelected:
                                                accountCubit.addressType ==
                                                    'home',
                                            title:
                                                localizationStrings.permanent,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 7.w,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => accountCubit
                                              .changeAddressType('work'),
                                          child: MaleFemaleContainer(
                                            isSelected:
                                                accountCubit.addressType ==
                                                    'work',
                                            title: localizationStrings.work,
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              BlocConsumer<AccountCubit, AccountStates>(
                listener: (context, state) {
                  

                  if (state is AddingAddressSuccessState) {
                    showTopModalSheetErrorMessage(context, state.msg ?? '--',);
                  }
                },
                builder: (innerContext, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(),
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (formKey.currentState!.validate() &&
                              true) {
                            logg('save address');
                            accountCubit.addNewAddress(
                              context: context,
                              contactPersonNAme: fullNameCont.text,
                              address: address.text,
                              address2: address2.text,
                              city: city.text,
                              email:email.text,
                              phone: getCachedPhoneNumber() ?? '',
                              state: stateCont.text,
                              country: countryController.text,
                            ).then((value) =>
                                MainCubit.get(context).getAddresses().then((value) =>  Navigator.of(context)..pop()..pop())).catchError((error){
                                  logg('add new address error');
                                  showTopModalSheetErrorMessage(context, error.data['message']);

                            });
                          } else {
                            logg('all fields required');
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: state is SavingAddressState ? 45.w : 250.w,
                          height: 43.h,
                          decoration: BoxDecoration(
                            color: state is SavingAddressState
                                ? Colors.transparent
                                : primaryColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(
                                state is SavingAddressState ? 55.sp : 8.0.sp),
                            border: Border.all(
                                width: 1.0,
                                color: state is SavingAddressState
                                    ? Colors.transparent
                                    : primaryColor),
                          ),
                          child: Center(
                            child: state is SavingAddressState
                                ? DefaultColoredLoader(
                                    customWidth: 42.w,
                                    customHeight: 42.w,
                                  )
                                : Text(
                                    localizationStrings.save,
                                    style: mainStyle(20.0, FontWeight.w900,
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(),
                    ],
                  );
                },
              ),

            ],
          ),
        ));
  }
}

// Widget _buildDropdownItem(Country country) => Container(
      

//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         children: <Widget>[
//           CountryPickerUtils.getDefaultFlagImage(country),
//           SizedBox(
//             width: 8.0,
//           ),
//           SizedBox(
//             width: 0.5.sw,
//             child: Text(
//               "${country.name}",
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
