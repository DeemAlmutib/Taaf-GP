import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:taaf/homepage.dart';
import 'package:taaf/report.dart';
import 'src/views/user/profilePage.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
   final pages = [
    const HompageWidget(),
    ProfilePage(),
    const ReportWidget(),
    
    
  ];
  int Index = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Color(0xFF007282) ,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Color(0xFF007282),
            color: Colors.white,
            activeColor: Colors.white,
            padding: EdgeInsets.all(16),
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            onTabChange: (index){
              print(index);
            } ,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'الرئيسية'
                ),
            ],
          ),
        ),
      ) ,
    );
  }
}

