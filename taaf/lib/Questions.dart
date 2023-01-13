import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ffi/ffi.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taaf/homepage.dart';
import 'package:taaf/login.dart';
import 'package:taaf/welcomePage.dart';
import 'Translation/Symptoms/findArabicSymptom.dart';
import 'Translation/Diseases/findArabicDisease.dart';

import 'flutter_flow/flutter_flow_theme.dart';
import 'navigation.dart';

class Questions extends StatefulWidget {
   final sympController;
   Questions({Key? key, this.sympController}) : super(key: key);
  @override
  State<Questions> createState() => _QuestionsState();
 // static List<dynamic> allSymptompsArray =  [];
 static List<dynamic> allSymptompsArray =  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0
 ,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0,0,0,0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0,0,0,00,0,0,0,0,0,0,0,0,0];
 static var nextSymp  ; // coming from the model // very important attribute 
 static var nextSympAR ;
 static var depth ; // important to to reach the next symptopm in the tree
 static var comingFromModel = true ; 
 static var expected ; 
}

class _QuestionsState extends State<Questions> {//http://3.83.132.184:5001/
var symp = Questions.nextSymp ;
// method that will take the list of symptomps that the user has said yes to and return the final result 
Future<http.Response> PredictDisease(List<String> symptomp) {

  return http.post(
    Uri.parse('http://18.212.48.165:5001/DiseaseApi'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, List<String>>{
      'disease': symptomp,
    }),
  );
}

// method to see if you should go to the doctor or not / takes the array of symptopms and the number of days the user has been sick 
// as enhancement of the app we could ask the user (from how many days you have been sick?) in order to use this method
Future<http.Response> getDiseaseSeverity(exp, days) {
  return http.post(
    Uri.parse('http://18.212.48.165:5001/SeverityApi'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<dynamic, dynamic>{'expression': exp, 'days': days}),
  );
}
// method that takes the disease name and get its description
Future<http.Response> getDiseaseDescription(String disease) {
  return http.post(
    Uri.parse('http://18.212.48.165:5001/DescriptionApi'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'disease': disease,
    }),
  );
}
// method that takes the disease name and returns the the of advices 
Future<http.Response> getDiseasePrecaution(String disease) {
  return http.post(
    Uri.parse('http://18.212.48.165:5001/PrecautionApi'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'disease': disease,
    }),
  );
}

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String userId = "";
late User loggedInUser;

@override
  void initState() {
    getCurrentUser();
  }

void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        userId = loggedInUser.uid;
      }
    } catch (e) {
      print(e);
    }
  }



