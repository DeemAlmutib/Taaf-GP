import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:taaf/SymptomsPages/Knee.dart';
import 'package:taaf/SymptomsPages/abdomen.dart';
import 'package:taaf/SymptomsPages/back.dart';
import 'package:taaf/SymptomsPages/handFoot.dart';
import 'package:taaf/SymptomsPages/headSy.dart';
import 'package:taaf/SymptomsPages/lowerBody.dart';
import 'package:taaf/SymptomsPages/muscle.dart';
import 'package:taaf/SymptomsPages/neckSy.dart';
import 'package:taaf/SymptomsPages/upperBoday.dart';
import 'package:taaf/history.dart';
import 'package:taaf/homePage.dart';
import 'package:taaf/humanModel.dart';
import 'package:taaf/Questions.dart';
import 'package:taaf/src/controllers/user/editProfileController.dart';
import 'package:taaf/src/views/user/editProfile.dart';
import 'package:taaf/src/views/user/profilePage.dart';
//import 'package:flutter_nested_navigaton/pages/page1.dart';
//import 'package:flutter_nested_navigaton/pages/page2.dart';
//import 'package:flutter_nested_navigaton/pages/page3.dart';
//import 'package:flutter_nested_navigaton/pages/page4.dart';

import 'navigator_keys.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

var Index = 2;

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    EditProfileController editProfileController = EditProfileController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //   title: Text("Main Page"),
      // ),
      body: Column(
        children: [
          Expanded(
              child: Navigator(
            key: Navigation.mainNavigation,
            initialRoute: "/",
            onGenerateRoute: (RouteSettings settings) {
              Widget page;

              switch (settings.name) {
                case "/":
                  {
                    page = HompageWidget();
                    break;
                  }
                case "/main/2":
                  {
                    page = humanModel();
                    break;
                  }
                case "/main/3":
                  {
                    page = HistoryWidget();
                    break;
                  }
                case "/main/4":
                  {
                    page = ProfilePage();
                    break;
                  }
                case "/main/5":
                  {
                    page = ProfilePage();
                    break;
                  }
                case "/main/6":
                  {
                    page = upperBoday();
                    break;
                  }
                case "/main/7":
                  {
                    page = HeadSymptoms();
                    break;
                  }
                case "/main/8":
                  {
                    page = neckSymptoms();
                    break;
                  }
                case "/main/9":
                  {
                    page = Knee();
                    break;
                  }
                case "/main/10":
                  {
                    page = abdomen();
                    break;
                  }
                case "/main/11":
                  {
                    page = lowerBody();
                    break;
                  }
                case "/main/12":
                  {
                    page = muscle();
                    break;
                  }
                case "/main/13":
                  {
                    page = handFoot();
                    break;
                  }
                case "/main/14":
                  {
                    page = back();
                    break;
                  }
                case "/main/15":
                  {
                    page = editProfile(
                        editProfileController: editProfileController);
                    break;
                  }

                default:
                  {
                    page = Questions(sympController: settings.name);
                  }
              }

              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => page,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset.zero;
                  const end = Offset.zero;
                  final tween = Tween(begin: begin, end: end);
                  final offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              );
            },
          )),
          // Divider(),
          Container(
            color: Color(0xFF007282),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: GNav(
                selectedIndex: Index,
                backgroundColor: Color(0xFF007282),
                color: Colors.white,
                activeColor: Colors.white,
                padding: EdgeInsets.all(13),
                tabBackgroundColor: Color.fromARGB(255, 118, 171, 173),
                gap: 8,
                onTabChange: (Index) {
                  switch (Index) {
                    case 2:
                      HompageWidget();
                      break;

                    case 1:
                      HistoryWidget();
                      break;

                    case 0:
                      ProfilePage();
                      break;
                  }
                },
                tabs: [
                  GButton(
                    icon: Icons.person,
                    text: 'الملف الشخصي',
                    textStyle: GoogleFonts.tajawal(color: Colors.white),
                    onPressed: () {
                      setState(() {
                        Index = 0;
                      });
                      Questions.allSymptompsArray = [
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        00,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0
                      ];
                      // Questions.nextSymp = widget.sympController;
                      // coming from the model //
                      Questions.comingFromModel = true;
                      Navigation.mainNavigation.currentState!
                          .pushNamed("/main/4");
                    },
                  ),
                  GButton(
                    icon: Icons.history,
                    text: 'التشخيصات السابقة',
                    textStyle: GoogleFonts.tajawal(color: Colors.white),

                    // GoogleFonts.tajawal() ,

                    onPressed: () {
                      setState(() {
                        Index = 1;
                      });
                      Questions.allSymptompsArray = [
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        00,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0
                      ];
                      // Questions.nextSymp = widget.sympController;
                      // coming from the model //
                      Questions.comingFromModel = true;
                      Navigation.mainNavigation.currentState!
                          .pushNamed("/main/3");
                    },
                  ),
                  GButton(
                    icon: Icons.home,
                    text: 'الرئيسية',
                    textStyle: GoogleFonts.tajawal(color: Colors.white),
                    onPressed: () {
                      setState(() {
                        Index = 2;
                      });
                      Questions.allSymptompsArray = [
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        00,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0
                      ];
                      // Questions.nextSymp = widget.sympController;
                      // coming from the model //
                      Questions.comingFromModel = true;
                      Navigation.mainNavigation.currentState!.pushNamed("/");
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      //)
    );
  }
}
