import 'package:flutter/material.dart';

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
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blue, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 2.0),
    ),
    filled: true,
    fillColor: Colors.grey[50],
    hintStyle: TextStyle(
      color: Colors.grey[500],
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16,
      vertical: isSpinner ? 12 : 16,
    ),
  );
}
