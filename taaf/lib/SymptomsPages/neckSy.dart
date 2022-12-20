//import '../flutter_flow/flutter_flow_radio_button.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../flutter_flow/flutter_flow_theme.dart';

class neckSymptoms extends StatefulWidget {
  const neckSymptoms({Key? key}) : super(key: key);

  @override
  _neckSymptoms createState() => _neckSymptoms();
}

class _neckSymptoms extends State<neckSymptoms> {
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
                  'assets/images/background_(1).png',
                ).image,
              ),
            ),
            child: Container(
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
                    title: Text(
                        "تضخم في الغدة الدرقية ( انتفاخ بارز أسفل عنقك مباشرة تحت تفاحة آدم )",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "enlarged_thyroid",
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
                    title: Text("ألم في الرقبة",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
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
                        "تصلب في الرقبة ( الشعور بالألم وصعوبة تحريك الرقبة وخاصة عند محاولة ادارة الرأس الى أحد الجانبين )",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
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
