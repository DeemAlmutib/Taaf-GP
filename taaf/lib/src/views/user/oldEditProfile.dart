import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taaf/src/controllers/AuthController.dart';

import '../../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';
import '../../../../flutter_flow/flutter_flow_widgets.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../src/base/showToast.dart';
import '../../../../verifyPhone.dart';
import '../../../../welcomePage.dart';
import 'dart:ui' as ui;

import '../../../homePage.dart';
import '../../controllers/user/editProfileController.dart';
import '../widgets/AppDateFormField.dart';

class editProfile extends StatefulWidget {
  const editProfile({Key? key}) : super(key: key);

  @override
  _editProfileWidgetState createState() => _editProfileWidgetState();
}

class _editProfileWidgetState extends State<editProfile> {
  EditProfileController editProfileController = EditProfileController();

  String? dropDownValue;
  TextEditingController textEditingController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController username = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  final AuthController _authController = AuthController();

  String dropdownValue = 'انثى';
  String? countryCode;
  @override
  void initState() {
    nameController = TextEditingController();
    editProfileController.getProfileData().then((value) {
      setValues();
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController?.dispose();
    super.dispose();
  }

  void setValues() {
    setState(() {
      countryCode = editProfileController.userModel.phoneCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(editProfileController.userModel);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Color.fromARGB(255, 248, 252, 255),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => WelcomePage()));
          },
        ),
      ),
      key: scaffoldKey,
      backgroundColor: Color(0xFF14181B),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: BoxDecoration(
            color: Color(0xFF14181B),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/backgroundEdit.jpg',
              ).image,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(-0.1, -0.55),
                child: Container(
                  width: 389.1,
                  height: 150.1,
                  decoration: BoxDecoration(),
                  child: Align(
                    alignment: AlignmentDirectional(0, 0.35),
                    child: Center(),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 300,
                height: 53.9,
                margin: EdgeInsets.only(right: 45, left: 45),
                child: Directionality(
                  //   textDirection: TextDirection.rtl,
                  textDirection: ui.TextDirection.rtl,

                  child: TextFormField(
                    textAlign: TextAlign.right,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 239, 237, 237),

                      hintText: '  الإسم ',
                      enabled: true,
                      //contentPadding: const EdgeInsets.only(
                      // left: 12.0, right: 14.0, bottom: 8.0, top: 8.0),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 10.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 236, 231, 231),
                            width: 3,
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Color(0x5A000000)),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "يجب ملء هذا الحقل";
                      String pattern =
                          r'^(?=.{2,20}$)[\u0621-\u064Aa-zA-Z\d\-_\s]+$';
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(value.trim()))
                        return '  يجب أن يحتوي اسم المستخدم على حرفين على الاقل وأن لايتجاوز ٢٠حرف ';
                      return null;
                    },
                    onSaved: (value) {
                      //   OTPController.text = value!;
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 19,
              ),
              Container(
                width: 385.3,
                height: 300,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 300,
                      height: 53.9,
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
                                      // controller: textController,
                                      autofocus: true,
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
                                            color: Color.fromARGB(
                                                193, 108, 99, 87),
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
                                          return "الرجاء إدخال رقم الهاتف صحيح";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        // textController.text = value!;
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
                    SizedBox(
                      height: 19,
                    ),
                    AppDateFormField(
                      hintText: "تاريخ الميلاد",
                      initialValue: '2022-12-14',
                      textEditingController: dateController,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "يجب ملء هذا الحقل";
                        String pattern =
                            r'^(?=.{2,20}$)[\u0621-\u064Aa-zA-Z\d\-_\s]+$';
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(value.trim()))
                          return '  يجب أن يحتوي اسم المستخدم على حرفين على الاقل وأن لايتجاوز ٢٠حرف ';
                        return null;
                      },
                      onSave: (value) {},
                    ),
                    SizedBox(
                      height: 19,
                    ),
                    Container(
                      width: 300,
                      height: 53.9,
                      margin: EdgeInsets.only(right: 45, left: 45),
                      child: SingleChildScrollView(
                        child: Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 239, 237, 237),

                                hintText: '  الإسم ',
                                enabled: true,
                                //contentPadding: const EdgeInsets.only(
                                // left: 12.0, right: 14.0, bottom: 8.0, top: 8.0),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 236, 231, 231),
                                      width: 3,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Color(0x5A000000)),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              dropdownColor: Color.fromARGB(255, 239, 237, 237),
                              value: "انثى",
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: editProfileController.genderItems),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 19,
                    ),
                    Container(
                      width: 221.8,
                      height: 77.8,
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 25, 20, 5),
                        child: FFButtonWidget(
                          onPressed: () async {
                            // var validator = formKey.currentState?.validate();
                            // if (validator != null && validator == true) {
                            //   bool allGood =
                            //       await _authController.phoneAuthentication(
                            //           textController.text.toString().trim(),
                            //           context);
                            //   if (allGood) {
                            //     AppShowToast(text: "تم إرسال رمز التحقق");
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       const SnackBar(
                            //         content: Text('تم إرسال رمز التحقق',
                            //             style: TextStyle(fontSize: 18),
                            //             textAlign: TextAlign.right),
                            //       ),
                            //     );
                            //     Navigator.of(context)
                            //         .pushReplacement(MaterialPageRoute(
                            //             builder: (context) => verifyloginPage(
                            //                   authController: _authController,
                            //                 )));
                            //   } else {
                            //     AppShowToast(text: "error");
                            //   }
                            //   // AppShowToast(text: "all good");
                            // }
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
                          text: 'حفظ ',
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
                            borderRadius: 30,
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

  
  // if the user clicks on the back button without saving the changes 
    showAlertDialogg(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "لا",
        style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "نعم ",
        style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        textAlign: TextAlign.right,
      ),
      onPressed: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>homePage() ));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: Text(
        "هل أنت متأكد من العوده دون حفظ التغيرات ",
        style: GoogleFonts.tajawal(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}


