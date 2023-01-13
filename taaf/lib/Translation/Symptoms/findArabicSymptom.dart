import 'dart:convert';
import 'package:flutter/services.dart' show PlatformException, rootBundle;
import 'Symptoms.dart';

class findArabicSymptom  {

   
  
  List<Symptoms> symptomsList = [];
  List<Symptoms> foundSymptom = [];

  
   Future<List<Symptoms>> ReadJsonData() async {
    //read json file
    final jsondata = await rootBundle.loadString('lib/Translation/Symptoms/SymptomsData.json');
    //decode json data as list
    final list = json.decode(jsondata) as List<dynamic>;

    //map json and initialize using DataModel
    return list.map((e) => Symptoms.fromJson(e)).toList();
  }

   Future<void> findSymptom(String name) async {
    //foundSymptom.clear();
    symptomsList = await ReadJsonData() as List<Symptoms>;

   //  String arabicSymp = " ";
   
    for (var i = 0; i < symptomsList.length; i++) {
      
     //foundSymptom.clear();

      if (name == symptomsList[i].nameEn) {
         foundSymptom.clear();
        print(symptomsList[i].nameAr);
        foundSymptom.add(Symptoms.fromJson(symptomsList[i].toJson()));
        print("found: ");
         print(foundSymptom[0].nameAr);
        
       // arabicSymp = symptomsList[i].nameAr!;
        break;
      } 
    }

    // return arabicSymp;
    
  }
}