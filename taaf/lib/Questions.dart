import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ffi/ffi.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taaf/login.dart';
import 'package:taaf/welcomePage.dart';

class Questions extends StatefulWidget {
  @override
  State<Questions> createState() => _QuestionsState();
 // static List<dynamic> allSymptompsArray =  [];
 static List<dynamic> allSymptompsArray =  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0
 ,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0];
 static var nextSymp ='malaise'; // coming from the model // very important attribute 
 static var nextSympAR ;
 static var depth ; // important to to reach the next symptopm in the tree
 static var comingFromModel = true ; 
}

class _QuestionsState extends State<Questions> {
var symp = Questions.nextSymp ;
// method that will take the list of symptomps that the user has said yes to and return the final result 
Future<http.Response> PredictDisease(List<String> symptomp) {

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
// method to see if you should go to the doctor or not / takes the array of symptopms and the number of days the user has been sick 
// as enhancement of the app we could ask the user (from how many days you have been sick?) in order to use this method
Future<http.Response> getDiseaseSeverity(exp, days) {
  return http.post(
    Uri.parse('http://10.0.2.2:5000/SeverityApi'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<dynamic, dynamic>{'expression': exp, 'days': days}),
  );
}
// method that takes the disease name and get its description
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
// method that takes the disease name and returns the the of advices 
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
symptomp ="finish" ; 
}
else if(symptopms[4]==1 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0 ){// chills yes
  symptomp ="finish" ; 
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
  symptomp ="finish" ;  // disease will be determined - send array to the model
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
  symptomp ="finish" ;  // disease will be determined - send array to the model
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
  symptomp ="finish" ;  // disease will be determined - send array to the model
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
if(Questions.depth==16){

if(symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 16 bladder_discomfort 
symptomp ="passage_of_gases" ; 
}
else if(symptopms[16]==1 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  bladder_discomfort 
  symptomp ="finish" ;  
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
  symptomp ="finish" ;   
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
  symptomp ="finish" ;   
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
  symptomp ="finish" ;   
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
symptomp ="finish" ; 
}
else if(symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  high_fever
  symptomp ="finish" ;  
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
symptomp ="back_pain" ; 
}
else if(symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//  vomiting
  symptomp ="high_fever" ;   
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

if(Questions.depth==29){
if(symptopms[29]==1 &&symptopms[28]==1 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 29 stomach pain
symptomp ="finish" ; 
}
else if(symptopms[29]==0 && symptopms[28]==1 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// stomach pain
  symptomp ="finish" ;   
}
}
if(Questions.depth==30){
if(symptopms[30]==1 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// nodal_skin_eruptions30
symptomp ="finish" ; 
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
  symptomp ="finish" ;   
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
symptomp ="finish" ; 
}
else if(symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0 && symptopms[29]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==1 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//32 
  symptomp ="finish" ;   
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
symptomp ="finish" ; 
}


else if(symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==1 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//33 skin_peeling
  symptomp ="finish" ;  
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
symptomp ="finish" ; 
}


else if(symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 && symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==1 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){//35  fatigue
  symptomp ="finish" ;   
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
if(Questions.depth==39){
if(symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 39 sunken_eyes
symptomp ="breathlessness" ; 
}


else if(symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 39  sunken_eyes
  symptomp ="finish" ;   
}

}


if(Questions.depth==40){
if(symptopms[40]==1 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 40 breathlessness"
symptomp ="finish" ; 
}


else if(symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==1 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 40  breathlessness"
  symptomp ="finish" ;   
}

}

if(Questions.depth==29){
  print("seeee");
if( symptopms[29]==1 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0&& symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 29 stomach_pain
symptomp ="finish" ; 
}


else if( symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 29 stomach_pain
  symptomp ="headache" ;    
}

}
if(Questions.depth==41){
if( symptopms[41]==1 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 41 headache
symptomp ="finish" ; 
}


else if( symptopms[41]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==1 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==1 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==1 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 41 headache
  symptomp ="finish" ;   
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
if(Questions.depth==43){
if( symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 43 indigestion
symptomp ="distention_of_abdomen" ; 
}


else if( symptopms[43]==1 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;   // indigestion
}
}
if(Questions.depth==44){
if( symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 44 distention_of_abdomen
symptomp ="finish" ; 
}


else if( symptopms[44]==1 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==1 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]== 0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
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
if(Questions.depth==46){
if( symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==1 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 46 acidity
symptomp ="finish" ; 
}


else if( symptopms[46]==1 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==1 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
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
  symptomp ="finish" ;   //knee_pain
}
}
if(Questions.depth==49){
if( symptopms[49]==1 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==1 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){// 49 coma
symptomp ="finish" ; 
}


else if( symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==1 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="itching" ;   //coma
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
if(Questions.depth==53){
if(symptopms[53]==1 && symptopms[52]==1 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){// 53 mild_fever
symptomp ="finish" ; 
}


else if( symptopms[53]==0 && symptopms[52]==1 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==1 && symptopms[1]==0 && symptopms[0]==0){
  symptomp ="finish" ;   // mild_fever
}
}

if(Questions.depth==53){
if(symptopms[53]==1 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){// 53 mild_fever
symptomp ="finish" ; 
}


else if( symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
  symptomp ="phlegm" ;   // mild_fever and mucle pain
}
}
if(Questions.depth==54){
if(symptopms[54]==1 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){// 54  pain_behind_the_eyes
symptomp ="finish" ; 
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
symptomp ="finish" ; 
}


else if(symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==1 && symptopms[0]==0){
  symptomp ="finish" ;   //  phlegm
}
}
if(Questions.depth==56){

if(symptopms[56]==0 &&symptopms[55]==0 &&symptopms[54]==0 &&symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 &&symptopms[50]==0 &&symptopms[49]==0 && symptopms[48]==0 &&symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 && symptopms[43]==0 &&symptopms[42]==0 &&symptopms[41]==0 &&symptopms[40]==0  && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 && symptopms[33]==0 &&symptopms[32]==0 &&symptopms[31]==0 &&symptopms[30]==0 && symptopms[29]==0 &&symptopms[28]==0 && symptopms[27]==0 && symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 &&symptopms[15]==0 &&symptopms[14]==0 && symptopms[13]==0 &&symptopms[12]==0 && symptopms[11]==0 && symptopms[10]==0 &&symptopms[9]==0 && symptopms[8]==0 &&symptopms[7]==0 &&
symptopms[6]==0 && symptopms[5]==0 && 
symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){// 56 enlarged_thyroid
symptomp ="finish" ; 
}


else if(symptopms[56]==1 &&symptopms[55]==0 &&symptopms[54]==0 && symptopms[53]==0 && symptopms[52]==0 &&symptopms[51]==0 && symptopms[50]==0 &&symptopms[49]==0 &&symptopms[48]==0 && symptopms[47]==0 &&symptopms[46]==0 && symptopms[45]==0 &&symptopms[44]==0 &&symptopms[43]==0 &&symptopms[42]==0 && symptopms[40]==0 && symptopms[40]==0 && symptopms[39]==0 &&symptopms[38]==0 &&symptopms[37]==0 && symptopms[36]==0 &&symptopms[35]==0 && symptopms[34]==0 &&symptopms[33]==0  &&symptopms[32]==0 &&symptopms[31]==0  &&symptopms[30]==0  && symptopms[29]==0 &&symptopms[28]==0 &&  symptopms[27]==0&& symptopms[26]==0 && symptopms[25]==0 && symptopms[24]==0 && symptopms[23]==0 && symptopms[22]==0 && symptopms[21]==0 && symptopms[20]==0 && symptopms[19]==0 && symptopms[18]==0 && symptopms[17]==0 &&symptopms[16]==0 && symptopms[15]==0 &&symptopms[14]==0 &&symptopms[13]==0 &&symptopms[12]==0 &&symptopms[11]==0 &&symptopms[10]==0 &&symptopms[9]==0  && symptopms[8]==0 && symptopms[7]==0 && 
  symptopms[6]==0 && symptopms[5]==0 && symptopms[4]==0 && symptopms[3]==0 && symptopms[2]==0 && symptopms[1]==0 && symptopms[0]==1){
  symptomp ="finish" ;   //  enlarged_thyroid
}
}

return symptomp ; 

}

//processing the symp coming from the model
//////////////////

Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
           content: Text(
             "  هل أنت متأكد من أنك رغبتك في الخروج ؟ ",
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
 ,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0];
              Questions.nextSymp ='malaise';
               // coming from the model // 
               Questions.comingFromModel = true;

              
                Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Questions())); // should be the human body model
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
    if(Questions.nextSymp =="finish"){
// disease = await PredictDisease(Yes_Symptoms); 
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
        
         decoration:Questions.nextSymp!="finish"? BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/Images/Q2.jpeg' ), 
            fit: BoxFit.fill
             )): BoxDecoration(),
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
                 Text(
                  " تم التشخِيص",
                  style: GoogleFonts.tajawal(
                    fontSize: 23,
                    //fontStyle: FontStyle.italic,
                    color: Color(0xFF007282),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20,),
                if(Questions.nextSymp != "finish")
               LoadingAnimationWidget.staggeredDotsWave( // LoadingAnimationwidget that call the
        color: Color(0xFF007282),                          // staggereddotwave animation
        size: 50,
      ),
    
                

          Column(children: [ 
            SizedBox(height:35),
// we have 2 widgets , questions widget will view the questions and the result - the answer widget will view yes no button , each button should contains a specific logic as will be shown below
           _questionWidget(Questions.nextSymp),SizedBox(height: 30,),
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
       
      return Column(
     children:[

      
        
       
                // shadowColor: Colors.black,
                // child: Container(
                //   height: 60,
            Divider(
thickness: 1,
indent: 60,
endIndent: 60,
color: Color(0xFF007282),
        ),     //   width: 350,
      SizedBox(height: 10,),

      Row(children: [
       
        Text(
        "            " +  (jsonDecode(disease.body)['result']).toString()  ,
         style: GoogleFonts.tajawal(
                    fontSize: 18,
                    //fontStyle: FontStyle.italic,
                    color: Color(0xFF007282),
                    fontWeight: FontWeight.bold,
                  ),

        ),
         Text(
           " من المحتمل أنك تعاني من "  ,
         style: GoogleFonts.tajawal(
                    fontSize: 18,
                    //fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 60, 61, 61),
                    fontWeight: FontWeight.bold,
                  ),
        ),


      ],),
        
        SizedBox(height: 10,),
        Divider(
thickness: 1,
indent: 60,
endIndent: 60,
color: Color(0xFF007282),
        ),
                
        SizedBox(height: 10,) ,
         Align(
          alignment: Alignment.centerRight,
          child:  Text(
        DateTime.now().toString() + "                   " ,
         style: GoogleFonts.tajawal(
                    fontSize: 12,
                    //fontStyle: FontStyle.italic,
                    
                    color: Color.fromARGB(255, 116, 117, 117),
                    fontWeight: FontWeight.bold,
                  ),
        ), 
        ),
        SizedBox(height: 25,),
       
        Align(
          alignment: Alignment.centerRight,
          child:  Text(
        "ملخص              "  ,
         style: GoogleFonts.tajawal(
                    fontSize: 19,
                    //fontStyle: FontStyle.italic,
                    
                    color: Color(0xFF007282),
                    fontWeight: FontWeight.bold,
                  ),
        ), 
        ),
        SizedBox(height: 10,),
        Align(
          alignment: Alignment.centerRight,
        child: Text(' :وصف المرض             ' , style: GoogleFonts.tajawal(
                    fontSize: 15,
                    //fontStyle: FontStyle.italic,
                    
                    color: Color.fromARGB(255, 152, 152, 152),
                    fontWeight: FontWeight.bold,
                  ),
         ),),
         SizedBox(height: 5,),
        Column(children: [ Container(
height:50,
width: 500,

       child: 
       Align(
        alignment: Alignment.centerRight,
       child: Text(jsonDecode(description.body)['result'].toString() ,  style: const TextStyle(
            color: Color.fromARGB(225, 8, 8, 8),
            fontSize: 12,
            
            fontWeight: FontWeight.w600,
          ),)),),
           SizedBox(height: 5,),

           Align(alignment: Alignment.centerRight,
       child :Text(': نصائح              ' , style: GoogleFonts.tajawal(
                    fontSize: 15,
                    //fontStyle: FontStyle.italic,
                    
                    color: Color.fromARGB(255, 152, 152, 152),
                    fontWeight: FontWeight.bold,
                  ),
         ),
           ),
              SizedBox(height: 5,),
          Container(
          height:80,
          width: 500,

          child:
          Column(children: [ 
             Align(alignment: Alignment.centerRight,
            child: Text("   1-" + jsonDecode(precaution.body)['result'][0].toString() +"                   ",  style: const TextStyle(
            color:  Color.fromARGB(225, 11, 11, 11),
            fontSize: 12,
            
            fontWeight: FontWeight.w600,
          ),),),
         SizedBox(height : 10),
          Align(alignment: Alignment.centerRight,
          child: Text("   2-" + jsonDecode(precaution.body)['result'][1].toString() + "                    ",  style: const TextStyle(
            color:  Color.fromARGB(225, 8, 8, 8),
            fontSize: 12,
            
            fontWeight: FontWeight.w600,
          ),),),
          SizedBox(height : 10),
           Align(alignment: Alignment.centerRight,
         child: Text("   3-" + jsonDecode(precaution.body)['result'][2].toString() + "                      ",  style: const TextStyle(
            color:  Color.fromARGB(225, 12, 12, 12),
            fontSize: 12,
            
            fontWeight: FontWeight.w600,
          ),),)
          
          ]),
          
          
         ),
        ]),
SizedBox(height: 10,),
        ElevatedButton(
          child: Text('                   خروج                 ',
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
          onPressed: () {
               Questions.allSymptompsArray =  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0
 ,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0];
              Questions.nextSymp ='malaise';
               // coming from the model // 
               Questions.comingFromModel = true;
             Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Questions()));
          },
        ),
        ]);


    
    }
    else{
  
    Questions.nextSymp = symp ; 
   // Questions.nextSymp = symp ; 
    //return Row(
     //children:[
      return  Container(
              child: PhysicalModel(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                elevation: 18,
                shadowColor: Colors.black,
                child: Container(
                  height: 90,
                  width: 350,
                
              
        
     child: Center(
     child: Text(
                  " هل تعاني من ${symp} ?",
                  style: GoogleFonts.tajawal(
                    fontSize: 20,
                    //fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 65, 66, 66),
                    fontWeight: FontWeight.bold,
                  ),
                ),),)),);

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
                 "نعم",
                  style: GoogleFonts.tajawal(
                    fontSize: 20,
                    //fontStyle: FontStyle.italic,
                    color: Color.fromARGB(224, 74, 198, 74),
                    fontWeight: FontWeight.bold,
                  ),
                ),
        style: OutlinedButton.styleFrom(
          
         side: BorderSide(width: 2.0, color: Color.fromRGBO(0, 114, 130, 30)),
         //shadowColor: Colors.transparent,
         backgroundColor:  Colors.white.withOpacity(0.0),
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
  print(disease.body);
  //return(ResultWidget(disease.body)) ;
  setState(() {
   show = true ; 
 });
 
 }
 

        },
      ),
      
       OutlinedButton(
        child: Text(
                "لا" ,
                  style: GoogleFonts.tajawal(
                    fontSize: 20,
                    //fontStyle: FontStyle.italic,
                    color: Color.fromARGB(225, 230, 41, 28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 2.0, color: Color.fromRGBO(0, 114, 130, 30)),
          backgroundColor: Colors.white.withOpacity(0.0),
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
    Questions.allSymptompsArray[index]=1 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="breathlessness"){
    index = 40; 
    Questions.allSymptompsArray[index]=1 ; 
    Questions.depth = index ; 
    
    Questions.nextSymp= getSymp(Questions.allSymptompsArray);
    print(Questions.nextSymp); 
     print(Yes_Symptoms); 
    print(Questions.allSymptompsArray); 
   }
   else if (Questions.nextSymp=="headache"){
    index = 41; 
    Questions.allSymptompsArray[index]=1 ; 
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

  

   

    