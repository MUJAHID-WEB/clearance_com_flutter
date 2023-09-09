import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/constants/countries.dart';
import 'package:clearance/core/main_cubits/cubit_main.dart';
import 'package:clearance/core/main_functions/main_funcs.dart';
import 'package:clearance/modules/auth_screens/sign_in_screen.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/cubit/account_cubit.dart';
import 'package:clearance/modules/main_layout/sub_layouts/account/cubit/account_state.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:clearance/modules/auth_screens/cubit/cubit_auth.dart';
import '../../../../../core/cache/cache.dart';
import '../../../../../core/error_screens/show_error_message.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../../core/styles_colors/styles_colors.dart';
import '../account_shared_widgets/account_shared_widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({Key? key}) : super(key: key);

  static String routeName = 'myAccount';

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var authCubit = AuthCubit.get(context);
    String _phoneNumber = authCubit.userInfoModel?.data?.phone ?? '';
    String code = '';
    String dial = '';
    final fNameCont = TextEditingController();
    final lNameCont = TextEditingController();
    final emailCont = TextEditingController();
    final phoneCont = TextEditingController();
    final formKey = GlobalKey<FormState>();

    fNameCont.text = authCubit.userInfoModel!.data!.fName!;
    lNameCont.text = authCubit.userInfoModel!.data!.lName!;
    emailCont.text =authCubit.userInfoModel!.data!.email!
        .contains('@guest.ae') ? '' : authCubit.userInfoModel!.data!.email!;
    code = authCubit.userInfoModel!.data!.dialCode != null
        ? countries
            .firstWhere((element) =>
                element.dialCode == authCubit.userInfoModel!.data!.dialCode)
            .code
        : '';
    dial = authCubit.userInfoModel!.data!.dialCode ?? '';
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: const DefaultAppBarWithOnlyBackButton(),
        ),
        body: BlocListener<AccountCubit, AccountStates>(
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              showTopModalSheetErrorMessage(context, localizationStrings!.update_profile_success);

              Navigator.pop(context);
            } else if (state is ErrorUpdateProfile) {
              showTopModalSheetErrorMessage(context, state.message ?? localizationStrings!.something_went_wrong);
            }
          },
          child: Padding(
              padding: EdgeInsets.only(bottom: 0.05.sh),
              child: ConditionalBuilder(
                condition:
                    authCubit.userInfoModel!.data!.isVerifiedPhone == 1 ||
                        authCubit.userInfoModel!.data!.isVerifiedEmail == 1,
                builder: (context) => Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 26.0.w, vertical: 10.h),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  AccountItemContainer(
                                    title: localizationStrings!.myAccount,
                                    svgPath:
                                        'assets/images/account/Profil_Icon.svg',
                                  ),
                                  SizedBox(
                                    height: 22.h,
                                  ),
                                  DefaultInputField(
                                    label: localizationStrings.firstName,
                                    controller: fNameCont,
                                    validate: (String? val) {
                                      if (val!.isEmpty) {
                                        return 'Please enter your first name';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  DefaultInputField(
                                    label: localizationStrings.lastName,
                                    controller: lNameCont,
                                    validate: (String? val) {
                                      if (val!.isEmpty) {
                                        return 'Please enter your last name';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                      DefaultInputField(
                                          label: localizationStrings.email,
                                          controller: emailCont,
                                          validate:  (String? val) {
                                            if(val!.isEmpty && authCubit.userInfoModel!.data!.email!
                                                .contains('@guest.ae')){
                                              return null;
                                            }
                                            if (val.isEmpty ) {
                                              return 'Please enter your Email';
                                            } else if (val.contains('.') &&
                                                val
                                                    .split('.')
                                                    .last
                                                    .isNotEmpty &&
                                                val.contains('@') &&
                                                val.split('@')[1].isNotEmpty) {
                                              return null;
                                            } else {
                                              return 'invalid email';
                                            }
                                          }),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  PhoneInputField(
                                    label: localizationStrings.phone,
                                    fromProfile: true,
                                    onInputChanged: (PhoneNumber phoneNumber) {
                                      _phoneNumber = phoneNumber.phoneNumber!;
                                      code = phoneNumber.isoCode!;
                                      dial = phoneNumber.dialCode!;
                                    },
                                    phoneController: phoneCont,
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                ],
                              ),
                            )),
                      ),
                      BlocBuilder<AccountCubit, AccountStates>(
                        builder: (context, state) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
                            child: Column(
                              children: [
                                if (state is LoadingState) ...{
                                  const SizedBox(
                                      child: LinearProgressIndicator())
                                },
                                DefaultButton(
                                  onClick: () {
                                    if (formKey.currentState!.validate()) {
                                      if (fNameCont.text == authCubit.userInfoModel!.data!.fName! &&
                                          lNameCont.text ==
                                              authCubit.userInfoModel!.data!
                                                  .lName! &&
                                          emailCont.text ==
                                              authCubit.userInfoModel!.data!
                                                  .email! &&
                                          _phoneNumber ==
                                              authCubit.userInfoModel!.data!
                                                  .phone!) {
                                        showTopModalSheetErrorMessage(context, localizationStrings.nothing_to_do);
                                        return;
                                      }
                                      logg(dial);
                                      logg(_phoneNumber);
                                      AccountCubit.get(context).updateProfile(
                                        code: code,
                                        dial: dial != ''
                                            ? dial
                                            : getCachedPhoneDialCode() ??
                                                '+971',
                                        firstName: fNameCont.text,
                                        lastName: lNameCont.text,
                                        email: emailCont.text.isEmpty ? authCubit.userInfoModel!.data!.email! : emailCont.text,
                                        context: context,
                                        phoneNumber: _phoneNumber,
                                      );
                                    }
                                  },
                                  title: localizationStrings.save,
                                  titleColor:
                                  primaryColor.withOpacity(0.8),
                                  borderColors:
                                  primaryColor.withOpacity(0.5),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
                        child: DefaultButton(
                          onClick: () {
                            if (authCubit.userInfoModel!.data!.email!
                                .contains('@guest.ae')) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const SignInScreen()));
                              return;
                            }
                            authCubit.logOut(context).then((value) =>
                                MainCubit.get(context).removeAddresses()).then((value) => clearAllCacheWithoutTheme());
                          },
                          title: authCubit.userInfoModel!.data!.email!
                                  .contains('@guest.ae')
                              ? localizationStrings.joinUs
                              : localizationStrings.signOut,
                          titleColor: primaryColor.withOpacity(0.8),
                          borderColors:
                          primaryColor.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      authCubit.userInfoModel!.data!.email!
                              .contains('@guest.ae')
                          ? Container()
                          : Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 0.05.sw),
                              child: DefaultButton(
                                onClick: () {
                                  myAlertDialog(
                                    context,
                                    localizationStrings.deleteAccount,
                                    alertDialogContent: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(localizationStrings
                                            .weWillBeNotAbleToRestore),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            DefaultButton(
                                                title: localizationStrings
                                                    .deleteAccount,
                                                borderColors: Colors.red,
                                                titleColor: Colors.red,
                                                onClick: () => authCubit
                                                    .deleteAccount(context)
                                                    .then((value) =>
                                                        MainCubit.get(context)
                                                            .removeAddresses())
                                                    .then((value) =>
                                                        clearAllCache())),
                                            SizedBox(
                                              width: 7.w,
                                            ),
                                            DefaultButton(
                                              title: localizationStrings.cancel,
                                              onClick: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    dismissible: true,
                                  );
                                },
                                title: localizationStrings.deleteAccount,
                                titleColor: Colors.white,
                                backColor: primaryColor,
                                borderColors:
                                primaryColor.withOpacity(0.5),
                              ),
                            ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
                fallback: (context) => Center(
                  child: InkWell(
                    onTap: () {
                      navigateToWithoutNavBar(context, const SignInScreen(),
                          SignInScreen.routeName);
                    },
                    child: DefaultContainer(
                        height: 45.h,
                        width: 0.35.sw,
                        backColor: Colors.white.withOpacity(0.5),
                        borderColor: primaryColor,
                        childWidget: Center(
                          child: Text(
                            'Join us',
                            style: mainStyle(20.0, FontWeight.w600,
                                color: primaryColor),
                          ),
                        )),
                  ),
                ),
              )),
        ));
  }
}

class MaleFemaleContainer extends StatelessWidget {
  const MaleFemaleContainer({
    Key? key,
    required this.isSelected,
    required this.title,
    this.svgPath,
  }) : super(key: key);

  final bool isSelected;

  final String title;
  final String? svgPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: svgPath == null ? 55.h : 130.h,
      decoration: BoxDecoration(
        color: isSelected == true
            ? const Color(0xff48ac92)
            : const Color(0xffffffff),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 1.0, color: const Color(0xffa4c4f4)),
      ),
      child: Column(
        mainAxisAlignment: svgPath == null
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              height: svgPath == null ? 0 : 61.h,
              child: svgPath == null
                  ? null
                  : SvgPicture.asset(
                      svgPath!,
                      color: isSelected == true
                          ? Colors.white
                          : const Color(0xff48AC92),
                    )),
          Text(
            title,
            style: mainStyle(svgPath == null ? 14.0 : 20.0, FontWeight.w600,
                color: isSelected == true ? Colors.white : Colors.black),
          )
        ],
      ),
    );
  }
}
