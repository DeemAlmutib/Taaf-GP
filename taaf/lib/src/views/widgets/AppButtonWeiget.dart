import 'package:flutter/material.dart';
import 'package:taaf/src/helper/Dimensions.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';

class AppButtonWeiget extends StatelessWidget {
  AppButtonWeiget(
      {Key? key,
      required this.text,
      this.height = 0,
      this.width = 0,
      required this.onPressed})
      : super(key: key);

  double height;
  double width;
  String text;
  Function onPressed;

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Container(
      width: width == 0 ? dimensions.width10 * 22 : width,
      height: height == 0 ? dimensions.height10 * 8 : height,
      decoration: BoxDecoration(),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20, 25, 20, 5),
        child: FFButtonWidget(
          onPressed: () async {
            onPressed();
          },
          text: text,
          options: FFButtonOptions(
            width: dimensions.width10,
            height: dimensions.height10,
            color: Color(0xFF007282),
            textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                  fontFamily: 'Tajawal',
                  color: Colors.white,
                  fontSize: dimensions.font18,
                  fontWeight: FontWeight.bold,
                ),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1,
            ),
            borderRadius: dimensions.width10 * 3,
          ),
        ),
      ),
    );
  }
}
