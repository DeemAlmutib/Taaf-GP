import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taaf/src/controllers/AuthController.dart';
import 'package:taaf/src/helper/Dimensions.dart';

import '../flutter_flow/flutter_flow_drop_down.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../src/base/showToast.dart';
import '../verifyPhone.dart';
import '../welcomePage.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({Key? key}) : super(key: key);

  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  String? dropDownValue;
  TextEditingController textController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Color.fromARGB(255, 248, 252, 255),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => WelcomePageWidget()));
          },
        ),
      ),
      key: scaffoldKey,
      backgroundColor: Color(0xFF14181B),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: dimensions.screenHeigh,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 19, 20, 21),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset(
              'assets/images/background_(1).png',
            ).image,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: dimensions.height10 * 10,
              ),
              Text(
                'تسجيل الدخول',
                style: FlutterFlowTheme.of(context).title1.override(
                      fontFamily: 'Tajawal',
                      color: FlutterFlowTheme.of(context).primaryBtnText,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: dimensions.screenHeigh / 2.5,
              ),
              Text(
                'تسجيل الدخول برقم الهاتف',
                style: FlutterFlowTheme.of(context).title1.override(
                      fontFamily: 'Tajawal',
                      color: Color(0xFF007282),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: dimensions.height20,
              ),
              Container(
                width: dimensions.screenWidth,
                height: dimensions.height10 * 15,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 280,
                      height: 53.9,
                      decoration: BoxDecoration(
                        color: Color(0xFFECECEC),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x5A000000),
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Form(
                            key: formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 100,
                                  child: CountryCodePicker(
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyText2
                                        .override(
                                          fontFamily: 'Tajawal',
                                          color: Color(0xC157636C),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    onChanged: (Object? object) {
                                      String line = "$object";
                                      _authController.countryPhoneCode = line;
                                      // AppShowToast(text: line);
                                    },
                                    onInit: (Object? object) {
                                      String line = "$object";
                                      _authController.countryPhoneCode = line;

                                      // AppShowToast(text: line);
                                    },
                                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                    initialSelection: '+966',
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
                                  height: 30,
                                  child: VerticalDivider(
                                    thickness: 2,
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  decoration: BoxDecoration(),
                                  child: Container(
                                    width: 70,
                                    child: TextFormField(
                                      controller: textController,
                                      // autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        errorStyle:
                                            TextStyle(height: 0, fontSize: 10),
                                        hintText: '5XXXXXXXX',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyText2
                                            .override(
                                              fontFamily: 'Tajawal',
                                              color: Color(0xC157636C),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Tajawal',
                                            color: Color(0xC157636C),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                      keyboardType: TextInputType.phone,
                                      autovalidateMode:
                                          AutovalidateMode.disabled,
                                      validator: (value) {
                                        if (value!.length == 0) {
                                          return "يجب ملء هذا الحقل";
                                        } else if (value.length != 9) {
                                          return " رقم الهاتف يجب ان يتكون من 9 أرقام";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        textController.text = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 221.8,
                      height: 77.8,
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 25, 20, 5),
                        child: FFButtonWidget(
                          onPressed: () async {
                            var validator = formKey.currentState?.validate();
                            if (validator != null && validator == true) {
                              bool allGood =
                                  await _authController.phoneAuthentication(
                                      textController.text.toString().trim(),
                                      scaffoldKey.currentState!.context);
                              if (allGood) {
                                //  AppShowToast(text: "تم إرسال رمز التحقق");
                                appShowSnackBar(
                                        context, 'تم إرسال رمز التحقق', false)
                                    .then((value) {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (context) => verifyloginPage(
                                                authController: _authController,
                                              )));
                                });
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(
                                //     content: Text('تم إرسال رمز التحقق',
                                //         style: TextStyle(fontSize: 18),
                                //         textAlign: TextAlign.right),
                                //   ),
                                // );

                              } else {
                                // AppShowToast(text: "error");
                              }
                              // AppShowToast(text: "all good");
                            }
                            //setState(() {
                            //    if(_formkey.currentState.validate()){}
                            //  });

                            // AppShowToast(
                            //     text: _authController.countryPhoneCode +
                            //         phoneController.text.trim());
                            // Navigator.of(context).pushReplacement(MaterialPageRoute(
                            //     builder: (context) => verifyloginPage()));
                            print('Button pressed ...');
                          },
                          text: 'تسجيل ',
                          options: FFButtonOptions(
                            width: 10,
                            height: 10,
                            color: Color(0xFF007282),
                            textStyle:
                                FlutterFlowTheme.of(context).subtitle2.override(
                                      fontFamily: 'Tajawal',
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: 30, //BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
