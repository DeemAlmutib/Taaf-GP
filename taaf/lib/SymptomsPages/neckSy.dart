//import '../flutter_flow/flutter_flow_radio_button.dart';

import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taaf/humanModel.dart';

import '../Questions.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../main.dart';

class neckSymptoms extends StatefulWidget {
  const neckSymptoms({Key? key}) : super(key: key);

  @override
  _neckSymptoms createState() => _neckSymptoms();
}

class _neckSymptoms extends State<neckSymptoms> {
  String? sym; // var have the symptoms name in english
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Color.fromRGBO(0, 114, 130, 100),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => humanModel()));
            },
          ),
        ),
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
            child: Container(
                padding: EdgeInsets.only(top: 150),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                          " ???????????? ???????????? ???????????? ?????????? ???????????? ????????   ", // ?????? *
                          style: FlutterFlowTheme.of(context).title1.override(
                                fontFamily: 'Tajawal',
                                color: Color.fromARGB(156, 0, 0, 0),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.right),

                      // Divider(
                      //   color: Colors.black,
                      //   //height: 36,
                      // ),
                      // RadioListTile(
                      //   title: Text(
                      //       "???????? ???? ?????????? ?????????????? ( ???????????? ???????? ???????? ???????? ???????????? ?????? ?????????? ?????? )",
                      //       style: FlutterFlowTheme.of(context).title1.override(
                      //             fontFamily: 'Tajawal',
                      //             color: Color.fromRGBO(0, 114, 130, 100),
                      //             fontSize: 15,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //       textAlign: TextAlign.right),
                      //   value: "enlarged_thyroid",
                      //   groupValue: sym,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       sym = value.toString();
                      //     });
                      //   },
                      // ),
                      Divider(
                        color: Colors.black,
                        height: 36,
                      ),
                      RadioListTile(
                        title: Text("?????? ???? ????????????",
                            style: FlutterFlowTheme.of(context).title1.override(
                                  fontFamily: 'Tajawal',
                                  color: Color.fromRGBO(0, 114, 130, 100),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.right),
                        value: "neck_pain",
                        groupValue: sym,
                        onChanged: (value) {
                          setState(() {
                            sym = value.toString();
                          });
                        },
                      ),
                      Divider(
                        color: Colors.black,
                        //height: 36,
                      ),
                      RadioListTile(
                        title: Text(
                            "???????? ???? ???????????? ( ???????????? ???????????? ???????????? ?????????? ???????????? ?????????? ?????? ???????????? ?????????? ?????????? ?????? ?????? ???????????????? )",
                            style: FlutterFlowTheme.of(context).title1.override(
                                  fontFamily: 'Tajawal',
                                  color: Color.fromRGBO(0, 114, 130, 100),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.right),
                        value: "stiff_neck",
                        groupValue: sym,
                        onChanged: (value) {
                          setState(() {
                            sym = value.toString();
                          });
                        },
                      ),
                      Divider(
                        color: Colors.black,
                        //height: 36,
                      ),
                      Container(
                        width: 221.8,
                        height: 77.8,
                        decoration: BoxDecoration(),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(20, 25, 20, 5),
                          child: FFButtonWidget(
                            onPressed: () {
                              if (sym == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('???????????? ???????????? ???????? ??????',
                                        textAlign: TextAlign.right),
                                    backgroundColor: Color(0xFF007282),
                                  ),
                                );
                                print("deem");

                                print(sym);
                              } else {
                                print("else");
                                print(sym);

                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Questions(sympController: sym)));
                              }
                              ;
                            },
                            text: '????????????',
                            options: FFButtonOptions(
                              width: 10,
                              height: 10,
                              color: Color(0xFF007282),
                              textStyle: FlutterFlowTheme.of(context)
                                  .subtitle2
                                  .override(
                                    fontFamily: 'Tajawal',
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: 30, //BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }
}
