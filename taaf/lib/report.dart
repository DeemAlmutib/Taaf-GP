import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportWidget extends StatefulWidget {
  final String date;
  final String disease;
  final String description;
  final String precaution;
  const ReportWidget(
    {Key? key,
    required this.date,
    required this.disease,
    required this.description,
    required this.precaution
    })
     : super(key: key);

  @override
  _ReportWidgetState createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String userId = "";
  late User loggedInUser;

@override
  void initState() {
    getCurrentUser();
  }

void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        userId = loggedInUser.uid;
      }
    } catch (e) {
      print(e);
    }
  }


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
                  height: 243.8,
                  decoration: BoxDecoration(),
                  child: Align(
                    alignment: AlignmentDirectional(0.9, 1),
                    child: Text(
                      widget.date,
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Tajawal',
                            color: Color(0xFF8C8C8C),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 389.9,
                height: 158.7,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 55.6,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.9, 0),
                        child: Text(
                          'ملخص',
                          textAlign: TextAlign.end,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Tajawal',
                                    color: Color(0xFF636366),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                    Container(
                      width: 382,
                      height: 107.8,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.8, -1),
                        child: Text(
                          widget.description,
                          textAlign: TextAlign.end,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Tajawal',
                                    color: Color(0xFF636366),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ),
                  ],
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
                      height: 50.1,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.9, -1),
                        child: Text(
                          'من المحتمل أنك تعاني من ',
                          textAlign: TextAlign.end,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Tajawal',
                                    color: Color(0xFF636366),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                    Container(
                      height: 52.9,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.9, -1),
                        child: Text(
                          widget.disease,
                          textAlign: TextAlign.end,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Tajawal',
                                    color: Color(0xFF007282),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                    Container(
                      width: 380,
                      height: 44,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.95, -1),
                        child: Text(
                          'نصائح',
                          textAlign: TextAlign.end,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Tajawal',
                                    color: Color(0xFF636366),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                    Container(
                      width: 396.9,
                      height: 100,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.9, -1),
                        child: Text(
                          widget.precaution,
                          textAlign: TextAlign.end,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Tajawal',
                                    color: Color(0xFF636366),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   width: 378.2,
              //   height: 100,
              //   decoration: BoxDecoration(
              //     color: FlutterFlowTheme.of(context).secondaryBackground,
              //   ),
                
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
