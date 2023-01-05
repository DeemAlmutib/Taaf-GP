import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:taaf/homePage.dart';
import 'package:taaf/humanModel.dart';
import 'package:taaf/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:taaf/navigation.dart';
import 'package:taaf/src/views/user/profilePage.dart';
import 'package:taaf/welcomePage.dart';
import 'src/views/user/editProfile.dart';
import 'src/base/globals.dart';
import 'src/helper/userSharedPreferences.dart';
import 'welcomePage.dart';
import 'firebase_options.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ffi/ffi.dart';

import 'login/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await UserSharedPreferences.init();
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
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('en'), const Locale('ar')],
      debugShowCheckedModeBanner: false,
      title: 'Firebase',
      // scaffoldMessengerKey: snackbarKey,
      home: WelcomePageWidget(),
    );
  }
}

Widget checkLogin() {
  var userID = UserSharedPreferences.getUserID();

  print(userID);

  if (userID == null) {
    return LoginPageWidget();
  } else {
    return ProfilePage();
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

class AddData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("geeksforgeeks"),
      ),
      body: Center(
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
          onPressed: () async {
            FirebaseFirestore.instance
                .collection('data')
                .add({'text': 'data added through app2'});

            // test apis -- uncomment the code below to test ((ctrl + k + u ) shortcut to uncomment - you can change the mthod parameters if you like to see different results

            // var s = await getSym("cough");
            // print(s.body); // printing symptomps related to cough

            // var disease = await PredictDisease(["high_fever", "skin_rash"]);
            // print(disease.body); // printing the disease that has these 2 symptopms which are high fever and skin rash

            // var description = await getDiseaseDescription("Psoriasis");
            // print(description.body);

            // var pre = await getDiseasePrecaution("Psoriasis");
            // print(pre.body);

            // var severity =
            //     await getDiseaseSeverity(["high_fever", "skin_rash"], 3);
            // print(jsonDecode(severity.body)[
            //     'result']); // the way you can access things in the body of the request
          },
        ),
      ),
    );
  }
}
