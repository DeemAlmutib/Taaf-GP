import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taaf/login.dart';
import 'package:taaf/src/controllers/AuthController.dart';
import 'package:taaf/src/controllers/user/editProfileController.dart';
import 'package:taaf/src/helper/Dimensions.dart';
import 'package:taaf/src/views/user/editProfile.dart';
import 'package:taaf/src/views/widgets/AppButtonWeiget.dart';
import 'package:taaf/src/views/widgets/AppButtonWithIconWeiget.dart';
import 'package:taaf/src/views/widgets/AppSmallTextWidget.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../homePage.dart';
import '../../../login/loginPage.dart';
import '../../../welcomePage.dart';
import '../widgets/AppLargTextWidget.dart';
import '../widgets/AppLoadingIndicator.dart';
import 'package:taaf/navigator_keys.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  EditProfileController editProfileController = EditProfileController();

  @override
  void initState() {
    super.initState();

    initPage();
  }

  void initPage() async {
    editProfileController.getProfileData().then((value) {
      print(value.toJson());
      setState(() {
        editProfileController.isProfileLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
       // backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
         elevation: 0.0,
        centerTitle: true,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
       title: Image.asset('assets/Images/taaf.jpg' , height: 90, alignment: FractionalOffset.center), 
       toolbarHeight: 100,
      ),
        key: scaffoldKey,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage(
          //       'assets/images/home.png',
          //     ),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(
                //   height: dimensions.height20,
                // ),
                SizedBox(
                  height: dimensions.height25 * 7,
                ),
                editProfileController.isProfileLoading
                    ? AppLoadingIndicator()
                    : Container(
                        width: dimensions.width10 * 32,
                        height: dimensions.height10 * 25,
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            /** Positioned WIdget **/
                            Positioned(
                              top: dimensions.height55,
                              child: Container(
                                width: dimensions.width10 * 30,
                                height: dimensions.height10 * 19,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: dimensions.width10 * 3,
                                      color: Color(0xD78D8989),
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(
                                      dimensions.width10 * 3),
                                ),
                                child: Column(children: [
                                  SizedBox(
                                    height: dimensions.height10 * 6,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppLargTextWidget(
                                          text: editProfileController
                                                          .userModel.name !=
                                                      null &&
                                                  editProfileController
                                                      .userModel
                                                      .name!
                                                      .isNotEmpty
                                              ? editProfileController
                                                  .userModel.name!
                                              : "حساب جديد",
                                          size: dimensions.font10 * 2,
                                        ),
                                      ),
                                      SizedBox(
                                        width: dimensions.width15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      editProfile(
                                                        editProfileController:
                                                            editProfileController,
                                                      )));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.edit,
                                            size: dimensions.icon25,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: dimensions.width15,
                                      ),
                                    ],
                                  ),
                                  AppSmallTextWidget(
                                    text:
                                        editProfileController.userModel.phone !=
                                                    null &&
                                                editProfileController
                                                        .userModel.phoneCode !=
                                                    null
                                            ? (editProfileController
                                                    .userModel.phoneCode! +
                                                editProfileController
                                                    .userModel.phone!)
                                            : "حساب جديد",
                                    size: dimensions.font10 * 2,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: dimensions.height5,
                                  ),
                                  AppSmallTextWidget(
                                    text: editProfileController
                                                    .userModel.gender !=
                                                null &&
                                            editProfileController
                                                .userModel.gender!.isNotEmpty
                                        ? editProfileController
                                            .userModel.gender!
                                        : " ",
                                    size: dimensions.font10 * 2,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: dimensions.height5,
                                  ),
                                  AppSmallTextWidget(
                                    text: editProfileController
                                                    .userModel.birthDate !=
                                                null &&
                                            editProfileController
                                                .userModel.birthDate!.isNotEmpty
                                        ? editProfileController
                                            .userModel.birthDate!
                                        : " ",
                                    size: dimensions.font10 * 2,
                                    textAlign: TextAlign.center,
                                  )
                                ]),
                              ), //Icon
                            ), //Positioned
                            /** Positioned WIdget **/

                            Positioned(
                              top: 0,
                              right: dimensions.width10 * 11,
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 236, 236, 236),
                                child: Image.asset(
                                  editProfileController.getProfileImage(
                                      editProfileController.userModel.gender),
                                  fit: BoxFit.fill,
                                  width: dimensions.width10 * 8,
                                  // height: dimensions.height10 * 10,
                                ),
                                radius: dimensions.font10 * 5,
                              ), //CircularAvatar
                            ), //Positioned
                          ], //<Widget>[]
                        ),
                      ),
                SizedBox(
                  height: dimensions.height25,
                ),
                AppButtonWithIconWeiget(
                  text: "تسجيل الخروج",
                  icon: Icons.logout,
                  iconColor: Colors.white,
                  iconSize: dimensions.icon25,
                  onPressed: () async {
                    print('hi');
                    // showAlertDialogg(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text(
                                "هل أنت متأكد من رغبتك في تسجيل الخروج؟ ",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                textAlign: TextAlign.right),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Navigator.pop(context);
                                  Navigation.mainNavigation.currentState!
                                      .pushNamed("/main/4");
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "لا",
                                  style: GoogleFonts.tajawal(
                                    fontSize: 15,
                                    color: Color(0xFF007282),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await AuthController().logout();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoginPageWidget()));
                                },
                                child: Text(
                                  "نعم",
                                  style: GoogleFonts.tajawal(
                                    fontSize: 15,
                                    color: Color(0xFF007282),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ]);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialogg(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "إلغاء",
        style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        //  Navigation.mainNavigation.currentState!.pushNamed("/main/");
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "تسجيل خروج ",
        style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        textAlign: TextAlign.right,
      ),
      onPressed: () async {
        await AuthController().logout();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPageWidget()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: Text(
        "هل أنت متأكد من رغبتك في تسجيل الخروج؟ ",
        style: GoogleFonts.tajawal(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
