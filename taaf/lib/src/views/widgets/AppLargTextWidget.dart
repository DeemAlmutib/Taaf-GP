import 'package:flutter/material.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';

class AppLargTextWidget extends StatelessWidget {
  AppLargTextWidget({Key? key, required this.text, required this.size ,  this.textAlign = TextAlign.end})
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
            color: Color(0xFF007282),
            fontSize: size,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
