import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../newNavigation.dart';

// void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
 GlobalKey<IntroductionScreenState> introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MainPage()),
    );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/Images/background.png',
      fit: BoxFit.fill,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/Images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
     //autoScrollDuration: 5000, // comment it if you dont want it to scroll automatically
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
           //child: _buildImage('taaf.jpg', 100),
          ),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
         style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF007282)) ,
          child: Text(
                                "تخطي",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                textAlign: TextAlign.right),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
        titleWidget: Column(
                  children: [ Text(
                                "مرحبا بك عزيزي مستخدم تعاف",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                textAlign: TextAlign.right),]),
                   
          bodyWidget:
            Column(
                  children: [ Text(
                                "   تعاف تطبيق يستخدم الذكاء الاصطناعي لتخمين المرض الذي لديك  بناء على إجابتك على عدة أسئلة متعلقة  بأعراضك  ",
                                style: GoogleFonts.tajawal(
                                  height: 1.5,
                                  color: Color.fromARGB(255, 81, 79, 79) ,
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                textAlign: TextAlign.center ),

                               SizedBox(height: 20,),
                                
                                Text(
                                " تنويه: تعاف يقدم لك تشخيص مقترح فقط ولا يغنيك عن زيارة الطبيب ",
                                style: GoogleFonts.tajawal(
                                  height: 1.5,
                                  color: Color.fromARGB(255, 190, 57, 57) ,
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                textAlign: TextAlign.center ),
                                
                                
                                ]),
         image: _buildImage('taaf.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
        titleWidget: Column(
                  children: [ Text(
                                "تعليمات مهمة أثناء إستخدام التطبيق",
                                style: GoogleFonts.tajawal(
                                   color: Color.fromARGB(255, 190, 57, 57) ,
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                textAlign: TextAlign.right),]),
                   
          bodyWidget:
            Column(
                  children: [ Text(
                                "أولا يمكنك بدء التشخيص عن طريق الضغط على زر (إبدأ)  في الصفحة الرئيسية",
                                style: GoogleFonts.tajawal(
                                  height: 1.5,
                                  color: Color.fromARGB(255, 10, 92, 34) ,
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                textAlign: TextAlign.center ),

                               SizedBox(height: 20,),
                              
                                
                                
                                ]),
         image: _buildImage('taaf.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Column(
                  children: [ Text(
                                "تعليمات مهمة أثناء إستخدام التطبيق",
                                style: GoogleFonts.tajawal(
                                   color: Color.fromARGB(255, 190, 57, 57) ,
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                textAlign: TextAlign.right),]),
                   
          bodyWidget:
            Column(
                  children: [ Text(
                                "بعد ذلك سيظهر لك (مجسم الإنسان )، يمكنك تدوير الجسم عن طريق تحريك الشريط في أسفل الصفحة يمينا و يسارا",
                                style: GoogleFonts.tajawal(
                                  height: 1.5,
                                  color: Color.fromARGB(255, 10, 92, 34) ,
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                textAlign: TextAlign.center ),

                               SizedBox(height: 20,),
                              
                                
                                
                                ]),
          image: _buildImage('taaf.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Column(
                  children: [ Text(
                                "تعليمات مهمة أثناء إستخدام التطبيق",
                                
                                style: GoogleFonts.tajawal(
                                   color: Color.fromARGB(255, 190, 57, 57) ,
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                textAlign: TextAlign.right),]),
                   
          bodyWidget:
            Column(
                  children: [ Text(
                                "قم بالنقر على المكان الذي يؤلمك من (مجسم الانسان)",
                                style: GoogleFonts.tajawal(
                                  height: 1.5,
                                  color: Color.fromARGB(255, 10, 92, 34) ,
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                textAlign: TextAlign.center ),

                               SizedBox(height: 20,),

                               Text(
                                " ومن ثم ستظهر لك عدة أعراض متعلقة بالمكان الذي اخترته ، قم بإختيار العرض الأكثر شدة لديك ",
                                style: GoogleFonts.tajawal(
                                  height: 1.5,
                                  color: Color.fromARGB(255, 10, 92, 34) ,
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                textAlign: TextAlign.center ),
                              
                                
                                ]),
            image: _buildImage('taaf.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
         titleWidget: Column(
                  children: [ Text(
                                "تعليمات مهمة أثناء إستخدام التطبيق",
                                
                                style: GoogleFonts.tajawal(
                                   color: Color.fromARGB(255, 190, 57, 57) ,
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                textAlign: TextAlign.right),]),
                   
          bodyWidget:
            Column(
                  children: [ Text(
                                "بعد ذلك سيقوم تعاف بسؤالك عدة اسئلة، نتمنى منك الإجابة بنعم أو لا حتى يتم التوصل إلى نتيجة المرض الذي لديك",
                                style: GoogleFonts.tajawal(
                                  height: 1.5,
                                  color: Color.fromARGB(255, 10, 92, 34) ,
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                textAlign: TextAlign.center ),

                               SizedBox(height: 20,),

                              
                              
                                
                                ]),
          image: _buildImage('taaf.jpg'),
          footer: ElevatedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            child: const Text(
              'FooButton',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          decoration: pageDecoration.copyWith(bodyFlex: 6,imageFlex: 6,safeArea: 80),
        ),
        PageViewModel(
          titleWidget: Text(
                                "نتمنى لك دوام الصحة والعافية  ",
                                style: GoogleFonts.tajawal(
                                  height: 1.5,
                                  color: Color(0xFF007282) ,
                                    fontWeight: FontWeight.bold, fontSize: 25),
                                textAlign: TextAlign.center ),

                              
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
             
            ],
          ),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          image: _buildImage('taaf.jpg'),
          reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back , color: Colors.white),
      skip:Text(
                                "تخطي",
                                style: GoogleFonts.tajawal(
                                  height: 1.5,
                                  color:  Colors.white ,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center ),
      next: const Icon(Icons.arrow_forward , color: Colors.white),
      done: Text(
                                "إنهاء",
                                style: GoogleFonts.tajawal(
                                  height: 1.5,
                                  color:  Colors.white ,
                      
                                    fontWeight: FontWeight.bold), ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.white,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Color(0xFF007282),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text("This is the screen after Introduction")),
    );
  }
}