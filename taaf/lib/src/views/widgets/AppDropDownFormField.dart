import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:taaf/flutter_flow/flutter_flow_util.dart';
import 'package:taaf/src/helper/Dimensions.dart';

class AppDropDownFormField extends StatelessWidget {
  AppDropDownFormField({
    Key? key,
    required this.hintText,
    this.initialValue,
    required this.onChanged,
    this.enabled = true,
    required this.items,
  }) : super(key: key);

  String hintText;
  bool enabled;
  String? initialValue;
  final Function onChanged;
  List<DropdownMenuItem<String>> items;
  final dropdownState = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    // print(initialValue);
    if (initialValue != null && initialValue!.isEmpty) {
      initialValue = null;
    } 

    return Container(
      width: dimensions.width300,
      height: dimensions.height55,
      margin: EdgeInsets.only(
          right: dimensions.width15 * 3, left: dimensions.width15 * 3),
      child: SingleChildScrollView(
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: DropdownButtonFormField(
              key: dropdownState,
              value: initialValue,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 239, 237, 237),
                hintText: hintText,
                enabled: enabled,
                contentPadding: EdgeInsets.symmetric(
                    vertical: dimensions.height15,
                    horizontal: dimensions.width10),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(dimensions.width10 * 3),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 236, 231, 231),
                      width: 3,
                    )),
                focusedBorder: OutlineInputBorder(
                  borderSide: new BorderSide(color: Color(0x5A000000)),
                  borderRadius: BorderRadius.circular(dimensions.width10 * 10),
                ),
              ),
              dropdownColor: Color.fromARGB(255, 239, 237, 237),
              // value: initialValue,
              onChanged: (String? newValue) {
                onChanged(newValue);
              },
              items: items),
        ),
      ),
    );
  }
}
