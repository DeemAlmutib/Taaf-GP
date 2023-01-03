import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taaf/login/loginPage.dart';
import 'login.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF14181B),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: BoxDecoration(
            color: Color(0xFF14181B),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/first_page.png',
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
                  height: 355.1,
                  decoration: BoxDecoration(),
                  child: Align(
                    alignment: AlignmentDirectional(0, 0.35),
                    child: Text(
                      'مرحبًا بك!',
                      style: FlutterFlowTheme.of(context).title1.override(
                            fontFamily: 'Tajawal',
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 260,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    elevation: 5.0,
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 11, horizontal: 40),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginPageWidget()));
                    },
                    child: Text(
                      "تسجيل الدخول",
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
                ],
              ))),
    ));
  }
}
