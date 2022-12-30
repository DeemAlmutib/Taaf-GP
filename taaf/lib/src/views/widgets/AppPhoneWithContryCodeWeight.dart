import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../helper/Dimensions.dart';

class AppPhoneWithContryCodeWeight extends StatelessWidget {
  AppPhoneWithContryCodeWeight(
      {Key? key,
      required this.countryCode,
      required this.textEditingController,
      required this.onSave})
      : super(key: key);

  final String? countryCode;
  TextEditingController textEditingController;
  Function onSave;

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return Container(
      width: dimensions.width300,
      height: dimensions.height59_9,
      decoration: BoxDecoration(
        color: Color(0xFFECECEC),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Color.fromARGB(65, 0, 0, 0),
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
        borderRadius: BorderRadius.circular(dimensions.width10 * 3),
      ),
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: dimensions.width10 * 10,
            child: CountryCodePicker(
              textStyle: FlutterFlowTheme.of(context).bodyText2.override(
                    fontFamily: 'Tajawal',
                    color: Color(0xC157636C),
                    fontSize: dimensions.font16 * 1.5,
                    fontWeight: FontWeight.w600,
                  ),
              onChanged: (Object? object) {
                String line = "$object";
                onSave(line);
                // _authController.countryPhoneCode = line;
                // AppShowToast(text: line);
              },
              onInit: (Object? object) {
                String line = "$object";
                onSave(line);
                // _authController.countryPhoneCode = line;

                // AppShowToast(text: line);
              },
              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
              initialSelection: countryCode,
              favorite: ['+966', 'KSA'],
              // optional. Shows only country name and flag
              showCountryOnly: false,
              showFlag: false,
              showDropDownButton: true,
              // optional. Shows only country name and flag when popup is closed.
              showOnlyCountryWhenClosed: false,
              // optional. aligns the flag and the Text left
              alignLeft: false,
            ),
          ),
          SizedBox(
            height: dimensions.height10 * 2,
            child: VerticalDivider(
              thickness: 2,
            ),
          ),
          Container(
            width: dimensions.width10 * 7,
            child: TextFormField(
              controller: textEditingController,
              
              // autofocus: true,
              obscureText: false,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0, fontSize: dimensions.font10),
                hintText: '5XXXXXXXX',
                hintStyle: FlutterFlowTheme.of(context).bodyText2.override(
                      fontFamily: 'Tajawal',
                      color: Color(0xC157636C),
                      fontSize: dimensions.font16,
                      fontWeight: FontWeight.w600,
                    ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
              style: FlutterFlowTheme.of(context).bodyText1.override(
                    fontFamily: 'Tajawal',
                    color: Color.fromARGB(193, 108, 99, 87),
                    fontSize: dimensions.font16 * 1.5,
                    fontWeight: FontWeight.w600,
                  ),
              keyboardType: TextInputType.phone,
              autovalidateMode: AutovalidateMode.disabled,
              validator: (value) {
                if (value!.length == 0) {
                  return "يجب ملء هذا الحقل";
                } else if (value.length != 9) {
                  return "الرجاء إدخال رقم الهاتف صحيح";
                } else {
                  return null;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
