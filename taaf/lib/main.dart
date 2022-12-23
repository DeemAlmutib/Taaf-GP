import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:taaf/homepage.dart';
//import 'src/base/globals.dart';
//import 'welcomePage.dart';
//import 'firebase_options.dart';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ffi/ffi.dart';

import 'login/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(MyApp());
  print("object");
}

//test
class MyApp extends StatelessWidget {
// This widget is the root
// of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      title: 'Firebase',
      //scaffoldMessengerKey: snackbarKey,
      home: HompageWidget(),
    );
  }
}

// method for getting the symptopms , it should take the first symptomp
Future<http.Response> getSym(String symptomp) {
  // method to fetch symptopms from python based on the first symptomp
  return http.post(
    Uri.parse('http://10.0.2.2:5000/SymptopmsApi'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'disease': symptomp,
    }),
  );
}

// method for getting the disease , takes the set of symptomps that the user has said yes to
Future<http.Response> PredictDisease(List<String> symptomp) {
  // method to fetch symptopms from python based on the first symptomp
  return http.post(
    Uri.parse('http://10.0.2.2:5000/DiseaseApi'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, List<String>>{
      'disease': symptomp,
    }),
  );
}

// method for getting the description of the disease , it take the disease name and returns its description
Future<http.Response> getDiseaseDescription(String disease) {
  return http.post(
    Uri.parse('http://10.0.2.2:5000/DescriptionApi'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'disease': disease,
    }),
  );
}

// method that takes the disease name and returns the set of advices
Future<http.Response> getDiseasePrecaution(String disease) {
  return http.post(
    Uri.parse('http://10.0.2.2:5000/PrecautionApi'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'disease': disease,
    }),
  );
}

// method that takes the array of symptopms and the number of days the patient has been suffering from these symptopms to tell him if he should go to the doctor or not
Future<http.Response> getDiseaseSeverity(exp, days) {
  return http.post(
    Uri.parse('http://10.0.2.2:5000/SeverityApi'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<dynamic, dynamic>{'expression': exp, 'days': days}),
  );
}
