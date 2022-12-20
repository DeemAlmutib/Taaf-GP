//import '../flutter_flow/flutter_flow_radio_button.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../flutter_flow/flutter_flow_theme.dart';

class upperBoday extends StatefulWidget {
  const upperBoday({Key? key}) : super(key: key);

  @override
  _upperBoday createState() => _upperBoday();
}

class _upperBoday extends State<upperBoday> {
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
                    title: Text("توعك أو ضيق أو شُعور بعدم الراحة",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "malaise",
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
                        "الحموضة ( شعور بالحرقان في المعدة أو الحلق أو شعور بمذاق مُر في الحلق أو الفم )",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "acidity",
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
                    title: Text(" شعور بالغثيان مع التقيّؤ   ",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "vomiting",
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
                        " ( عسر في الهضم ( شعور بالألم في الجزء العلوي من البطن مع الشعور بالامتلاء فور تناول الطعام   ",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "indigestion",
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
                    title: Text(" ألم في المعده ",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "stomach_pain",
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
                    title: Text("  عطاس مستمر  ",
                        style: FlutterFlowTheme.of(context).title1.override(
                              fontFamily: 'Tajawal',
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right),
                    value: "continuous_sneezing",
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
