import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void AppShowToast(
    {required String text, ToastGravity position = ToastGravity.CENTER}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.black.withOpacity(0.8),
      gravity: position);
}
