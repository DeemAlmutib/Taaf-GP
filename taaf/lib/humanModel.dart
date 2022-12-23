import 'package:body_part_selector/body_part_selector.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ffi/ffi.dart';
import 'homepage.dart';
import 'login/loginPage.dart';

//test
class humanModel extends StatelessWidget {
  const humanModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Body Part Selector',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: //
            ColorScheme.fromSeed(
          seedColor: Color.fromARGB(156, 77, 77, 77),
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
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Color.fromRGBO(0, 114, 130, 100),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HompageWidget()));
            },
          ),
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1,
            decoration: BoxDecoration(
              color: Color(0xFF14181B),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(
                  'assets/images/home.png',
                ).image,
              ),
            ),
            child: BodyPartSelectorTurnable(
              bodyParts: _bodyParts,
              onSelectionUpdated: (p) => setState(() => _bodyParts = p),
              labelData: const RotationStageLabelData(
                front: 'أمام',
                left: ' الايسر',
                right: ' الايمن',
                back: 'خلف',
              ),
            ),
          ),
        ));
  }
}
