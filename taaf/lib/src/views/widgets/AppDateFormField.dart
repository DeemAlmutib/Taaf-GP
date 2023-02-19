import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:taaf/flutter_flow/flutter_flow_util.dart';

import '../../helper/Dimensions.dart';

class AppDateFormField extends StatelessWidget {
  AppDateFormField(
      {Key? key,
      required this.hintText,
      this.initialValue,
      required this.onSave,
      required this.validator,
      this.enabled = true,
      required this.textEditingController})
      : super(key: key);

  String hintText;
  bool enabled;
  String? initialValue;
  final Function onSave;
  final Function validator;
  TextEditingController textEditingController;
  var nowDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    if (initialValue != null &&
        initialValue!.isNotEmpty &&
        textEditingController.text.isEmpty) {
      textEditingController.text = initialValue!;
    }
    return Container(
      width: dimensions.width300,
      height: dimensions.height55,
      margin: EdgeInsets.only(
          right: dimensions.width15 * 3, left: dimensions.width15 * 3),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 239, 237, 237),
        borderRadius: BorderRadius.circular(dimensions.width10 * 10),
        boxShadow: [
          BoxShadow(
              color: Color.fromARGB(255, 236, 231, 231),
              blurRadius: 1,
              offset: Offset(0, 3) // changes position of shadow
              ),
          BoxShadow(
              color: Color.fromARGB(255, 236, 231, 231),
              blurRadius: 1,
              offset: Offset(-3, 0) // changes position of shadow
              ),
          BoxShadow(
              color: Color.fromARGB(255, 236, 231, 231),
              blurRadius: 1,
              offset: Offset(3, 0) // changes position of shadow
              ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: dimensions.width10,
          ),
          GestureDetector(
            onTap: () async {
              // textEditingController.text = 'dddd';
              DateTime? date = DateTime(DateTime.now().year);
              FocusScope.of(context).requestFocus(new FocusNode());
              date = await showDatePicker(
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                locale: const Locale("ar", "AR"),
                context: context,
                initialDate: textEditingController.text.isEmpty != true
                    ? DateTime.parse(textEditingController.text)
                    : nowDate,
                firstDate: DateTime(1900),
                lastDate: nowDate,
                builder: (context, child) => Theme(
                  data: ThemeData().copyWith(
                      colorScheme:
                          ColorScheme.light(primary: Color(0xFF007282))),
                  child: child!,
                ),
              );

              if (date != null) {
                textEditingController.text =
                    DateFormat('yyyy-MM-dd').format(date);
                print(textEditingController.text);
              } else {
                print('empty');
              }
            },
            child: Icon(
              Icons.calendar_month,
              size: dimensions.icon25,
              color: Colors.grey,
            ),
          ),
          Directionality(
            //   textDirection: TextDirection.rtl,
            textDirection: ui.TextDirection.rtl,
            child: Expanded(
              child: TextFormField(
                textAlign: TextAlign.right,
                readOnly: true,
                //  controller: OTPController,

                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 239, 237, 237),

                  hintText: hintText,
                  enabled: enabled,

                  //contentPadding: const EdgeInsets.only(
                  // left: 12.0, right: 14.0, bottom: 8.0, top: 8.0),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: dimensions.height25,
                      horizontal: dimensions.width10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(dimensions.width10 * 3),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 236, 231, 231),
                      width: 0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Color(0x5A000000)),
                    borderRadius:
                        BorderRadius.circular(dimensions.width10 * 10),
                  ),
                ),
                controller: textEditingController,
                validator: (value) {
                  return validator(value);
                },
                onSaved: (value) {
                  onSave(value);
                },

                onTap: () async {
                  // textEditingController.text = 'dddd';
                  DateTime? date = DateTime(DateTime.now().year);
                  FocusScope.of(context).requestFocus(new FocusNode());
                  date = await showDatePicker(
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    locale: const Locale("ar", "AR"),
                    context: context,
                    initialDate: textEditingController.text.isEmpty != true
                        ? DateTime.parse(textEditingController.text)
                        : nowDate,
                    firstDate: DateTime(1900),
                    lastDate: nowDate,
                    builder: (context, child) => Theme(
                      data: ThemeData().copyWith(
                          colorScheme:
                              ColorScheme.light(primary: Color(0xFF007282))),
                      child: child!,
                    ),
                  );

                  if (date != null) {
                    textEditingController.text =
                        DateFormat('yyyy-MM-dd').format(date);
                    print(textEditingController.text);
                  } else {
                    print('empty');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}
