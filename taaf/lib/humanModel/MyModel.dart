/*
import 'package:body_part_selector/body_part_selector.dart';
import 'package:flutter/material.dart';

/*void main() {
  runApp(const MyApp());
}*/

class MyModel extends StatefulWidget {
  const MyModel({Key? key}) : super(key: key);

  // This widget is the root of your application.
/*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Body Part Selector',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      home: const MyHomePage(title: 'Body part Selector'),
    );
  }*/
  @override
  _MyModel createState() => _MyModel();
}

class _MyModel extends State<MyModel> {
// final String title;

  BodyParts _bodyParts = const BodyParts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: Text(widget.title),
          ),
      body: SafeArea(
        child: BodyPartSelectorTurnable(
          bodyParts: _bodyParts,
          onSelectionUpdated: (p) => setState(() => _bodyParts = p),
          labelData: const RotationStageLabelData(
            front: 'Vorne',
            left: 'Links',
            right: 'Rechts',
            back: 'Hinten',
          ),
        ),
      ),
    );
  }
}
*/