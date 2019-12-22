import 'package:flutter/material.dart';
import 'package:flutter_accordion_menu/page.dart';
import 'package:screen/screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Accordion Menu',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    setState(() {
      Screen.keepOn(true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Page();
  }
}
