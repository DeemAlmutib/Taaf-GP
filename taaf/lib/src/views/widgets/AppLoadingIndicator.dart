import 'package:flutter/material.dart';
import 'package:taaf/src/helper/Dimensions.dart';
import 'package:taaf/src/views/widgets/AppSmallTextWidget.dart';

class AppLoadingIndicator extends StatelessWidget {
  AppLoadingIndicator({
    Key? key,
    this.text = "جاري جلب البيانات ..."
  }) : super(key: key);

  String text;

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Column(
      children: [
        CircularProgressIndicator(
          color: Color(0xFF007282),
        ),
        SizedBox(
          height: dimensions.height15,
        ),
        AppSmallTextWidget(
          text: text,
          size: dimensions.font10 * 1.5,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: dimensions.height15,
        ),
      ],
    );
  }
}
