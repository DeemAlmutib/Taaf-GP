import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class success2 extends StatefulWidget {
  const success2({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<success2> createState() => _success2();
}

Color themeColor = const Color(0xFF43D19E);

class _success2 extends State<success2> {
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 170,
              padding: EdgeInsets.all(35),
              decoration: BoxDecoration(
                // color: ,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 80,
                color: Color.fromARGB(255, 140, 167, 190),
                //fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Text(
              "yesss",
              style: GoogleFonts.tajawal(
                color: Color.fromARGB(255, 140, 167, 190),
                fontWeight: FontWeight.w600,
                fontSize: 36,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            /*  Text(
              "Payment done Successfully",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),*/
            SizedBox(height: screenHeight * 0.05),
            /*   Text(
              "You will be redirected to the home page shortly\nor click here to return to home page",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),*/
            SizedBox(height: screenHeight * 0.06),
            Flexible(
              child: HomeButton(
                title: '??????????',
                onTap: () {
                  //   Navigator.pushReplacement(
                  //        MaterialPageRoute(
                  //         builder: (context) => )
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  HomeButton({Key? key, this.title, this.onTap}) : super(key: key);

  String? title;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 250,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 140, 167, 190),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Text(
            title ?? '',
            style: GoogleFonts.tajawal(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 31,
            ),
          ),
        ),
      ),
    );
  }
}