var symptomp ; // important attribute 
// this method has been created manually to get the next symptopm to ask the user about based on his answer // to view the question in a way like a tree ! 
String getSymp(List<dynamic> symptopms){
 
print(symptopms);

if(Questions.depth==0){
if(symptopms[0]==1){ // 0 abnormal_menstruation
symptomp = "enlarged_thyroid" ; 


}
else if(symptopms[0]==0){ // abnormal_menstruation
symptomp ="muscle_pain";

}
}
//////////////////////
///
if(Questions.depth==1){
if(symptopms[1]==1 && symptopms[0]==0 ){ // 1 muscle_pain
symptomp = "pain_behind_the_eyes" ; 

}
else if(symptopms[1]==0 && symptopms[0]==0){ //muscle_pain
symptomp ="malaise"; 

}
}
///////////////////////////////
if(Questions.depth==2){
if(symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 2 malaise no 
symptomp ="irritability" ; 
 
}
else if(symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){// malise yes
  symptomp ="yellowing_of_eyes" ; 
 
}
}

if(Questions.depth==3){
if(symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0 ){// 3 irritability no 
symptomp ="chills";


}
else if(symptopms[3]==1 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// irritability yes
  symptomp ="slurred_speech";
  
}
}

if(Questions.depth==4){
if(symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0 ){// 4 chills
symptomp ="weight_loss" ; 

}
else if(symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0 ){// chills yes
  symptomp ="fatigue" ; 
}
}

if(Questions.depth==4){
if(symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0 ){// 4 chills
symptomp ="red_spots_over_body" ; // to be continued 
}
else if(symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0 ){// chills yes
  symptomp ="continuous_sneezing" ; 
}
}

if(Questions.depth==5){

if(symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 5 weight_loss
symptomp ="dark_urine" ; 
}
else if(symptopms[5]==1 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  weight_loss
  symptomp ="increased_appetite" ; 
}
}

if(Questions.depth==6){
if( symptopms[6]==1 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 6 dark_urine 
symptomp ="coma" ; 
}
else if( symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  dark_urine 
  symptomp ="joint_pain" ; 
}
}
if(Questions.depth==7){
if(symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 7 joint_pain
symptomp ="neck_pain" ; 
}
else if( symptopms[7]==1 &&
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// joint_pain
  symptomp ="skin_rash" ; 
}
}

if(Questions.depth==8){

if(symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 8 neck_pain
symptomp ="obesity" ; 
}
else if( symptopms[8]==1 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// neck_pain
  symptomp ="knee_pain" ; 
}
}
if(Questions.depth==9){

if( symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 9 obesity
symptomp ="stiff_neck" ; 
}
else if(symptopms[9]==1 && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// obesity
  symptomp ="restlessness" ; 
}
}
if(Questions.depth==10){
if( symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 10  stiff_neck
symptomp ="constipation" ; 
}
else if(symptopms[10]==1 &&symptopms[9]==0 && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// stiff_neck
  symptomp ="acidity" ; 
}
}
if(Questions.depth==11){
if( symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 11  constipation
symptomp ="diarrhoea" ; 
}
else if(symptopms[11]==1 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  constipation
  symptomp ="pain_during_bowel_movements" ;  // disease will be determined - send array to the model // Changed by Sarah
}
}

if(Questions.depth==12){

if(symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 12 diarrhoea
symptomp ="swelling_of_stomach" ; 
}
else if(symptopms[12]==1 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  diarrhoea
  symptomp ="vomiting" ;  // disease will be determined - send array to the model // Sarah: the value was finish and changed to vomiting
}
}

if(Questions.depth==13){
if(symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 13 swelling_of_stomach
symptomp ="unsteadiness" ; 
}
else if(symptopms[13]==1 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  swelling_of_stomach
  symptomp ="finish" ;  // disease will be determined - send array to the model
}
}

if(Questions.depth==14){

if(symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 14 unsteadiness 
symptomp ="loss_of_balance" ; 
}
else if(symptopms[14]==1 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  unsteadiness 
  symptomp ="loss_of_balance" ;  // disease will be determined - send array to the model
}
}
if(Questions.depth==15){

if(symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 15 loss_of_balance
symptomp ="bladder_discomfort" ; 
}
else if(symptopms[15]==1 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="vomiting" ;  // make sure this symptopm will be then one with loss of balance in the if statement 
}
}
if(Questions.depth==15){ // this added for more deeping

if(symptopms[15]==1 &&symptopms[14]==1 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 15 loss_of_balance
symptomp ="headache" ; // updated it was finish
}
else if(symptopms[15]==0 &&symptopms[14]==1 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="spinning_movements" ;  // make sure this symptopm will be then one with loss of balance in the if statement 
}
}


if(Questions.depth==16){

if(symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 16 bladder_discomfort 
symptomp ="passage_of_gases" ; 
}
else if(symptopms[16]==1 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  bladder_discomfort 
  symptomp ="burning_micturition" ;  // edited by Sarah, it was finish
}
}
if(Questions.depth==17){

if(symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 17 passage_of_gases
symptomp ="abdominal_pain" ; 
}
else if(symptopms[17]==1 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  passage_of_gases
  symptomp ="finish" ;  
}
}

if(Questions.depth==18){
if(symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 18  abdominal_pain
symptomp ="yellowish_skin" ; 
}
else if(symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  abdominal_pain
  symptomp ="indigestion" ;  
}
}
if(Questions.depth==19){

if(symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 19  yellowish_skin
symptomp ="family_history" ; 
}
else if(symptopms[19]==1 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  yellowish_skin
  symptomp ="itching" ;   
}
}
//yellowish_skin
if(Questions.depth==19){

if(symptopms[19]==0 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 19  yellowish_skin
symptomp ="yellowing_of_eyes" ; 
}
else if(symptopms[19]==1 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  yellowish_skin
  symptomp ="finish" ;   
}
}
if(Questions.depth==20){
if(symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 20  family_history
symptomp ="cough" ; 
}
else if(symptopms[20]==1 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  family_history
  symptomp ="nausea" ;   
}
}
if(Questions.depth==21){

if(symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 21  cough
symptomp ="chest_pain" ; 
}
else if(symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  cough
  symptomp ="fatigue" ;  
}
}
if(Questions.depth==21){

if(symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 21  cough
symptomp ="finish" ; 
}
else if(symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  cough
  symptomp ="finish" ;  
}

}

if(Questions.depth==22){
if(symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 22  chest_pain
symptomp ="altered_sensorium" ; 
}
else if(symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  chest_pain
  symptomp ="stomach_pain" ;   
}
}
if(Questions.depth==22){
if(symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){// 22  chest_pain amd malaise
symptomp ="chills" ; 
}
else if(symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){//  chest_pain
  symptomp ="sweating" ;   
}
}
if(Questions.depth==23){
if(symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 23  altered_sensorium
symptomp ="blister" ; 
}
else if(symptopms[23]==1 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  altered_sensorium
  symptomp ="weakness_of_one_body_side" ;   // added it was finish
}
}
if(Questions.depth==24){
if(symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 24  blister
symptomp ="high_fever" ; 
}
else if(symptopms[24]==1 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  blister
  symptomp ="high_fever" ;   // edited by Sarah, It was finish
}
}
if(Questions.depth==25){
if(symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 25  high_fever
symptomp ="vomiting" ; 
}
else if(symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  high_fever
  symptomp ="skin_rash" ;  
}
}

if(Questions.depth==25){
if(symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 25  high_fever //!!!
symptomp ="knee_pain" ; 
}
else if(symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  high_fever
  symptomp ="finish" ;  
}
}

if(Questions.depth==25){
if(symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){// 25  high_fever //!!!
symptomp ="finish" ; 
}
else if(symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){//  high_fever
  symptomp ="receiving_blood_transfusion" ;  
}
}

if(Questions.depth==25){ // 25  high_fever // added  by Sarah (high_fever or no high_fever - blister)
if(symptopms[25]==0 && symptopms[24]==1 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="skin_rash" ; 
}
else if(symptopms[25]==1 && symptopms[24]==1 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="skin_rash" ;  
}
}



if(Questions.depth==26){
if(symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 26  vomiting
symptomp ="burning_micturition" ; 
}
else if(symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  vomiting
  symptomp ="sunken_eyes" ;   
}
}
if(Questions.depth==26){
if(symptopms[26]==1 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 26  vomiting and joint pain
symptomp ="throat_irritation" ; // here i changed
}
else if(symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  vomiting
  symptomp ="finish" ;   
}
}
if(Questions.depth==26){
if(symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==1 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 26  vomiting and loss balance
symptomp ="back_pain" ; 
}
else if(symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==1 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  vomiting
  symptomp ="finish" ;   
}
}
if(Questions.depth==26){
if(symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 26  vomiting and joint pain
symptomp ="skin_peeling" ; // here i changed
}
else if(symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  vomiting
  symptomp ="high_fever" ;   
}
}
if(Questions.depth==26){
if(symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==1 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 26  vomiting and joint pain
symptomp ="finish" ; // here i changed
}
else if(symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==1 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  vomiting
  symptomp ="finish" ;   
}
}
if(Questions.depth==26){
if(symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 26  vomiting and joint pain
symptomp ="finish" ; // here i changed
}
else if(symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  vomiting
  symptomp ="finish" ;   
}
}

if(Questions.depth==26){ // added by Sarah
if(symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==1 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 26  vomiting and diarrhoea
symptomp ="sunken_eyes" ; 
}
else if(symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==1 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  vomiting
  symptomp ="sunken_eyes" ;   
}
}



if(Questions.depth==27){

if(symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 27  burning_micturition
symptomp ="itching" ; 
}
else if(symptopms[27]==1 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  burning_micturition
  symptomp ="foul_smell_of urine" ;  
}
}


if(Questions.depth==27){ // added by Sarah (burning_micturition - bladder_discomfort)

if(symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==1 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 27  burning_micturition
symptomp ="foul_smell_of urine" ; 
}
else if(symptopms[27]==1 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==1 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  burning_micturition
  symptomp ="foul_smell_of urine" ;  
}
}

if(Questions.depth ==28){
if(symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 28  itching
symptomp ="nodal_skin_eruptions" ; 
}
else if(symptopms[28]==1 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  29 stomach pain
  symptomp ="stomach_pain" ;   
}
}
if(Questions.depth ==28){
if(symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==1 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 28  itching
symptomp ="finish" ; 
}
else if(symptopms[28]==1 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==1 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  29 stomach pain
  symptomp ="finish" ;   
}
}
if(Questions.depth ==28){
if(symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==1 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 28  itching
symptomp ="finish" ; 
}
else if(symptopms[28]==1 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==1 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  29 stomach pain
  symptomp ="finish" ;   
}
}

if(Questions.depth==29){ // maybe chicken pox
if(symptopms[29]==1 &&symptopms[28]==1 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 29 stomach pain
symptomp ="red_spots_over_body" ; 
}
else if(symptopms[29]==0 && symptopms[28]==1 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// stomach pain
  symptomp ="skin_rash" ;   
}
}
if(Questions.depth==29){
if(symptopms[29]==1 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 29 stomach pain
symptomp ="acidity" ; 
}
else if(symptopms[29]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// stomach pain
  symptomp ="acidity" ;   
}
}
if(Questions.depth==30){
if(symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// nodal_skin_eruptions30
symptomp ="skin_rash" ; 
}
else if(symptopms[30]==0 && symptopms[29]==0 && symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//30 nodal_skin_eruptions
  symptomp ="continuous_sneezing" ;    
}}
if(Questions.depth==31){
if(symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0  &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 31 continuous_sneezing
symptomp ="skin_rash" ; 
}
else if(symptopms[31]==1  &&symptopms[30]==0 && symptopms[29]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//31 continuous_sneezing
  symptomp ="shivering" ;   // new symptopm // updated it was finish
}
}
if(Questions.depth==31){
if(symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0  &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){// 31 continuous_sneezing
symptomp ="high_fever" ; 
}
else if(symptopms[31]==1  &&symptopms[30]==0 && symptopms[29]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){//31 continuous_sneezing
  symptomp ="shivering" ;   // new symptopm // updated it was finish
}
}
if(Questions.depth==32){
if(symptopms[32]==1  &&symptopms[31]==0 &&symptopms[30]==0&& symptopms[29]==0  &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 32 skin_rash
symptomp ="skin_peeling" ; 
}
else if(symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//32 
  symptomp ="muscle_wasting" ;   
}
}
if(Questions.depth==32){
if(symptopms[32]==1  &&symptopms[31]==0 &&symptopms[30]==0&& symptopms[29]==0  &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 32 skin_rash
symptomp ="red_sore_around_nose" ; 
}
else if(symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//32 
  symptomp ="extra_marital_contacts" ;   
}
}
if(Questions.depth==32){
if(symptopms[32]==1  &&symptopms[31]==0 &&symptopms[30]==0&& symptopms[29]==0  &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 32 skin_rash
symptomp ="finish" ; 
}
else if(symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//32 
  symptomp ="vomiting" ;   
}
}
if(Questions.depth==32){
if(symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0&& symptopms[29]==0  &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 32 skin_rash and joint pain
symptomp ="skin_peeling" ; 
}
else if(symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//32 
  symptomp ="high_fever" ;   
}
}
if(Questions.depth==32){
if(symptopms[32]==1  &&symptopms[31]==0 &&symptopms[30]==0&& symptopms[29]==0  &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 32 skin_rash
symptomp ="skin_peeling" ; 
}
else if(symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//32 
  symptomp ="vomiting" ;   
}
}
if(Questions.depth==32){
if(symptopms[32]==1  &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0  &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 32 skin_rash
symptomp ="red_spots_over_body" ; 
}
else if(symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==1 && symptopms[29]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//32 
  symptomp ="red_spots_over_body" ;   
}
}
if(Questions.depth==32){
if(symptopms[32]==1  &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==1 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 32 skin_rash
symptomp ="dischromic _patches" ; 
}
else if(symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 && symptopms[28]==1 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//32 
  symptomp ="dischromic _patches" ;   
}
}

if(Questions.depth==32){ // added by Sarah (skin_rash or no skin_rash - high_fever  - blister)
if(symptopms[32]==1  &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==1 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 32 skin_rash
symptomp ="red_sore_around_nose" ; 
}
else if(symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==1 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//32 
  symptomp ="red_sore_around_nose" ;   
}
}

if(Questions.depth==32){ // added by Sarah (skin_rash or no skin_rash - no high_fever  - blister)
if(symptopms[32]==1  &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==1 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 32 skin_rash
symptomp ="red_sore_around_nose" ; 
}
else if(symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==1 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//32 
  symptomp ="red_sore_around_nose" ;   
}
}

if(Questions.depth==33){
if(symptopms[33]==1  &&symptopms[32]==1&&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 33 skin_peeling
symptomp ="finish" ; 
}


else if(symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//33 skin_peeling
  symptomp ="finish" ;  
}
}

if(Questions.depth==33){
if(symptopms[33]==1  &&symptopms[32]==0&&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1&&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 33 skin_peeling
symptomp ="silver_like_dusting" ; 
}


else if(symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//33 skin_peeling
  symptomp ="knee_pain" ;  
}
}
if(Questions.depth==33){
if(symptopms[33]==1  &&symptopms[32]==1&&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1&&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 33 skin_peeling
symptomp ="silver_like_dusting" ; 
}


else if(symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//33 skin_peeling
  symptomp ="silver_like_dusting" ;  
}
}

if(Questions.depth==34){
if(symptopms[34]==1 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 34  muscle_wasting
symptomp ="finish" ; 
}


else if(symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//34  muscle_wasting
  symptomp ="fatigue" ;   
}
}

if(Questions.depth==35){
if(symptopms[35]==1 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 35  fatigue
symptomp ="finish" ; 
}


else if(symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//35  fatigue
  symptomp ="pain_during_bowel_movements" ;   
}

}

if(Questions.depth==35){
if(symptopms[35]==1 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 35  fatigue
symptomp ="breathlessness" ; // updated it was finish
}


else if(symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//35  fatigue
  symptomp ="stomach_pain" ;   // updated it was finish
}


}

if(Questions.depth==35){
if(symptopms[35]==1 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 35  fatigue
symptomp ="cough" ; 
}


else if(symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//35  fatigue
  symptomp ="finish" ;   
}

}

if(Questions.depth==35){
if(symptopms[35]==1 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 35  fatigue
symptomp ="finish" ; 
}


else if(symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//35  fatigue
  symptomp ="finish" ;   
}


}
if(Questions.depth==35){
if(symptopms[35]==1 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 35  fatigue
symptomp ="finish" ; 
}


else if(symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//35  fatigue
  symptomp ="finish" ;   
}


}
if(Questions.depth==36){
if(symptopms[36]==1 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 36 pain_during_bowel_movements
symptomp ="finish" ; 
}


else if(symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//36  pain_during_bowel_movements
  symptomp ="muscle_weakness" ;   
}
}

if(Questions.depth==36){ // added by Sarah
if(symptopms[36]==1 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==1 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 36 pain_during_bowel_movements
symptomp ="irritation_in_anus" ; 
}


else if(symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==1 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//36  pain_during_bowel_movements
  symptomp ="irritation_in_anus" ;   
}
}

if(Questions.depth==37){
if(symptopms[37]==1 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 37 muscle_weakness
symptomp ="finish" ; 
}


else if(symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 37 muscle_weakness
  symptomp ="finish" ;  
}

}

if(Questions.depth==38){
if(symptopms[38]==1&& symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==1 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  38 foul_smell_of urine
symptomp ="finish" ; 
}


else if(symptopms[38]==0 && symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==1 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 38 foul_smell_of urine
  symptomp ="finish" ;  
}

}

if(Questions.depth==38){ // added by Sarah (foul_smell_of urine or no foul_smell_of urine - burning_micturition - bladder_discomfort)

if(symptopms[38]==1&& symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==1 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==1 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  38 foul_smell_of urine
symptomp ="continuous_feel_of_urine" ; 
}


else if(symptopms[38]==0 && symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==1 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==1 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 38 foul_smell_of urine
  symptomp ="continuous_feel_of_urine" ;  
}

}

if(Questions.depth==38){ // added by Sarah (foul_smell_of urine or no foul_smell_of urine - no burning_micturition - bladder_discomfort)

if(symptopms[38]==1&& symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==1 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  38 foul_smell_of urine
symptomp ="continuous_feel_of_urine" ; 
}


else if(symptopms[38]==0 && symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==1 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 38 foul_smell_of urine
  symptomp ="continuous_feel_of_urine" ;  
}

}

if(Questions.depth==39){
if(symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 39 sunken_eyes
symptomp ="breathlessness" ; 
}


else if(symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 39  sunken_eyes
  symptomp ="dehydration" ;   
}

}

if(Questions.depth==39){ // added by Sarah
if(symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==1 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 39 sunken_eyes or no sunken_eyes  - no vomiting - diarrhoea
symptomp ="dehydration" ; 
}


else if(symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==1 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 39  sunken_eyes
  symptomp ="dehydration" ;   
}

}

if(Questions.depth==39){ // added by Sarah
if(symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==1 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 39 sunken_eyes or no sunken_eyes -  vomiting - diarrhoea
symptomp ="dehydration" ; 
}


else if(symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==1 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 39  sunken_eyes
  symptomp ="dehydration" ;   
}

}


if(Questions.depth==40){
if(symptopms[40]==1 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 40 breathlessness"
symptomp ="sweating" ; 
}


else if(symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 40  breathlessness"
  symptomp ="stomach_pain" ;   
}

}
if(Questions.depth==40){
if(symptopms[40]==1 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 40 breathlessness"
symptomp ="mucoid_sputum" ; 
}


else if(symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 40  breathlessness"
  symptomp ="blood_in_sputum" ; /// here tub  
}

}
if(Questions.depth==40){ // if he said yes to no breath and no to fatigue
if(symptopms[40]==1 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 40 breathlessness"
symptomp ="finish" ; 
}


else if(symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 40  breathlessness"
  symptomp ="finish" ;   
}

}
if(Questions.depth==40){
if(symptopms[40]==1 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 40 breathlessness"
symptomp ="fatigue" ; 
}


else if(symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 40  breathlessness"
  symptomp ="fatigue" ;   
}

}

if(Questions.depth==40){
if(symptopms[40]==1 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){// 40 breathlessness"
symptomp ="finish" ; 
}


else if(symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1&& symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){// 40  breathlessness"
  symptomp ="finish" ;   
}

}


if(Questions.depth==29){
  print("seeee");
if( symptopms[29]==1 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0&& symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 29 stomach_pain
symptomp ="acidity" ; 
}


else if( symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 29 stomach_pain
  symptomp ="headache" ;    
}

}
if(Questions.depth==29){
  print("seeee");
if( symptopms[29]==1 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0&& symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 29 stomach_pain
symptomp ="acidity"; 
}


else if( symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0  && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 29 stomach_pain
  symptomp ="loss_of_smell" ;    
}

}
if(Questions.depth==41){
if( symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 41 headache
symptomp ="dizziness" ; // updated
}


else if( symptopms[41]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==1 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 41 headache
  symptomp ="blood_in_sputum" ;   // updated
}
}
// weakness_of_one_body_side if has headache
if(Questions.depth==41){
if( symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 41 headache
symptomp ="weakness_of_one_body_side" ; 
}


else if( symptopms[41]==1 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==1 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 41 headache
  symptomp ="finish" ;  // no need  
}
}
if(Questions.depth==41){
if( symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==1 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 41 headache
symptomp ="finish" ; 
}


else if( symptopms[41]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==1 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==1 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 41 headache
  symptomp ="finish" ;  // no need  
}
}
if(Questions.depth==41){ // headache and chest pain
if( symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 41 headache
symptomp ="dizziness" ; 
}


else if( symptopms[41]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 41 headache
  symptomp ="blood_in_sputum" ;  // no need  
}
}
if(Questions.depth==41){ // headache and loss of balamce and unsteadiness
if( symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==1 &&symptopms[14]==1 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 41 headache
symptomp ="spinning_movements" ; 
}


else if( symptopms[41]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==1 &&symptopms[14]==1 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 41 headache
  symptomp ="spinning_movements" ;  // no need  
}
}

if(Questions.depth==42){
if( symptopms[42]==1 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==1 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 42 nausea
symptomp ="finish" ; 
}


else if( symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==1 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// nausea
  symptomp ="finish" ;   // 
}
}

if(Questions.depth==42){
if( symptopms[42]==1 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 42 nausea
symptomp ="finish" ; 
}


else if( symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// nausea
  symptomp ="finish" ;   // 
}
}
if(Questions.depth==43){
if( symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 43 indigestion
symptomp ="distention_of_abdomen" ; 
}


else if( symptopms[43]==1 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="yellowish_skin" ;   // indigestion
}
}
if(Questions.depth==43){
if( symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==1 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 43 indigestion
symptomp ="finish" ; 
}


else if( symptopms[43]==1 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==1 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="yellowing_of_eyes" ;   // indigestion
}
}
if(Questions.depth==44){
if( symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 44 distention_of_abdomen
symptomp ="vomiting" ; 
}


else if( symptopms[44]==1 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="vomiting" ;   // distention_of_abdomen
}
}
if(Questions.depth==44){
if( symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 44 distention_of_abdomen
symptomp ="finish" ; 
}


else if( symptopms[44]==1 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;   // distention_of_abdomen
}
}
if(Questions.depth==45){
if(  symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==1 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 45 back_pain
symptomp ="finish" ; 
}


else if(  symptopms[45]==1 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==1 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;   // back_pain
}
}
if(Questions.depth==45){ // back pain and neck pain
if(  symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==1 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 45 back_pain
symptomp ="dizziness" ; 
}


else if(  symptopms[45]==1 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==1 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="dizziness" ;   // back_pain and dizziness
}
}
if(Questions.depth==46){
if( symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==1 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 46 acidity
symptomp ="visual_disturbances" ; 
}


else if( symptopms[46]==1 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==1 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="visual_disturbances" ;   //acidity
}
}
if(Questions.depth==46){
if( symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==1 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 46 acidity
symptomp ="finish" ; 
}


else if( symptopms[46]==1 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==1 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;   //acidity
}
}
if(Questions.depth==46){
if( symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 46 acidity
symptomp ="finish" ; 
}


else if( symptopms[46]==1 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;   //acidity
}
}

if(Questions.depth==46){
if( symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==1 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 46 acidity
symptomp ="finish" ; 
}


else if( symptopms[46]==1 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==1 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0&& symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;   //acidity
}
}
if(Questions.depth==46){
if( symptopms[46]==1 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==1 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 46 acidity
symptomp ="finish" ; 
}


else if( symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==1 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0&& symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;   //acidity
}
}

if(Questions.depth==47){
if( symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==1 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 47 restlessness
symptomp ="finish" ; 
}


else if( symptopms[47]==1 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==1  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;   //restlessness
}
}
if(Questions.depth==48){
if( symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==1 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 48 knee_pain
symptomp ="finish" ; 
}


else if(symptopms[48]==1 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==1 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="back_pain" ;   //knee_pain
}
}
if(Questions.depth==48){
if( symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 48 knee_pain
symptomp ="painful_walking" ; 
}


else if(symptopms[48]==1 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;   //knee_pain
}
}
if(Questions.depth==48){
if( symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 48 knee_pain
symptomp ="finish" ; 
}


else if(symptopms[48]==1 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;   //knee_pain
}
}
if(Questions.depth==48){
if( symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==1 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 48 knee_pain
symptomp ="back_pain" ; 
}


else if(symptopms[48]==1 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==1 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="painful_walking" ;   //knee_pain
}
}
if(Questions.depth==49){
if( symptopms[49]==1 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==1 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 49 coma
symptomp ="yellowing_of_eyes" ; //edited by Sarah
}


else if( symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==1 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="receiving_blood_transfusion" ;   //coma //edited by Sarah
}
}
if(Questions.depth==50){
if(  symptopms[50]==1 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==1 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 50 increased_appetite
symptomp ="finish" ; 
}


else if(  symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==1 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;   //increased_appetite
}
}
if(Questions.depth==51){
if( symptopms[51]==1 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==1 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 51 slurred_speech
symptomp ="finish" ; 
}


else if( symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==1 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// slurred_speech
  symptomp ="finish" ;   //slurred_speech
}
}
if(Questions.depth==52){
if( symptopms[52]==1 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){// 52  yellowing_of_eyes
symptomp ="mild_fever" ; 
}


else if( symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
    symptomp = "chest_pain";
}
}
if(Questions.depth==52){
if( symptopms[52]==1 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==1 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==1 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 52  yellowing_of_eyes
symptomp ="finish" ; 
}


else if( symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==1 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==1 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
    symptomp = "finish";
}
}
if(Questions.depth==52){
if( symptopms[52]==1 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==1 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 52  yellowing_of_eyes
symptomp ="finish" ; 
}


else if( symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
    symptomp = "finish";
}
}

if(Questions.depth==52){ // added by Sarah (yellowing_of_eyes or no yellowing_of_eyes - coma - dark_urine)
if( symptopms[52]==1 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==1 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==1 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 52  yellowing_of_eyes
symptomp ="acute_liver_failure" ; 
}


else if(symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==1 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==1 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
    symptomp = "acute_liver_failure";
}
}

if(Questions.depth==53){
if(symptopms[53]==1 && symptopms[52]==1 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){// 53 mild_fever
symptomp ="red_spots_over_body" ; 
}


else if( symptopms[53]==0 && symptopms[52]==1 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="red_spots_over_body" ;   // mild_fever
}
}

if(Questions.depth==53){
if(symptopms[53]==1 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){// 53 mild_fever
symptomp ="throat_irritation" ; 
}


else if( symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
  symptomp ="phlegm" ;   // mild_fever and mucle pain
}
}

if(Questions.depth==53){
if(symptopms[53]==1 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){// 53 mild_fever
symptomp ="finish" ; 
}


else if( symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;   // mild_fever a malaise
}
}
if(Questions.depth==54){
if(symptopms[54]==1 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){// 54  pain_behind_the_eyes
symptomp ="red_spots_over_body" ; 
}


else if(symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
  symptomp ="mild_fever" ;   //  pain_behind_the_eyes
}
}


if(Questions.depth==55){
if(symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){// 55  phlegm
symptomp ="sweating" ; 
}


else if(symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
  symptomp ="loss_of_smell" ;   //  phlegm
}
}
if(Questions.depth==55){ // phlegm and continous sneezing
if(symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 55  phlegm
symptomp ="throat_irritation" ; 
}


else if(symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==1  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="loss_of_smell" ;   //  phlegm
}
}
if(Questions.depth==55){ // phlegm 
if(symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 55  phlegm
symptomp ="rusty_sputum" ; 
}


else if(symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;   //  phlegm
}
}
if(Questions.depth==55){ // phlegm 
if(symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){// 55  phlegm
symptomp ="finish" ; 
}


else if(symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==1  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="rusty_sputum" ;   //  phlegm
}
}

if(Questions.depth==55){ // phlegm 
if(symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 55  phlegm
symptomp ="loss_of_smell" ; 
}


else if(symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="rusty_sputum" ;   //  phlegm
}
}
if(Questions.depth==55){ // phlegm 
if(symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 55  phlegm
symptomp ="rusty_sputum" ; 
}


else if(symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="rusty_sputum" ;   //  phlegm
}
}
if(Questions.depth==56){

if(symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){// 56 enlarged_thyroid
symptomp ="sweating" ; //edited by Sarah, it was finish
}


else if(symptopms[56]==1 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
  symptomp ="lethargy" ;   //  enlarged_thyroid //edited by Sarah, it was finish
}
}
if(Questions.depth==57){ // spinning 57

if(symptopms[57]==1 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==1 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==1 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="vomiting" ;  
}
}
if(Questions.depth==57){ // spinning 57

if(symptopms[57]==1 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==1 &&symptopms[14]==1 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==1 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==1 &&symptopms[14]==1 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  // updated 
}
}
if(Questions.depth==57){ // spinning 57

if(symptopms[57]==1 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==1 &&symptopms[14]==1 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==1 &&symptopms[14]==1 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  // updated 
}
}
if(Questions.depth==58){ // extra_marital_contacts 58

if(symptopms[58]==1 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; // extra_marital_contacts 58
}


else if(symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="mucoid_sputum" ;  
}
}
if(Questions.depth==59){ //mucoid_sputum 59

if(symptopms[59]==1 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="breathlessness" ; // mucoid_sputum 59 // updated
}


else if(symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="loss_of_smell" ;  //mucoid_sputum
}
}
if(Questions.depth==59){ //mucoid_sputum 59

if(symptopms[59]==1 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==1  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; // mucoid_sputum 59 // updated
}


else if(symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==1 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //mucoid_sputum
}
}
if(Questions.depth==59){ //mucoid_sputum 59

if(symptopms[59]==1 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; // mucoid_sputum 59 // updated
}


else if(symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //mucoid_sputum
}
}
if(Questions.depth==59){ //mucoid_sputum 59

if(symptopms[59]==1 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==1  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; // mucoid_sputum 59 // updated
}


else if(symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==1 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && 
  symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //mucoid_sputum
}
}
if(Questions.depth==59){ //mucoid_sputum 59

if(symptopms[59]==1 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==1  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; // mucoid_sputum 59 // updated
}


else if(symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 &&  symptopms[40]==1 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && 
  symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //mucoid_sputum
}
}




if(Questions.depth==60){ //loss_of_smell 60

if(symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="throat_irritation" ; //loss_of_smell 60
}


else if(symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="throat_irritation" ;  //loss_of_smell
}
}
if(Questions.depth==60){ //loss of smell and headache 

if(symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; //loss_of_smell
}
else if(symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; // loss_of_smell
}
}
if(Questions.depth==60){ //loss of smell and continous sneezing

if(symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; //loss_of_smell
}
else if(symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; // loss_of_smell
}
}
if(Questions.depth==60){ //loss of smell and continous sneezing and phelgm

if(symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; //loss_of_smell
}
else if(symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; // loss_of_smell
}
}
if(Questions.depth==60){ //loss of smell  and phelgm and cough and fatigue 

if(symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; //loss_of_smell
}
else if(symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; // loss_of_smell
}
}
if(Questions.depth==60){ //loss of smell  and phelgm and cough and fatigue 

if(symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="congestion" ; //loss_of_smell
}
else if(symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="congestion" ; // loss_of_smell
}
}
if(Questions.depth==60){ //loss of smell  and phelgm  

if(symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; //loss_of_smell
}
else if(symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; // loss_of_smell
}
}
if(Questions.depth==60){ //loss of smell  and musle pain 

if(symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
symptomp ="finish" ; //loss_of_smell
}
else if(symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
symptomp ="finish" ; // loss_of_smell
}
}

if(Questions.depth==61){ //throat_irritation

if(symptopms[61]==1 &&symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; //throat_irritation
}
else if(symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; //throat_irritation
}


else if(symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //throat_irritation
}
}
if(Questions.depth==61){ //throat_irritation and headache

if(symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="visual_disturbances" ; //throat_irritation
}
else if(symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="visual_disturbances" ; //throat_irritation
}



}

if(Questions.depth==61){ //throat_irritation and phelgm

if(symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="loss_of_smell" ; //throat_irritation
}
else if(symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="loss_of_smell" ; //throat_irritation
}



}
if(Questions.depth==61){ //throat_irritation and phelgm

if(symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="congestion" ; //throat_irritation
}
else if(symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="loss_of_smell" ; //throat_irritation
}



}
if(Questions.depth==61){ //throat_irritation and headache

if(symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="visual_disturbances" ; //throat_irritation
}
else if(symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="visual_disturbances" ; //throat_irritation
}



}
if(Questions.depth==61){ //throat_irritation and continous sneezing

if(symptopms[61]==1 &&symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="congestion" ; //throat_irritation
}
else if(symptopms[61]==0 &&symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="congestion" ; //throat_irritation
}



}
if(Questions.depth==61){ //throat_irritation and continous sneezing

if(symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="congestion" ; //throat_irritation
}
else if(symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="congestion" ; //throat_irritation
}



}
if(Questions.depth==61){ //throat_irritation and mild fever and musle pain

if(symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==1 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
symptomp ="congestion" ; //throat_irritation
}
else if(symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==1 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
symptomp ="sweating" ; //throat_irritation
}



}
if(Questions.depth==61){ //throat_irritation and vomiting and high fever and joint pain

if(symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="congestion" ; //throat_irritation
}
else if(symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="congestion" ; //throat_irritation
}



}








if(Questions.depth==62){ // weakness in one body side

if(symptopms[62]==1 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==1 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="sinus_pressure" ;  
}
}

if(Questions.depth==62){ // weakness in one body side and altered sensorium

if(symptopms[62]==1 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==1 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==1 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="headache" ;  
}
}
if(Questions.depth==63){ // sinus_pressure

if(symptopms[63]==1 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="throat_irritation" ; 
}


else if(symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==1 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="throat_irritation" ;  
}
}
if(Questions.depth==63){ // sinus_pressure

if(symptopms[63]==1 &&symptopms[62]==0 &&symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==1 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  
}
}
//// shivering
if(Questions.depth==64){ // shivering 

if(symptopms[64]==1 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="watering_from_eyes" ; 
}


else if(symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==1  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="phlegm" ;  // now go to phegm put continous sneezing one - number 31 
}
}
if(Questions.depth==64){ // shivering 

if(symptopms[64]==1 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==1  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="phlegm" ;  // now go to phegm put continous sneezing one - number 31 
}
}
// rusty_sputum 65 
if(Questions.depth==65){ // rusty_sputum 65 

if(symptopms[65]==1 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="fast_heart_rate" ; 
}


else if(symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="throat_irritation" ;  // rusty_sputum 65 
}
}
if(Questions.depth==65){ // rusty_sputum 65 

if(symptopms[65]==1 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==1  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  // rusty_sputum 65 
}
}

if(Questions.depth==65){ // rusty_sputum 65 

if(symptopms[65]==1 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  // rusty_sputum 65 
}
}
if(Questions.depth==65){ // rusty_sputum 65 

if(symptopms[65]==1 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  // rusty_sputum 65 
}
}
if(Questions.depth==65){ // rusty_sputum 65 

if(symptopms[65]==1 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  // rusty_sputum 65 
}
}
// 66 red_sore_around_nose
if(Questions.depth==66){ // 66 red_sore_around_nose

if(symptopms[66]==1 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="yellow_crust_ooze" ; 
}


else if(symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="yellow_crust_ooze" ;  //66 red_sore_around_nose
}
}

if(Questions.depth==66){ // 66 red_sore_around_nose // added by Sarah (red_sore_around_nose or no red_sore_around_nose - skin_rash -  high_fever  - blister)

if(symptopms[66]==1 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==1 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==1 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //66 red_sore_around_nose
}
}

if(Questions.depth==66){ // 66 red_sore_around_nose // added by Sarah (red_sore_around_nose or no red_sore_around_nose - no skin_rash -  high_fever  - blister)

if(symptopms[66]==1 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==1 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==1 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //66 red_sore_around_nose
}
}

if(Questions.depth==66){ // 66 red_sore_around_nose // added by Sarah (red_sore_around_nose or no red_sore_around_nose -  skin_rash -  no high_fever  - blister)

if(symptopms[66]==1 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==1 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==1 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //66 red_sore_around_nose
}
}

if(Questions.depth==66){ // 66 red_sore_around_nose // added by Sarah (red_sore_around_nose or no red_sore_around_nose -  no skin_rash -  no high_fever  - blister)

if(symptopms[66]==1 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==1 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==1 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //66 red_sore_around_nose
}
}

// yellow_crust_ooze
if(Questions.depth==67){ // yellow_crust_ooze 67

if(symptopms[67]==1 && symptopms[66]==1 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //67 yellow_crust_ooze
}
}
if(Questions.depth==67){ // yellow_crust_ooze 67

if(symptopms[67]==1 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[67]==0 &&symptopms[66]==1 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //67 yellow_crust_ooze
}
}
// family_history
if(Questions.depth==68){ // visual_disturbances 68

if(symptopms[68]==1 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==1 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //visual_disturbances 68
}
}
if(Questions.depth==68){ // visual_disturbances 68

if(symptopms[68]==1 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==1 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //visual_disturbances 68
}
}
if(Questions.depth==68){ // visual_disturbances 68

if(symptopms[68]==1 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==1 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==1&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==1 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //visual_disturbances and sinus pressure 68
}
}
if(Questions.depth==68){ // visual_disturbances 68

if(symptopms[68]==1 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==1 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==1 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="blurred_and_distorted_vision" ; 
}


else if(symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==1 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==1 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="blurred_and_distorted_vision" ;  //visual_disturbance AND STIFF NECK 68
}
}
if(Questions.depth==68){ // visual_disturbances 68

if(symptopms[68]==1 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==1 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="blurred_and_distorted_vision" ; 
}


else if(symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==1 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="blurred_and_distorted_vision" ;  //visual_disturbance AND STIFF NECK 68
}
}
//red_spots_over_body
if(Questions.depth==69){ // red_spots_over_body 69

if(symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==1 && symptopms[52]==1 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==1 && symptopms[52]==1 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0&& symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //visual_disturbances and sinus pressure 68
}
}
if(Questions.depth==69){ // red_spots_over_body 69

if(symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="mild_fever" ; 
}


else if(symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="mild_fever" ;  //red_spots_over_body 69
}
}
if(Questions.depth==69){ // red_spots_over_body 69 with malise and mild fever 

if(symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==1 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; // now go to mild fever in case of no 
}


else if(symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==1 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //red_spots_over_body 69
}
}
if(Questions.depth==69){ // red_spots_over_body 69 with malise and mild fever 

if(symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="swelled_lymph_nodes" ; // n 
}


else if(symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==1  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="pus_filled_pimples" ;  //red_spots_over_body 69
}
}
if(Questions.depth==69){ // red_spots_over_body 69 with malise and mild fever 

if(symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="swelled_lymph_nodes" ; // now go to mild fever in case of no 
}


else if(symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==1  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="pus_filled_pimples" ;  //red_spots_over_body 69
}
}
if(Questions.depth==69){ // red_spots_over_body 69 with malise and mild fever 

if(symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==1 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
symptomp ="loss_of_appetite" ; // now go to mild fever in case of no 
}


else if(symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==1 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
  symptomp ="loss_of_appetite" ;  //red_spots_over_body 69
}
}
if(Questions.depth==69){ // red_spots_over_body 69 with itching and stomachpain

if(symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0&&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==1 &&symptopms[28]==1 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; // now go to mild fever in case of no 
}


else if(symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==1 &&symptopms[28]==1 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]== 0&& symptopms[0]==0){
  symptomp ="finish" ;  //red_spots_over_body 69
}
}


