import 'dart:async';
import 'dart:io';

import 'package:clearance/core/shared_widgets/shared_widgets.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cart_screen.dart';
import 'package:clearance/modules/main_layout/sub_layouts/cart/cubit/cart_cubit.dart';
import 'package:clearance/modules/main_layout/sub_layouts/main_payment/cubit/cubit_payment.dart';
import 'package:clearance/modules/main_layout/sub_layouts/main_payment/cubit/states_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants/networkConstants.dart';
import '../main_functions/main_funcs.dart';
import '../styles_colors/styles_colors.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({
    Key? key,
    required this.paymentLink,
    required this.paymentMethod,
  }) : super(key: key);

  final String paymentLink;
  final String paymentMethod;

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late Completer<WebViewController> controller;
  late WebViewController _webViewController;
  late final ValueNotifier<bool> loadingWebViewNotifier;

  @override
  void initState() {
    super.initState();
    controller = Completer<WebViewController>();
    loadingWebViewNotifier = ValueNotifier(false);
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    var paymentCubit = PaymentCubit.get(context);
    var cartCubit = CartCubit.get(context);

    var progressVal;
    return SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56.0.h),
            child: const DefaultAppBarWithOnlyBackButton(),
          ),
          body: Builder(builder: (BuildContext context) {
            return ValueListenableBuilder<bool>(
                valueListenable: loadingWebViewNotifier,
                builder: (context, isLoadedValue, _) {
                  return BlocConsumer<PaymentCubit, PaymentsStates>(
                    listener: (context, state) {},
                    builder: (context, state) => Stack(
                      alignment: Alignment.center,
                      children: [
                        WebView(
                          initialUrl: widget.paymentLink,
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated:
                              (WebViewController webViewController) {
                            controller.complete(webViewController);
                            _webViewController = webViewController;
                          },
                          onProgress: (int progress) {
                            progressVal = progress;
                            loadingWebViewNotifier.value = (progress == 100);
                            logg('WebView is loading (progress : $progress%)');
                          },
                          javascriptChannels: <JavascriptChannel>{
                            _toasterJavascriptChannel(context, paymentCubit),
                          },
                          navigationDelegate: (NavigationRequest request) {
                            if (widget.paymentMethod == 'telr') {
                              if (request.url
                                  .startsWith(successRedirectPayLink)) {
                                logg('blocking navigation to $request}');
                                paymentCubit
                                    .callSucessPlaceOrder('telr')
                                    .then((value) {
                                  CartCubit.get(context)
                                      .getCartDetails(updateAllList: true)
                                      .then((value) {
                                    return null;
                                  });
                                  showTopModalSheet<String>(context,
                                      Builder(builder: (context) {
                                    return Container(
                                      margin: EdgeInsets.only(top: 20.h),
                                      color: Colors.white.withOpacity(0.8),
                                      height: 120.h,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 25.w,
                                                  ),
                                                  SizedBox(
                                                    height: 25.w,
                                                    width: 25.w,
                                                    child: Lottie.asset(
                                                        'assets/images/public/lf30_editor_c6ebyow8.json',
                                                        width: 25.w,
                                                        height: 25.w),
                                                  ),
                                                  SizedBox(
                                                    width: 25.w,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Your order placed successfully',
                                                      style: mainStyle(15.0,
                                                          FontWeight.w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }));
                                  Future.delayed(Duration(milliseconds: 3000))
                                      .then((value) => Navigator.of(context)
                                        ..pop()
                                        ..pop());
                                });

                                return NavigationDecision.prevent;
                              } else if (request.url
                                  .startsWith(backRedirectPayLink)) {
                                logg(
                                    'payment canceled so navigate to the previous screen');

                                Navigator.of(context).pop();
                                return NavigationDecision.prevent;
                              } else if (request.url
                                  .startsWith(failRedirectPayLink)) {
                                logg(
                                    'payment canceled so navigate to the previous screen');
                                Navigator.of(context).pop();
                                return NavigationDecision.prevent;
                              } else {
                                logg('payment redirected');
                                return NavigationDecision.navigate;
                              }
                            } else if (widget.paymentMethod == 'postpay') {
                              if (request.url
                                  .startsWith(successRedirectPostPayPayLink)) {
                                logg('blocking navigation to $request}');

                                paymentCubit
                                    .callSucessPlaceOrder('postpay')
                                    .then((value) {
                                  CartCubit.get(context)
                                      .getCartDetails(updateAllList: true)
                                      .then((value) {
                                    return null;
                                  });

                                  showTopModalSheet<String>(context,
                                      Builder(builder: (context) {
                                    return Container(
                                      margin: EdgeInsets.only(top: 20.h),
                                      color: Colors.white.withOpacity(0.8),
                                      height: 120.h,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 25.w,
                                                  ),
                                                  SizedBox(
                                                    height: 25.w,
                                                    width: 25.w,
                                                    child: Lottie.asset(
                                                        'assets/images/public/lf30_editor_c6ebyow8.json',
                                                        width: 25.w,
                                                        height: 25.w),
                                                  ),
                                                  SizedBox(
                                                    width: 25.w,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Your order placed successfully',
                                                      style: mainStyle(15.0,
                                                          FontWeight.w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }));
                                  Future.delayed(Duration(milliseconds: 3000))
                                      .then((value) => Navigator.of(context)
                                        ..pop()
                                        ..pop());
                                });

                                return NavigationDecision.prevent;
                              } else if (request.url
                                  .startsWith(backRedirectPpostPayPayLink)) {
                                logg(
                                    'payment canceled so navigate to the previous screen');

                                Navigator.of(context).pop();
                                return NavigationDecision.prevent;
                              } else if (request.url
                                  .startsWith(failRedirectPostPayPayLink)) {
                                logg(
                                    'payment canceled so navigate to the previous screen');
                                Navigator.of(context).pop();
                                return NavigationDecision.prevent;
                              } else {
                                logg('payment redirected');
                                return NavigationDecision.navigate;
                              }
                            } else {
                              return NavigationDecision.navigate;
                            }
                          },
                          onPageStarted: (String url) {
                            paymentCubit.changeLoadingCardStatus(true);
                            logg('Page started loading: $url');
                          },
                          onPageFinished: (String url) {
                            paymentCubit.changeLoadingCardStatus(false);

                            logg('Page finished loading: $url');
                          },
                          gestureNavigationEnabled: true,
                          backgroundColor: const Color(0x00000000),
                        ),
                        !isLoadedValue
                            ?  const DefaultLoader()
                            : const SizedBox.shrink(),
                      ],
                    ),
                  );
                });
          }),
        ));
  }

  JavascriptChannel _toasterJavascriptChannel(
      BuildContext context, PaymentCubit cubit) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          logg('message: ' + message.message);
          if (message.message.startsWith('card_info -')) {
            logg('successfuly got the card info');
          }
        });
  }
}
