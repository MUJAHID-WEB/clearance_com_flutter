import 'dart:io';

import 'package:clearance/core/cache/cache.dart';
import 'package:clearance/core/constants/countries.dart';
import 'package:clearance/core/main_cubits/cubit_main.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clearance/core/constants/startup_settings.dart';
import 'package:clearance/core/constants/dimensions.dart';
import 'package:clearance/core/shared_widgets/shared_widgets.dart';
import 'package:clearance/core/styles_colors/styles_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../core/constants/networkConstants.dart';
import '../../core/error_screens/show_error_message.dart';
import '../../core/main_functions/main_funcs.dart';
import '../../core/network/dio_helper.dart';
import '../../core/network/google_sign_in.dart';
import '../main_layout/sub_layouts/cart/cart_screen.dart';
import 'cubit/cubit_auth.dart';
import 'cubit/states_auth.dart';
import 'guest_verification_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static String routeName = 'faqScreenView';

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);

    var authCubit = AuthCubit.get(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: defaultHorizontalPadding * 4, vertical: 15.h),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Center(
                      child: CacheHelper.getData(key: 'squareCurvedLogoUrl') ==
                              null
                          ? Image.asset(
                              'assets/icons/mainIcon.png',
                              height: 75.h,
                            )
                          : Image.file(
                              File(
                                CacheHelper.getData(key: 'squareCurvedLogoUrl'),
                              ),
                              height: 75.h)),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                          child: TabBar(
                            tabs: [
                              Tab(
                                  child: Text(
                                localizationStrings!.login,
                                style: mainStyle(
                                  14.0,
                                  FontWeight.w600,
                                ),
                              )),
                              Tab(
                                  child: Text(
                                localizationStrings.signUp,
                                style: mainStyle(
                                  14.0,
                                  FontWeight.w600,
                                ),
                              )),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(children: [
                            LoginView(),
                            const SignUpView(),
                          ]),
                        ),
                        BlocConsumer<AuthCubit, AuthStates>(
                          listener: (context, state) {},
                          builder: (context, state) => state
                                  is! AuthLoadingGuestState
                              ? SizedBox(
                                  height: 40.h,
                                  child: TextButton(
                                      onPressed: () {
                                        MainCubit.get(context)
                                            .getDeviceId()
                                            .then((value) {
                                          logg(value.toString());
                                          authCubit.guestLogin(
                                              deviceUniqueId: value.toString(),
                                              context: context);
                                          return null;
                                        });
                                      },
                                      child: Text(
                                        localizationStrings.continueGuest,
                                        style: mainStyle(18.0, FontWeight.w600,
                                            color: primaryColor),
                                      )),
                                )
                              : SizedBox(
                                  height: 30.h,
                                  child: const Center(
                                      child: LinearProgressIndicator())),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailCont = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passCont = TextEditingController();

  final TextEditingController passResetCont = TextEditingController();

  final GlobalKey<FormState> resetPassFormKey = GlobalKey<FormState>();

  final TextEditingController forgotPassEmailController =
      TextEditingController();

  late final AppLocalizations localizationStrings =
      AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);

    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          showTopModalSheetErrorMessage(context, state.error ?? localizationStrings.unknown_error);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SimpleLoginInputField(
                        controller: emailCont,
                        hintText: localizationStrings.email,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 75.w,
                            child: const Divider(
                              color: Colors.black,
                              thickness: 0.2,
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                localizationStrings.or,
                                style: mainStyle(
                                  15.0,
                                  FontWeight.w200,
                                ),
                              )),
                          SizedBox(
                            width: 75.w,
                            child: const Divider(
                              color: Colors.black,
                              thickness: 0.2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      PhoneInputField(
                          label: localizationStrings.phone,
                          phoneController: phoneController),
                      SizedBox(
                        height: 15.h,
                      ),
                      BlocBuilder<AuthCubit, AuthStates>(
                        builder: (context, state) {
                          return SimpleLoginInputField(
                            controller: passCont,
                            obscureText: !authCubit.passDisplayed,
                            hintText: localizationStrings.passWord,
                            suffixColor: authCubit.passDisplayed == true
                                ? primaryColor
                                : titleColor.withOpacity(0.5),
                            suffix: authCubit.passDisplayed == true
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            onSuffixPressed: () {
                              logg('suffix pressed');

                              authCubit.changePassDisplayStatus();
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              myAlertDialog(
                                  context, localizationStrings.verify_account,
                                  alertDialogContent: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DefaultButton(
                                        title: localizationStrings.email,
                                        onClick: () {
                                          Navigator.pop(context);
                                          myAlertDialog(
                                              context,
                                              localizationStrings
                                                  .enter_your_email,
                                              alertDialogContent: Form(
                                                key: resetPassFormKey,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: 30.h,
                                                    ),
                                                    SimpleLoginInputField(
                                                      hintText:
                                                          localizationStrings
                                                              .email,
                                                      controller:
                                                          forgotPassEmailController,
                                                      validate: (String? val) {
                                                        if (val!.isEmpty) {
                                                          return localizationStrings
                                                              .enter_your_email;
                                                        }
                                                        if (!val
                                                            .contains('@')) {
                                                          return localizationStrings
                                                              .invalid_email;
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                    BlocBuilder<AuthCubit,
                                                        AuthStates>(
                                                      builder:
                                                          (context, state) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: state
                                                                  is SendingForgotPassEmailState
                                                              ? const DefaultLoader()
                                                              : DefaultButton(
                                                                  title: localizationStrings
                                                                      .send_reset_email,
                                                                  onClick: () {
                                                                    if (resetPassFormKey
                                                                        .currentState!
                                                                        .validate()) {
                                                                      logg(
                                                                          'reset pass');
                                                                      authCubit
                                                                          .sendResetPassEmail(
                                                                        email: forgotPassEmailController
                                                                            .text,
                                                                        context:
                                                                            context,
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                        );
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ));
                                        },
                                      ),
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                      DefaultButton(
                                        title: localizationStrings.phone,
                                        onClick: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const GuestVerificationScreen(
                                                        requestVerify: false,
                                                      ))).then((value) {
                                                        logg(value);
                                            if (value != null) {
                                              myAlertDialog(
                                                  context,
                                                  localizationStrings
                                                      .enter_new_pass,
                                                  alertDialogContent: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    mainAxisSize:
                                                    MainAxisSize.min,
                                                    children: [
                                                      BlocBuilder<AuthCubit,
                                                          AuthStates>(
                                                        builder:
                                                            (context, state) {
                                                          return SimpleLoginInputField(
                                                            controller:
                                                            passResetCont,
                                                            obscureText: !authCubit
                                                                .resetPassDisplayed,
                                                            hintText:
                                                            localizationStrings
                                                                .passWord,
                                                            suffixColor: authCubit
                                                                .resetPassDisplayed ==
                                                                true
                                                                ? primaryColor
                                                                : titleColor
                                                                .withOpacity(
                                                                0.5),
                                                            suffix: authCubit
                                                                .resetPassDisplayed ==
                                                                true
                                                                ? Icons
                                                                .visibility_outlined
                                                                : Icons
                                                                .visibility_off_outlined,
                                                            validate:
                                                                (String? val) {
                                                              if (val!
                                                                  .isEmpty) {
                                                                return localizationStrings
                                                                    .please_enter_new_pass;
                                                              }
                                                              if (val.length <
                                                                  8) {
                                                                return localizationStrings
                                                                    .password_short;
                                                              }
                                                              return null;
                                                            },
                                                            onSuffixPressed: () {
                                                              logg(
                                                                  'suffix pressed');
                                                              authCubit
                                                                  .changeResetPassDisplayStatus();
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: 30.h,
                                                      ),
                                                      DefaultButton(
                                                        title: localizationStrings
                                                            .change,
                                                        onClick: () async {
                                                          Navigator.pop(
                                                              context);
                                                          Response response =
                                                          await MainDioHelper
                                                              .postData(
                                                              url:
                                                              resetPasswordByPhone,
                                                              data: {
                                                                'password':
                                                                passResetCont
                                                                    .text,
                                                                'id_token':
                                                                getCachedIdToken()
                                                              });
                                                          if (response
                                                              .statusCode ==
                                                              200) {
                                                            showTopModalSheetErrorMessage(
                                                                context,
                                                                localizationStrings
                                                                    .update_pass_success);

                                                            removeIdToken();
                                                          } else {
                                                            showTopModalSheetErrorMessage(
                                                                context,
                                                                localizationStrings
                                                                    .something_went_wrong);
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ));
                                            }
                                          } );
                                        },
                                      ),
                                    ],
                                  ));
                            },
                            child: Text(
                              localizationStrings.forgotPassword,
                              style: mainStyle(13.0, FontWeight.w700,
                                  color: primaryColor),
                            ),
                          ),
                        ],
                      ),
                         ConditionalBuilder(
                          condition: authCubit.state is! AuthLoadingState,
                          builder: (context) => GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (validate()) {
                                logg('go to login');
                                if (emailCont.text.contains('@')) {
                                  authCubit.userEmailLogin(
                                    email: emailCont.text,
                                    pass: passCont.text,
                                    context: context,
                                  );
                                } else {
                                  authCubit.userPhoneLogin(
                                    phone: (getCachedPhoneDialCode()! +
                                            getCachedPhoneNumber()!)
                                        .replaceAll(RegExp(r"\s+"), ""),
                                    pass: passCont.text,
                                    context: context,
                                  );
                                }
                              }
                            },
                            child: DefaultContainer(
                              height: 40..h,
                              backColor: primaryColor,
                              borderColor: Colors.transparent,
                              childWidget: Center(
                                child: Text(
                                  localizationStrings.login,
                                  style: mainStyle(16.0, FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          fallback: (context) => SizedBox(
                            height: 45.h,
                            child: const Center(
                              child: LinearProgressIndicator(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validate() {
    String phone = phoneController.text;
    String email = emailCont.text;
    String password = passCont.text;
    if (email.isNotEmpty) {
      if (!email.contains('@')) {
        showTopModalSheetErrorMessage(context, localizationStrings.invalid_email);
        return false;
      }
    }
    if (phone.isNotEmpty) {
      if (double.tryParse(
              getCachedPhoneDialCode()! + getCachedPhoneNumber()!) ==
          null) {
        showTopModalSheetErrorMessage(context, localizationStrings.invalid_phone);

        return false;
      }
      String dialCode = getCachedPhoneDialCode() ?? '';
      Country country =
          countries.singleWhere((element) => element.dialCode == dialCode);
      if ((country.minLength - 1) >
          phone.replaceAll(RegExp(r'[^0-9]'), '').length) {
        showTopModalSheetErrorMessage(context, localizationStrings.phone_short);

        return false;
      }
      if (country.maxLength < phone.replaceAll(RegExp(r'[^0-9]'), '').length) {
        showTopModalSheetErrorMessage(context, localizationStrings.phone_long);

        return false;
      }
    }
    if (phone.isEmpty && email.replaceAll(RegExp(r"\s+"), "").isEmpty) {
      showTopModalSheetErrorMessage(context, localizationStrings.please_enter_email_or_phone);

      return false;
    }
    if (password.isEmpty) {
      showTopModalSheetErrorMessage(context, localizationStrings.please_enter_new_pass);

      return false;
    }
    if (password.length < 8) {
      showTopModalSheetErrorMessage(context, localizationStrings.password_short);

      return false;
    }
    return true;
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizationStrings = AppLocalizations.of(context);
    var formKey = GlobalKey<FormState>();
    var firstNameCont = TextEditingController();
    var lastNameCont = TextEditingController();
    var emailCont = TextEditingController();
    var phoneCont = TextEditingController();
    var passCont = TextEditingController();
    var authCubit = AuthCubit.get(context);

    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          showTopModalSheetErrorMessage(context, state.error ?? localizationStrings!.unknown_error);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SimpleLoginInputField(
                        controller: firstNameCont,
                        textInputAction: TextInputAction.next,
                        hintText: localizationStrings!.firstName,
                        keyboardType: TextInputType.name,
                        validate: (String? val) {
                          if (val!.isEmpty) {
                            return localizationStrings.enter_first_name;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SimpleLoginInputField(
                        controller: lastNameCont,
                        hintText: localizationStrings.lastName,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validate: (String? val) {
                          if (val!.isEmpty) {
                            return localizationStrings.enter_last_name;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SimpleLoginInputField(
                        controller: emailCont,
                        hintText: localizationStrings.email,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validate: (String? val) {
                          if (val!.isEmpty) {
                            return localizationStrings.enter_your_email;
                          } else if (val.contains('.') &&
                              val.split('.').last.isNotEmpty &&
                              val.contains('@') &&
                              val.split('@')[1].isNotEmpty) {
                            return null;
                          } else {
                            return localizationStrings.invalid_email;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      PhoneInputField(
                        phoneController: phoneCont,
                        label: localizationStrings.phone,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      BlocBuilder<AuthCubit, AuthStates>(
                        builder: (context, state) {
                          return SimpleLoginInputField(
                            controller: passCont,
                            obscureText: !authCubit.passDisplayed,
                            textInputAction: TextInputAction.next,
                            hintText: localizationStrings.passWord,
                            validate: (String? val) {
                              if (val!.isEmpty) {
                                return localizationStrings.enter_your_pass;
                              }
                              if (val.length < 8) {
                                return localizationStrings.password_short;
                              }
                              return null;
                            },
                            suffixColor: authCubit.passDisplayed == true
                                ? primaryColor
                                : titleColor.withOpacity(0.5),
                            suffix: authCubit.passDisplayed == true
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            onSuffixPressed: () {
                              logg('suffix pressed');
                              authCubit.changePassDisplayStatus();
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            SizedBox(
              height: 5.h,
            ),
            BlocConsumer<AuthCubit, AuthStates>(
              listener: (context, state) {
                if (state is AuthErrorState) {
                  showTopModalSheetErrorMessage(context, state.error ?? localizationStrings.unknown_error);
                }
              },
              builder: (context, state) => ConditionalBuilder(
                condition: authCubit.state is! AuthLoadingState,
                builder: (context) => GestureDetector(
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (formKey.currentState!.validate()) {
                      logg('go to login');
                      await MainDioHelper.getData(
                              url: emailCheckExistenceEP + emailCont.text)
                          .then((value) async {
                        logg('email not exist');
                        await MainDioHelper.getData(
                                url: phoneCheckExistenceEP +
                                    (getCachedPhoneDialCode()! +
                                        getCachedPhoneNumber()!))
                            .then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const GuestVerificationScreen(
                                        requestVerify: false,
                                      ))).then((value) {
                            if (getCachedIdToken() == null) {
                              return;
                            }
                            authCubit.userRegister(
                                firstName: firstNameCont.text,
                                lastName: lastNameCont.text,
                                email: emailCont.text,
                                idToken: getCachedIdToken() ?? '',
                                phone: getCachedPhoneDialCode()! +
                                    getCachedPhoneNumber()!,
                                dialCode: getCachedPhoneDialCode()!,
                                pass: passCont.text,
                                context: context);
                          });
                        }).catchError((error) {
                          logg('phone exist');
                          showTopModalSheetErrorMessage(context, localizationStrings.phone_already_exist);

                          return;
                        });
                      }).catchError((error) {
                        logg('email exist');
                        showTopModalSheetErrorMessage(context, localizationStrings.email_already_exist);
                        return;
                      });
                    }
                  },
                  child: DefaultContainer(
                    height: 40..h,
                    backColor: primaryColor,
                    borderColor: Colors.transparent,
                    childWidget: Center(
                      child: Text(
                        localizationStrings.signUp,
                        style: mainStyle(16.0, FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                fallback: (context) => SizedBox(
                  height: 45.h,
                  child: const Center(
                    child: LinearProgressIndicator(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class SocialMediaSign extends StatelessWidget {
//   const SocialMediaSign({
//     Key? key,
//     required this.localizationStrings,
//   }) : super(key: key);
//
//   final AppLocalizations? localizationStrings;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Platform.isIOS
//             ? Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () async {
//                       logg('apple sign in');
//                       appleFireBaseSignIn(context);
//                     },
//                     child: DefaultContainer(
//                       height: 40.h,
//                       borderColor: const Color(0xffA4C4F4),
//                       childWidget: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             flex: 6,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 SvgPicture.asset(
//                                   'assets/images/account/apple.svg',
//                                   width: 20.h,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             width: 7.w,
//                           ),
//                           Expanded(
//                             flex: 15,
//                             child: Text(
//                               localizationStrings!.continueWithApple,
//                               style: mainStyle(
//                                 16.0,
//                                 FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15.h,
//                   ),
//                 ],
//               )
//             : SizedBox(),
//         GestureDetector(
//           onTap: () {
//             googleSignIn(context);
//           },
//           child: DefaultContainer(
//             height: 40.h,
//             borderColor: const Color(0xffA4C4F4),
//             childWidget: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                   flex: 6,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       SvgPicture.asset(
//                         'assets/images/account/icons8_google.svg',
//                         width: 20.h,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: 7.w,
//                 ),
//                 Expanded(
//                   flex: 15,
//                   child: Text(
//                     localizationStrings!.continueWithGoogle,
//                     style: mainStyle(
//                       16.0,
//                       FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 15.h,
//         ),
//         GestureDetector(
//           onTap: () {
//             faceBookSignIn(context);
//           },
//           child: DefaultContainer(
//             height: 40.h,
//             borderColor: const Color(0xffA4C4F4),
//             childWidget: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                   flex: 6,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       SvgPicture.asset(
//                         'assets/images/account/icons8_facebook_f.svg',
//                         width: 15.h,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10.w,
//                 ),
//                 Expanded(
//                   flex: 15,
//                   child: Text(
//                     localizationStrings!.continueWithFacebook,
//                     style: mainStyle(
//                       16.0,
//                       FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 15.h,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 75.w,
//               child: const Divider(
//                 color: Colors.black,
//                 thickness: 0.2,
//               ),
//             ),
//             Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Text(
//                   localizationStrings!.or,
//                   style: mainStyle(
//                     15.0,
//                     FontWeight.w200,
//                   ),
//                 )),
//             SizedBox(
//               width: 75.w,
//               child: const Divider(
//                 color: Colors.black,
//                 thickness: 0.2,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 15.h,
//         ),
//       ],
//     );
//   }
// }

// Future<UserCredential> appleFireBaseSignIn(BuildContext context) async {
//   var loginCubit = AuthCubit.get(context);
//
//   final rawNonce = generateNonce();
//
//   final AuthorizationCredentialAppleID appleCredential =
//       await SignInWithApple.getAppleIDCredential(
//     scopes: [
//       AppleIDAuthorizationScopes.email,
//       AppleIDAuthorizationScopes.fullName,
//     ],
//     webAuthenticationOptions: WebAuthenticationOptions(
//         redirectUri: Uri.parse(
//             'https://clearance-ac83c.firebaseapp.com/__/auth/handler'),
//         clientId: 'CT52662ZLN.ae.clearance'),
//   );
//
//   final oauthCredential = OAuthProvider("apple.com").credential(
//     idToken: appleCredential.identityToken,
//     rawNonce: rawNonce,
//   );
//
//   UserCredential userCredential =
//       await FirebaseAuth.instance.signInWithCredential(oauthCredential);
//
//   logg('identityToken: ' +
//       appleCredential.identityToken.toString() +
//       '  userIdentifier: ' +
//       appleCredential.userIdentifier.toString() +
//       ' additionalUserInfo: ' +
//       userCredential.additionalUserInfo.toString() +
//       ' givenName: ' +
//       appleCredential.givenName.toString());
//   loginCubit.socialMediaUserLogin(
//     token: appleCredential.identityToken.toString(),
//     uniqueId: appleCredential.userIdentifier.toString(),
//     email: userCredential.additionalUserInfo!.profile!['email'].toString(),
//     name: appleCredential.givenName.toString() +
//         ' ' +
//         appleCredential.familyName.toString(),
//     medium: 'apple',
//     context: context,
//   );
//
//   return userCredential;
// }
//
// Future googleSignIn(BuildContext context) async {
//   final user =
//       await GoogleSignInApi.login(context).then((value) {}).catchError((error) {
//     logg(error.toString());
//   });
// }
//
// Future faceBookSignIn(BuildContext context) async {
//   var loginCubit = AuthCubit.get(context);
//   String? _accessToken;
//   logg('fb sign  in');
//   final LoginResult result = await FacebookAuth.i.login().then((value) async {
//     logg(value.status.toString());
//     logg(value.toString());
//     if (value.status == LoginStatus.success) {
//       _accessToken = value.accessToken!.token;
//       logg('access token: ' + _accessToken.toString());
//       final userData = await FacebookAuth.i.getUserData(
//         fields: "name,email,picture.width(200)",
//       );
//       logg('userData:' + userData.toString());
//
//       loginCubit.socialMediaUserLogin(
//         token: _accessToken.toString(),
//         uniqueId: userData['id'],
//         email: userData['email'],
//         medium: 'facebook',
//         context: context,
//       );
//     }
//     return value;
//   }).catchError((error) {
//     logg('error');
//     logg(error.toString());
//   });
//
//   final userData = await FacebookAuth.instance.getUserData();
// }
