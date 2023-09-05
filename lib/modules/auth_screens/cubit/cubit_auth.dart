import 'package:clearance/core/error_screens/show_error_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clearance/appMainInitial.dart';
import 'package:clearance/core/cache/cache.dart';
import 'package:clearance/core/main_cubits/cubit_main.dart';
import 'package:clearance/modules/auth_screens/cubit/states_auth.dart';
import 'dart:convert' as convert;
import '../../../core/constants/networkConstants.dart';
import '../../../core/main_functions/main_funcs.dart';
import '../../../core/network/dio_helper.dart';
import '../../../models/api_models/user_info_model.dart';
import '../../../models/api_models/user_model.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);

  bool passDisplayed = false;


  bool resetPassDisplayed = false;

  bool isUserAuth = false;


  bool verifiedNow=false;
  UserModel? userSignUpModel;

  UserInfoModel? userInfoModel;

  Future<void> changePassDisplayStatus() async {
    passDisplayed = !passDisplayed;
    emit(PassDispStatusChangedState());
  }

  Future<void> changeResetPassDisplayStatus() async {
    resetPassDisplayed = !resetPassDisplayed;
    emit(PassDispStatusChangedState());
  }


  Future<void> socialMediaUserLogin({
    required String token,
    required String uniqueId,
    required String email,
    String? name,
    required String medium,
    required BuildContext context,
  }) async {
    var mainCubit = MainCubit.get(context);
    emit(AuthLoadingState());
    mainCubit.getDeviceId().then((value) async {
      await MainDioHelper.postData(url: socialLoginEnd, data: {
        'token': token,
        'unique_id': uniqueId,
        'email': email,
        'name': name ?? '',
        'medium': medium,
        'device_id': value,
      }).then((value) {
        logg('login response: ' + value.toString());
        
        
        logg('token: ' + value.data['data']['token']);

        saveCacheToken(value.data['data']['token']);

        checkUserAuth().then(
            (value) => navigateToAndFinishUntil(context, MainAppMaterialApp()));
        

        mainCubit.updateToken();
        mainCubit.initial(isLogout: false , context: context);

        
        
        
        
        

        emit(LoginSuccessState());
      }).catchError((error) {
        logg(error.toString());
        
        emit(AuthErrorState(getErrorMessageFromErrorJsonResponse(error)));
      });
    });
  }

  Future<void> sendResetPassEmail({
    required String email,
    required BuildContext context,
  }) async {
    emit(SendingForgotPassEmailState());
    await MainDioHelper.postData(url: forgotPassEnd, data: {
      'identity': email,
    }).then((value) {
      logg(' response: ' + value.toString());

      Navigator.pop(context);
      showTopModalSheetErrorMessage(context, value.data['message']);
      
      emit(LoginSuccessState());
    }).catchError((error) {
      logg(error.toString());
      Navigator.pop(context);
      logg('error is: ' + getErrorMessageFromErrorJsonResponse(error)!);
      
      emit(AuthErrorState(getErrorMessageFromErrorJsonResponse(error)));
    });
  }

  Future<void> guestLogin({
    required String deviceUniqueId,
    
    required BuildContext context,
  }) async {
    var mainCubit = MainCubit.get(context);
    emit(AuthLoadingGuestState());
    await MainDioHelper.postData(url: guestRegisterEnd, data: {
      'device_id': deviceUniqueId,
      
    }).then((value) {
      logg('login response: ' + value.toString());

      
      userSignUpModel = UserModel.fromJson(value.data);

      if (userSignUpModel != null) {
        userCacheProcess(userSignUpModel!).then((value) => checkUserAuth().then(
            (value) =>
                navigateToAndFinishUntil(context, const MainAppMaterialApp())));
        
      }
      mainCubit.updateToken();
      mainCubit.initial(isLogout: false , context: context);
      
      emit(LoginSuccessState());
    }).catchError((error) {
      logg(error.toString());
      logg('error is: ' + getErrorMessageFromErrorJsonResponse(error)!);
      
      emit(AuthErrorState(getErrorMessageFromErrorJsonResponse(error)));
    });
  }

  Future<void> userEmailLogin({
    required String email,
    required String pass,
    required BuildContext context,
  }) async {
    var mainCubit = MainCubit.get(context);
    emit(AuthLoadingState());
    mainCubit.getDeviceId().then((value) async {
      await MainDioHelper.postData(
              url: emailLoginEnd,
              data: {'email': email, 'password': pass, 'device_id': value})
          .then((value) {
        logg('login response: ' + value.toString());

        
        userSignUpModel = UserModel.fromJson(value.data);

        if (userSignUpModel != null) {
          userCacheProcess(userSignUpModel!).then((value) => checkUserAuth()
              .then((value) =>
                  navigateToAndFinishUntil(context, const MainAppMaterialApp())));
          
        }
        mainCubit.updateToken();
        mainCubit.initial(isLogout: false , context: context);
        
        emit(LoginSuccessState());
      }).catchError((error) {
        logg(error.toString());
        logg('error is: ' + getErrorMessageFromErrorJsonResponse(error)!);
        
        emit(AuthErrorState(getErrorMessageFromErrorJsonResponse(error)));
      });
    });
  }

  Future<void> userPhoneLogin({
    required String phone,
    required String pass,
    required BuildContext context,
  }) async {
    var mainCubit = MainCubit.get(context);
    emit(AuthLoadingState());
    mainCubit.getDeviceId().then((value) async {
      await MainDioHelper.postData(
          url: phoneLoginEnd,
          token: getCachedToken(),
          data: {'phone': phone, 'password': pass, 'device_id': value})
          .then((value) {
        logg('login response: ' + value.toString());


        userSignUpModel = UserModel.fromJson(value.data);

        if (userSignUpModel != null) {
          userCacheProcess(userSignUpModel!).then((value) => checkUserAuth()
              .then((value) =>
              navigateToAndFinishUntil(context, const MainAppMaterialApp())));

        }
        mainCubit.updateToken();
        mainCubit.initial(isLogout: false,context: context);

        emit(LoginSuccessState());
      }).catchError((error) {
        logg(error.toString());
        logg('error is: ' + getErrorMessageFromErrorJsonResponse(error)!);

        emit(AuthErrorState(getErrorMessageFromErrorJsonResponse(error)));
      });
    });
  }


  Future<void> userRegister({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String pass,
    required String dialCode,
    required String idToken,
    required BuildContext context,
  }) async {
    var mainCubit = MainCubit.get(context);
    emit(AuthLoadingState());
    mainCubit.getDeviceId().then((value) async {
      await MainDioHelper.postData(url: newRegisterEnd, data: {
        'f_name': firstName,
        'l_name': lastName,
        'email': email,
        'password': pass,
        'user_type': '1',
        'phone': phone,
        'country_dial_code':dialCode,
        'id_token':idToken,
        'device_id': value
      }).then((value) {
        logg('sign up response: ' + value.toString());

        userSignUpModel = UserModel.fromJson(value.data);

        if (userSignUpModel != null) {
          userCacheProcess(userSignUpModel!).then((value) => checkUserAuth()
              .then((value) =>
                  navigateToAndFinishUntil(context, const MainAppMaterialApp())));
        }

        mainCubit.updateToken();
        mainCubit.initial(isLogout: false , context: context);
        emit(SignUpSuccessState());
      }).catchError((error) {
        logg(error.response.toString());
        emit(AuthErrorState(getErrorMessageFromErrorJsonResponse(error)));
      });
    });
  }

  Future<void> logOut(BuildContext context) async {
    var mainCubit = MainCubit.get(context);
    logg('logging out ');
    emit(AuthLoadingState());
    String? token = mainCubit.token;
    logg('logging out');

    await MainDioHelper.postData(url: logOutEnd, token: token).then((value) {
      logg('logged out with msg: ' + value.toString());
      removeToken();
      MainCubit.get(context)
          .getDeviceId()
          .then((value) {
        logg(value.toString());
        AuthCubit.get(context).guestLogin(
            deviceUniqueId: value.toString(),
            context: context);
      });
      emit(LogOutSuccesstate());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.response.toString());
      removeToken();
      MainCubit.get(context)
          .getDeviceId()
          .then((value) {
        logg(value.toString());
        AuthCubit.get(context).guestLogin(
            deviceUniqueId: value.toString(),
            context: context);
      });
      // Navigator.of(context, rootNavigator: true).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const MainAppMaterialApp()));
      emit(AuthErrorState(error.toString()));
    });
  }


  Future<void> deleteAccount(BuildContext context) async {
    var mainCubit = MainCubit.get(context);
    logg(' Deleting account ');
    emit(AuthLoadingState());
    String? token = mainCubit.token;
    logg('logging out');

    await MainDioHelper.postData(url: deleteAccountEnd, token: token)
        .then((value) {
      logg('logged out with msg: ' + value.toString());
      removeToken();
      mainCubit.disableCacheGotFlag();
      mainCubit.initial(isLogout: true , context: context);
      MainCubit.get(context)
          .getDeviceId()
          .then((value) {
        logg(value.toString());
        AuthCubit.get(context).guestLogin(
            deviceUniqueId: value.toString(),
            context: context);
      });
      mainCubit.navigateToTap(0);
      // Navigator.of(context, rootNavigator: true).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const SignInScreen()));
      emit(LogOutSuccesstate());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.response.toString());
      removeToken();
      mainCubit.disableCacheGotFlag();
      mainCubit.initial(isLogout: true , context: context);
      MainCubit.get(context)
          .getDeviceId()
          .then((value) {
        logg(value.toString());
        AuthCubit.get(context).guestLogin(
            deviceUniqueId: value.toString(),
            context: context);
      });
      mainCubit.updateToken();
     // pushNewScreenLayout(context, const SignInScreen(), false);
      emit(AuthErrorState(error.toString()));
    });
  }

  Future<void> userCacheProcess(UserModel userSignUpModel) async {
    await saveCacheToken(userSignUpModel.data!.token);
    await saveCacheName(userSignUpModel.data!.user!.fName!
        );
    await saveCacheEmail(userSignUpModel.data!.user!.email);
  }

  bool isUserAuthChecked = false;

  Future<void> checkUserAuth() async {

    logg('checking user auth');

    String? token = getCachedToken();

    logg('ghtest token' + token.toString());
    emit(CheckingAuthState());
    if (token != null) {
      await MainDioHelper.getData(url: userInfoEnd, token: token).then((value) {
        logg('Saving userInfo to model');
        logg(value.data.toString());
        try {
          saveCacheUserInfo(convert.jsonEncode(value.data));
          userInfoModel = UserInfoModel.fromJson(value.data);
          logg('userInfo Saved to model: ' + userInfoModel.toString());
        } catch (error) {
          logg('error is: #@' + error.toString());
        }

        if (userInfoModel != null) {
          if (userInfoModel!.data!.email!.length > 2) {
            logg('token is authorized');
            saveCacheName(userInfoModel!.data!.fName!
                );
            saveCacheEmail(userInfoModel!.data!.email);
            isUserAuth = true;
          }
        }
        isUserAuthChecked = true;
        emit(CheckingAuthStateDone());
      }).catchError((error) {
        logg('an error occured');
        logg(error.toString());
        isUserAuthChecked = true;

        emit(CheckingAuthStateError());
      });
    } else {
      logg('token is null');
      isUserAuthChecked = true;

      emit(CheckingAuthStateDone());
    }
  }
  void getLocalUserData(){
    if(getCachedUserInfo()==null){
      return;
    }
    userInfoModel = UserInfoModel.fromJson(convert.jsonDecode(getCachedUserInfo()!));
    isUserAuth = true;
    isUserAuthChecked=true;
  }
}
