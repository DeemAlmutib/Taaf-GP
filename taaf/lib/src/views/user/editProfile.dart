import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taaf/src/controllers/AuthController.dart';
import 'package:taaf/src/helper/Dimensions.dart';
import 'package:taaf/src/models/user_model.dart';
import 'package:taaf/src/views/user/profilePage.dart';
import 'package:taaf/src/views/widgets/AppButtonWeiget.dart';
import 'package:taaf/src/views/widgets/AppDropDownFormField.dart';
import 'package:taaf/src/views/widgets/AppLoadingIndicator.dart';
import 'package:taaf/src/views/widgets/AppSmallTextWidget.dart';
import 'package:taaf/src/views/widgets/AppTextFormField.dart';
import 'package:taaf/src/views/widgets/AppTextWeight.dart';

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
import '../widgets/AppPhoneWithContryCodeWeight.dart';

class editProfile extends StatefulWidget {
  editProfile({Key? key, required this.editProfileController})
      : super(key: key);
  EditProfileController editProfileController;

  @override
  _editProfileWidgetState createState() => _editProfileWidgetState();
}

class _editProfileWidgetState extends State<editProfile> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  AuthController authController = AuthController();
  bool newPhoneNumberVerifed = false;

  @override
  void initState() {
    widget.editProfileController.phoneEditingController.text =
        widget.editProfileController.userModel.phone!;
    if (widget.editProfileController.userModel.gender != null &&
        widget.editProfileController.userModel.gender!.isNotEmpty) {
      widget.editProfileController.gender =
          widget.editProfileController.userModel.gender!;
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(editProfileController.userModel);
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Color.fromARGB(255, 248, 252, 255),
          onPressed: () async {
            if (widget.editProfileController.checkChanges()) {
              await showAlertDialogg(context);
            } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            }
          },
        ),
      ),
      key: scaffoldKey,
      backgroundColor: Color(0xFF14181B),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: dimensions.screenHeigh,
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
                  SizedBox(
                    height: 120,
                  ),
                  AppTextWeight(
                      text: "تعديل الملف الشخصي", fontSize: dimensions.font36),
                  SizedBox(
                    height: 100,
                  ),
                  AppTextFormField(
                      hintText: "الاسم",
                      onSave: (value) {},
                      initialValue:
                          widget.editProfileController.userModel.name ?? "",
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
                      textEditingController:
                          widget.editProfileController.nameEditingController),
                  SizedBox(
                    height: dimensions.height20,
                  ),
                  AppPhoneWithContryCodeWeight(
                    countryCode:
                        widget.editProfileController.userModel.phoneCode ??
                            "+966",
                    textEditingController:
                        widget.editProfileController.phoneEditingController,
                    onSave: (value) {
                      widget.editProfileController.phoneCode = value;
                    },
                  ),
                  SizedBox(
                    height: dimensions.height20,
                  ),
                  AppDateFormField(
                    hintText: "تاريخ الميلاد",
                    initialValue:
                        widget.editProfileController.userModel.birthDate !=
                                    null &&
                                widget.editProfileController.userModel
                                    .birthDate!.isNotEmpty
                            ? widget.editProfileController.userModel.birthDate
                            : "",
                    textEditingController:
                        widget.editProfileController.birthDateEditingController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "يجب ملء هذا الحقل";
                      } else {
                        return null;
                      }
                    },
                    onSave: (value) {},
                  ),
                  SizedBox(
                    height: dimensions.height20,
                  ),
                  AppDropDownFormField(
                      hintText: "الجنس",
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          widget.editProfileController.gender = value;
                        });
                      },
                      items: widget.editProfileController.genderItems,
                      initialValue: widget.editProfileController.gender),
                  SizedBox(
                    height: dimensions.height20,
                  ),
                  widget.editProfileController.isEditProfileLoading
                      ? AppLoadingIndicator(
                          text: "جاري ارسال البيانات",
                        )
                      : AppButtonWeiget(
                          text: "حفظ",
                          onPressed: () async {
                            if (widget.editProfileController
                                    .phoneEditingController.text
                                    .trim()
                                    .length <
                                9) {
                              appShowSnackBar(
                                  context, "رقم الهاتف يجب ان يكون 9 ارقام ");
                              return;
                            }

                            if (widget.editProfileController.userModel.phone ==
                                    widget.editProfileController
                                        .phoneEditingController.text
                                        .trim() &&
                                widget.editProfileController.userModel
                                        .phoneCode ==
                                    widget.editProfileController.phoneCode) {
                              newPhoneNumberVerifed = true;
                            } else {
                              bool phoneAvailability = await authController
                                  .checkPhoneNumberAvailability(
                                      phoneNumber: widget.editProfileController
                                          .phoneEditingController.text
                                          .trim(),
                                      phoneCode: widget
                                          .editProfileController.phoneCode);
                              if (phoneAvailability) {
                                widget.editProfileController
                                    .verficationDialogStep = 0;
                                newPhoneNumberVerifed = false;
                                widget.editProfileController
                                    .otpEditingController.text = "";
                                widget.editProfileController.isSendOtpLoading =
                                    false;
                                widget.editProfileController
                                    .isOTPVerficationLoading = false;
                                await showChangeNumberDialog(
                                    dimensions, widget.editProfileController);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'رقم الهاتف المدخل مستخدم بالفعل !',
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.right),
                                  ),
                                );
                                return;
                              }
                            }

                            if (newPhoneNumberVerifed) {
                              setState(() {
                                widget.editProfileController
                                    .isEditProfileLoading = true;
                              });
                              await widget.editProfileController
                                  .updateUserData()
                                  .then((value) {
                                if (value) {
                                  widget.editProfileController
                                      .isEditProfileLoading = false;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'تم تعديل الملف الشخصي بنجاح',
                                          style: TextStyle(fontSize: 18),
                                          textAlign: TextAlign.right),
                                    ),
                                  );
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage()));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'حصل خطأ اثناء تعديل الملف الشخصي يرجى المحاولة مره اخرى !',
                                          style: TextStyle(fontSize: 18),
                                          textAlign: TextAlign.right),
                                    ),
                                  );
                                  setState(() {
                                    widget.editProfileController
                                        .isEditProfileLoading = false;
                                  });
                                }
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('يرجى تاكيد رقم الهاتف الجديد',
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.right),
                                ),
                              );
                            }
                            // return;

                            // Timer(Duration(seconds: 10), () {
                            //   setState(() {
                            //     widget.editProfileController
                            //         .isEditProfileLoading = false;
                            //   });
                            // });
                          }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showChangeNumberDialog(
          Dimensions dimensions, EditProfileController editProfileController) =>
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
                child: AlertDialog(
                  title: AppSmallTextWidget(
                      text: "تغيير رقم الهاتف", size: dimensions.font18),
                  content: Container(
                    height: editProfileController.verficationDialogStep == 0
                        ? dimensions.height10 * 16
                        : dimensions.height10 * 7,
                    width: double.maxFinite,
                    child: Column(
                        children: editProfileController.verficationDialogStep ==
                                0
                            ? [
                                if (editProfileController
                                        .verficationDialogStep ==
                                    0)
                                  AppSmallTextWidget(
                                    text:
                                        "هل انت متأكد من تغيير رقم الهاتف الخاص بك ؟ ",
                                    size: dimensions.font18,
                                    textAlign: TextAlign.center,
                                  ),
                                AppSmallTextWidget(
                                  text: "من \n" +
                                      (editProfileController
                                              .userModel.phoneCode! +
                                          editProfileController
                                              .userModel.phone!),
                                  size: dimensions.font18,
                                  textAlign: TextAlign.center,
                                ),
                                AppSmallTextWidget(
                                  text: "الى \n" +
                                      (editProfileController.phoneCode +
                                          editProfileController
                                              .phoneEditingController.text
                                              .trim()),
                                  size: dimensions.font18,
                                  textAlign: TextAlign.center,
                                ),
                                AppSmallTextWidget(
                                  text: "سيتطلب ذالك تاكيد رقم الهاتف الجديد ",
                                  size: dimensions.font18,
                                  textAlign: TextAlign.center,
                                ),

                                //
                              ]
                            : [
                                AppTextFormField(
                                    hintText: "رمز التحقق",
                                    onSave: () {},
                                    validator: () {},
                                    textInputType: TextInputType.number,
                                    textEditingController: editProfileController
                                        .otpEditingController)
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
                        editProfileController.verficationDialogStep = 0;
                        newPhoneNumberVerifed = false;
                        editProfileController.otpEditingController.text = "";
                        Navigator.pop(context, false);
                        editProfileController.isSendOtpLoading = false;
                        editProfileController.isOTPVerficationLoading = false;
                      },
                    ),
                    if (editProfileController.verficationDialogStep == 0 &&
                        editProfileController.isSendOtpLoading == false)
                      TextButton(
                        child: Text(
                          "تاكيد رقم الهاتف",
                          style: GoogleFonts.tajawal(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF007282)),
                        ),
                        onPressed: () async {
                          if (editProfileController.phoneEditingController.text
                              .trim()
                              .isNotEmpty) {
                            setState(() {
                              editProfileController.isSendOtpLoading = true;
                            });
                            authController.countryPhoneCode =
                                editProfileController.phoneCode;
                            authController
                                .updateUserAuthontication(
                                    editProfileController
                                        .phoneEditingController.text
                                        .trim(),
                                    context)
                                .then((value) {
                              if (value) {
                                setState(() {
                                  editProfileController.isSendOtpLoading =
                                      false;
                                  editProfileController.verficationDialogStep =
                                      1;
                                });
                              } else {
                                setState(() {
                                  editProfileController.isSendOtpLoading =
                                      false;
                                });
                              }
                            });
                          }
                        },
                      ),
                    if (editProfileController.verficationDialogStep == 0 &&
                        editProfileController.isSendOtpLoading == true)
                      AppLoadingIndicator(
                        text: "",
                      ),
                    if (editProfileController.verficationDialogStep == 1 &&
                        editProfileController.isOTPVerficationLoading == false)
                      TextButton(
                        child: Text(
                          "تحقق",
                          style: GoogleFonts.tajawal(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF007282)),
                        ),
                        onPressed: () async {
                          if (editProfileController.otpEditingController.text
                                  .trim()
                                  .isNotEmpty &&
                              editProfileController.otpEditingController.text
                                      .trim()
                                      .length ==
                                  6) {
                            setState(() {
                              editProfileController.isOTPVerficationLoading =
                                  true;
                            });

                            authController
                                .verfiyOtpForUpdate(
                                    editProfileController
                                        .otpEditingController.text
                                        .trim(),
                                    context)
                                .then((value) {
                              if (value) {
                                setState(() {
                                  editProfileController
                                      .isOTPVerficationLoading = false;
                                  newPhoneNumberVerifed = true;
                                  Navigator.pop(context, false);
                                });
                              } else {
                                setState(() {
                                  editProfileController
                                      .isOTPVerficationLoading = false;
                                });
                              }
                            });
                          }
                        },
                      ),
                    if (editProfileController.verficationDialogStep == 1 &&
                        editProfileController.isOTPVerficationLoading == true)
                      AppLoadingIndicator(
                        text: "",
                      ),
                  ],
                ),
              );
            });
          });

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
            MaterialPageRoute(builder: (context) => ProfilePage()));
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
