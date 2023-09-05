
import 'package:bloc/bloc.dart';

import 'main_functions/main_funcs.dart';

class MyBlocObserver extends BlocObserver
{
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    logg('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logg('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logg('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    logg('onClose -- ${bloc.runtimeType}');
  }
}