import "package:flutter/material.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";
import 'package:taaf/homePage.dart';
import 'package:taaf/humanModel.dart';
import 'package:taaf/login.dart';
import 'package:taaf/login/loginPage.dart';
import 'package:taaf/n.dart';

class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('en'), const Locale('ar')],
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/" : (context) => MainPage(), // HERE PUT THE WELCOME PAGE 
        "/main" : (context) => humanModel()
      },
    );
  }
}