//sweating70
if(Questions.depth==70){ // sweating 70

if(symptopms[70]==1 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="breathlessness" ; 
}


else if(symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="breathlessness" ;  //sweating 70
}
}
if(Questions.depth==70){ // sweating 70

if(symptopms[70]==1 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==1  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==1 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //sweating 70
}
}

if(Questions.depth==70){ // sweating 70

if(symptopms[70]==1 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==1  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==1 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="mucoid_sputum" ;  //sweating 70
}
}
if(Questions.depth==70){ // sweating 70

if(symptopms[70]==1 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==1 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==1 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //sweating 70
}
}

if(Questions.depth==70){ // sweating 70

if(symptopms[70]==1 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==1 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==1 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
  symptomp ="finish" ;  //sweating 70
}
}
if(Questions.depth==70){ // sweating 70

if(symptopms[70]==1 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
  symptomp ="finish" ;  //sweating 70
}
}

if(Questions.depth==70){ // sweating 70 // added by Sarah (sweating or no sweating - abnormal_menstruation)

if(symptopms[70]==1 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
symptomp ="fast_heart_rate" ; 
}


else if(symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
  symptomp ="fast_heart_rate" ;  //sweating 70
}
}


//receiving_blood_transfusion
if(Questions.depth==71){ // receiving_blood_transfusion 71

if(symptopms[71]==1 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  // 71 receiving_blood_transfusion
}
}

