import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HompageWidget extends StatefulWidget {
  const HompageWidget({Key? key}) : super(key: key);

  @override
  _HompageWidgetState createState() => _HompageWidgetState();
}

class _HompageWidgetState extends State<HompageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF14181B),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
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
                        height: 342.8,
                        decoration: BoxDecoration(),
                        child: Align(
                          alignment: AlignmentDirectional(0.15, 0.35),
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
                        height: 81.4,
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
                height: 158.7,
                decoration: BoxDecoration(),
                child: Align(
                  alignment: AlignmentDirectional(0, -0.75),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                    child: Text(
                      'تعاف مستعد لمساعدتك اليوم ',
                      textAlign: TextAlign.end,
                      style: FlutterFlowTheme.of(context).title1.override(
                            fontFamily: 'Tajawal',
                            color: Color(0xFF007282),
                            fontSize: 30,
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
                      width: 285,
                      height: 189,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 30,
                            color: Color(0xD78D8989),
                            offset: Offset(0, 2),
                          )
                        ],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 244.9,
                            height: 78.7,
                            decoration: BoxDecoration(),
                            child: Align(
                              alignment: AlignmentDirectional(1, 0.25),
                              child: Text(
                                'هل تود البدء؟',
                                textAlign: TextAlign.end,
                                style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .override(
                                      fontFamily: 'Tajawal',
                                      fontSize: 24,
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
                                  width: 98.2,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Image.asset(
                                    'assets/images/image_1.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  width: 162.1,
                                  height: 100,
                                  decoration: BoxDecoration(),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.4, -0.35),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 25),
                                      child: FFButtonWidget(
                                        onPressed: () {
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
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w600,
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
