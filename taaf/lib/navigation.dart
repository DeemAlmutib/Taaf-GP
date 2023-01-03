import 'package:flutter/material.dart';
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
    const HompageWidget(),
    ProfilePage(),
    const HistoryWidget(),
    
  ];

  int Index = 0;
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: pages[Index],
      bottomNavigationBar: Container(
        color: Color(0xFF007282) ,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: GNav(
            backgroundColor: Color(0xFF007282),
            color: Colors.white,
            activeColor: Colors.white,
            padding: EdgeInsets.all(13),
            tabBackgroundColor: Color.fromARGB(255, 118, 171, 173),
            gap: 8,
            onTabChange: (Index){
              switch (Index){
                case 0 :
                HompageWidget();
              }
             


              
              
            } ,
            
            
            tabs: [
             
                GButton(
                icon: Icons.person,
                text: 'الملف الشخصي',
                 onPressed: () {
                setState(() {
                  Index = 1;
                });
              },
                ),
                 GButton(
                icon: Icons.history,
                text:  'التشخيصات السابقة',
                 onPressed: () {
                setState(() {
                  Index = 2;
                });
              },
                ),
                 GButton(
                icon: Icons.home,
                text: 'الرئيسية',
                 onPressed: () {
                setState(() {
                  Index = 0;
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

