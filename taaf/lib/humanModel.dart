import 'package:body_part_selector/body_part_selector.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ffi/ffi.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'homepage.dart';
import 'login/loginPage.dart';
import 'navigation.dart';

//test
class humanModel extends StatelessWidget {
  const humanModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: //
            ColorScheme.fromSeed(
          seedColor: Color(0xFF007282),
        ),
      ),
      home: const humanModelPage(title: 'Body Part Selector'),
    );
  }
}

class humanModelPage extends StatefulWidget {
  const humanModelPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<humanModelPage> createState() => _humanModelPage();
}

class _humanModelPage extends State<humanModelPage> {
  BodyParts _bodyParts = const BodyParts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: Text(
          '  انقُر على المكان الذي تعاني منه  ',
          //textAlign: TextAlign.end,
          style: FlutterFlowTheme.of(context).title1.override(
                fontFamily: 'Tajawal',
                color: Color(0xFF007282),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Color(0xFF007282),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Navigation()));
          },
        ),
      ),

      // key: scaffoldKey,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1,

            /* decoration: BoxDecoration(
              color: Color(0xFF14181B),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(
                  'assets/images/home.png',
                ).image,
              ),
            ),*/
            //  child:FlipCardWidget(
            child: BodyPartSelectorTurnable(
              bodyParts: _bodyParts,
              onSelectionUpdated: (p) => setState(() => _bodyParts = p),
              labelData: const RotationStageLabelData(
                front: 'أمام',
                left: "يسار",
                right: 'يمين ',
                back: 'خلف',
              ),
            ),
          )),
      // )
    );
  }
}
