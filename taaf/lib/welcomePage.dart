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
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background_(1).png'),
              fit: BoxFit.fill)),
      child: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Text(
                    "  !مرحبًا بـك ",
                    style: GoogleFonts.tajawal(
                      fontSize: 35,
                      //fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 225, 234, 239),
                      fontWeight: FontWeight.bold,
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
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LoginPageWidget()));
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
