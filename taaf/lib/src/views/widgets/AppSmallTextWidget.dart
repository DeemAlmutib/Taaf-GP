import 'package:flutter/material.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';

class AppSmallTextWidget extends StatelessWidget {
  AppSmallTextWidget({Key? key, required this.text, required this.size ,  this.textAlign = TextAlign.end})
      : super(key: key);

  String text;
  double size;
  TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: FlutterFlowTheme.of(context).bodyText1.override(
            fontFamily: 'Tajawal',
            color: Color(0xFFA0A0A0),
            fontSize: size,
            fontWeight: FontWeight.w400,
          ),
    );
  }
}
