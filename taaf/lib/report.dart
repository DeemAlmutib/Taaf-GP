import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'navigator_keys.dart';

class ReportWidget extends StatefulWidget {
  final String date;
  final String disease;
  final String description;
  final String precaution;
  final String precaution2;
  final String precaution3;
  const ReportWidget(
    {Key? key,
    required this.date,
    required this.disease,
    required this.description,
    required this.precaution,
    required this.precaution2,
    required this.precaution3
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
        appBar: AppBar(
        leading:IconButton(icon: Icon(Icons.arrow_back , size: 35,), 
        color:  Color(0xFF007282), 
         onPressed: () => // Navigator.of(context).pushReplacement(
        //         MaterialPageRoute(builder: (context) => Navigation()))
           Navigation.mainNavigation.currentState!.pushNamed("/main/3")
        
        ),
       // backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
         elevation: 0.0,
        centerTitle: true,
      backgroundColor:Color.fromARGB(255, 255, 255, 255),
       title: Image.asset('assets/Images/taaf.jpg' , 
       height: 90, 
       alignment: FractionalOffset.center), 
       toolbarHeight: 100,
      ),
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 30,),
              Align(
                alignment: AlignmentDirectional(-0.1, -0.55),
                child: Container(
                  width: 389.1,
                  //height: 243.8,
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
                      height: 45.6,
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
                     width: 372,
                      //height: 90.8,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.8, -1),
                        child: Text(
                          'تنويه: نتيجة هذا الإختبار هي فقط تشخيص مقترح لا يغنيك عن زيارة الطبيب    ' ,
                          textAlign: TextAlign.end,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Tajawal',
                                    color: Color.fromARGB(255, 189, 60, 60),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    
              ),

             SizedBox(height:30),
              Container(
                      height: 40.1,
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
                      height: 45.9,
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
                      height: 35,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.95, -1),
                        child: Text(
                          'وصف المرض',
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
                            width: 372,
                            child: Align(
                        alignment: AlignmentDirectional(0.8, -1),
                                  child: Text(widget.description , 
                                
                                   textAlign: TextAlign.end,
                                   style:  GoogleFonts.tajawal(
                    fontSize: 13,
                    height: 1.5,
                    //fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 65, 66, 66).withOpacity(0.65),
                    fontWeight: FontWeight.bold,
                  ),))),
                  SizedBox(
                    height: 5,
                  ),
                    Container(
                      width: 380,
                      height: 35,
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
                    SizedBox(
                      height: 5,
                    ),
                    Container( 
                      width: 372, 
                      child: Align(alignment: AlignmentDirectional(0.95, -1),
                             child: Text("   " + widget.precaution +" - ",  
                             textAlign: TextAlign.end,
                             style: GoogleFonts.tajawal(
                    fontSize: 13,
                    height: 1.5,
                    //fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 65, 66, 66).withOpacity(0.65),
                    fontWeight: FontWeight.bold,
                  ),),),),
                  SizedBox(
                    height: 5,
                  ),
                   Container( 
                      width: 372, 
                      child: Align(alignment: AlignmentDirectional(0.95, -1),
                             child: Text("   " + widget.precaution2 +" - ",  
                             textAlign: TextAlign.end,
                             style: GoogleFonts.tajawal(
                    fontSize: 13,
                    height: 1.5,
                    //fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 65, 66, 66).withOpacity(0.65),
                    fontWeight: FontWeight.bold,
                  ),),),),
                   SizedBox(
                    height: 5,
                  ),
                   Container( 
                      width: 372, 
                      child: Align(alignment: AlignmentDirectional(0.95, -1),
                             child: Text("   " + widget.precaution3 +" - ",  
                             textAlign: TextAlign.end,
                             style: GoogleFonts.tajawal(
                    fontSize: 13,
                    height: 1.5,
                    //fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 65, 66, 66).withOpacity(0.65),
                    fontWeight: FontWeight.bold,
                  ),),),),

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
    );
  }
}