//receiving_blood_transfusion
if(Questions.depth==71){ // receiving_blood_transfusion 71 // added by Sarah (receiving_blood_transfusion or no receiving_blood_transfusion - dark_urine)

if(symptopms[71]==1 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==00 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==1 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="lethargy" ; 
}


else if(symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==1 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="lethargy" ;  // 71 receiving_blood_transfusion
}
}


// dehydration

if(Questions.depth==72){ // dehydration 72

if(symptopms[72]==1 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="nausea" ; 
}


else if(symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==1 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="nausea" ;  //dehydration 72
}
}
if(Questions.depth==72){ // dehydration 72

if(symptopms[72]==1 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==1 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==1 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==1 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //dehydration 72
}
}

if(Questions.depth==72){ // dehydration 72 // added by Sarah // dehydration or no dehydration - sunken_eyes -  vomiting - diarrhoea

if(symptopms[72]==1 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==1 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==1 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==1 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //dehydration 72
}
}

if(Questions.depth==72){ // dehydration 72 // added by Sarah // dehydration or no dehydration - no sunken_eyes -  vomiting - diarrhoea

if(symptopms[72]==1 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==1 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==1 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==1 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //dehydration 72
}
}

if(Questions.depth==72){ // dehydration 72 // added by Sarah // dehydration or no dehydration -  sunken_eyes -  no vomiting - diarrhoea

if(symptopms[72]==1 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==1 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==1 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //dehydration 72
}
}

if(Questions.depth==72){ // dehydration 72 // added by Sarah // dehydration or no dehydration -  no sunken_eyes -  no vomiting - diarrhoea

if(symptopms[72]==1 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==1 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==1 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //dehydration 72
}
}

//dizziness
if(Questions.depth==73){ // dizziness 73

if(symptopms[73]==1 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==1 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==1 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //dizziness 73
}
}
if(Questions.depth==73){ // dizziness 73

if(symptopms[73]==1 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==1 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==1 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==1 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==1 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //dizziness 73
}
}
if(Questions.depth==73){ // dizziness 73

if(symptopms[73]==1 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==1 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==1 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //dizziness 73
}
}
if(Questions.depth==74){ // blood_in_sputum 74

if(symptopms[74]==1 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="swelled_lymph_nodes" ; 
}


else if(symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="phlegm" ;  //blood_in_sputum 74
}
}
if(Questions.depth==74){ // blood_in_sputum 74

if(symptopms[74]==1 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="swelled_lymph_nodes" ; 
}


else if(symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="phlegm" ;  //blood_in_sputum 74
}
}
if(Questions.depth==75){ // swelled_lymph_nodes 75

if(symptopms[75]==1 &&symptopms[74]==1 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[75]==0 &&symptopms[74]==1 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //swelled_lymph_nodes 75
}
}
if(Questions.depth==75){ // swelled_lymph_nodes 75

if(symptopms[75]==1 &&symptopms[74]==1 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[75]==0 &&symptopms[74]==1 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==1 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //swelled_lymph_nodes 75
}
}
if(Questions.depth==75){ // swelled_lymph_nodes 75

if(symptopms[75]==1 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==1  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //swelled_lymph_nodes 75
}
}
if(Questions.depth==75){ // swelled_lymph_nodes 75

if(symptopms[75]==1 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="loss_of_appetite" ; 
}


else if(symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==1  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="loss_of_appetite" ;  //swelled_lymph_nodes 75
}
}
if(Questions.depth==75){ // swelled_lymph_nodes 75

if(symptopms[75]==1 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="loss_of_appetite" ; 
}


else if(symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==1  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="loss_of_appetite" ;  //swelled_lymph_nodes 75
}
}



// watering_from_eyes
if(Questions.depth==76){ // watering_from_eyes 76

if(symptopms[76]==1 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==1 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==1 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==1  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //watering_from_eyes 76
}
}
if(Questions.depth==76){ // watering_from_eyes 76

if(symptopms[76]==1 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==1 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==1 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==1  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //watering_from_eyes 76
}
}
// congestion 
if(Questions.depth==77){ // congestion  77

if(symptopms[77]==1 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==1 &&symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==1 &&symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==1  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //watering_from_eyes 76
}
}
if(Questions.depth==77){ // congestion  77

if(symptopms[77]==1 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==1  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //watering_from_eyes 76
}
}
if(Questions.depth==77){ // congestion  77

if(symptopms[77]==1 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //watering_from_eyes 76
}
}
if(Questions.depth==77){ // congestion  77

if(symptopms[77]==1 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==1  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //watering_from_eyes 76
}
}
if(Questions.depth==77){ // congestion  77

if(symptopms[77]==1 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==1 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //watering_from_eyes 76
}
}
//congestion
if(Questions.depth==77){ // congestion  77

if(symptopms[77]==1 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //watering_from_eyes 76
}
}
if(Questions.depth==77){ // congestion  77

if(symptopms[77]==1 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==1 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==1 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
  symptomp ="finish" ;  // congestion and throat irritation and mildfaver and muscle pain.
}
}
if(Questions.depth==77){ // congestion  77

if(symptopms[77]==1 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==1 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  // congestion and throat irritation and mildfaver and muscle pain.
}
}
if(Questions.depth==77){ // congestion  77

if(symptopms[77]==1 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==1 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  // congestion and throat irritation and mildfaver and muscle pain.
}
}
if(Questions.depth==77){ // congestion  77

if(symptopms[77]==1 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==1 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==1 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==1  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  
}
}
//fast_heart_rate
if(Questions.depth==78){ // fast_heart_rate  78

if(symptopms[78]==1 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==1 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="sweating" ; 
}


else if(symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==1 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="sweating" ;  //fast_heart_rate  78
}
}
if(Questions.depth==78){ // fast_heart_rate  78

if(symptopms[78]==1 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==1 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==1 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==1 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==1 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==1 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //fast_heart_rate  78
}
}

if(Questions.depth==78){ // fast_heart_rate  78 // added by Sarah (fast_heart_rate or no fast_heart_rate - sweating - abnormal_menstruation)


if(symptopms[78]==1 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==1 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
symptomp ="excessive_hunger" ; 
}


else if(symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==1 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
  symptomp ="excessive_hunger" ;  
}
}

if(Questions.depth==78){ // fast_heart_rate  78 // added by Sarah (fast_heart_rate or no fast_heart_rate - no sweating - abnormal_menstruation)


if(symptopms[78]==1 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
symptomp ="excessive_hunger" ; 
}


else if(symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
  symptomp ="excessive_hunger" ;  
}
}


// pus_filled_pimples
if(Questions.depth==79){ // pus_filled_pimples  79

if(symptopms[79]==1 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //pus_filled_pimples 79
}
}
if(Questions.depth==79){ // fast_heart_rate  78

if(symptopms[79]==1 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //fast_heart_rate  78
}
}
if(Questions.depth==80){ // loss_of_apetite  79

if(symptopms[80]==1 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==1 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}
// dont forget case 69=0 and 32 = 0 

else if(symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==1 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //loss_of_apetite  79
}
}
if(Questions.depth==80){ // loss_of_apetite  79

if(symptopms[80]==1 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}
// dont forget case 69=0 and 32 = 0 

else if(symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //loss_of_apetite  79
}
}
if(Questions.depth==80){ // loss_of_apetite  79

if(symptopms[80]==1 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==1 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}
// dont forget case 69=0 and 32 = 0 

else if(symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==1 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //loss_of_apetite  79
}
}
if(Questions.depth==80){ // loss_of_apetite  79

if(symptopms[80]==1 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}
// dont forget case 69=0 and 32 = 0 

else if(symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //loss_of_apetite  79
}
}
if(Questions.depth==80){ // loss_of_apetite  79

if(symptopms[80]==1 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}
// dont forget case 69=0 and 32 = 0 

else if(symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //loss_of_apetite  79
}
}

if(Questions.depth==80){ // loss_of_apetite  80

if(symptopms[80]==1 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==1 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}
// dont forget case 69=0 and 32 = 0 

else if(symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==1 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //loss_of_apetite  80
}
}
if(Questions.depth==80){ // loss_of_apetite  80

if(symptopms[80]==1 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}
// dont forget case 69=0 and 32 = 0 

else if(symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //loss_of_apetite  79
}
}
if(Questions.depth==80){ // loss_of_apetite 80

if(symptopms[80]==1 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==1 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}
// dont forget case 69=0 and 32 = 0 

else if(symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==1 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //loss_of_apetite  79
}
}
if(Questions.depth==80){ // loss_of_apetite  79

if(symptopms[80]==1 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}
// dont forget case 69=0 and 32 = 0 

else if(symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //loss_of_apetite  79
}
}
if(Questions.depth==80){ // loss_of_apetite  79

if(symptopms[80]==1 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}
// dont forget case 69=0 and 32 = 0 

else if(symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //loss_of_apetite  79
}
}
if(Questions.depth==80){ // loss_of_apetite  79

if(symptopms[80]==1 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==1 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}
// dont forget case 69=0 and 32 = 0 

else if(symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==1 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //loss_of_apetite  79
}
}

