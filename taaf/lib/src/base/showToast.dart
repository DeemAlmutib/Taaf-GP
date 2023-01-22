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

Future<bool> appShowSnackBar(BuildContext context, String text, bool isError) {
  if (isError) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(text,
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    // fontStyle: FontStyle.italic,
                    color: Colors.red),
                textAlign: TextAlign.right),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
          ),
        )
        .closed
        .then((value) {
      return true;
    });
  } else {
    return ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(text,
                style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
          ),
        )
        .closed
        .then((value) {
      return true;
    });
  }
}
