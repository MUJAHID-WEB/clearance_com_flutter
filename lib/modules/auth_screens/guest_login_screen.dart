import 'package:clearance/modules/auth_screens/cubit/cubit_auth.dart';
import 'package:clearance/modules/auth_screens/cubit/states_auth.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/main_cubits/cubit_main.dart';
import '../../core/main_functions/main_funcs.dart';

class GuestLoginScreen extends StatelessWidget {
  const GuestLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var authCubit = AuthCubit.get(context);
    MainCubit.get(context)
        .getDeviceId()
        .then((value) {
      logg(value.toString());
      authCubit.guestLogin(
          deviceUniqueId: value.toString(),
          context: context);
    });
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        return const Center(child: DefaultLoader());
      },
    );
  }
}
