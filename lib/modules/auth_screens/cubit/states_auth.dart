abstract class AuthStates{}

class AuthInitialState extends AuthStates{}
class AuthLoadingState extends AuthStates{}
class LoginSuccessState extends AuthStates{}
class PassDispStatusChangedState extends AuthStates{}
class SendingForgotPassEmailState extends AuthStates{}
class CheckingAuthState extends AuthStates{}
class CheckingAuthStateDone extends AuthStates{}
class CheckingAuthStateError extends AuthStates{}
class AuthLoadingGuestState extends AuthStates{}
class SignUpSuccessState extends AuthStates{}
class LogOutSuccesstate extends AuthStates{}

class AuthErrorState extends AuthStates {
  final String? error;

  AuthErrorState(this.error);
}