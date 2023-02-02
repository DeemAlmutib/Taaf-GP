import 'package:taaf/humanModel.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HompageWidget extends StatefulWidget {
  const HompageWidget({Key? key}) : super(key: key);

  @override
  _HompageWidgetState createState() => _HompageWidgetState();
}

class _HompageWidgetState extends State<HompageWidget> {
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'assets/images/home.png',
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
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 432.2,
                        height: 295.6,
                        decoration: BoxDecoration(),
                        child: Align(
                          alignment: AlignmentDirectional(0.15, 0.65),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                            child: Text(
                              'تعاف يستخدم الذكاء الإصطناعي في تشخيص الأمراض العامة ',
                              textAlign: TextAlign.end,
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Tajawal',
                                    color: Color(0xFF007282),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 371.3,
                        height: 27.1,
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Divider(
                              thickness: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 389.9,
                height: 103.6,
                decoration: BoxDecoration(),
                child: Align(
                  alignment: AlignmentDirectional(0, -0.9),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                    child: Text(
                      'تعاف مستعد لمساعدتك اليوم ',
                      textAlign: TextAlign.end,
                      style: FlutterFlowTheme.of(context).title1.override(
                            fontFamily: 'Tajawal',
                            color: Color(0xFF007282),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 385.3,
                height: 246.1,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 170,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        // boxShadow: [
                        //   BoxShadow(
                        //     blurRadius: 30,
                        //     color: Color(0xD78D8989),
                        //     offset: Offset(0, 2),
                        //   )
                        // ],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Color(0xFF007282),
                          width: 6,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 244.9,
                            height: 70.6,
                            decoration: BoxDecoration(),
                            child: Align(
                              alignment: AlignmentDirectional(0.95, 0.25),
                              child: Text(
                                'هل تود البدء في التشخيص؟',
                                textAlign: TextAlign.end,
                                style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .override(
                                      fontFamily: 'Tajawal',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                          Container(
                            width: 264.4,
                            height: 100,
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(),
                                  child: Image.asset(
                                    'assets/images/image_1.png',
                                    width: 100,
                                    height: 64.4,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  width: 157.6,
                                  height: 100,
                                  decoration: BoxDecoration(),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.4, -0.35),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 30),
                                      child: FFButtonWidget(
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      humanModel()));
                                          print('Button pressed ...');
                                        },
                                        text: 'ابدأ',
                                        options: FFButtonOptions(
                                          width: 131,
                                          height: 50,
                                          color: Color(0xFF007282),
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .subtitle2
                                                  .override(
                                                    fontFamily: 'Tajawal',
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius: 15,
                                        ),
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