if(Questions.depth==80){ // loss_of_apetite  79

if(symptopms[80]==1 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==1 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==1 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==1 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
  symptomp ="finish" ;  //loss_of_apetite  79
}
}
if(Questions.depth==80){ // loss_of_apetite  79

if(symptopms[80]==1 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==1 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==1 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
  symptomp ="finish" ;  //loss_of_apetite  79
}
}


//silver_like_dusting
if(Questions.depth==81){ // silver_like_dusting  80

if(symptopms[81]==1 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==1 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==1  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //silver_like_dusting  80
}
}
if(Questions.depth==81){ // silver_like_dusting  80

if(symptopms[81]==1 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //silver_like_dusting  80
}
}
if(Questions.depth==81){ // silver_like_dusting  80

if(symptopms[81]==1 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==1 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==1  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //silver_like_dusting  80
}
}
//painful_walking 82
if(Questions.depth==82){ // painful_walking 82

if(symptopms[82]==1 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==1 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //painful_walking 82
}
}
if(Questions.depth==82){ // painful_walking 82

if(symptopms[82]==1 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==1 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==1 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="hip_joint_pain" ; 
}


else if(symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==1 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==1 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="hip_joint_pain" ;  //painful_walking 82
}
}
//dischromic _patches 83

if(Questions.depth==83){ // dischromic _patches 83

if(symptopms[83]==1 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==1 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==1 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0&&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==1 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==1 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0&& 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //dischromic _patches 83
}
}
if(Questions.depth==83){ // dischromic _patches 83

if(symptopms[83]==1 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==1 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==1 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  //painful_walking 82
}
}
//weakness_in_limbs 84
if(Questions.depth==84){ // /weakness_in_limbs 84

if(symptopms[84]==1 &&symptopms[83]==0 &&symptopms[82]==1 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==1 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==1 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==1 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==1 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==1 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  ///weakness_in_limbs 84
}
}
if(Questions.depth==84){ // /weakness_in_limbs 84

if(symptopms[84]==1 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==1 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==1 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==1 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==1 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  ///weakness_in_limbs 84
}
}

//
if(Questions.depth==84){ // /weakness_in_limbs 84

if(symptopms[84]==1 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==1 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==1 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==1 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==1 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  ///weakness_in_limbs 84
}
}
//blurred_and_distorted_vision
if(Questions.depth==85){ // /blurred_and_distorted_vision 85

if(symptopms[85]==1 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==1 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==1 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==1 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==1 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==1 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==1 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  ///blurred_and_distorted_vision 85
}
}
if(Questions.depth==85){ // /blurred_and_distorted_vision 85

if(symptopms[85]==1 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==1 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==1 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==1 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==1 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  ///blurred_and_distorted_vision 85
}
}
if(Questions.depth==85){ // /blurred_and_distorted_vision 85

if(symptopms[85]==1 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==1 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==1 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==1 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==1 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  ///blurred_and_distorted_vision 85
}
}
if(Questions.depth==85){ // /blurred_and_distorted_vision 85

if(symptopms[85]==1 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==1 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==1 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  ///blurred_and_distorted_vision 85
}
}

if(Questions.depth==86){ // irritation_in_anus 86 // added by Sarah (irritation_in_anus or no irritation_in_anus - pain_during_bowel_movements - constipation )

if(symptopms[86]==1 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==1 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==1 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="bloody_stool" ; 
}


else if(symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==1 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==1 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="bloody_stool" ;  
}
}

if(Questions.depth==86){ // irritation_in_anus 86 // added by Sarah (irritation_in_anus or no irritation_in_anus - no pain_during_bowel_movements - constipation )

if(symptopms[86]==1 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==1 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="bloody_stool" ; 
}


else if(symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==1 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="bloody_stool" ;  
}
}

if(Questions.depth==87){ // bloody_stool 87 // added by Sarah (bloody_stool or no bloody_stool - irritation_in_anus - pain_during_bowel_movements - constipation )

if(symptopms[87]==1 && symptopms[86]==1 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==1 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==1 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[87]==0 && symptopms[86]==1 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==1 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==1 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  
}
}

if(Questions.depth==87){ // bloody_stool 87 // added by Sarah (bloody_stool or no bloody_stool - no irritation_in_anus - pain_during_bowel_movements - constipation )

if(symptopms[87]==1 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==1 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==1 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==1 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==1 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  
}
}

if(Questions.depth==87){ // bloody_stool 87 // added by Sarah (bloody_stool or no bloody_stool -  irritation_in_anus - no pain_during_bowel_movements - constipation )

if(symptopms[87]==1 && symptopms[86]==1 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==1 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[87]==0 && symptopms[86]==1 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==1 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  
}
}

if(Questions.depth==87){ // bloody_stool 87 // added by Sarah (bloody_stool or no bloody_stool -  no irritation_in_anus - no pain_during_bowel_movements - constipation )

if(symptopms[87]==1 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==1 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==1 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  
}
}

if(Questions.depth==88){ // lethargy 88 // added by Sarah (lethargy or no lethargy - enlarged_thyroid - abnormal_menstruation )

if(symptopms[88]==1 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==1 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
symptomp ="puffy_face_and_eyes" ; 
}


else if(symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==1 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
  symptomp ="puffy_face_and_eyes" ;  
}
}

if(Questions.depth==88){ // lethargy 88 // added by Sarah (lethargy or no lethargy - receiving_blood_transfusion - dark_urine )

if(symptopms[88]==1 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==1 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==1 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==1 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==1 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  
}
}

if(Questions.depth==88){ // lethargy 88 // added by Sarah (lethargy or no lethargy - no receiving_blood_transfusion - dark_urine )

if(symptopms[88]==1 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==1 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==1 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  
}
}

if(Questions.depth==89){ // puffy_face_and_eyes 89 // added by Sarah (puffy_face_and_eyes or no puffy_face_and_eyes - lethargy - enlarged_thyroid - abnormal_menstruation )

if(symptopms[89]==1 && symptopms[88]==1 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==1 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
symptomp ="finish" ; 
}


else if(symptopms[89]==0 && symptopms[88]==1 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==1 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
  symptomp ="finish" ;  
}
}

if(Questions.depth==89){ // puffy_face_and_eyes 89 // added by Sarah (puffy_face_and_eyes or no puffy_face_and_eyes - no lethargy - enlarged_thyroid - abnormal_menstruation )

if(symptopms[89]==1 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==1 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
symptomp ="finish" ; 
}


else if(symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==1 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
  symptomp ="finish" ;  
}
}

if(Questions.depth==90){ // excessive_hunger 90 // added by Sarah (excessive_hunger or no excessive_hunger - fast_heart_rate  -  sweating - abnormal_menstruation)

if(symptopms[90]==1 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==1 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==1 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
symptomp ="finish" ; 
}


else if(symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==1 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==1 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
  symptomp ="finish" ;  
}
}

if(Questions.depth==90){ // excessive_hunger 90 // added by Sarah (excessive_hunger or no excessive_hunger - no fast_heart_rate  -  sweating - abnormal_menstruation)

if(symptopms[90]==1 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==1 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
symptomp ="finish" ; 
}


else if(symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==1 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
  symptomp ="finish" ;  
}
}

if(Questions.depth==90){ // excessive_hunger 90 // added by Sarah (excessive_hunger or no excessive_hunger -  fast_heart_rate  -  no sweating - abnormal_menstruation)

if(symptopms[90]==1 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==1 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
symptomp ="finish" ; 
}


else if(symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==1 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
  symptomp ="finish" ;  
}
}

if(Questions.depth==90){ // excessive_hunger 90 // added by Sarah (excessive_hunger or no excessive_hunger - no fast_heart_rate  -  no sweating - abnormal_menstruation)

if(symptopms[90]==1 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
symptomp ="finish" ; 
}


else if(symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
  symptomp ="finish" ;  
}
}

if(Questions.depth==91){ // continuous_feel_of_urine 91  // added by Sarah (continuous_feel_of_urine or no continuous_feel_of_urine - foul_smell_of urine - burning_micturition - bladder_discomfort)

if(symptopms[91]==1 && symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==1 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==1 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==1 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[91]==0 && symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==1 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==1 && symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==1 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  
}
}

if(Questions.depth==91){ // continuous_feel_of_urine 91  // added by Sarah (continuous_feel_of_urine or no continuous_feel_of_urine - no foul_smell_of urine - burning_micturition - bladder_discomfort)

if(symptopms[91]==1 && symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==1 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==1 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[91]==0 && symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==1 && symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==1 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  
}
}

if(Questions.depth==91){ // continuous_feel_of_urine 91  // added by Sarah (continuous_feel_of_urine or no continuous_feel_of_urine - foul_smell_of urine - no burning_micturition - bladder_discomfort)

if(symptopms[91]==1 && symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==1 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==1 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[91]==0 && symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==1 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==1 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  
}
}

if(Questions.depth==91){ // continuous_feel_of_urine 91  // added by Sarah (continuous_feel_of_urine or no continuous_feel_of_urine - no foul_smell_of urine - no burning_micturition - bladder_discomfort)

if(symptopms[91]==1 && symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==1 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[91]==0 && symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==1 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  
}
}

if(Questions.depth==92){ // acute_liver_failure 92  // added by Sarah (acute_liver_failure -  yellowing_of_eyes - coma - dark_urine)

if(symptopms[92]==1 && symptopms[91]==0 && symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==1 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==1 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==1 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[92]==0 && symptopms[91]==0 && symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==1 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==1 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==1 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  
}
}

if(Questions.depth==92){ // acute_liver_failure 92  // added by Sarah (acute_liver_failure or no acute_liver_failure  - no yellowing_of_eyes - coma - dark_urine)

if(symptopms[92]==1 && symptopms[91]==0 && symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 && symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0 &&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==1 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==1 && symptopms[5]==0 && 
symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
symptomp ="finish" ; 
}


else if(symptopms[92]==0 && symptopms[91]==0 && symptopms[90]==0 && symptopms[89]==0 && symptopms[88]==0 && symptopms[87]==0 && symptopms[86]==0 && symptopms[85]==0 &&symptopms[84]==0 &&symptopms[83]==0 &&symptopms[82]==0 &&symptopms[81]==0 &&symptopms[80]==0 &&symptopms[79]==0 &&symptopms[78]==0 &&symptopms[77]==0 &&symptopms[76]==0 &&symptopms[75]==0 &&symptopms[74]==0 &&symptopms[73]==0 &&symptopms[72]==0 && symptopms[71]==0 &&symptopms[70]==0 &&symptopms[69]==0 &&symptopms[68]==0 &&symptopms[67]==0 &&symptopms[66]==0 &&symptopms[65]==0 &&symptopms[64]==0 &&symptopms[63]==0&&symptopms[62]==0 &&symptopms[61]==0 &&symptopms[60]==0 &&symptopms[59]==0 &&symptopms[58]==0 &&symptopms[57]==0 &&symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==1 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[41]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==0 && symptopms[25]== 0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==1 && symptopms[5]==0 && 
  symptopms[4]== 0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;  
}
}




return symptomp ; 

}

