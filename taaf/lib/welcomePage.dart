import 'package:taaf/src/helper/Dimensions.dart';
import 'package:taaf/src/views/user/SignUpPage.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login/loginPage.dart';

class WelcomePageWidget extends StatefulWidget {
  const WelcomePageWidget({Key? key}) : super(key: key);

  @override
  _WelcomePageWidgetState createState() => _WelcomePageWidgetState();
}

class _WelcomePageWidgetState extends State<WelcomePageWidget> {
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF14181B),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
        child: Container(
          width: dimensions.screenWidth,
          height: dimensions.screenHeigh,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 197, 217, 232),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/first_page.png',
              ).image,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: dimensions.screenHeigh * 0.1,
                  ),
                  Text(
                    '!مرحبًا بك',
                    style: FlutterFlowTheme.of(context).title1.override(
                          fontFamily: 'Tajawal',
                          color: FlutterFlowTheme.of(context).primaryBtnText,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: dimensions.screenHeigh * 0.55,
                  ),
                  FFButtonWidget(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginPageWidget()));
                    },
                    text: 'تسجيل الدخول',
                    options: FFButtonOptions(
                      width: dimensions.width10 * 22,
                      height: dimensions.height10 * 6,
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
                  SizedBox(height: dimensions.height10),
                  FFButtonWidget(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SignUpPage()));
                    },
                    text: 'تسجيل حساب',
                    options: FFButtonOptions(
                      width: dimensions.width10 * 22,
                      height: dimensions.height10 * 6,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
