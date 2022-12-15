import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taaf/src/base/showToast.dart';
import 'package:taaf/verifyPhone.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'src/controllers/AuthController.dart';
//import 'package:country_list_pick/country_list_pick.dart';

class loginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<loginPage> {
  final TextEditingController phoneController = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.fill)),
      child: Form(
        key: _formkey,
        child: Container(
            margin: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //   Image(
                //   image: AssetImage('assets/Images/taaf.jpg'),
                // height: 40,
                //width: 40,
                //),
                SizedBox(
                  height: 120,
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
                  height: 190,
                ),
                Text(
                  " تسجيل الدخول برقم الهاتف  ",
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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CountryCodePicker(
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
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          controller: phoneController,
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
                            } else if (value!.length != 9) {
                              return "الرجاء إدخال رقم الهاتف صحيح";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            phoneController.text = value!;
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 9,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  elevation: 5.0,
                  height: 50,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 60),
                  onPressed: () async {
                    var validator = _formkey.currentState?.validate();
                    if (validator != null && validator == true) {
                      bool allGood = await _authController.phoneAuthentication(
                          phoneController.text.toString().trim());
                      if (allGood) {
                        AppShowToast(text: "check your phone");
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => verifyloginPage(
                                  authController: _authController,
                                )));
                      } else {
                        AppShowToast(text: "error");
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
                  },
                  child: Text(
                    "تسجيل ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tajawal(
                      fontSize: 20,
                      //fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 226, 237, 243),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Color(0xFF007282),
                ),
              ],
            )),
      ),
    )));
  }
}
