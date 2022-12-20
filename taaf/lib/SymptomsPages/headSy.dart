//import '../flutter_flow/flutter_flow_radio_button.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../flutter_flow/flutter_flow_theme.dart';

class HeadSymptoms extends StatefulWidget {
  const HeadSymptoms({Key? key}) : super(key: key);

  @override
  _HeadSymptoms createState() => _HeadSymptoms();
}

class _HeadSymptoms extends State<HeadSymptoms> {
  String? sym;
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
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 120),
              child: Column(
                children: [
                  /*  Text(
                    "من ماذا تعاني؟",
                    style: TextStyle(fontSize: 18),
                  ),*/
                  Divider(
                    color: Colors.black,
                    //height: 36,
                  ),
                  RadioListTile(
                    title: Text("دوران مع شعور أنك على وشك السقوط",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color: Color.fromRGBO(0, 114, 130, 100),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "unsteadiness",
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
                    title: Text("ارتفاع في درجة الحرارة (  37.8 ف أكثر )",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color: Color.fromRGBO(0, 114, 130, 100),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "high_fever",
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
                    title: Text("صداع أو ألم في الرأس",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color: Color.fromRGBO(0, 114, 130, 100),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "headache",
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
                    title: Text("رتفاع طفيف في درجة الحرارة ( حمّى خفيفة )",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color: Color.fromRGBO(0, 114, 130, 100),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "mild_fever",
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
                        " ( اصفرار في العيون ( تحول اللون الأبيض المحاط بالعدسة إلى أصفر ",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color: Color.fromRGBO(0, 114, 130, 100),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "yellowing_of_eyes",
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
                    title: Text(" فقدان بالوعي أو إغماء مفاجئ مؤخرا ",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color: Color.fromRGBO(0, 114, 130, 100),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "coma",
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
                    title: Text(" دوران مع شعور أنك على وشك السقوط ",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color: Color.fromRGBO(0, 114, 130, 100),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "unsteadiness",
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
                    title: Text(" اختلال في التوازن أثناء الوقوف ",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color: Color.fromRGBO(0, 114, 130, 100),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "loss_of_balance",
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
                    title: Text(" عدم القدرة على التركيز أو التفكير بوضوح ",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color: Color.fromRGBO(0, 114, 130, 100),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "altered_sensorium",
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
                    title: Text(" عدم القدرة على التركيز أو التفكير بوضوح ",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color: Color.fromRGBO(0, 114, 130, 100),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "altered_sensorium",
                    groupValue: sym,
                    onChanged: (value) {
                      setState(() {
                        sym = value.toString();
                      });
                    },
                  ),
                ],
                //     ),
                //  ),
                //  ),
                //  ],
              ),
            ),
          ),
        ));
  }
}
