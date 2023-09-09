import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../modules/auth_screens/cubit/cubit_auth.dart';
import '../main_functions/main_funcs.dart';


class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn(
  );

  // static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future<GoogleSignInAccount?> login(BuildContext context) {
    var loginCubit = AuthCubit.get(context);
    return _googleSignIn.signIn().then((result) {
      logg('respons: ' + result.toString());
      result!.authentication.then((googleKey) {
        logg('accessToken: ' + googleKey.accessToken.toString());
        logg('idToken: ' + googleKey.idToken.toString());
        logg('currentUser displayName: ' +
            _googleSignIn.currentUser!.displayName.toString());

        loginCubit.socialMediaUserLogin(
          token: googleKey.accessToken.toString(),
          uniqueId: _googleSignIn.currentUser!.id,
          email: _googleSignIn.currentUser!.email,
          medium: 'google',
          context: context,
        );
      }).catchError((err) {
        logg('inner error: ' + err.toString());
      });
    }).catchError((err) {
      logg('error occured: ' + err.toString());
    });
  }

  static Future logout() => _googleSignIn.disconnect();
}
