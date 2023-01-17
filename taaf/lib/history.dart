import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taaf/report.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({Key? key}) : super(key: key);

  @override
  _HistoryWidgetState createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

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



  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF14181B),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: BoxDecoration(
            color: Color(0xFF14181B),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/home.png',
              ).image,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(-0.1, -0.55),
                child: Container(
                  width: 389.1,
                  height: 148.8,
                  decoration: BoxDecoration(),
                ),
              ),
             Center(
                             child: Text(
          ' تشخيصك السابق ',
          //textAlign: TextAlign.end,
          style: FlutterFlowTheme.of(context).title1.override(
                    fontFamily: 'Tajawal',
                    color: Color(0xFF007282),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                           ),
              Container(
                width: 389.9,
                height: 645.8,
                decoration: BoxDecoration(),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('report').orderBy('date', descending:true ).snapshots(),
                  builder:(context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index)=> 
                        userId == snapshot.data?.docs[index]['user']?
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // SizedBox(
                                //   width: 10,
                                // ),
                                IconButton(
                                  onPressed: () {
                                     Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ReportWidget(
                                        date: snapshot.data?.docs[index]['date'] ,
                                        disease: snapshot.data?.docs[index]['disease'] ,
                                        description: snapshot.data?.docs[index]['description'],
                                        precaution: snapshot.data?.docs[index]['precaution'],
                                        precaution2: snapshot.data?.docs[index]['precaution2'],
                                        precaution3: snapshot.data?.docs[index]['precaution3'],
                                      )));
                                    print('button');
                                  }, 
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new, 
                                    color: Color(0xFF007282) ,
                                    size: 25
                                    ,)
                                    ),
                                    // SizedBox(
                                    //   width: 30,
                                    //  ),
                                Column(
                                  children: [
                                     SizedBox(
                                      height: 10,
                                     ),
                                    Container(
                                      // width: 210,
                                      child: Text(
                                        snapshot.data?.docs[index]['date']
                                        ,
                                        style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Tajawal',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  Container(
                                  child: Text(
                                    snapshot.data?.docs[index]['disease']
                                    ,
                                    style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .override(
                                      fontFamily: 'Tajawal',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF007282) ,
                                    ),
                                  ),
                                ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ):
                        Container(),
                      );

                    }else{
                      return Container();
                    }
                  } ,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Future getUserHistory() async{
//   var data = await FirebaseFirestore.instance
//   .collection('report')
//   .doc(uid);
  

// }