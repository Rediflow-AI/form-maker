import 'package:flutter/material.dart';
import 'constants.dart';

InputDecoration elegantInputDecoration({
  String? hintText,
  Widget? prefix,
  Widget? suffix,
  bool isSpinner = false,
}) {
  return InputDecoration(
    hintText: hintText,
    prefixIcon: prefix,
    suffixIcon: suffix,
    border: OutlineInputBorder(
      borderRadius: primaryBorderRadius,
      borderSide: const BorderSide(color: primaryGray, width: 0.6),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: primaryBorderRadius,
      borderSide: const BorderSide(color: primaryGray, width: 0.6),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: primaryBorderRadius,
      borderSide: const BorderSide(color: primaryActiveColor, width: 1.2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: primaryBorderRadius,
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: primaryBorderRadius,
      borderSide: const BorderSide(color: Colors.red, width: 1.2),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(
      horizontal: normalPadding,
      vertical: isSpinner ? smallPadding : normalPadding,
    ),
  );
}
