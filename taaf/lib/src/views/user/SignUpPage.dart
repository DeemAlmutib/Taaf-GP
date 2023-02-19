import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taaf/homepage.dart';
import 'package:taaf/src/base/showToast.dart';
import 'package:taaf/src/controllers/user/SignUpController.dart';
import 'package:taaf/welcomePage.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../newNavigation.dart';
import '../../controllers/AuthController.dart';
import '../../helper/Dimensions.dart';
import '../widgets/AppDateFormField.dart';
import '../widgets/AppDropDownFormField.dart';
import '../widgets/AppLoadingIndicator.dart';
import '../widgets/AppPhoneWithContryCodeWeight.dart';
import '../widgets/AppSmallTextWidget.dart';
import '../widgets/AppTextFormField.dart';
import 'instructions.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  SignUpController signUpController = SignUpController();
  bool newPhoneNumberVerifed = false;

  @override
  void initState() {
    signUpController.userModel.gender = signUpController.gender;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: Image.asset('assets/Images/white_logo3.png',
            height: 90, alignment: FractionalOffset.center),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // automaticallyImplyLeading: true,
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 1,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/Images/edit profile_no logo.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: dimensions.screenHeigh * 0.005,
                ),
                Text(
                  'إنشاء حساب',
                  style: FlutterFlowTheme.of(context).title1.override(
                        fontFamily: 'Tajawal',
                        color: FlutterFlowTheme.of(context).primaryBtnText,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  height: dimensions.height10 * 13,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      AppTextFormField(
                        hintText: "الاسم",
                        onSave: (value) {
                          signUpController.userModel.name = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "يجب ملء هذا الحقل";
                          String pattern =
                              r'^(?=.{2,20}$)[\u0621-\u064Aa-zA-Z\d\-_\s]+$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value.trim()))
                            return '  يجب أن يحتوي اسم المستخدم على حرفين على الاقل وأن لايتجاوز ٢٠ حرف ';
                          return null;
                        },
                        textEditingController:
                            signUpController.nameEditingController,
                      ),
                      SizedBox(
                        height: dimensions.height20,
                      ),
                      AppPhoneWithContryCodeWeight(
                        countryCode: signUpController.phoneCode,
                        textEditingController:
                            signUpController.phoneEditingController,
                        onSave: (value) {
                          signUpController.phoneCode = value;
                          signUpController.userModel.phoneCode = value;
                          signUpController.userModel.phone = signUpController
                              .phoneEditingController.text
                              .trim();
                        },
                      ),
                      SizedBox(
                        height: dimensions.height20,
                      ),
                      AppDateFormField(
                        hintText: "تاريخ الميلاد",
                        textEditingController:
                            signUpController.birthDateEditingController,
                        validator: (value) {
                          return null;
                        },
                        onSave: (value) {
                          signUpController.userModel.birthDate = value;
                        },
                      ),
                      SizedBox(
                        height: dimensions.height20,
                      ),
                      AppDropDownFormField(
                        hintText: "الجنس",
                        onChanged: (value) {
                          setState(() {
                            signUpController.gender = value;
                            signUpController.userModel.gender = value;
                          });
                        },
                        items: signUpController.genderItems,
                        initialValue: signUpController.gender,
                      ),
                      SizedBox(
                        height: dimensions.height10 * 3,
                      ),
                      signUpController.isLoading
                          ? AppLoadingIndicator(
                              text: "جاري ارسال البيانات",
                            )
                          : FFButtonWidget(
                              onPressed: () async {
                                formKey.currentState?.save();
                                signUpController.userModel.phone =
                                    signUpController.phoneEditingController.text
                                        .trim();
                                String validationStatus = await signUpController
                                    .validateSignUpForm(context);

                                if (validationStatus == "") {
                                  appShowSnackBar(
                                          context,
                                          "تم إرسال رمز التحقق إلى هاتفك",
                                          false)
                                      .then((value) async {
                                    await showChangeNumberDialog(
                                            dimensions, signUpController)
                                        .then((value) {
                                      if (newPhoneNumberVerifed == true) {
                                        // Navigator.of(context).pushReplacement(
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             MainPage()));
                                                     Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    App()));
                                                    
                                      }
                                    });
                                  });
                                } else if (validationStatus != " ") {
                                  appShowSnackBar(
                                      context, validationStatus, true);
                                }
                              },
                              text: 'إنشاء حساب',
                              options: FFButtonOptions(
                                width: dimensions.width10 * 22,
                                height: dimensions.height10 * 6,
                                color: Color(0xFF007282),
                                textStyle: FlutterFlowTheme.of(context)
                                    .subtitle2
                                    .override(
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
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future showChangeNumberDialog(
          Dimensions dimensions, SignUpController signUpController) =>
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (
            context,
          ) {
            return StatefulBuilder(builder: (context, setState) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                /* */
                child: AlertDialog(
                  title: AppSmallTextWidget(
                      text: "تأكيد رقم الهاتف ", size: dimensions.font18),
                  content: Container(
                    height: dimensions.height10 * 7,
                    width: double.maxFinite,
                    child: Column(children: [
                      AppTextFormField(
                          hintText: "رمز التحقق",
                          onSave: () {},
                          validator: () {},
                          textInputType: TextInputType.number,
                          textEditingController:
                              signUpController.otpEditingController)
                    ]),
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        "الغاء",
                        style: GoogleFonts.tajawal(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF007282)),
                      ),
                      onPressed: () {
                        newPhoneNumberVerifed = false;
                        signUpController.otpEditingController.text = "";
                        Navigator.pop(context, false);
                        signUpController.isOTPVerficationLoading = false;
                      },
                    ),
                    if (signUpController.isOTPVerficationLoading == false)
                      TextButton(
                        child: Text(
                          "تحقق",
                          style: GoogleFonts.tajawal(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF007282)),
                        ),
                        onPressed: () async {
                          if (signUpController.otpEditingController.text
                                  .trim()
                                  .isNotEmpty &&
                              signUpController.otpEditingController.text
                                      .trim()
                                      .length ==
                                  6) {
                            setState(() {
                              signUpController.isOTPVerficationLoading = true;
                            });

                            signUpController
                                .verfiyOTP(
                                    signUpController.otpEditingController.text
                                        .trim(),
                                    context,
                                    signUpController.userModel)
                                .then((value) {
                              if (value) {
                                setState(() {
                                  signUpController.isOTPVerficationLoading =
                                      false;
                                  newPhoneNumberVerifed = true;
                                  Navigator.pop(context, false);
                                });
                              } else {
                                setState(() {
                                  signUpController.isOTPVerficationLoading =
                                      false;
                                });
                              }
                            });
                          } else {
                            appShowSnackBar(
                                context,
                                "رمز التحقق يجب ان يكون 6 ارقام , يرجى التأكد من رمز التحقق والمحاولة مرة أخرى",
                                true);
                          }
                        },
                      ),
                    if (signUpController.isOTPVerficationLoading == true)
                      AppLoadingIndicator(
                        text: "",
                      ),
                  ],
                ),
              );
            });
          });
}
