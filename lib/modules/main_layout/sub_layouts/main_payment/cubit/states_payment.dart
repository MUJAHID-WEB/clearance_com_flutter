abstract class PaymentsStates{}
 class PaymentsStatesInitialize extends PaymentsStates{}
 class SelectedMethodChanged extends PaymentsStates{}
 class GettingPaymentLik extends PaymentsStates{}
 class PlacingOrderStateInPayment extends PaymentsStates{}
 class ChangeLoadingCardStatus extends PaymentsStates{}
 class SuccessfullyOrderPlacedInPaymen extends PaymentsStates{}
 class ErrorPaymentState extends PaymentsStates{
  final String error;

  ErrorPaymentState(this.error);
 } class ErrorPlacingOrderStateInPayment extends PaymentsStates{
  final String error;

  ErrorPlacingOrderStateInPayment(this.error);
 }
 class SuccessfulGettingPayLink extends PaymentsStates{}
 class ErrorSendingPaymentData extends PaymentsStates{
 final String? error;
 ErrorSendingPaymentData({this.error});
 }
 class SuccessfulVerification extends PaymentsStates{
   final bool showChooseAddress;
   SuccessfulVerification({this.showChooseAddress=false});
 }