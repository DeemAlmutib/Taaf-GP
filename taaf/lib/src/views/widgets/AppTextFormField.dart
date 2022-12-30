import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:taaf/flutter_flow/flutter_flow_util.dart';
import 'package:taaf/src/helper/Dimensions.dart';

class AppTextFormField extends StatelessWidget {
  AppTextFormField(
      {Key? key,
      required this.hintText,
      this.initialValue,
      required this.onSave,
      required this.validator,
      this.enabled = true,
      required this.textEditingController,
      this.textInputType = TextInputType.text})
      : super(key: key);

  String hintText;
  bool enabled;
  String? initialValue;
  final Function onSave;
  final Function validator;
  TextEditingController textEditingController;
  TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    if (initialValue != null &&
        initialValue!.isNotEmpty &&
        textEditingController.text.trim().isEmpty) {
      textEditingController.text = initialValue!;
    }
    // print(initialValue);
    // print(textEditingController.text.trim().isEmpty);
    // print(textEditingController.text.isEmpty);
    // print(textEditingController.text);
    return Container(
      width: dimensions.width300,
      height: dimensions.height59_9,
      margin: EdgeInsets.only(
          right: dimensions.height15 * 3, left: dimensions.height15 * 3),
      child: Directionality(
        //   textDirection: TextDirection.rtl,
        textDirection: ui.TextDirection.rtl,

        child: TextFormField(
          textAlign: TextAlign.right,
          keyboardType: textInputType,
          controller: textEditingController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 239, 237, 237),
            hintText: hintText,
            enabled: enabled,
            contentPadding: EdgeInsets.symmetric(
                vertical: dimensions.height25, horizontal: dimensions.width10),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(dimensions.width10 * 3),
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 236, 231, 231),
                  width: 3,
                )),
            focusedBorder: OutlineInputBorder(
              borderSide: new BorderSide(color: Color(0x5A000000)),
              borderRadius: BorderRadius.circular(dimensions.width25 * 4),
            ),
          ),
          validator: (value) {
            validator(value);
          },
          onSaved: (value) {
            onSave(value);
          },
        ),
      ),
    );
  }
}
