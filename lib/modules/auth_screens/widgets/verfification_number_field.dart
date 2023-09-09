import 'package:clearance/core/cache/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../../../core/styles_colors/styles_colors.dart';


class VerificationNumberFields extends StatefulWidget {
  const VerificationNumberFields({
    Key? key,
     this.onCompleted,
    this.validator,
     this.onChanged,
  }) : super(key: key);

  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  State<VerificationNumberFields> createState() => _VerificationNumberFieldsState();
}

class _VerificationNumberFieldsState extends State<VerificationNumberFields> {
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: mainStyle(15.0, FontWeight.w600),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      borderRadius: BorderRadius.circular(10),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(),
    );

    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        validator: widget.validator,
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        showCursor: true,
        pinAnimationType: PinAnimationType.slide,
        onCompleted: widget.onCompleted,
        onChanged: widget.onChanged,
        length: 6,
        keyboardType: TextInputType.number,
      ),
    );
  }
}
