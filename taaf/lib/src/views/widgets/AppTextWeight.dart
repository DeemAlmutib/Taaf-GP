import 'package:flutter/material.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';

class AppTextWeight extends StatelessWidget {
  String text;
  double fontSize;
  AppTextWeight({
    Key? key,
    required this.text,
    required this.fontSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
     text,
      style: FlutterFlowTheme.of(context).title1.override(
            fontFamily: 'Tajawal',
            color: FlutterFlowTheme.of(context).primaryBtnText,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
