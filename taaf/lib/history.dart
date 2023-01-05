import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              Container(
                width: 389.9,
                height: 645.8,
                decoration: BoxDecoration(),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('report').snapshots(),
                  builder:(context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index)=> Container(
                          child: Text(
                            snapshot.data?.docs[index]['disease']
                          ),
                        ),
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