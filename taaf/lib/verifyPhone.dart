import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taaf/newNavigation.dart';
import 'package:taaf/src/base/showToast.dart';
import 'package:taaf/src/controllers/AuthController.dart';
import 'package:taaf/src/views/user/profilePage.dart';

import 'homePage.dart';
import 'login/loginPage.dart';
// import 'navigation.dart';
import 'navigator_keys.dart';

class verifyloginPage extends StatefulWidget {
  AuthController authController;
  verifyloginPage({Key? key, required this.authController}) : super(key: key);

  @override
  _verifyLoginPageState createState() => _verifyLoginPageState();
}

class _verifyLoginPageState extends State<verifyloginPage> {
  final TextEditingController OTPController = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

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
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Color.fromARGB(255, 248, 252, 255),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPageWidget()));
            },
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
              child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF14181B),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(
                  'assets/Images/loginPage_noLogo3.png',
                ).image,
              ),
            ),
            child: Form(
              key: _formkey,
              child: Container(
                  margin: EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 130,
                      ),
                      Text(
                        " تسجيل الدخول   ",
                        style: GoogleFonts.tajawal(
                          fontSize: 35,
                          //fontStyle: FontStyle.italic,
                          color: Color.fromARGB(255, 238, 245, 248),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 168,
                      ),
                      Text(
                        " ادخل رمز التفعيل المرسل إليك  ",
                        style: GoogleFonts.tajawal(
                          fontSize: 20,
                          //fontStyle: FontStyle.italic,
                          color: Color(0xFF007282),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          controller: OTPController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 239, 237, 237),

                            //hintText: ' رقم الهاتف ',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 12.0, right: 14.0, bottom: 8.0, top: 8.0),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 236, 231, 231),
                                    width: 3)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Color.fromARGB(79, 29, 73, 109)),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              return "يجب ملء هذا الحقل";
                            } else if (value!.length != 6) {
                              return "رمز التحقق المدخل غير صحيح يجب ان يكون 6 ارقام ";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            OTPController.text = value!;
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                            keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6)
                              ],
                          maxLength: 6,
                        ),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () async {
                                  bool allGood = await widget.authController
                                      .phoneAuthentication(
                                          widget.authController.phoneNumber,
                                          context);
                                  if (allGood) {
                                    appShowSnackBar(context,
                                        "تم إرسال الرقم مرةً أخرى ", false);
                                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    //     builder: (context) => verifyloginPage(
                                    //           authController: _authController,
                                    //         )));
                                  } else {
                                    appShowSnackBar(
                                        context,
                                        "حصل أمر خاطى، يرجى اعادة المحاولة ",
                                        true);
                                  }

                                  // Navigator.of(context).pushReplacement(
                                  //     MaterialPageRoute(
                                  //         builder: (context) => homePage()));
                                },
                                child: const Text('اعادة ارسال الرمز ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 84, 139, 187),
                                      decoration: TextDecoration.underline,
                                    ))),
                            Text(
                              'لم يصلك رمز التفعيل؟',
                              style: GoogleFonts.tajawal(
                                  fontSize: 17,
                                  color: Color.fromARGB(157, 117, 156, 181),
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                      SizedBox(
                        height: 15,
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                        elevation: 5.0,
                        height: 50,
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 60),
                        onPressed: () async {
                          var validator = _formkey.currentState?.validate();
                          if (validator != null && validator == true) {
                            bool allGood = await widget.authController
                                .verfiyOTP(OTPController.text.toString().trim(),
                                    context);
                            if (allGood) {
                              appShowSnackBar(
                                      context, "تم تسجيل الدخول بنجاح ", false)
                                  .then((value) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => MainPage()));
                              });
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     content: Text("تم تسجيل الدخول بنجاح ",
                              //         style: TextStyle(fontSize: 18),
                              //         textAlign: TextAlign.right),
                              //   ),
                              // // );

                              // Navigator.of(context).pushReplacement(
                              //     MaterialPageRoute(
                              //         builder: (context) => ProfilePage()));

                              //Navigation.mainNavigation.currentState!.pushNamed("/");
                            } else {
                              // AppShowToast(text: "error");
                            }
                            // AppShowToast(text: "all good");
                          }

                          // Navigator.of(context).pushReplacement(
                          //     MaterialPageRoute(builder: (context) => homePage()));
                        },
                        child: Text(
                          "تحقق ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tajawal(
                            fontSize: 20,
                            //fontStyle: FontStyle.italic,
                            color: Color.fromARGB(255, 226, 237, 243),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Color.fromRGBO(0, 114, 130, 30),
                      ),
                      Container(
                          child: Column(
                        children: [],
                      ))
                    ],
                  )),
            ),
          )),
        ));
  }
}
