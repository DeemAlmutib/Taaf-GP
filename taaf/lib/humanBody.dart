/*
import 'package:flutter/material.dart';
import 'package:human_body_selector/human_body_selector.dart';
import 'package:human_body_selector/svg_painter/maps.dart';
import 'package:taaf/login/loginPage.dart';

class humanBody extends StatefulWidget {
  const humanBody({Key? key}) : super(key: key);

  @override
  State<humanBody> createState() => _humanBodye();
}

class _humanBodye extends State<humanBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Human body selector example'),
        ),
        backgroundColor: Colors.grey,
        body: const MySelector(),
      ),
    );
  }
}

class MySelector extends StatelessWidget {
  const MySelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: HumanBodySelector(
        map: Maps.HUMAN,
        onChanged: (bodyPart, active) {
          LoginPageWidget();
        },
        onLevelChanged: (bodyPart) {},
        multiSelect: true,
        toggle: true,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width - 100,
      ),
    );
  }
}*/
