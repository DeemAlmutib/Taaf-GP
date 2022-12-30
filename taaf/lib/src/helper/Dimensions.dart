import 'package:flutter/cupertino.dart';

class Dimensions {
  late double screenHeigh;
  late double screenWidth;

  //heights
  late double height5;
  late double height10;
  late double height15;
  late double height20;
  late double height25;
  late double height59_9;
  late double height55;

  //widths
  late double width5;
  late double width10;
  late double width15;
  late double width20;
  late double width25;
  late double width300;

  // fonts
  late double font36;
  late double font16;
  late double font10;
  late double font18;

  // icons
  late double icon25;

  Dimensions(BuildContext context) {
    this.screenHeigh = MediaQuery.of(context).size.height;
    this.screenWidth = MediaQuery.of(context).size.width;

    //heights
    height5 = screenHeigh / 136.6;
    height10 = screenHeigh / 68.3;
    height15 = screenHeigh / 45.53333333333333;
    height20 = screenHeigh / 34.15;
    height25 = screenHeigh / 27.32;
    height59_9 = screenHeigh / 11.40233722871452;
    height55 = screenHeigh / 12.41818181818182;

    //width
    width5 = screenWidth / 82.2;
    width10 = screenWidth / 41.1;
    width15 = screenWidth / 27.4;
    width20 = screenWidth / 20.55;
    width25 = screenWidth / 16.44;
    width300 = screenWidth / 1.37;
    //fonts
    font36 = screenWidth / 11.41666666666667;
    font16 = screenWidth / 42.6875;
    font10 = screenWidth / 41.1;
    font18 = screenWidth / 22.83333333333333;

    //icons
    icon25 = screenWidth / 16.44;
  }
}
