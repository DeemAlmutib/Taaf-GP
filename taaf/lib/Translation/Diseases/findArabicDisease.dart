import 'dart:convert';
import 'package:flutter/services.dart' show PlatformException, rootBundle;
import 'Diseases.dart';

class findArabicDisease  {

   
  
  List<Diseases> diseasesList = [];
  List<Diseases> foundDisease = [];

  
   Future<List<Diseases>> ReadJsonData() async {
    //read json file
    final jsondata = await rootBundle.loadString('lib/Translation/Diseases/DiseasesData.json');
    //decode json data as list
    final list = json.decode(jsondata) as List<dynamic>;

    //map json and initialize using DataModel
    return list.map((e) => Diseases.fromJson(e)).toList();
  }

   Future<void> findDisease(String name) async {
    foundDisease.clear();


    diseasesList = await ReadJsonData() as List<Diseases>;

    
          for (var i = 0; i < diseasesList.length; i++) {
      

      if (name == diseasesList[i].name) {
       foundDisease.clear();
        print(diseasesList[i].nameAr);
        foundDisease.add(Diseases.fromJson(diseasesList[i].toJson()));
        print("found: ");
         print(foundDisease[0].nameAr);
        
       
        break;
      } 
    }
     

  
    
  }
}