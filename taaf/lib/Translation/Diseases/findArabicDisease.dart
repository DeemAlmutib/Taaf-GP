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

   Future<void> findDisease(String name, String type) async {
    foundDisease.clear();


    diseasesList = await ReadJsonData() as List<Diseases>;

     switch (type) {
    case "disease":
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
      break;


    case "description": 
      for (var i = 0; i < diseasesList.length; i++) {
      

      if (name == diseasesList[i].description) {
       foundDisease.clear();
        print(diseasesList[i].descriptionAr);
        foundDisease.add(Diseases.fromJson(diseasesList[i].toJson()));
        print("found: ");
         print(foundDisease[0].descriptionAr);
        
       
        break;
      } 
    }
      break;

    case "advice1": 
           for (var i = 0; i < diseasesList.length; i++) {
      

      if (name == diseasesList[i].advice1) {
       foundDisease.clear();
        print(diseasesList[i].advice1Ar);
        foundDisease.add(Diseases.fromJson(diseasesList[i].toJson()));
        print("found: ");
         print(foundDisease[0].advice1Ar);
        
       
        break;
      } 
    }
      break;

      case "advice2": 
           for (var i = 0; i < diseasesList.length; i++) {
      

      if (name == diseasesList[i].advice2) {
       foundDisease.clear();
        print(diseasesList[i].advice2Ar);
        foundDisease.add(Diseases.fromJson(diseasesList[i].toJson()));
        print("found: ");
         print(foundDisease[0].advice2Ar);
        
       
        break;
      } 
    }
      break;

         case "advice3": 
           for (var i = 0; i < diseasesList.length; i++) {
      

      if (name == diseasesList[i].advice3) {
       foundDisease.clear();
        print(diseasesList[i].advice3Ar);
        foundDisease.add(Diseases.fromJson(diseasesList[i].toJson()));
        print("found: ");
         print(foundDisease[0].advice3Ar);
        
       
        break;
      } 
    }
      break;

    
         case "advice4": 
           for (var i = 0; i < diseasesList.length; i++) {
      

      if (name == diseasesList[i].advice4) {
       foundDisease.clear();
        print(diseasesList[i].advice4Ar);
        foundDisease.add(Diseases.fromJson(diseasesList[i].toJson()));
        print("found: ");
         print(foundDisease[0].advice4Ar);
        
       
        break;
      } 
    }
      break;

  }

   


    
  }
}