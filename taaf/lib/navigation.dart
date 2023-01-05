import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:taaf/homepage.dart';
import 'package:taaf/report.dart';
import 'package:taaf/src/views/user/profilePage.dart';

import 'history.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
   final pages = [
    ProfilePage(),
    const HistoryWidget(),
    const HompageWidget(),
    
  ];

  int Index = 2;
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: pages[Index],
      bottomNavigationBar: Container(
        color: Color(0xFF007282) ,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: GNav(
            selectedIndex: Index,
            backgroundColor: Color(0xFF007282),
            color: Colors.white,
            activeColor: Colors.white,
            padding: EdgeInsets.all(13),
            tabBackgroundColor: Color.fromARGB(255, 118, 171, 173),
            gap: 8,
            onTabChange: (Index){
              switch (Index){
                case 2 :
                HompageWidget();
              break ; 
              
                case 1 :
               HistoryWidget();
               break ; 

               case 0: 
               ProfilePage(); 
               break; 

              }
             
                
              
             

            }
              
              
             ,
            
            
            tabs: [
              

             
                GButton(
                icon: Icons.person,
                text: 'الملف الشخصي',
                textStyle: GoogleFonts.tajawal(
                  color: Colors.white
                 ),
                 onPressed: () {
                setState(() {
                  Index = 0;
                });
              },
                ),
                 GButton(
                icon: Icons.history,
                text:  'التشخيصات السابقة',
                 textStyle: GoogleFonts.tajawal(
                  color: Colors.white
                 ),
                
                 
               
                 // GoogleFonts.tajawal() ,
               
                 onPressed: () {
                setState(() {
                  Index = 1;
                });
              },
                ),
                 GButton(
                icon: Icons.home,
                text: 'الرئيسية',
              textStyle: GoogleFonts.tajawal(
                  color: Colors.white
                 ),
                
                 onPressed: () {
                setState(() {
                  Index = 2;
                });
              },
                ),

                
            ],
          ),
        ),
      ) ,
    );
  }
}