//processing the symp coming from the model
//////////////////
///
Future<Response> predict(List<String> x) async{
var y = await PredictDisease(x);

return y ; 

}
Future<Response> predictD(String d) async{
  var y = getDiseaseDescription(d); 
  return y ; 

}
Future<Response> predictA(String d ) async{
   var y = getDiseasePrecaution(d); 
  return y ; 
}

Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
           content: Text(
             "  هل أنت متأكد من رغبتك في الخروج ؟ ",
                  style: GoogleFonts.tajawal(
                    fontSize: 14,
                    //fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 7, 7, 7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child:Text(
                 "نعم",
                  style: GoogleFonts.tajawal(
                    fontSize: 15,
                    //fontStyle: FontStyle.italic,
                    color: Color(0xFF007282),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              onPressed: () {
             Questions.allSymptompsArray =  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0
 ,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0,0,0,0, 0, 0, 0, 0, 0, 0, 0,0,0,0,
 0,0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0,0,0,00,0,0,0,0,0,0,0,0,0];
              Questions.nextSymp = widget.sympController;
               // coming from the model // 
               Questions.comingFromModel = true;

               Navigator.of(context).pushReplacement(
                             MaterialPageRoute(builder: (context) => Navigation()));
          
                //hould be the human body model
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child:Text(
                 "لا",
                  style: GoogleFonts.tajawal(
                    fontSize: 15,
                    //fontStyle: FontStyle.italic,
                    color: Color(0xFF007282),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


////////////////////////
var Symptomp ; 
var index ; 
bool show = false  ; 
List<String> Yes_Symptoms=[]; // this is the array that will collect the symptopms that the user has said yes to and pass it to PredictDieseas API
var disease ; 
var description ; 
var precaution ; 

// processing the symptopm coming from the model
//////////////////////////////////////////////////////


////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
      //// Attention////
      ///the variable nextSymp should be coming from the prevois page which is the human model
      ///
      
    if(Questions.comingFromModel == true ){
      Questions.nextSymp = widget.sympController ;
    if(Questions.nextSymp =="finish"){
// \\disease = await PredictDisease(Yes_Symptoms); 
// description = await getDiseaseDescription(jsonDecode(disease).body['result'][0]);
// precaution = await getDiseasePrecaution(jsonDecode(disease).body['result'][0]);
// print(disease);
print("D1");
                          
     }
    else if(Questions.nextSymp=="abnormal_menstruation"){
    index = 0 ; 
  
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("abnormal_menstruation"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="muscle_pain"){
    index = 1; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("muscle_pain"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="malaise"){
    index = 2; 
    
    
    Questions.allSymptompsArray[index]=1 ;
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("malaise");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }

   else if (Questions.nextSymp=="irritability"){
    index = 3; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("irritability");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="chills"){
    index = 4; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("chills");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print("here"); 
    print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="weight_loss"){
    index = 5; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("weight_loss");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="dark_urine"){
    index = 6; 
   
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("dark_urine");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="joint_pain"){
    index = 7;
   
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("joint_pain");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="neck_pain"){
    index = 8; 
    
    Questions.allSymptompsArray[index]=1 ;
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("neck_pain");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="obesity"){
    index = 9; 
    Questions.allSymptompsArray[index]=1; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("obesity");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="stiff_neck"){
    index = 10; 

    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("stiff_neck");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="constipation"){
    index = 11; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("constipation");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="diarrhoea"){
    index = 12; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("diarrhoea");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="swelling_of_stomach"){
    index = 13; 
    Questions.allSymptompsArray[index]=1;
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("swelling_of_stomach"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="unsteadiness"){
    index = 14; 
    Questions.allSymptompsArray[index]=1 ;
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("unsteadiness"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="loss_of_balance"){
    index = 15; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("loss_of_balance"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="bladder_discomfort"){
    index = 16; 
    Questions.allSymptompsArray[index]=1 ;
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("bladder_discomfort"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp);
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray);  
   }
   else if (Questions.nextSymp=="passage_of_gases"){
    index = 17; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("passage_of_gases"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="abdominal_pain"){
    index = 18; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("abdominal_pain"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="yellowish_skin"){
    index = 19; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("yellowish_skin"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="family_history"){
    index = 20; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("family_history"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp);
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray);  
   }
   else if (Questions.nextSymp=="cough"){
    index = 21; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("cough"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="chest_pain"){
    index = 22; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    Yes_Symptoms.add("chest_pain"); 
    print(Questions.depth);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="altered_sensorium"){
    index = 23; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("altered_sensorium"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="blister"){
    index = 24; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("blister"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="high_fever"){
    index = 25; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("high_fever"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="vomiting"){
    index = 26; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("vomiting"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="burning_micturition"){
    index = 27; 
    
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("burning_micturition"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="itching"){
    index = 28; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("itching"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print(Yes_Symptoms); 
    print(Questions.allSymptompsArray);
    print(Questions.depth) ; 
   }
   else if (Questions.nextSymp=="stomach_pain"){
    index = 29; 
   
    
    print(Questions.depth);
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("stomach_pain"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="nodal_skin_eruptions"){
    index = 30; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("nodal_skin_eruptions"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
    print(Questions.depth); 
   }
   else if (Questions.nextSymp=="continuous_sneezing"){
    index = 31; 
    Questions.allSymptompsArray[index]=1 ;
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("continuous_sneezing"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="skin_rash"){
    index = 32; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("skin_rash"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="skin_peeling"){
    index = 33; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("skin_peeling"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="muscle_wasting"){
    index = 34; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("muscle_wasting"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="fatigue"){
    index = 35; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("fatigue"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="pain_during_bowel_movements"){
    index = 36; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("pain_during_bowel_movements"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="muscle_weakness"){
    index = 37; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("muscle_weakness"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="foul_smell_of urine"){
    index = 38; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("foul_smell_of urine"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="sunken_eyes"){
    index = 39; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("sunken_eyes"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="breathlessness"){
    index = 40; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("breathlessness"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="headache"){
    index = 41; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("headache"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }

   else if (Questions.nextSymp=="nausea"){
    index = 42; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("nausea"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="indigestion"){
    index = 43; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("indigestion"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="distention_of_abdomen"){
    index = 44; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("distention_of_abdomen"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="back_pain"){
    index = 45; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("back_pain"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="acidity"){
    index = 46; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("acidity"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="restlessness"){
    index = 47; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("restlessness"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="knee_pain"){
    index = 48; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("knee_pain"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="coma"){
    index = 49; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("coma"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="increased_appetite"){
    index = 50; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("increased_appetite"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="slurred_speech"){
    index = 51; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("slurred_speech"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="yellowing_of_eyes"){
    index = 52; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("yellowing_of_eyes"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }

   else if (Questions.nextSymp=="mild_fever"){
    index = 53; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("mild_fever"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="pain_behind_the_eyes"){
    index = 54; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("pain_behind_the_eyes"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="phlegm"){
    index = 55; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("phlegm"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="enlarged_thyroid"){
    index = 56; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("enlarged_thyroid"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="spinning_movement"){
    index = 57; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("spinning_movement"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="extra_marital_contacts"){
    index = 58; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("extra_marital_contacts"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="mucoid_sputum"){
    index = 59; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("mucoid_sputum"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="loss_of_smell"){
    index = 60; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("loss_of_smell"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
  else if (Questions.nextSymp=="throat_irritation"){
    index = 61; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("throat_irritation"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   // weakness_of_one_body_side
   else if (Questions.nextSymp=="weakness_of_one_body_side"){
    index = 62; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("weakness_of_one_body_side"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } // 
   //swelled_lymph_nodes
   else if (Questions.nextSymp=="sinus_pressure"){
    index = 63; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("sinus_pressure"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="shivering"){
    index = 64; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("shivering"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   //rusty_sputum
   else if (Questions.nextSymp=="rusty_sputum"){
    index = 65; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("rusty_sputum"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   // red_sore_around_nose
   else if (Questions.nextSymp=="red_sore_around_nose"){
    index = 66; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("red_sore_around_nose"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
//yellow_crust_ooze
 else if (Questions.nextSymp=="yellow_crust_ooze"){
    index = 67; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("yellow_crust_ooze"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
if(Questions.nextSymp!="finish"){
 print(Questions.nextSymp);
 setState(() {
   show = true ; 
 });
 
 }
 

Questions.comingFromModel = false ; 
      }

    return Scaffold(
      appBar: AppBar(
        leading:IconButton(icon: Icon(Icons.arrow_back , size: 35,), color:  Color(0xFF007282), 
        onPressed: () =>  _dialogBuilder(context)
         
     
         
        
        ),
       // backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
         elevation: 0.0,
        centerTitle: true,
      backgroundColor: Colors.white,
       title: Image.asset('assets/Images/taaf.jpg' , height: 90, alignment: FractionalOffset.center), 
       toolbarHeight: 100,
      ),
      backgroundColor: Colors.white,
    
      body: Container(
        width:500 ,
        
        //  decoration:Questions.nextSymp!="finish"? BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage('assets/Images/Q2.jpeg' ), 
        //     fit: BoxFit.fill
        //      )): BoxDecoration(),
          // decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage('assets/Images/background_(1).png'),
          //     fit: BoxFit.fill)),

       
        child:
            Column(children: [
              SizedBox(height: 30,),
              if(Questions.nextSymp!="finish")
           Text(
                  "تعافَ يقوم بتشخِيصك الآن",
                  style: GoogleFonts.tajawal(
                    fontSize: 23,
                    //fontStyle: FontStyle.italic,
                    color: Color(0xFF007282),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if(Questions.nextSymp=="finish")
                  Container(
                width: 389.9,
                height: 120.7,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                alignment: AlignmentDirectional(-0.1, -0.55),
                child: Container(
                  width: 389.1,
                 // height: 100,
                  decoration: BoxDecoration(),
                  child: Align(
                    alignment: AlignmentDirectional(0.9, 1),
                    child: Text(
                      DateTime.now().toString(),
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Tajawal',
                            color: Color(0xFF8C8C8C),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ),
                    Container(
                      height: 45.6,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.9, 0),
                        child: Text(
                          'ملخص',
                          textAlign: TextAlign.end,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Tajawal',
                                    color: Color(0xFF636366),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                    Container(
                      width: 382,
                      //height: 90.8,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.8, -1),
                        child: Text(
                          'ملاحظة: نتيجة هذا الإختبار هي فقط تشخيص أولي لا يغنيك عن زيارة الطبيب    ' ,
                          textAlign: TextAlign.end,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Tajawal',
                                    color: Color(0xFF636366),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                //SizedBox(height: 20,),
                // if(Questions.nextSymp != "finish")
                // Container(
               
                //   child:Image.asset(
                //                     'assets/Images/q4.png',
                //                     width: 100,
                //                     height: 80,
                //                     fit: BoxFit.cover,
                //                   ),),
    
                

          Column(children: [ 
            if(Questions.nextSymp!="finish")
            SizedBox(height:80),
// we have 2 widgets , questions widget will view the questions and the result - the answer widget will view yes no button , each button should contains a specific logic as will be shown below
           _questionWidget(Questions.nextSymp),SizedBox(height: 60,),
          _answerButton(), ],
          )
         
         
          
        ]),
      ),
    );
  }

  _questionWidget(String symp)  { // this widget is going to show the questions if the disease is not yet reached , if the disease is reached it is going to show the result
    print("symp");
    print(symp);
    print("Questions.nextSymp");
    print(Questions.nextSymp);

   
 

    if(symp =="finish"){ // means that we have reached an end and the diagnosis should appear

         Future<String> getArabicDisease(String name, String type) async {
       findArabicDisease arabicDiseaseClass = new findArabicDisease();
        await arabicDiseaseClass.findDisease(name, type);
      String arabicData = "";

         switch (type) {
    case "disease":
     arabicData = arabicDiseaseClass.foundDisease[0].nameAr!;
      break;

    case "description": 
     arabicData = arabicDiseaseClass.foundDisease[0].descriptionAr!;
      break;

    case "advice1": 
      arabicData = arabicDiseaseClass.foundDisease[0].advice1Ar!;
      break;

    case "advice2": 
      arabicData = arabicDiseaseClass.foundDisease[0].advice2Ar!;
      break;

    case "advice3": 
      arabicData = arabicDiseaseClass.foundDisease[0].advice3Ar!;
      break;

    case "advice4": 
      arabicData = arabicDiseaseClass.foundDisease[0].advice4Ar!;
      break;

  }
      
       return arabicData;
  }
       
      return Column(
     children:[

      
        
       

      Column(children: [
       FutureBuilder<Response>(
        future: predict(Yes_Symptoms), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Response> snapshot)  {
          List<Widget> children;
          if (snapshot.hasData) {
            //var x = await PredictDisease(Yes_Symptoms);
          Questions.expected = jsonDecode((snapshot.data)!.body)['result'].toString() ;

            children = <Widget>[
              SizedBox(height:15),
              Container(
                      height: 40.1,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.9, -1),
                        child: Text(
                          'من المحتمل أنك تعاني من ',
                          textAlign: TextAlign.end,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Tajawal',
                                    color: Color(0xFF636366),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                    Container(
                      height: 45.9,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child:  FutureBuilder(
                          future: getArabicDisease(jsonDecode((snapshot.data)!.body)['result'][0].toString(), "disease"),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // If we got an error
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    '${snapshot.error} occurred',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                );

                                // if we got our data
                              } else if (snapshot.hasData) {
                                // Extracting data from snapshot object
                                final arabicDisease = snapshot.data as String;
                        return Align(
                        alignment: AlignmentDirectional(0.9, -1),
                        child: Text(
                         arabicDisease,
                          textAlign: TextAlign.end,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Tajawal',
                                    color: Color(0xFF007282),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      );
                              }
                            }

                            return SizedBox();
                          },

                          
                        ),
                    ),
       
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                // width: 60,
                // height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),

       
        

      ],),
        
        
        Container(
                      width: 380,
                      height: 35,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.95, -1),
                        child: Text(
                          'وصف المرض',
                          textAlign: TextAlign.end,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Tajawal',
                                    color: Color(0xFF636366),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
        // SizedBox(height: 5,),
        Column(children: [ Container(
height:69,
width: 500,


       child: 
       FutureBuilder<Response>(
        future: predict(Yes_Symptoms), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Response> snapshot1) {
          List<Widget> children;
          if (snapshot1.hasData) {

            children = <Widget>[

        FutureBuilder<Response>(
          
        future: predictD(jsonDecode((snapshot1.data)!.body)['result'][0].toString()), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Response> snapshot2) {
          List<Widget> children;
          if (snapshot2.hasData) {
            print(jsonDecode((snapshot1.data)!.body)['result'][0].toString());
            print(jsonDecode((snapshot2.data)!.body)['result'][0].toString()); 
            print("snapshots");
            children = <Widget>[
          FutureBuilder(
                          future: getArabicDisease(jsonDecode((snapshot2.data)!.body)['result'].toString(), "description"),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // If we got an error
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    '${snapshot.error} occurred',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                );

                                // if we got our data
                              } else if (snapshot.hasData) {
                                // Extracting data from snapshot object
                                final arabicDiscription = snapshot.data as String;
                          return   Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(arabicDiscription ,  style: const TextStyle(
                                  color: Color(0xFF636366),
                                  fontSize: 12,
            
                                  fontWeight: FontWeight.w600,
                                  ),));
                              }
                            }

                            return SizedBox();
                          },

                          
                        ),
         
            ];
          } else if (snapshot2.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot2.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
               // width: 60,
               // height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),


             
            ];
          } else if (snapshot1.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot1.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
               // width: 60,
               // height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
       
      ),
           SizedBox(height: 5,),

          Container(
                      width: 380,
                      height: 35,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.95, -1),
                        child: Text(
                          ' نصائح',
                          textAlign: TextAlign.end,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Tajawal',
                                    color: Color(0xFF636366),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
              SizedBox(height: 5,),
          Container(
          height:70,
          width: 500,

          child:
          FutureBuilder<Response>(
        future: predict(Yes_Symptoms), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Response> snapshot1) {
          List<Widget> children;
          if (snapshot1.hasData) {
            children = <Widget>[
               FutureBuilder<Response>(
        future: predictA(jsonDecode((snapshot1.data)!.body)['result'][0].toString()), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Response> snapshot2) {
          List<Widget> children;
          if (snapshot2.hasData) {
            print(jsonDecode((snapshot1.data)!.body)['result'][0].toString());
            print(jsonDecode((snapshot2.data)!.body)['result'][0].toString()); 
            print("snapshots");
            children = <Widget>[
               Column(children: [ 
              //advice1 future FutureBuilder
              FutureBuilder(
                          future: getArabicDisease(jsonDecode((snapshot2.data)!.body)['result'][0].toString(), "advice1"),
                          builder: (context, snapshot3) {
                            if (snapshot3.connectionState ==
                                ConnectionState.done) {
                              // If we got an error
                              if (snapshot3.hasError) {
                                return Center(
                                  child: Text(
                                    '${snapshot3.error} occurred',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                );

                                // if we got our data
                              } else if (snapshot3.hasData) {
                                // Extracting data from snapshot object
                                final arabicAdvice = snapshot3.data as String;
                             return  Align(alignment: Alignment.centerRight,
                             child: Text("   1-" + arabicAdvice +"                   ",  style: const TextStyle(
                             color:  Color(0xFF636366),
                             fontSize: 12,
            
                             fontWeight: FontWeight.w600,
                             ),),);  
                              }
                            }

                            return SizedBox();
                          },

                          
                        ),
        
         SizedBox(height : 5),

        //advice2 future FutureBuilder
              FutureBuilder(
                          future: getArabicDisease(jsonDecode((snapshot2.data)!.body)['result'][1].toString(), "advice2"),
                          builder: (context, snapshot4) {
                            if (snapshot4.connectionState ==
                                ConnectionState.done) {
                              // If we got an error
                              if (snapshot4.hasError) {
                                return Center(
                                  child: Text(
                                    '${snapshot4.error} occurred',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                );

                                // if we got our data
                              } else if (snapshot4.hasData) {
                                // Extracting data from snapshot object
                                final arabicAdvice = snapshot4.data as String;
                             return  Align(alignment: Alignment.centerRight,
                             child: Text("   2-" + arabicAdvice +"                   ",  style: const TextStyle(
                             color:  Color(0xFF636366),
                             fontSize: 12,
            
                             fontWeight: FontWeight.w600,
                             ),),);  
                              }
                            }

                            return SizedBox();
                          },

                          
                        ),

          SizedBox(height : 5),

         //advice3 future FutureBuilder
              FutureBuilder(
                          future: getArabicDisease(jsonDecode((snapshot2.data)!.body)['result'][2].toString(), "advice3"),
                          builder: (context, snapshot5) {
                            if (snapshot5.connectionState ==
                                ConnectionState.done) {
                              // If we got an error
                              if (snapshot5.hasError) {
                                return Center(
                                  child: Text(
                                    '${snapshot5.error} occurred',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                );

                                // if we got our data
                              } else if (snapshot5.hasData) {
                                // Extracting data from snapshot object
                                final arabicAdvice = snapshot5.data as String;
                             return  Align(alignment: Alignment.centerRight,
                             child: Text("   3-" + arabicAdvice +"                   ",  style: const TextStyle(
                             color:  Color(0xFF636366),
                             fontSize: 12,
            
                             fontWeight: FontWeight.w600,
                             ),),);  
                              }
                            }

                            return SizedBox();
                          },

                          
                        ),
          
          ]),
          
            ];
          } else if (snapshot2.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('Error: ${snapshot2.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                //width: 60,
                //height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
             
            ];
          } else if (snapshot1.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot1.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
               // width: 60,
               // height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
         
          
         ),
        ]),
SizedBox(height: 5,),
        ElevatedButton(
          child: Text('                      حفظ                          ',
          style: GoogleFonts.tajawal(
                    fontSize: 15,
                    //fontStyle: FontStyle.italic,
                    
                    color: Color.fromARGB(255, 255, 253, 253),
                    fontWeight: FontWeight.bold,
                  ),),
          style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(0, 114, 130, 30)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            //side: BorderSide(color: Colors.red)
          ),
        ),
          ),
          onPressed: () { // deem and aljoharah here you are going to use firebase 
          // Yes_Symptoms , disease , description and  are the 2 vari
              _firestore
          .collection('report')
          .doc(jsonDecode(disease.body)['result'][0].toString() + userId)
          .set(
            {
            'date': DateTime.now().toString(),
            'user': userId,
            'disease': jsonDecode(disease.body)['result'][0].toString() ,
            'description':jsonDecode(description.body)['result'].toString(),
            'precaution':jsonDecode(precaution.body)['result'].toString()
          });

          print('report added');
        
             Questions.allSymptompsArray =  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0
 ,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0,0,0,0, 0, 0, 0, 0, 0, 0, 0,0,0,0,
 0,0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0,0,0,00,0,0,0,0,0,0,0,0,0];
              Questions.nextSymp = widget.sympController ;
               // coming from the model // 
               Questions.comingFromModel = true;
                  print(Yes_Symptoms); 
              print(jsonDecode(disease.body)['result'][0].toString()); 
               print(jsonDecode(description.body)['result'].toString()); 
               print(jsonDecode(precaution.body)['result'][0].toString()); // at index zero is the first advice so you can store 3 in the firebase [1] and [2]
               
              Navigator.of(context).pushReplacement(
                             MaterialPageRoute(builder: (context) => Navigation()));


          },
        ),
        ]);


    
    }
    else{

     

    Future<String> getArabicSymp(String name) async {
       findArabicSymptom arabicSympClass = new findArabicSymptom();
        await arabicSympClass.findSymptom(name);
       String arabicSymp = arabicSympClass.foundSymptom[0].nameAr!;
       return arabicSymp;
  }

  
    //getArabicSymp(Questions.nextSymp);
    Questions.nextSymp = symp ; // save this spot

   // Questions.nextSymp = symp ; 
    //return Row(
     //children:[
      return  Container(
        height:100,
              child:
              FutureBuilder(
                          future: getArabicSymp(symp),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // If we got an error
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    '${snapshot.error} occurred',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                );

                                // if we got our data
                              } else if (snapshot.hasData) {
                                // Extracting data from snapshot object
                                final arabicSymp = snapshot.data as String;
                                return PhysicalModel(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                elevation: 18,
                shadowColor: Colors.black,
                child: Container(
                  height: 90,
                  width: 350,
                
              
        
     child: Center(
     child: Text(
                  " هل تعاني من ${arabicSymp}؟ ",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    fontSize: 20,
                    //fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 65, 66, 66),
                    fontWeight: FontWeight.bold,
                  ),
                ),),));
                              }
                            }

                            return SizedBox();
                          },

                          
                        ),
 );

   // ]);
  }

  }
  





  Widget _answerButton() {
    //bool isSelected = answer == "Yes";
    //bool show = false ; 
    if(Questions.nextSymp=="finish"){
      return Text(""); 
    }
   else{
    return Column(
      children:[
  // DecoratedBox(
  //   decoration: BoxDecoration(
  //   gradient:LinearGradient(colors: [Color.fromRGBO(0, 114, 130, 30) , Color.fromARGB(255, 248, 246, 246) , Colors.transparent]),
  //   borderRadius: BorderRadius.circular(30),
  //   boxShadow: <BoxShadow>[
  //     BoxShadow(
  //       color: Color.fromRGBO(0,0,0,0.57),
  //       blurRadius: 5 ,

  //     )

  //   ]
  //   ),
    
       OutlinedButton(
        
        child: Text(
                 "          نعم          ",
                  style: GoogleFonts.tajawal(
                    fontSize: 20,
                    //fontStyle: FontStyle.italic,
                    color: Color.fromARGB(224, 74, 198, 74),
                    fontWeight: FontWeight.bold,
                  ),
                ),
        style: OutlinedButton.styleFrom(
          
         side: BorderSide(width: 3.0, color: Color.fromRGBO(0, 114, 130, 30)),
         //shadowColor: Colors.transparent,
         backgroundColor:  Colors.white,
         shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(20)
       // )
         ),
        ),
        onPressed: () async{
if(Questions.nextSymp =="finish"){
disease = await PredictDisease(Yes_Symptoms); 
description = await getDiseaseDescription(jsonDecode(disease).body['result'][0]);
precaution = await getDiseasePrecaution(jsonDecode(disease).body['result'][0]);
print(disease);
print("D1");
                          
     }
    else if(Questions.nextSymp=="abnormal_menstruation"){
    index = 0 ; 
  
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("abnormal_menstruation"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="muscle_pain"){
    index = 1; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("muscle_pain"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="malaise"){
    index = 2; 
    
    
    Questions.allSymptompsArray[index]=1 ;
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("malaise");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }

   else if (Questions.nextSymp=="irritability"){
    index = 3; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("irritability");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="chills"){
    index = 4; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("chills");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print("here"); 
    print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="weight_loss"){
    index = 5; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("weight_loss");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="dark_urine"){
    index = 6; 
   
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("dark_urine");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="joint_pain"){
    index = 7;
   
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("joint_pain");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="neck_pain"){
    index = 8; 
    
    Questions.allSymptompsArray[index]=1 ;
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("neck_pain");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="obesity"){
    index = 9; 
    Questions.allSymptompsArray[index]=1; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("obesity");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="stiff_neck"){
    index = 10; 

    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("stiff_neck");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="constipation"){
    index = 11; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("constipation");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="diarrhoea"){
    index = 12; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("diarrhoea");
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="swelling_of_stomach"){
    index = 13; 
    Questions.allSymptompsArray[index]=1;
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("swelling_of_stomach"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="unsteadiness"){
    index = 14; 
    Questions.allSymptompsArray[index]=1 ;
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("unsteadiness"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="loss_of_balance"){
    index = 15; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("loss_of_balance"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="bladder_discomfort"){
    index = 16; 
    Questions.allSymptompsArray[index]=1 ;
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("bladder_discomfort"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp);
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray);  
   }
   else if (Questions.nextSymp=="passage_of_gases"){
    index = 17; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("passage_of_gases"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="abdominal_pain"){
    index = 18; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("abdominal_pain"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="yellowish_skin"){
    index = 19; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("yellowish_skin"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="family_history"){
    index = 20; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("family_history"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp);
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray);  
   }
   else if (Questions.nextSymp=="cough"){
    index = 21; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("cough"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="chest_pain"){
    index = 22; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    Yes_Symptoms.add("chest_pain"); 
    print(Questions.depth);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="altered_sensorium"){
    index = 23; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("altered_sensorium"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="blister"){
    index = 24; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("blister"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="high_fever"){
    index = 25; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("high_fever"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="vomiting"){
    index = 26; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("vomiting"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="burning_micturition"){
    index = 27; 
    
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("burning_micturition"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="itching"){
    index = 28; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("itching"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print(Yes_Symptoms); 
    print(Questions.allSymptompsArray);
    print(Questions.depth) ; 
   }
   else if (Questions.nextSymp=="stomach_pain"){
    index = 29; 
   
    
    print(Questions.depth);
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("stomach_pain"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="nodal_skin_eruptions"){
    index = 30; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    }
    Yes_Symptoms.add("nodal_skin_eruptions"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
    print(Questions.depth); 
   }
   else if (Questions.nextSymp=="continuous_sneezing"){
    index = 31; 
    Questions.allSymptompsArray[index]=1 ;
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("continuous_sneezing"); 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="skin_rash"){
    index = 32; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("skin_rash"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="skin_peeling"){
    index = 33; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("skin_peeling"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="muscle_wasting"){
    index = 34; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("muscle_wasting"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="fatigue"){
    index = 35; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("fatigue"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="pain_during_bowel_movements"){
    index = 36; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("pain_during_bowel_movements"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="muscle_weakness"){
    index = 37; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("muscle_weakness"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="foul_smell_of urine"){
    index = 38; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("foul_smell_of urine"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="sunken_eyes"){
    index = 39; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("sunken_eyes"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="breathlessness"){
    index = 40; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("breathlessness"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="headache"){
    index = 41; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("headache"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }

   else if (Questions.nextSymp=="nausea"){
    index = 42; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("nausea"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="indigestion"){
    index = 43; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("indigestion"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="distention_of_abdomen"){
    index = 44; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("distention_of_abdomen"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="back_pain"){
    index = 45; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("back_pain"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="acidity"){
    index = 46; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("acidity"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="restlessness"){
    index = 47; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("restlessness"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="knee_pain"){
    index = 48; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("knee_pain"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="coma"){
    index = 49; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("coma"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="increased_appetite"){
    index = 50; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("increased_appetite"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="slurred_speech"){
    index = 51; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("slurred_speech"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="yellowing_of_eyes"){
    index = 52; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("yellowing_of_eyes"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }

   else if (Questions.nextSymp=="mild_fever"){
    index = 53; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("mild_fever"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="pain_behind_the_eyes"){
    index = 54; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("pain_behind_the_eyes"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="phlegm"){
    index = 55; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("phlegm"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="enlarged_thyroid"){
    index = 56; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("enlarged_thyroid"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }

   else if (Questions.nextSymp=="spinning_movements"){
    index = 57; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("spinning_movements"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="extra_marital_contacts"){
    index = 58; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("extra_marital_contacts"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="mucoid_sputum"){
    index = 59; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("mucoid_sputum"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="loss_of_smell"){
    index = 60; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("loss_of_smell"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="throat_irritation"){
    index = 61; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("throat_irritation"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
  
else if (Questions.nextSymp=="weakness_of_one_body_side"){
    index = 62; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("weakness_of_one_body_side"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } // 
   else if (Questions.nextSymp=="sinus_pressure"){
    index = 63; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("sinus_pressure"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
// shivering
 else if (Questions.nextSymp=="shivering"){
    index = 64; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("shivering"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 


   else if (Questions.nextSymp=="rusty_sputum"){
    index = 65; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("rusty_sputum"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="red_sore_around_nose"){
    index = 66; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("red_sore_around_nose"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }

   else if (Questions.nextSymp=="yellow_crust_ooze"){
    index = 67; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("yellow_crust_ooze"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   // family_history
    else if (Questions.nextSymp=="visual_disturbances"){
    index = 68; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("visual_disturbances"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   //red_spots_over_body
   else if (Questions.nextSymp=="red_spots_over_body"){
    index = 69; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("red_spots_over_body"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   //sweating
else if (Questions.nextSymp=="sweating"){
    index = 70; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("sweating"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   //receiving_blood_transfusion
   else if (Questions.nextSymp=="receiving_blood_transfusion"){
    index = 71; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("receiving_blood_transfusion"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   // dehydration
   else if (Questions.nextSymp=="dehydration"){
    index = 72; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("dehydration"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
// dizziness
else if (Questions.nextSymp=="dizziness"){
    index = 73; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("dizziness"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

   else if (Questions.nextSymp=="blood_in_sputum"){
    index = 74; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("blood_in_sputum"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   //swelled_lymph_nodes
   else if (Questions.nextSymp=="swelled_lymph_nodes"){
    index = 75; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("swelled_lymph_nodes"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="watering_from_eyes"){
    index = 76; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("watering_from_eyes"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   //congestion
    else if (Questions.nextSymp=="congestion"){
    index = 77; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("congestion"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   //fast_heart_rate
   else if (Questions.nextSymp=="fast_heart_rate"){
    index = 78; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("fast_heart_rate"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 


   //pus_filled_pimples
    else if (Questions.nextSymp=="pus_filled_pimples"){
    index = 79; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("pus_filled_pimples"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

   else if (Questions.nextSymp=="loss_of_appetite"){
    index = 80; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("loss_of_appetite"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   //silver_like_dusting
   else if (Questions.nextSymp=="silver_like_dusting"){
    index = 81; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("silver_like_dusting"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   //painful_walking
   else if (Questions.nextSymp=="painful_walking"){
    index = 82; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("painful_walking"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   //dischromic _patches
   else if (Questions.nextSymp=="dischromic _patches"){
    index = 83; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("dischromic _patches"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   //weakness_in_limbs
   else if (Questions.nextSymp=="hip_joint_pain"){
    index = 84; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("hip_joint_pain"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

   //blurred_and_distorted_vision
   else if (Questions.nextSymp=="blurred_and_distorted_vision"){
    index = 85; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("blurred_and_distorted_vision"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

   //irritation_in_anus
   else if (Questions.nextSymp=="irritation_in_anus"){ // added by Sarah
    index = 86; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("irritation_in_anus"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

   //bloody_stool
   else if (Questions.nextSymp=="bloody_stool"){ // added by Sarah
    index = 87; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("bloody_stool"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

    //lethargy
   else if (Questions.nextSymp=="lethargy"){ // added by Sarah
    index = 88; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("lethargy"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

   //puffy_face_and_eyes
   else if (Questions.nextSymp=="puffy_face_and_eyes"){ // added by Sarah
    index = 89; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("puffy_face_and_eyes"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

   //excessive_hunger
   else if (Questions.nextSymp=="excessive_hunger"){ // added by Sarah
    index = 90; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("excessive_hunger"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

  //continuous_feel_of_urine
   else if (Questions.nextSymp=="continuous_feel_of_urine"){ // added by Sarah
    index = 91; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("continuous_feel_of_urine"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

  // acute_liver_failure
   else if (Questions.nextSymp=="acute_liver_failure"){ // added by Sarah
    index = 92; 
    Questions.allSymptompsArray[index]=1 ; 
    for(var i = 0 ; i<Questions.allSymptompsArray.length ; i++){
      if(Questions.allSymptompsArray[i]==1){
        Questions.depth = i ; 
      }

    } 
    Yes_Symptoms.add("acute_liver_failure"); 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 


if(Questions.nextSymp!="finish"){
 print(Questions.nextSymp);
 setState(() {
   show = true ; 
 });
 
 }
//blood_in_sputum
//


 else{
  show = true ; 
  print("d2");
  disease = await PredictDisease(Yes_Symptoms); 
  description = await getDiseaseDescription(jsonDecode(disease.body)['result'][0].toString());
  precaution = await getDiseasePrecaution(jsonDecode(disease.body)['result'][0].toString());
  print(disease.body);
  //return(ResultWidget(disease.body)) ;
  setState(() {
   show = true ; 
 });
 
 }
 

        },
      ),
      SizedBox(height:15),
      
       OutlinedButton(
        child: Text(
                "           لا             " ,
                  style: GoogleFonts.tajawal(
                    fontSize: 20,
                    //fontStyle: FontStyle.italic,
                    color: Color.fromARGB(225, 230, 41, 28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 3.0, color: Color.fromRGBO(0, 114, 130, 30)),
          backgroundColor: Colors.white,
         // backgroundColor:  Color.fromRGBO(0, 114, 130, 30),
          shape: const StadiumBorder(),
        ),
        onPressed: ()async {

if(Questions.nextSymp=="finish"){
disease = await PredictDisease(Yes_Symptoms); 
print(disease.body); 
description = await getDiseaseDescription(jsonDecode(disease).body['result'][0]);
precaution = await getDiseasePrecaution(jsonDecode(disease).body['result'][0]);
                          
     }
    else if(Questions.nextSymp=="abnormal_menstruation"){
    index = 0 ; 
    Questions.allSymptompsArray[index]=0 ; 
   Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="muscle_pain"){
    index = 1; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
     
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="malaise"){
    index = 2; 
    Questions.allSymptompsArray[index]=0 ;
    Questions.depth = index ; 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="irritability"){
    index = 3; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="chills"){
    index = 4; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="weight_loss"){
    index = 5; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="dark_urine"){
    index = 6; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="joint_pain"){
    index = 7; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="neck_pain"){
    index = 8; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="obesity"){
    index = 9; 
    Questions.allSymptompsArray[index]=0; 
   Questions.depth = index ; 
   
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="stiff_neck"){
    index = 10; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="constipation"){
    index = 11; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
   
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="diarrhoea"){
    index = 12; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="swelling_of_stomach"){
    index = 13; 
    Questions.allSymptompsArray[index]=0;
    
    Questions.depth = index ; 
   
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="unsteadiness"){
    index = 14; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="loss_of_balance"){
    index = 15; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="bladder_discomfort"){
    index = 16; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="passage_of_gases"){
    index = 17; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="abdominal_pain"){
    index = 18; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="yellowish_skin"){
    index = 19; 
    Questions.allSymptompsArray[index]=0 ;
    Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="family_history"){
    index = 20; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
     
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="cough"){
    index = 21; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
  
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="chest_pain"){
    index = 22; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="altered_sensorium"){
    index = 23; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print("problem"); 
   }
   else if (Questions.nextSymp=="blister"){
    index = 24; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="high_fever"){
    index = 25; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
   
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="vomiting"){
    index = 26; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
  
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="burning_micturition"){
    index = 27; 
    Questions.allSymptompsArray[index]=0; 
    Questions.depth = index ; 
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="itching"){
    index = 28; 
    


    
    Questions.depth = index;
    Questions.allSymptompsArray[index]=0 ; 
    
     
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print(Questions.allSymptompsArray);
    print(Questions.depth);
   }
else if (Questions.nextSymp=="stomach_pain"){
    index = 29; 
    
    Questions.allSymptompsArray[index]=0 ; 
    
    Questions.depth = index;
    Questions.nextSymp = getSymp(Questions.allSymptompsArray); 
    print(Questions.nextSymp); 
    print(Questions.allSymptompsArray);
    print(Questions.depth);
   }
   else if (Questions.nextSymp=="nodal_skin_eruptions"){
    index = 30; 
    Questions.allSymptompsArray[index]=0; 
    Questions.depth = index;
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print(Questions.depth); 
    print(Questions.allSymptompsArray);
   }
   else if (Questions.nextSymp=="continuous_sneezing"){
    index = 31; 
    Questions.allSymptompsArray[index]=0; 
    Questions.depth = index;
    Questions.nextSymp = getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   else if (Questions.nextSymp=="skin_rash"){
    index = 32; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
   }
   
else if (Questions.nextSymp=="skin_peeling"){
    index = 33; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print(Questions.allSymptompsArray); 
   }
   
   else if (Questions.nextSymp=="muscle_wasting"){
    index = 34; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="fatigue"){
    index = 35; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="pain_during_bowel_movements"){
    index = 36; 
    Questions.allSymptompsArray[index]=0; 
    Questions.depth = index ; 
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="muscle_weakness"){
    index = 37; 
    Questions.allSymptompsArray[index]=0; 
    Questions.depth = index ; 
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="foul_smell_of urine"){
    index = 38; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
     
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="sunken_eyes"){
    index = 39; 
    Questions.allSymptompsArray[index]=0; 
    Questions.depth = index ; 
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="breathlessness"){
    index = 40; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="headache"){
    index = 41; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
   
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="nausea"){
    index = 42; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="indigestion"){
    index = 43; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="distention_of_abdomen"){
    index = 44; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
   
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="back_pain"){
    index = 45; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="acidity"){
    index = 46; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
   
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="restlessness"){
    index = 47; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="knee_pain"){
    index = 48; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="coma"){
    index = 49; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
   
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="increased_appetite"){
    index = 50; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ;
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="slurred_speech"){
    index = 51; 
    Questions.allSymptompsArray[index]=0 ; 
   Questions.depth = index ;
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="yellowing_of_eyes"){
    index = 52; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
    else if (Questions.nextSymp=="mild_fever"){
    index = 53; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="pain_behind_the_eyes"){
    index = 54; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
   
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="phlegm"){
    index = 55; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
     
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="enlarged_thyroid"){
    index = 56; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="spinning_movements"){
    index = 57; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
    print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="extra_marital_contacts"){
    index = 58; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="mucoid_sputum"){
    index = 59; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="loss_of_smell"){
    index = 60; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="throat_irritation"){
    index = 61; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="weakness_of_one_body_side"){
    index = 62; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } // 
  else if (Questions.nextSymp=="sinus_pressure"){
    index = 63; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ;
   
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
else if (Questions.nextSymp=="shivering"){
    index = 64; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
  
   else if (Questions.nextSymp=="rusty_sputum"){
    index = 65; 
    Questions.allSymptompsArray[index]=0 ; 
   
     Questions.depth = index ; 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="red_sore_around_nose"){
    index = 66; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
   
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="yellow_crust_ooze"){
    index = 67; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="visual_disturbances"){
    index = 68; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
    else if (Questions.nextSymp=="red_spots_over_body"){
    index = 69; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
else if (Questions.nextSymp=="sweating"){
    index = 70; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="receiving_blood_transfusion"){
    index = 71; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
    else if (Questions.nextSymp=="dehydration"){
    index = 72; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="dizziness"){
    index = 73; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="blood_in_sputum"){
    index = 74; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
    else if (Questions.nextSymp=="swelled_lymph_nodes"){
    index = 75; 
    Questions.allSymptompsArray[index]=0; 
    Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="watering_from_eyes"){
    index = 76; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="congestion"){
    index = 77; 
    Questions.allSymptompsArray[index]=0; 
    Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="fast_heart_rate"){
    index = 78; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="pus_filled_pimples"){
    index = 79; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

   else if (Questions.nextSymp=="loss_of_appetite"){
    index = 80; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="silver_like_dusting"){
    index = 81; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="painful_walking"){
    index = 82; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="dischromic _patches"){
    index = 83; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ; 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="hip_joint_pain"){
    index = 84; 
    Questions.allSymptompsArray[index]=0 ; 
    Questions.depth = index ;
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 
   else if (Questions.nextSymp=="blurred_and_distorted_vision"){
    index = 85; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ; 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

    else if (Questions.nextSymp=="irritation_in_anus"){ // added by Sarah
    index = 86; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ; 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

    else if (Questions.nextSymp=="bloody_stool"){ // added by Sarah
    index = 87; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ; 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

    else if (Questions.nextSymp=="lethargy"){ // added by Sarah
    index = 88; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ; 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

    else if (Questions.nextSymp=="puffy_face_and_eyes"){ // added by Sarah
    index = 89; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ; 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

    else if (Questions.nextSymp=="excessive_hunger"){ // added by Sarah
    index = 90; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ; 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

    else if (Questions.nextSymp=="continuous_feel_of_urine"){ // added by Sarah
    index = 91; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ; 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 

    else if (Questions.nextSymp=="acute_liver_failure"){ // added by Sarah
    index = 92; 
    Questions.allSymptompsArray[index]=0 ; 
     Questions.depth = index ; 
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   } 



  if(Questions.nextSymp!="finish"){
 print(Questions.nextSymp);
 setState(() {
   show = true ; 
 });
 
 }

 else{
  show = true ; 
  print("d2");
  disease = await PredictDisease(Yes_Symptoms); 
  description = await getDiseaseDescription(jsonDecode(disease.body)['result'][0].toString());
  precaution = await getDiseasePrecaution(jsonDecode(disease.body)['result'][0].toString());
  //return(ResultWidget(disease.body)) ;
  setState(() {
   show = true ; 
 });
 
 }
        
          
        },
        
      ),

     
         
      ]
      
        
    );}
  }

  
      
  }

  

   

    